package controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import dal.DBContext;
import dal.AppointmentDao;
import dal.WorkingScheduleDAO;
import models.Appointment;
import models.User;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import java.time.LocalDateTime;
import utils.LocalDateTimeAdapter;

@WebServlet({"/getDoctorAppointments", "/doctor/appointments"})
public class DoctorAppointmentServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null || session.getAttribute("roleId") == null) {
            response.sendRedirect(request.getContextPath() + "/views/home/login.jsp?error=access_denied");
            return;
        }
        int roleId = (int) session.getAttribute("roleId");
        if (roleId != 2) {
            response.sendRedirect(request.getContextPath() + "/views/home/login.jsp?error=access_denied");
            return;
        }
        int userId = (int) session.getAttribute("userId");

        // Lấy doctorId từ userId
        int doctorId = new dal.WorkingScheduleDAO().getDoctorIdByUserId(userId);
        if (doctorId == -1) {
            response.sendRedirect(request.getContextPath() + "/views/home/login.jsp?error=doctor_not_found");
            return;
        }

        List<models.Appointment> appointments = dal.AppointmentDao.getAppointmentsByDoctorId(doctorId, 1, 100);
        request.setAttribute("appointments", appointments);
        request.getRequestDispatcher("/views/doctor/appointments.jsp").forward(request, response);
    }
    
    private void handleApiRequest(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null || session.getAttribute("roleId") == null) {
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "User not logged in");
            return;
        }
        int roleId = (int) session.getAttribute("roleId");
        if (roleId != 2) { // Chỉ cho doctor (roleId = 2)
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied");
            return;
        }
        int userId = (int) session.getAttribute("userId");

        try (Connection conn = DBContext.makeConnection()) {
            if (conn == null) {
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Cannot connect to database");
                return;
            }

            // Tìm doctorId từ userId
            String doctorSql = "SELECT doctor_id FROM doctors WHERE user_id = ?";
            int doctorId = -1;
            try (PreparedStatement stmt = conn.prepareStatement(doctorSql)) {
                stmt.setInt(1, userId);
                try (ResultSet rs = stmt.executeQuery()) {
                    if (rs.next()) {
                        doctorId = rs.getInt("doctor_id");
                    } else {
                        response.sendError(HttpServletResponse.SC_NOT_FOUND, "Doctor not found");
                        return;
                    }
                }
            }

            // Get page and size parameters with defaults
            int page = 1;
            int size = 10;
            try {
                String pageStr = request.getParameter("page");
                String sizeStr = request.getParameter("size");
                if (pageStr != null) page = Integer.parseInt(pageStr);
                if (sizeStr != null) size = Integer.parseInt(sizeStr);
            } catch (NumberFormatException e) {
                // Use default values if parsing fails
            }
            
            List<Appointment> appointments = AppointmentDao.getAppointmentsByDoctorId(doctorId, page, size);
            Gson gson = new GsonBuilder()
                .registerTypeAdapter(LocalDateTime.class, new LocalDateTimeAdapter())
                .create();
            response.getWriter().write(gson.toJson(appointments));
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database error: " + e.getMessage());
        }
    }
    
    private void handlePageRequest(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user == null || user.getRole().getRoleId() != 2) {
            response.sendRedirect(request.getContextPath() + "/views/home/login.jsp?error=access_denied");
            return;
        }
        
        // Get doctorId from session or database
        Integer doctorIdObj = (Integer) session.getAttribute("doctorId");
        int doctorId;
        if (doctorIdObj == null) {
            doctorId = new WorkingScheduleDAO().getDoctorIdByUserId(user.getUserId());
            if (doctorId == -1) {
                response.sendRedirect(request.getContextPath() + "/views/home/login.jsp?error=doctor_not_found");
                return;
            }
            session.setAttribute("doctorId", doctorId);
        } else {
            doctorId = doctorIdObj;
        }
        
        // Get appointments for the doctor
        List<Appointment> appointments = AppointmentDao.getAppointmentsByDoctorId(doctorId, 1, 50);
        request.setAttribute("appointments", appointments);
        
        request.getRequestDispatcher("/views/doctor/appointments.jsp").forward(request, response);
    }
}