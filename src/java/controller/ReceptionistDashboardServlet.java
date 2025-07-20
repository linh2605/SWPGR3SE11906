package controller;

import dal.AppointmentDao;
import dal.PatientStatusDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import models.Appointment;
import models.PatientStatus;

import java.io.IOException;
import java.time.LocalDate;
import java.util.List;

@WebServlet("/receptionist/dashboard")
public class ReceptionistDashboardServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Use AuthHelper for unified authentication
        if (!utils.AuthHelper.hasRole(request, 3)) { // 3 = receptionist
            response.sendRedirect(request.getContextPath() + "/views/error/access-denied.jsp");
            return;
        }
        
        try {
            // Lấy thống kê cho dashboard
            LocalDate today = LocalDate.now();
            
            // Số lịch hẹn hôm nay
            int todayAppointments = AppointmentDao.countAppointmentsByDate(today);
            
            // Số bệnh nhân chờ khám (status = 1: New)
            int waitingPatients = PatientStatusDao.countPatientsByStatus(1);
            
            // Số bệnh nhân đang xử lý (status = 2: Check-in)
            int processingPatients = PatientStatusDao.countPatientsByStatus(2);
            
            // Số bệnh nhân đã hoàn thành (status = 9: Đã khám xong đợi thanh toán)
            int completedPatients = PatientStatusDao.countPatientsByStatus(9);
            
            // Lấy lịch hẹn gần đây (5 lịch hẹn mới nhất)
            List<Appointment> recentAppointments = AppointmentDao.getRecentAppointments(5);
            
            // Lấy danh sách bệnh nhân chờ khám
            List<PatientStatus> waitingPatientList = PatientStatusDao.getPatientsByStatus(1);
            
            // Set attributes
            request.setAttribute("todayAppointments", todayAppointments);
            request.setAttribute("waitingPatients", waitingPatients);
            request.setAttribute("processingPatients", processingPatients);
            request.setAttribute("completedPatients", completedPatients);
            request.setAttribute("recentAppointments", recentAppointments);
            request.setAttribute("waitingPatientList", waitingPatientList);
            
            request.getRequestDispatcher("/views/receptionist/dashboard.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(500, "Lỗi server: " + e.getMessage());
        }
    }
} 