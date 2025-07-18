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
import models.Appointment;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import java.time.LocalDateTime;
import utils.LocalDateTimeAdapter;

@WebServlet("/getAppointments")
public class AppointmentServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        // Use AuthHelper for unified authentication
        if (!utils.AuthHelper.hasRole(request, 1)) { // 1 = patient
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied");
            return;
        }
        Integer userId = utils.AuthHelper.getCurrentUserId(request);
        if (userId == null) {
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "User not logged in");
            return;
        }

        try (Connection conn = DBContext.makeConnection()) {
            if (conn == null) {
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Cannot connect to database");
                return;
            }

            // Tìm patientId từ userId
            String patientSql = "SELECT patient_id FROM patients WHERE user_id = ?";
            int patientId = -1;
            try (PreparedStatement stmt = conn.prepareStatement(patientSql)) {
                stmt.setInt(1, userId);
                try (ResultSet rs = stmt.executeQuery()) {
                    if (rs.next()) {
                        patientId = rs.getInt("patient_id");
                    } else {
                        response.sendError(HttpServletResponse.SC_NOT_FOUND, "Patient not found");
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
            
            List<Appointment> appointments = AppointmentDao.getAppointmentsByPatientId(patientId, page, size);
            Gson gson = new GsonBuilder()
                .registerTypeAdapter(LocalDateTime.class, new LocalDateTimeAdapter())
                .create();
            response.getWriter().write(gson.toJson(appointments));
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database error: " + e.getMessage());
        }
    }
}