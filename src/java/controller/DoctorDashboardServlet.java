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
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null || user.getRole().getRoleId() != 2) { // 2 = doctor
            response.sendRedirect(request.getContextPath() + "/views/home/login.jsp?error=access_denied");
            return;
        }
        
        // Get doctorId from session or database
        Integer doctorIdObj = (Integer) session.getAttribute("doctorId");
        int doctorId;
        if (doctorIdObj == null) {
            // If doctorId is not in session, get it from database
            doctorId = new WorkingScheduleDAO().getDoctorIdByUserId(user.getUserId());
            if (doctorId == -1) {
                response.sendRedirect(request.getContextPath() + "/views/home/login.jsp?error=doctor_not_found");
                return;
            }
            session.setAttribute("doctorId", doctorId);
        } else {
            doctorId = doctorIdObj;
        }
        
        // Lấy số liệu thống kê cho dashboard bác sĩ
        int totalSchedules = new WorkingScheduleDAO().countSchedulesByDoctor(doctorId);
        int activeSchedules = new WorkingScheduleDAO().countActiveSchedulesByDoctor(doctorId);
        int pendingExceptions = new ScheduleExceptionDAO().countPendingExceptionsByDoctor(doctorId);
        int totalAppointments = new AppointmentDao().countAppointmentsByDoctor(doctorId);
        request.setAttribute("totalSchedules", totalSchedules);
        request.setAttribute("activeSchedules", activeSchedules);
        request.setAttribute("pendingExceptions", pendingExceptions);
        request.setAttribute("totalAppointments", totalAppointments);
        request.getRequestDispatcher("/views/doctor/doctor-dashboard.jsp").forward(request, response);
    }
} 