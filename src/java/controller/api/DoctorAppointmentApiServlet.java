package controller.api;

import dal.AppointmentDao;
import dal.WorkingScheduleDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import models.Appointment;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import java.io.IOException;
import java.time.LocalDateTime;
import java.util.List;
import java.util.ArrayList;
import java.util.Map;
import java.util.HashMap;
import utils.LocalDateTimeAdapter;

@WebServlet("/api/doctor/appointments")
public class DoctorAppointmentApiServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json;charset=UTF-8");
        
        // Use AuthHelper for unified authentication
        if (!utils.AuthHelper.hasRole(request, 2)) { // 2 = doctor
            response.setStatus(403);
            response.getWriter().write("[]");
            return;
        }
        
        Integer userId = utils.AuthHelper.getCurrentUserId(request);
        if (userId == null) {
            response.setStatus(401);
            response.getWriter().write("[]");
            return;
        }

        // Get doctorId from database
        int doctorId = new WorkingScheduleDAO().getDoctorIdByUserId(userId);
        if (doctorId == -1) {
            response.setStatus(404);
            response.getWriter().write("[]");
            return;
        }

        // Get appointments
        List<Appointment> appointments = AppointmentDao.getAppointmentsByDoctorId(doctorId, 1, 50);
        List<Map<String, Object>> result = new ArrayList<>();

        for (Appointment appt : appointments) {
            Map<String, Object> item = new HashMap<>();
            item.put("id", appt.getId());
            item.put("queueNumber", appt.getQueueNumber());
            item.put("date", appt.getAppointmentDateTime());
            item.put("shiftId", appt.getShiftId());
            item.put("patientName", appt.getPatient() != null && appt.getPatient().getUser() != null ? 
                     appt.getPatient().getUser().getFullName() : "");
            item.put("serviceName", appt.getService() != null ? appt.getService().getName() : "");
            item.put("statusCode", appt.getStatus() != null ? appt.getStatus().getCode() : "");
            item.put("status", appt.getStatus() != null ? appt.getStatus().getDisplayName() : "");
            item.put("paymentStatus", appt.getPaymentStatus() != null ? appt.getPaymentStatus().name() : "");
            item.put("note", appt.getNote());
            result.add(item);
        }

        Gson gson = new GsonBuilder()
            .registerTypeAdapter(LocalDateTime.class, new LocalDateTimeAdapter())
            .create();
        response.getWriter().write(gson.toJson(result));
    }
} 