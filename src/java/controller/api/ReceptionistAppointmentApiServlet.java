package controller.api;

import dal.AppointmentDao;
import dal.DoctorDao;
import models.Appointment;
import com.google.gson.Gson;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import java.util.ArrayList;
import java.util.HashMap;

@WebServlet("/api/receptionist/appointments")
public class ReceptionistAppointmentApiServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json;charset=UTF-8");
        // Lấy filter và phân trang từ query param
        String doctorIdStr = request.getParameter("doctorId");
        String dateStr = request.getParameter("date");
        String status = request.getParameter("status");
        int page = 1;
        int size = 20;
        try { page = Integer.parseInt(request.getParameter("page")); } catch (Exception ignored) {}
        try { size = Integer.parseInt(request.getParameter("size")); } catch (Exception ignored) {}

        List<Appointment> allAppointments;
        if (doctorIdStr != null && !doctorIdStr.isEmpty()) {
            int doctorId = Integer.parseInt(doctorIdStr);
            allAppointments = AppointmentDao.getAppointmentsByDoctorId(doctorId, 1, Integer.MAX_VALUE);
        } else {
            allAppointments = AppointmentDao.getAllAppointments(1, Integer.MAX_VALUE);
        }
        // Lọc tiếp theo ngày và trạng thái nếu có
        List<Appointment> filtered = new ArrayList<>();
        for (Appointment appt : allAppointments) {
            boolean match = true;
            if (dateStr != null && !dateStr.isEmpty()) {
                String apptDate = appt.getAppointmentDateTime() != null ? appt.getAppointmentDateTime().toLocalDate().toString() : "";
                if (!apptDate.equals(dateStr)) match = false;
            }
            if (status != null && !status.isEmpty()) {
                String apptStatus = appt.getStatus() != null ? appt.getStatus().getCode() : "";
                if (!apptStatus.equals(status)) match = false;
            }
            if (match) filtered.add(appt);
        }
        int totalCount = filtered.size();
        // Phân trang
        int from = Math.max(0, (page-1)*size);
        int to = Math.min(filtered.size(), from+size);
        List<Appointment> pageList = filtered.subList(from, to);
        // Chuyển sang định dạng FullCalendar cần
        List<Object> events = new ArrayList<>();
        for (Appointment appt : pageList) {
            String title = (appt.getService() != null ? appt.getService().getName() : "") + " - " + (appt.getDoctor() != null && appt.getDoctor().getUser() != null ? appt.getDoctor().getUser().getFullName() : "");
            String start = appt.getAppointmentDateTime() != null ? appt.getAppointmentDateTime().toString() : "";
            String statusDisp = appt.getStatus() != null ? appt.getStatus().getDisplayName() : "";
            events.add(new java.util.HashMap<String, Object>() {{
                put("id", appt.getId());
                put("title", title);
                put("start", start);
                put("status", statusDisp);
                put("allDay", false);
                put("doctorName", appt.getDoctor() != null && appt.getDoctor().getUser() != null ? appt.getDoctor().getUser().getFullName() : "");
                put("patientName", appt.getPatient() != null && appt.getPatient().getUser() != null ? appt.getPatient().getUser().getFullName() : "");
                put("serviceName", appt.getService() != null ? appt.getService().getName() : "");
            }});
        }
        HashMap<String, Object> result = new HashMap<>();
        result.put("data", events);
        result.put("totalCount", totalCount);
        response.getWriter().write(new Gson().toJson(result));
    }
} 