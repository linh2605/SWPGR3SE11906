package dal;

import models.*;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ConsultationSessionDAO {

    // Tạo phiên tư vấn mới
    public static int createSession(ConsultationSession session) throws SQLException {
        String sql = "INSERT INTO consultation_sessions (patient_id, doctor_id, status, patient_message, patient_symptoms, created_at, updated_at) VALUES (?, ?, ?, ?, ?, NOW(), NOW())";
        try (Connection conn = DBContext.makeConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            stmt.setInt(1, session.getPatient().getPatient_id());
            stmt.setInt(2, session.getDoctor().getDoctor_id());
            stmt.setString(3, session.getStatus());
            stmt.setString(4, session.getPatient_message());
            stmt.setString(5, session.getPatient_symptoms());
            
            int affectedRows = stmt.executeUpdate();
            
            if (affectedRows > 0) {
                try (ResultSet rs = stmt.getGeneratedKeys()) {
                    if (rs.next()) {
                        return rs.getInt(1);
                    }
                }
            }
        } catch (SQLException e) {
            System.err.println("Error creating consultation session: " + e.getMessage());
            e.printStackTrace();
            throw e;
        }
        return -1;
    }

    // Lấy tất cả phiên tư vấn của bệnh nhân
    public static List<ConsultationSession> getSessionsByPatient(int patientId) throws SQLException {
        List<ConsultationSession> sessions = new ArrayList<>();
        String sql = """
            SELECT cs.session_id, cs.status, cs.created_at, cs.updated_at, cs.patient_message, cs.patient_symptoms,
                   p.patient_id, p.gender AS patient_gender, p.date_of_birth AS patient_dob, p.address AS patient_address,
                   p.image_url AS patient_image, p.created_at AS patient_created_at,
                   u1.user_id AS patient_user_id, u1.full_name AS patient_full_name,
                   d.doctor_id, d.gender AS doctor_gender, d.dob AS doctor_dob, d.image_url AS doctor_image,
                   d.degree, d.experience, d.status AS doctor_status, d.created_at AS doctor_created_at,
                   u2.user_id AS doctor_user_id, u2.full_name AS doctor_full_name,
                   s.specialty_id, s.name AS specialty_name
            FROM consultation_sessions cs
            JOIN patients p ON cs.patient_id = p.patient_id
            JOIN users u1 ON p.user_id = u1.user_id
            JOIN doctors d ON cs.doctor_id = d.doctor_id
            JOIN users u2 ON d.user_id = u2.user_id
            LEFT JOIN specialties s ON d.specialty_id = s.specialty_id
            WHERE cs.patient_id = ?
            ORDER BY cs.updated_at DESC
        """;

        try (Connection conn = DBContext.makeConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, patientId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    sessions.add(extractFromResultSet(rs));
                }
            }
        }
        return sessions;
    }

    // Lấy tất cả phiên tư vấn của bác sĩ
    public static List<ConsultationSession> getSessionsByDoctor(int doctorId) throws SQLException {
        List<ConsultationSession> sessions = new ArrayList<>();
        String sql = """
            SELECT cs.session_id, cs.status, cs.created_at, cs.updated_at, cs.patient_message, cs.patient_symptoms,
                   p.patient_id, p.gender AS patient_gender, p.date_of_birth AS patient_dob, p.address AS patient_address,
                   p.image_url AS patient_image, p.created_at AS patient_created_at,
                   u1.user_id AS patient_user_id, u1.full_name AS patient_full_name,
                   d.doctor_id, d.gender AS doctor_gender, d.dob AS doctor_dob, d.image_url AS doctor_image,
                   d.degree, d.experience, d.status AS doctor_status, d.created_at AS doctor_created_at,
                   u2.user_id AS doctor_user_id, u2.full_name AS doctor_full_name,
                   s.specialty_id, s.name AS specialty_name
            FROM consultation_sessions cs
            JOIN patients p ON cs.patient_id = p.patient_id
            JOIN users u1 ON p.user_id = u1.user_id
            JOIN doctors d ON cs.doctor_id = d.doctor_id
            JOIN users u2 ON d.user_id = u2.user_id
            LEFT JOIN specialties s ON d.specialty_id = s.specialty_id
            WHERE cs.doctor_id = ?
            ORDER BY cs.updated_at DESC
        """;

        try (Connection conn = DBContext.makeConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, doctorId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    sessions.add(extractFromResultSet(rs));
                }
            }
        }
        return sessions;
    }

    // Lấy phiên tư vấn theo ID
    public static ConsultationSession getSessionById(int sessionId) throws SQLException {
        String sql = """
            SELECT cs.session_id, cs.status, cs.created_at, cs.updated_at, cs.patient_message, cs.patient_symptoms,
                   p.patient_id, p.gender AS patient_gender, p.date_of_birth AS patient_dob, p.address AS patient_address,
                   p.image_url AS patient_image, p.created_at AS patient_created_at,
                   u1.user_id AS patient_user_id, u1.full_name AS patient_full_name,
                   d.doctor_id, d.gender AS doctor_gender, d.dob AS doctor_dob, d.image_url AS doctor_image,
                   d.degree, d.experience, d.status AS doctor_status, d.created_at AS doctor_created_at,
                   u2.user_id AS doctor_user_id, u2.full_name AS doctor_full_name,
                   s.specialty_id, s.name AS specialty_name
            FROM consultation_sessions cs
            JOIN patients p ON cs.patient_id = p.patient_id
            JOIN users u1 ON p.user_id = u1.user_id
            JOIN doctors d ON cs.doctor_id = d.doctor_id
            JOIN users u2 ON d.user_id = u2.user_id
            LEFT JOIN specialties s ON d.specialty_id = s.specialty_id
            WHERE cs.session_id = ?
        """;

        try (Connection conn = DBContext.makeConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, sessionId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return extractFromResultSet(rs);
                }
            }
        }
        return null;
    }

    // Cập nhật trạng thái phiên tư vấn
    public static boolean updateSessionStatus(int sessionId, String status) throws SQLException {
        String sql = "UPDATE consultation_sessions SET status = ? WHERE session_id = ?";
        try (Connection conn = DBContext.makeConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, status);
            stmt.setInt(2, sessionId);
            
            return stmt.executeUpdate() > 0;
        }
    }

    private static ConsultationSession extractFromResultSet(ResultSet rs) throws SQLException {
        // Tạo Patient
        User patientUser = new User();
        patientUser.setUserId(rs.getInt("patient_user_id"));
        String patientFullName = rs.getString("patient_full_name");
        patientUser.setFullName(patientFullName != null ? patientFullName : "");

        Patient patient = new Patient();
        patient.setPatient_id(rs.getInt("patient_id"));
        patient.setUser(patientUser);
        
        String patientGender = rs.getString("patient_gender");
        if (patientGender != null) {
            patient.setGender(Gender.valueOf(patientGender.toUpperCase()));
        }
        
        patient.setDate_of_birth(rs.getDate("patient_dob"));
        patient.setAddress(rs.getString("patient_address"));
        patient.setImage_url(rs.getString("patient_image"));
        patient.setCreated_at(rs.getTimestamp("patient_created_at"));

        // Tạo Doctor
        User doctorUser = new User();
        doctorUser.setUserId(rs.getInt("doctor_user_id"));
        String doctorFullName = rs.getString("doctor_full_name");
        doctorUser.setFullName(doctorFullName != null ? doctorFullName : "");

        Specialty specialty = null;
        int specialtyId = rs.getInt("specialty_id");
        if (!rs.wasNull()) {
            String specialtyName = rs.getString("specialty_name");
            specialty = new Specialty(specialtyId, specialtyName != null ? specialtyName : "");
        }

        Doctor doctor = new Doctor();
        doctor.setDoctor_id(rs.getInt("doctor_id"));
        doctor.setUser(doctorUser);
        
        String doctorGender = rs.getString("doctor_gender");
        if (doctorGender != null) {
            doctor.setGender(Gender.valueOf(doctorGender.toUpperCase()));
        }
        
        doctor.setDob(rs.getDate("doctor_dob"));
        doctor.setImage_url(rs.getString("doctor_image"));
        doctor.setSpecialty(specialty);
        doctor.setDegree(rs.getString("degree"));
        doctor.setExperience(rs.getString("experience"));
        
        String doctorStatus = rs.getString("doctor_status");
        if (doctorStatus != null) {
            doctor.setStatus(Status.valueOf(doctorStatus));
        }
        
        doctor.setCreated_at(rs.getTimestamp("doctor_created_at"));

        // Tạo ConsultationSession
        ConsultationSession session = new ConsultationSession();
        session.setSession_id(rs.getInt("session_id"));
        session.setPatient(patient);
        session.setDoctor(doctor);
        
        String sessionStatus = rs.getString("status");
        session.setStatus(sessionStatus != null ? sessionStatus : "pending");
        
        session.setCreated_at(rs.getTimestamp("created_at"));
        session.setUpdated_at(rs.getTimestamp("updated_at"));
        session.setPatient_message(rs.getString("patient_message"));
        session.setPatient_symptoms(rs.getString("patient_symptoms"));

        return session;
    }
    
    // Đếm số phiên tư vấn của bác sĩ theo trạng thái
    public static int countSessionsByDoctorAndStatus(int doctorId, String status) throws SQLException {
        String sql = "SELECT COUNT(*) FROM consultation_sessions WHERE doctor_id = ? AND status = ?";
        try (Connection conn = DBContext.makeConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, doctorId);
            stmt.setString(2, status);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }
        return 0;
    }
    
    // Đếm tổng số phiên tư vấn của bác sĩ
    public static int countSessionsByDoctor(int doctorId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM consultation_sessions WHERE doctor_id = ?";
        try (Connection conn = DBContext.makeConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, doctorId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }
        return 0;
    }
} 