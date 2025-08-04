package controller;

import dal.PatientStatusDao;
import dal.PatientStatusLogDao;
import dal.StatusDAO;
import java.io.IOException;
import java.util.List;
import java.util.ArrayList;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import models.PatientStatus;
import models.PatientStatusLog;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import dal.DBContext;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import static java.time.DayOfWeek.FRIDAY;
import static java.time.DayOfWeek.MONDAY;
import static java.time.DayOfWeek.SATURDAY;
import static java.time.DayOfWeek.SUNDAY;
import static java.time.DayOfWeek.THURSDAY;
import static java.time.DayOfWeek.TUESDAY;
import static java.time.DayOfWeek.WEDNESDAY;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeFormatterBuilder;
import utils.LocalDateAdapter;
import utils.LocalDateTimeAdapter;

@WebServlet(name = "DoctorServlet", urlPatterns = {
    "/doctorupdate",
    "/doctor",
    "/getDoctorsByService",
    "/getDoctorsByServiceAndTime",
    "/getDoctorsByServiceAndDate",
    "/doctor-api",
    "/doctor-disable-schedule"
})
public class DoctorServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getServletPath();

        // Xử lý các yêu cầu GET khác (bác sĩ theo dịch vụ, theo thời gian, theo ngày)
        if ("/getDoctorsByService".equals(action)) {
            handleGetDoctorsByService(req, resp);
            return;
        }
        if ("/getDoctorsByServiceAndTime".equals(action)) {
            handleGetDoctorsByServiceAndTime(req, resp);
            return;
        }
        if ("/getDoctorsByServiceAndDate".equals(action)) {
            handleGetDoctorsByServiceAndDate(req, resp);
            return;
        }
        if ("/doctor-api".equals(action)) {
            handleGetDoctorsApi(req, resp);
            return;
        }
        if ("/doctor-disable-schedule".equals(action)) {
            handleGetDisableSchedule(req, resp);
            return;
        }

        // Use AuthHelper for unified authentication  
        if (!utils.AuthHelper.hasRole(req, 2)) { // 2 = doctor
            resp.sendRedirect(req.getContextPath() + "/views/error/access-denied.jsp");
            return;
        }

        // Lấy danh sách bệnh nhân mà bác sĩ có thể xử lý (role_id = 2)
        // Fix các appointment đã confirmed nhưng chưa có status_code = 3
//    dal.PatientStatusDao.fixConfirmedAppointments();
        List<PatientStatus> patients = PatientStatusDao.getByHandledRole(2);  // role_id = 2: doctor

        // Lấy logs từ patient_status_logs và cập nhật trạng thái cho bệnh nhân
        for (PatientStatus patient : patients) {
            List<PatientStatusLog> logs = PatientStatusLogDao.getLogsByPatientId(patient.getPatientId());
            if (!logs.isEmpty()) {
                // Lấy trạng thái và thời gian thay đổi cuối cùng (log mới nhất)
                PatientStatusLog latestLog = logs.get(logs.size() - 1);  // lấy log cuối cùng
                patient.setStatusCode(latestLog.getStatusCode());  // Cập nhật trạng thái từ log mới nhất
                patient.setChangedAt(latestLog.getChangedAt());    // Cập nhật thời gian thay đổi từ log mới nhất
            }
        }

        // Sắp xếp theo trạng thái ưu tiên: Đang khám -> Đã lấy kết quả xét nghiệm -> Đang đợi khám -> v.v...
        patients.sort((p1, p2) -> {
            // Ưu tiên theo trạng thái
            if (p1.getStatusCode() == 4 && p2.getStatusCode() != 4) {
                return -1;  // Đang khám lên đầu
            }
            if (p1.getStatusCode() == 8 && p2.getStatusCode() != 8) {
                return 1;   // Đã lấy kết quả xét nghiệm đứng sau Đang khám
            }
            if (p1.getStatusCode() == 3 && p2.getStatusCode() != 3) {
                return 1;  // Đang đợi khám đứng sau Đã lấy kết quả xét nghiệm
            }
            if (p1.getStatusCode() == 5 && p2.getStatusCode() != 5) {
                return -1;  // Đang chờ bệnh nhân xét nghiệm đứng sau Đang đợi khám
            }
            // So sánh các trạng thái còn lại
            if (p1.getStatusCode() != p2.getStatusCode()) {
                return Integer.compare(p1.getStatusCode(), p2.getStatusCode());
            }

            // Nếu trạng thái giống nhau, sắp xếp theo thời gian thay đổi
            return p1.getChangedAt().compareTo(p2.getChangedAt());
        });

        req.setAttribute("patients", patients);
        req.setAttribute("statuses", StatusDAO.getStatusesByRole(2));
        req.getRequestDispatcher("/views/doctor/managestatus.jsp").forward(req, resp);
    }

    private void handleGetDoctorsByService(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String serviceIdStr = request.getParameter("serviceId");
        int serviceId = 0;
        try {
            serviceId = Integer.parseInt(serviceIdStr);
        } catch (Exception e) {
            response.setStatus(400);
            response.getWriter().write("[]");
            return;
        }
        List<models.Doctor> doctors = dal.DoctorDao.getDoctorsByServiceId(serviceId);
        response.setContentType("application/json;charset=UTF-8");
        response.getWriter().write(new Gson().toJson(doctors));
    }

    private void handleGetDoctorsByServiceAndTime(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String serviceIdStr = request.getParameter("serviceId");
        String datetimeStr = request.getParameter("datetime");
        int serviceId = 0;
        try {
            serviceId = Integer.parseInt(serviceIdStr);
        } catch (Exception e) {
            response.setStatus(400);
            response.getWriter().write("[]");
            return;
        }
        java.time.LocalDateTime dateTime = null;
        try {
            dateTime = java.time.LocalDateTime.parse(datetimeStr);
        } catch (Exception e) {
            response.setStatus(400);
            response.getWriter().write("[]");
            return;
        }
        List<models.Doctor> doctors = dal.DoctorDao.getDoctorsByServiceId(serviceId);
        List<models.Doctor> availableDoctors = new java.util.ArrayList<>();
        availableDoctors.addAll(doctors);
        response.setContentType("application/json;charset=UTF-8");
        response.getWriter().write(new com.google.gson.Gson().toJson(availableDoctors));
    }

    private void handleGetDoctorsByServiceAndDate(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String serviceIdStr = request.getParameter("serviceId");
        String dateStr = request.getParameter("date");
        System.out.println("date:\'" + dateStr + "\'");
        String shiftIdStr = request.getParameter("shiftId");

        int serviceId = 0;
        int shiftId = 0;
        try {
            serviceId = Integer.parseInt(serviceIdStr);
            shiftId = Integer.parseInt(shiftIdStr);
        } catch (Exception e) {
            response.setStatus(400);
            response.getWriter().write("[]");
            return;
        }
        LocalDate date = null;
        try {
            date = LocalDate.parse(dateStr);
            System.out.println("date parse:" + date);
        } catch (Exception e) {
            response.setStatus(400);
            response.getWriter().write("[]");
            return;
        }
        String weekDayVN = getVietnameseWeekDay(date);

        List<models.Doctor> doctors = dal.DoctorDao.getDoctorsByServiceId(serviceId);
        List<models.Doctor> availableDoctors = new java.util.ArrayList<>();
        for (models.Doctor d : doctors) {
            boolean isAvailable = dal.AppointmentDao.isDoctorAvailableByWeekDayAndShift(d.getDoctor_id(), weekDayVN, shiftId);
            if (isAvailable) {
                availableDoctors.add(d);
            }
        }
        Gson gson = new GsonBuilder()
                .registerTypeAdapter(LocalDate.class, new LocalDateAdapter())
                .create();
        response.setContentType("application/json;charset=UTF-8");
        response.getWriter().write(gson.toJson(availableDoctors));
    }

    // Hàm chuyển đổi ngày sang tuần trong tuần (tiếng Việt)
    private String getVietnameseWeekDay(java.time.LocalDate date) {
        switch (date.getDayOfWeek()) {
            case MONDAY:
                return "Thứ 2";
            case TUESDAY:
                return "Thứ 3";
            case WEDNESDAY:
                return "Thứ 4";
            case THURSDAY:
                return "Thứ 5";
            case FRIDAY:
                return "Thứ 6";
            case SATURDAY:
                return "Thứ 7";
            case SUNDAY:
                return "Chủ nhật";
            default:
                return "";
        }
    }

    private void handleGetDoctorsApi(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String action = request.getParameter("action");

        if ("api".equals(action)) {
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");

            try {
                List<models.Doctor> doctors = dal.DoctorDao.getAllDoctors();
                Gson gson = new Gson();
                String json = gson.toJson(doctors);
                response.getWriter().write(json);
            } catch (Exception e) {
                response.setStatus(500);
                response.getWriter().write("{\"error\": \"Lỗi khi lấy danh sách bác sĩ\"}");
            }
        } else {
            response.setStatus(400);
            response.getWriter().write("{\"error\": \"Invalid action\"}");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            int patientId = Integer.parseInt(req.getParameter("patientId"));
            int statusCode = Integer.parseInt(req.getParameter("statusCode"));
            int changedBy = (int) req.getSession().getAttribute("userId");

            // Cập nhật trạng thái bệnh nhân
            PatientStatusDao.updateStatus(patientId, statusCode, changedBy);
            req.setAttribute("message", "Cập nhật trạng thái thành công!");
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Lỗi cập nhật trạng thái!");
        }

        // Sau khi cập nhật, lấy lại danh sách bệnh nhân và sắp xếp lại
        List<PatientStatus> patientStatusList = PatientStatusDao.getByHandledRole(2);  // role_id = 2: bác sĩ

        // Sắp xếp lại theo yêu cầu
        patientStatusList.sort((ps1, ps2) -> {
            int ps1Status = ps1.getStatusCode();
            int ps2Status = ps2.getStatusCode();

            if (ps1Status == 4) {
                return -1;  // Đang khám đứng đầu
            }
            if (ps2Status == 4) {
                return 1;
            }

            if (ps1Status == 8 && ps2Status != 8) {
                return -1;  // Đã lấy kết quả xét nghiệm đứng sau Đang khám
            }
            if (ps2Status == 8 && ps1Status != 8) {
                return 1;
            }

            return 0;  // Các trạng thái còn lại giữ nguyên
        });

        req.setAttribute("patients", patientStatusList);
        req.getRequestDispatcher("/views/doctor/managestatus.jsp").forward(req, resp);
    }

    private void handleGetDisableSchedule(HttpServletRequest request, HttpServletResponse response) throws IOException {
//        String serviceIdStr = request.getParameter("serviceId");
        String doctorIdStr = request.getParameter("doctorId");
        String patientIdStr = request.getParameter("patientId");

        int serviceId = 0;
        int doctorId = 0;
        int patientId = 0;
        try {
//            serviceId = Integer.parseInt(serviceIdStr);
            doctorId = Integer.parseInt(doctorIdStr);
            patientId = Integer.parseInt(patientIdStr);
        } catch (Exception e) {
            response.setStatus(400);
            response.getWriter().write("[]");
            return;
        }
        List<DisableShift> disableShifts = getDisableShift(doctorId, patientId);
        Gson gson = new GsonBuilder()
                .registerTypeAdapter(LocalDate.class, new LocalDateAdapter())
                .create();
        response.setContentType("application/json;charset=UTF-8");
        response.setStatus(200);
        response.getWriter().write(gson.toJson(disableShifts));
    }

    private List<DisableShift> getDisableShift(int doctorId, int patientId) {
        List<DisableShift> disableShifts = new ArrayList<>();
        String sql = "SELECT a.appointment_date\n"
                + "     , a.shift_id\n"
                + "  FROM (\n"
                + "        -- Lịch full của bác sĩ\n"
                + "        WITH appointment_counts AS (\n"
                + "            SELECT doctor_id\n"
                + "                 , appointment_date\n"
                + "                 , shift_id\n"
                + "                 , CASE DAYNAME(appointment_date)\n"
                + "                       WHEN 'Monday' THEN 'Thứ 2'\n"
                + "                       WHEN 'Tuesday' THEN 'Thứ 3'\n"
                + "                       WHEN 'Wednesday' THEN 'Thứ 4'\n"
                + "                       WHEN 'Thursday' THEN 'Thứ 5'\n"
                + "                       WHEN 'Friday' THEN 'Thứ 6'\n"
                + "                       WHEN 'Saturday' THEN 'Thứ 7'\n"
                + "                       WHEN 'Sunday' THEN 'Chủ nhật'\n"
                + "                   END AS week_day\n"
                + "                 , COUNT(*) AS appointments\n"
                + "              FROM appointments\n"
                + "             WHERE status != 'canceled'\n"
                + "             GROUP BY doctor_id, appointment_date, shift_id\n"
                + "            HAVING doctor_id = ?\n"
                + "        )\n"
                + "        SELECT ac.appointment_date\n"
                + "             , ac.shift_id\n"
                + "          FROM working_schedules ws\n"
                + "               JOIN appointment_counts ac\n"
                + "                 ON ws.doctor_id = ac.doctor_id\n"
                + "                AND ws.week_day = ac.week_day\n"
                + "                AND ws.shift_id = ac.shift_id\n"
                + "         WHERE ws.is_active = 1\n"
                + "           AND ac.appointments >= ws.max_patients\n"
                + "\n"
                + "        UNION\n"
                + "\n"
                + "        -- Lịch đã đặt của bệnh nhân\n"
                + "        SELECT appointment_date\n"
                + "             , shift_id\n"
                + "          FROM appointments\n"
                + "         WHERE patient_id = ?\n"
                + "           AND doctor_id = ?\n"
                + "           AND status NOT IN ('canceled', 'completed')\n"
                + "      ) a;";
        try {
            Connection conn = DBContext.makeConnection();
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, doctorId);
            stmt.setInt(2, patientId);
            stmt.setInt(3, doctorId);
            try (ResultSet rs = stmt.executeQuery()) {
                DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");;
                if (rs.next()) {

                    DisableShift ds = new DisableShift();
                    ds.setDate(rs.getTimestamp("appointment_date").toLocalDateTime().format(formatter));
                    ds.setShiftId(rs.getInt("shift_id"));
                    disableShifts.add(ds);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return disableShifts;
    }

    class DisableShift {

        String date;
        int shiftId;

        public DisableShift() {
        }

        public DisableShift(String date, int shiftId) {
            this.date = date;
            this.shiftId = shiftId;
        }

        public String getDate() {
            return date;
        }

        public void setDate(String date) {
            this.date = date;
        }

        public int getShiftId() {
            return shiftId;
        }

        public void setShiftId(int shiftId) {
            this.shiftId = shiftId;
        }

    }
}
