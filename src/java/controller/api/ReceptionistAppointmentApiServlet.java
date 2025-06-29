package controller.api;

import dal.AppointmentDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import models.Appointment;
import com.google.gson.Gson;
import java.io.IOException;
import java.util.List;
import java.util.ArrayList;

@WebServlet({"/api/receptionist/appointments", "/api/receptionist/appointments/status"})
public class ReceptionistAppointmentApiServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json;charset=UTF-8");
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null || session.getAttribute("roleId") == null) {
            response.setStatus(401);
            response.getWriter().write("[]");
            return;
        }
        int roleId = (int) session.getAttribute("roleId");
        if (roleId != 3) {
            response.setStatus(403);
            response.getWriter().write("[]");
            return;
        }
        List<Appointment> appointments = AppointmentDao.getAllAppointments(1, 1000);
        List<Object> events = new ArrayList<>();
        for (Appointment appt : appointments) {
            String patientName = (appt.getPatient() != null && appt.getPatient().getUser() != null) ? appt.getPatient().getUser().getFullName() : "";
            String serviceName = (appt.getService() != null) ? appt.getService().getName() : "";
            String status = (appt.getStatus() != null) ? appt.getStatus().getDisplayName() : "";
            String statusCode = (appt.getStatus() != null) ? appt.getStatus().getCode() : "";
            String paymentStatus = (appt.getPaymentStatus() != null) ? appt.getPaymentStatus().name() : "";
            String start = appt.getAppointmentDateTime() != null ? appt.getAppointmentDateTime().toString() : "";
            String date = appt.getAppointmentDateTime() != null ? appt.getAppointmentDateTime().toLocalDate().toString() : "";
            events.add(new java.util.HashMap<String, Object>() {{
                put("id", appt.getId());
                put("queueNumber", appt.getQueueNumber());
                put("date", date);
                put("shiftId", appt.getShiftId());
                put("patientName", patientName);
                put("serviceName", serviceName);
                put("status", status);
                put("statusCode", statusCode);
                put("paymentStatus", paymentStatus);
                put("note", appt.getNote());
                put("start", start); // cho FullCalendar
                put("title", serviceName + (patientName.isEmpty() ? "" : (" - " + patientName)));
                put("allDay", false);
            }});
        }
        response.getWriter().write(new Gson().toJson(events));
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String path = request.getServletPath();
        if ("/api/receptionist/appointments/status".equals(path)) {
            response.setContentType("application/json;charset=UTF-8");
            HttpSession session = request.getSession(false);
            if (session == null || session.getAttribute("userId") == null || session.getAttribute("roleId") == null) {
                response.setStatus(401);
                response.getWriter().write("{\"success\":false,\"message\":\"Unauthorized\"}");
                return;
            }
            int roleId = (int) session.getAttribute("roleId");
            if (roleId != 3) {
                response.setStatus(403);
                response.getWriter().write("{\"success\":false,\"message\":\"Forbidden\"}");
                return;
            }
            try {
                StringBuilder sb = new StringBuilder();
                String line;
                while ((line = request.getReader().readLine()) != null) {
                    sb.append(line);
                }
                String body = sb.toString();
                Gson gson = new Gson();
                java.util.Map<String, Object> map = gson.fromJson(body, java.util.Map.class);
                int id = ((Number) map.get("id")).intValue();
                String status = (String) map.get("status");
                boolean ok = dal.AppointmentDao.updateAppointmentStatus(id, status);
                response.getWriter().write("{\"success\":" + ok + "}");
            } catch (Exception e) {
                response.getWriter().write("{\"success\":false,\"message\":\"Error: " + e.getMessage() + "\"}");
            }
            return;
        }
        // fallback: do nothing for other POSTs
        response.setStatus(404);
        response.getWriter().write("{\"success\":false,\"message\":\"Not found\"}");
    }
} 