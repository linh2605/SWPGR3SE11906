package controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import DAO.DBContext;
import config.WebSocketConfig;

@WebServlet(name = "UpdateAppointmentStatusServlet", urlPatterns = {"/update-appointment-status"})
public class UpdateAppointmentStatusServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        String role = (String) session.getAttribute("role");
        
        // Check if user is receptionist
        if (!"receptionist".equals(role)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied");
            return;
        }

        int appointmentId = Integer.parseInt(request.getParameter("appointmentId"));
        String status = request.getParameter("status");

        try (Connection conn = new DBContext().makeConnection()) {
            String sql = "UPDATE appointments SET status = ? WHERE id = ?";
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setString(1, status);
                stmt.setInt(2, appointmentId);
                int result = stmt.executeUpdate();

                if (result > 0) {
                    // Send realtime notification
                    String notification = String.format(
                        "{\"type\":\"appointment_update\",\"appointmentId\":%d,\"status\":\"%s\"}",
                        appointmentId, status
                    );
                    WebSocketConfig.broadcast(notification);
                    
                    response.setContentType("application/json");
                    response.getWriter().write("{\"success\":true}");
                } else {
                    response.sendError(HttpServletResponse.SC_NOT_FOUND, "Appointment not found");
                }
            }
        } catch (SQLException e) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database error");
        }
    }
}