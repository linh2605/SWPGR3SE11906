package controller.api;

import dal.AppointmentDao;
import dal.PatientDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import models.Appointment;
import models.Patient;
import com.google.gson.Gson;
import java.io.IOException;
import java.util.List;
import java.util.ArrayList;

@WebServlet("/api/patient/appointments")
public class PatientAppointmentApiServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json;charset=UTF-8");
        // Use AuthHelper for unified authentication
        if (!utils.AuthHelper.isAuthenticated(request)) {
            response.setStatus(401);
            response.getWriter().write("[]");
            return;
        }
        
        Integer roleId = utils.AuthHelper.getCurrentUserRoleId(request);
        if (roleId == null || roleId != 1) {
            response.setStatus(403);
            response.getWriter().write("[]");
            return;
        }
        
        Integer userId = utils.AuthHelper.getCurrentUserId(request);
        Patient patient = PatientDao.getPatientByUserId(userId);
        if (patient == null) {
            response.setStatus(404);
            response.getWriter().write("[]");
            return;
        }
        int patientId = patient.getPatient_id();
        List<Appointment> appointments = AppointmentDao.getAppointmentsByPatientId(patientId, 1, 100);
        // Chuyển sang định dạng FullCalendar cần
        List<Object> events = new ArrayList<>();
        for (Appointment appt : appointments) {
            String title = (appt.getService() != null ? appt.getService().getName() : "") + " - " + (appt.getDoctor() != null && appt.getDoctor().getUser() != null ? appt.getDoctor().getUser().getFullName() : "");
            String start = appt.getAppointmentDateTime() != null ? appt.getAppointmentDateTime().toString() : "";
            String status = appt.getStatus() != null ? appt.getStatus().getDisplayName() : "";
            events.add(new java.util.HashMap<String, Object>() {{
                put("id", appt.getId());
                put("title", title);
                put("start", start);
                put("status", status);
                put("allDay", false);
            }});
        }
        response.getWriter().write(new Gson().toJson(events));
    }
} 