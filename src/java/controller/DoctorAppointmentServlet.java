package controller;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import dal.WorkingScheduleDAO;
import models.Appointment;
import models.User;

@WebServlet("/doctor/appointments")
public class DoctorAppointmentServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Use AuthHelper for unified authentication
        if (!utils.AuthHelper.hasRole(request, 2)) { // 2 = doctor
            response.sendRedirect(request.getContextPath() + "/views/error/access-denied.jsp");
            return;
        }
        
        User user = utils.AuthHelper.getCurrentUser(request);
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/views/error/access-denied.jsp");
            return;
        }
        
        // Get doctorId from database
        int doctorId = new WorkingScheduleDAO().getDoctorIdByUserId(user.getUserId());
        if (doctorId == -1) {
            response.sendRedirect(request.getContextPath() + "/views/home/login.jsp?error=doctor_not_found");
            return;
        }
        
        // Get appointments for the doctor (first 50 appointments)
        List<Appointment> appointments = dal.AppointmentDao.getAppointmentsByDoctorId(doctorId, 1, 50);
        
        request.setAttribute("appointments", appointments);
        request.getRequestDispatcher("/views/appointment/doctorDashboard.jsp").forward(request, response);
    }
}