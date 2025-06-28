package controller;

import dal.ScheduleExceptionDAO;
import dal.DoctorDao;
import dal.WorkingScheduleDAO;
import models.ScheduleException;
import models.User;
import models.Doctor;
import controller.auth.util.EmailServices;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name="AdminScheduleExceptionServlet", urlPatterns={"/admin/schedule-exceptions"})
public class AdminScheduleExceptionServlet extends HttpServlet {
    private ScheduleExceptionDAO scheduleExceptionDAO;
    private DoctorDao doctorDao;

    @Override
    public void init() throws ServletException {
        scheduleExceptionDAO = new ScheduleExceptionDAO();
        doctorDao = new DoctorDao();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null || user.getRole().getRoleId() != 4) { // 4 = admin
            response.sendRedirect(request.getContextPath() + "/views/home/login.jsp?error=access_denied");
            return;
        }

        // Lấy filter từ request
        String doctorIdStr = request.getParameter("doctorId");
        String status = request.getParameter("status");
        String dateStr = request.getParameter("date");
        String keyword = request.getParameter("keyword");
        Integer doctorId = null;
        if (doctorIdStr != null && !doctorIdStr.isEmpty()) {
            try { doctorId = Integer.parseInt(doctorIdStr); } catch (Exception ignored) {}
        }
        java.sql.Date date = null;
        if (dateStr != null && !dateStr.isEmpty()) {
            try { date = java.sql.Date.valueOf(dateStr); } catch (Exception ignored) {}
        }

        // Lấy danh sách bác sĩ cho dropdown
        List<Doctor> doctors = DoctorDao.getAllDoctors();
        // Lấy danh sách ngoại lệ đã filter
        List<ScheduleException> exceptions = scheduleExceptionDAO.getExceptionsWithFilter(doctorId, status, date, keyword);

        request.setAttribute("exceptions", exceptions);
        request.setAttribute("doctors", doctors);
        request.setAttribute("filterDoctorId", doctorId);
        request.setAttribute("filterStatus", status);
        request.setAttribute("filterDate", dateStr);
        request.setAttribute("filterKeyword", keyword);
        request.getRequestDispatcher("/views/admin/schedule-exceptions.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null || user.getRole().getRoleId() != 4) {
            response.sendRedirect(request.getContextPath() + "/views/home/login.jsp?error=access_denied");
            return;
        }
        
        String action = request.getParameter("action");
        int exceptionId = Integer.parseInt(request.getParameter("exceptionId"));
        
        ScheduleException exception = scheduleExceptionDAO.getExceptionById(exceptionId);
        if (exception == null) {
            response.sendRedirect(request.getContextPath() + "/admin/schedule-exceptions?error=not_found");
            return;
        }
        
        boolean success = false;
        WorkingScheduleDAO wsDao = new WorkingScheduleDAO();
        
        if ("approve".equals(action)) {
            // Cập nhật trạng thái thành Đã duyệt
            exception.setStatus("Đã duyệt");
            success = scheduleExceptionDAO.updateException(exception);
            // Cập nhật lịch làm việc tương ứng
            if (success) {
                String weekDay = "";
                java.sql.Date exDate = exception.getExceptionDate();
                java.time.LocalDate localDate = exDate.toLocalDate();
                java.time.DayOfWeek dayOfWeek = localDate.getDayOfWeek();
                switch (dayOfWeek) {
                    case MONDAY: weekDay = "Monday"; break;
                    case TUESDAY: weekDay = "Tuesday"; break;
                    case WEDNESDAY: weekDay = "Wednesday"; break;
                    case THURSDAY: weekDay = "Thursday"; break;
                    case FRIDAY: weekDay = "Friday"; break;
                    case SATURDAY: weekDay = "Saturday"; break;
                    case SUNDAY: weekDay = "Sunday"; break;
                }
                if ("Nghỉ phép".equals(exception.getExceptionType()) || "Khẩn cấp".equals(exception.getExceptionType())) {
                    // Hủy lịch làm việc (set is_active = 0) cho ngày đó
                    List<models.WorkingSchedule> schedules = wsDao.getSchedulesByDoctorId(exception.getDoctorId());
                    for (models.WorkingSchedule ws : schedules) {
                        if (ws.getWeekDay().equals(weekDay)) {
                            ws.setActive(false);
                            wsDao.updateSchedule(ws);
                        }
                    }
                } else if ("Thay đổi giờ làm".equals(exception.getExceptionType()) && exception.getNewShiftId() != null) {
                    // Đổi ca làm việc cho ngày đó
                    List<models.WorkingSchedule> schedules = wsDao.getSchedulesByDoctorId(exception.getDoctorId());
                    for (models.WorkingSchedule ws : schedules) {
                        if (ws.getWeekDay().equals(weekDay)) {
                            ws.setShiftId(exception.getNewShiftId());
                            wsDao.updateSchedule(ws);
                        }
                    }
                }
                sendExceptionApprovalEmail(exception, true, null);
                response.sendRedirect(request.getContextPath() + "/admin/schedule-exceptions?success=approved");
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/schedule-exceptions?error=update_failed");
            }
        } else if ("reject".equals(action)) {
            // Cập nhật trạng thái thành Đã từ chối
            exception.setStatus("Đã từ chối");
            success = scheduleExceptionDAO.updateException(exception);
            if (success) {
                sendExceptionApprovalEmail(exception, false, null);
                response.sendRedirect(request.getContextPath() + "/admin/schedule-exceptions?success=rejected");
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/schedule-exceptions?error=update_failed");
            }
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/schedule-exceptions");
        }
    }

    private void sendExceptionApprovalEmail(ScheduleException exception, boolean approved, String rejectReason) {
        try {
            Doctor doctor = doctorDao.getDoctorById(exception.getDoctorId());
            if (doctor != null && doctor.getUser() != null) {
                String subject = approved ? "Yêu cầu ngoại lệ đã được duyệt" : "Yêu cầu ngoại lệ đã bị từ chối";
                String content = approved ? 
                    String.format("Xin chào %s,\n\nYêu cầu ngoại lệ của bạn vào ngày %s đã được duyệt.\n\nTrân trọng!",
                        doctor.getUser().getFullName(), exception.getExceptionDate()) :
                    String.format("Xin chào %s,\n\nYêu cầu ngoại lệ của bạn vào ngày %s đã bị từ chối.\nLý do: %s\n\nTrân trọng!",
                        doctor.getUser().getFullName(), exception.getExceptionDate(), 
                        rejectReason != null ? rejectReason : "Không có lý do cụ thể");
                
                EmailServices.sendEmail(doctor.getUser().getEmail(), subject, content);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
} 