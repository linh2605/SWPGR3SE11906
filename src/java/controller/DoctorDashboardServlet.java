package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import models.User;
import dal.WorkingScheduleDAO;
import dal.ScheduleExceptionDAO;
import dal.AppointmentDao;
import dal.DoctorDao;
import java.io.IOException;

@WebServlet(name = "DoctorDashboardServlet", urlPatterns = {"/doctor/dashboard"})
public class DoctorDashboardServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Use AuthHelper for unified authentication
        if (!utils.AuthHelper.hasRole(request, 2)) { // 2 = doctor
            response.sendRedirect(request.getContextPath() + "/views/error/access-denied.jsp");
            return;
        }
        
        User user = utils.AuthHelper.getCurrentUser(request);
        
        // Get doctorId from database
        int doctorId = new WorkingScheduleDAO().getDoctorIdByUserId(user.getUserId());
        if (doctorId == -1) {
            response.sendRedirect(request.getContextPath() + "/views/home/login.jsp?error=doctor_not_found");
            return;
        }
        
        // Lấy số liệu thống kê cho dashboard bác sĩ
        int totalSchedules = new WorkingScheduleDAO().countSchedulesByDoctor(doctorId);
        int activeSchedules = new WorkingScheduleDAO().countActiveSchedulesByDoctor(doctorId);
        int pendingExceptions = new ScheduleExceptionDAO().countPendingExceptionsByDoctor(doctorId);
        int totalAppointments = new AppointmentDao().countAppointmentsByDoctor(doctorId);
        
        // Lấy số liệu tư vấn sức khỏe
        int pendingConsultations = 0;
        int activeConsultations = 0;
        int totalConsultations = 0;
        
        try {
            pendingConsultations = dal.ConsultationSessionDAO.countSessionsByDoctorAndStatus(doctorId, "pending");
            activeConsultations = dal.ConsultationSessionDAO.countSessionsByDoctorAndStatus(doctorId, "active");
            totalConsultations = dal.ConsultationSessionDAO.countSessionsByDoctor(doctorId);
        } catch (Exception e) {
            System.err.println("Error loading consultation data: " + e.getMessage());
            e.printStackTrace();
        }
        
        request.setAttribute("totalSchedules", totalSchedules);
        request.setAttribute("activeSchedules", activeSchedules);
        request.setAttribute("pendingExceptions", pendingExceptions);
        request.setAttribute("totalAppointments", totalAppointments);
        request.setAttribute("pendingConsultations", pendingConsultations);
        request.setAttribute("activeConsultations", activeConsultations);
        request.setAttribute("totalConsultations", totalConsultations);
        request.getRequestDispatcher("/views/doctor/doctor-dashboard.jsp").forward(request, response);
    }
} 