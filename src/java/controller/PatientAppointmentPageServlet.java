package controller;

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
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/patient/appointments")
public class PatientAppointmentPageServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Use AuthHelper for unified authentication
        if (!utils.AuthHelper.hasRole(request, 1)) { // 1 = patient
            response.sendRedirect(request.getContextPath() + "/views/error/access-denied.jsp");
            return;
        }
        
        Integer userId = utils.AuthHelper.getCurrentUserId(request);
        if (userId == null) {
            response.sendRedirect(request.getContextPath() + "/views/error/access-denied.jsp");
            return;
        }
        System.out.println("[DEBUG] PatientAppointmentPageServlet - userId: " + userId);
        
        // Lấy patientId từ userId
        Patient patient = PatientDao.getPatientByUserId(userId);
        if (patient == null) {
            System.out.println("[ERROR] PatientAppointmentPageServlet - Không tìm thấy patient cho userId: " + userId);
            request.setAttribute("error", "Không tìm thấy thông tin bệnh nhân. Vui lòng liên hệ quản trị viên.");
            request.setAttribute("appointments", new ArrayList<>());
            request.getRequestDispatcher("/views/appointment/appointments.jsp").forward(request, response);
            return;
        }
        
        int patientId = patient.getPatient_id();
        System.out.println("[DEBUG] PatientAppointmentPageServlet - patientId: " + patientId);
        
        List<Appointment> appointments = AppointmentDao.getAppointmentsByPatientId(patientId, 1, 50);
        System.out.println("[DEBUG] PatientAppointmentPageServlet - Số lịch hẹn tìm thấy: " + appointments.size());
        
        // Debug từng appointment
        for (Appointment appt : appointments) {
            System.out.println("[DEBUG] Appointment ID: " + appt.getId());
            System.out.println("[DEBUG] - Date: " + appt.getAppointmentDateTime());
            System.out.println("[DEBUG] - Doctor: " + (appt.getDoctor() != null ? appt.getDoctor().getUser().getFullName() : "null"));
            System.out.println("[DEBUG] - Service: " + (appt.getService() != null ? appt.getService().getName() : "null"));
            System.out.println("[DEBUG] - Status: " + (appt.getStatus() != null ? appt.getStatus().getDisplayName() : "null"));
        }
        
        request.setAttribute("appointments", appointments);
        request.getRequestDispatcher("/views/appointment/appointments.jsp").forward(request, response);
    }
} 