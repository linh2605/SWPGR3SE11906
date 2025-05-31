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

import DAO.DBContext;
import com.google.gson.Gson;

@WebServlet("/getDoctorAppointments")
public class DoctorAppointmentServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null || session.getAttribute("role_id") == null) {
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "User not logged in");
            return;
        }
        int roleId = (int) session.getAttribute("role_id");
        if (roleId != 2) { // Chỉ cho doctor (role_id = 2)
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied");
            return;
        }
        int userId = (int) session.getAttribute("user_id");

        List<Appointment> appointments = new ArrayList<>();
        try (Connection conn = DBContext.makeConnection()) {
            if (conn == null) {
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Cannot connect to database");
                return;
            }

            // Tìm doctor_id từ user_id
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

            // Lấy lịch hẹn của doctor_id
            String sql = "SELECT a.appointment_id, a.appointment_date, d.full_name AS doctor_name, p.full_name AS patient_name, a.status " +
                         "FROM appointments a " +
                         "JOIN doctors d ON a.doctor_id = d.doctor_id " +
                         "JOIN patients p ON a.patient_id = p.patient_id " +
                         "WHERE a.doctor_id = ?";
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setInt(1, doctorId);
                try (ResultSet rs = stmt.executeQuery()) {
                    while (rs.next()) {
                        Appointment appt = new Appointment();
                        appt.setId(rs.getInt("appointment_id"));
                        appt.setDateTime(rs.getTimestamp("appointment_date").toLocalDateTime());
                        appt.setDoctor(rs.getString("doctor_name"));
                        appt.setPatient(rs.getString("patient_name"));
                        appt.setStatus(rs.getString("status"));
                        appointments.add(appt);
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database error: " + e.getMessage());
            return;
        }

        Gson gson = new Gson();
        response.getWriter().write(gson.toJson(appointments));
    }

    public static class Appointment {
        private int id;
        private String doctor;
        private String patient;
        private String status;
        private String dateTime;

        public int getId() { return id; }
        public void setId(int id) { this.id = id; }
        public String getDoctor() { return doctor; }
        public void setDoctor(String doctor) { this.doctor = doctor; }
        public String getPatient() { return patient; }
        public void setPatient(String patient) { this.patient = patient; }
        public String getStatus() { return status; }
        public void setStatus(String status) { this.status = status; }
        public String getDateTime() { return dateTime; }
        public void setDateTime(String dateTime) { this.dateTime = dateTime; }
        public void setDateTime(java.time.LocalDateTime dateTime) {
            this.dateTime = dateTime.format(java.time.format.DateTimeFormatter.ISO_LOCAL_DATE_TIME);
        }
    }
}