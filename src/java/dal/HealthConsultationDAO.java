package dal;

import models.*;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class HealthConsultationDAO {

    public static void create(HealthConsultation hc) throws SQLException {
        String sql = "INSERT INTO health_consultation (doctor_id, patient_id, detail) VALUES (?, ?, ?)";
        try (Connection conn = DBContext.makeConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, hc.getDoctor().getDoctor_id());
            stmt.setInt(2, hc.getPatient().getPatient_id());
            stmt.setString(3, hc.getDetail());

            stmt.executeUpdate();
        }
    }

    public static List<HealthConsultation> getAll() throws SQLException {
        List<HealthConsultation> list = new ArrayList<>();

        String sql = """
            SELECT hc.consultation_id, hc.detail, hc.created_at,

                   d.doctor_id AS doctor_id, d.gender AS doctor_gender, d.dob AS doctor_dob,
                   d.image_url AS doctor_image, d.degree, d.experience,
                   d.status AS doctor_status, d.created_at AS doctor_created_at,
                   u1.user_id AS doctor_user_id, u1.full_name AS doctor_full_name,

                   s.specialty_id, s.name AS specialty_name,

                   p.patient_id AS patient_id, p.gender AS patient_gender,
                   p.date_of_birth AS patient_dob, p.address AS patient_address,
                   p.image_url AS patient_image, p.created_at AS patient_created_at,
                   u2.user_id AS patient_user_id, u2.full_name AS patient_full_name

            FROM health_consultation hc
            JOIN doctors d ON hc.doctor_id = d.doctor_id
            JOIN users u1 ON d.user_id = u1.user_id
            LEFT JOIN specialties s ON d.specialty_id = s.specialty_id
            JOIN patients p ON hc.patient_id = p.patient_id
            JOIN users u2 ON p.user_id = u2.user_id
        """;

        try (Connection conn = DBContext.makeConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                list.add(extractFromResultSet(rs));
            }
        }

        return list;
    }

    public static HealthConsultation getById(int id) throws SQLException {
        String sql = """
            SELECT hc.consultation_id, hc.detail, hc.created_at,

                   d.doctor_id AS doctor_id, d.gender AS doctor_gender, d.dob AS doctor_dob,
                   d.image_url AS doctor_image, d.degree, d.experience,
                   d.status AS doctor_status, d.created_at AS doctor_created_at,
                   u1.user_id AS doctor_user_id, u1.full_name AS doctor_full_name,

                   s.specialty_id, s.name AS specialty_name,

                   p.patient_id AS patient_id, p.gender AS patient_gender,
                   p.date_of_birth AS patient_dob, p.address AS patient_address,
                   p.image_url AS patient_image, p.created_at AS patient_created_at,
                   u2.user_id AS patient_user_id, u2.full_name AS patient_full_name

            FROM health_consultation hc
            JOIN doctors d ON hc.doctor_id = d.doctor_id
            JOIN users u1 ON d.user_id = u1.user_id
            LEFT JOIN specialties s ON d.specialty_id = s.specialty_id
            JOIN patients p ON hc.patient_id = p.patient_id
            JOIN users u2 ON p.user_id = u2.user_id
            WHERE hc.consultation_id = ?
        """;

        try (Connection conn = DBContext.makeConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return extractFromResultSet(rs);
                }
            }
        }

        return null;
    }

    public static void update(HealthConsultation hc) throws SQLException {
        String sql = "UPDATE health_consultation SET detail = ? WHERE consultation_id = ?";
        try (Connection conn = DBContext.makeConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, hc.getDetail());
            stmt.setInt(2, hc.getConsultation_id());

            stmt.executeUpdate();
        }
    }

    public static void delete(int id) throws SQLException {
        String sql = "DELETE FROM health_consultation WHERE consultation_id = ?";
        try (Connection conn = DBContext.makeConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, id);
            stmt.executeUpdate();
        }
    }

    private static HealthConsultation extractFromResultSet(ResultSet rs) throws SQLException {
        User doctorUser = new User();
        doctorUser.setUserId(rs.getInt("doctor_user_id"));
        doctorUser.setFullName(rs.getString("doctor_full_name"));

        Specialty specialty = new Specialty(
                rs.getInt("specialty_id"),
                rs.getString("specialty_name")
        );

        Doctor doctor = new Doctor();
        doctor.setDoctor_id(rs.getInt("doctor_id"));
        doctor.setUser(doctorUser);
        doctor.setGender(Gender.valueOf(rs.getString("doctor_gender").toUpperCase()));
        doctor.setDob(rs.getDate("doctor_dob"));
        doctor.setImage_url(rs.getString("doctor_image"));
        doctor.setSpecialty(specialty);
        doctor.setDegree(rs.getString("degree"));
        doctor.setExperience(rs.getString("experience"));
        doctor.setStatus(Status.valueOf(rs.getString("doctor_status")));
        doctor.setCreated_at(rs.getTimestamp("doctor_created_at"));

        User patientUser = new User();
        patientUser.setUserId(rs.getInt("patient_user_id"));
        patientUser.setFullName(rs.getString("patient_full_name"));

        Patient patient = new Patient();
        patient.setPatient_id(rs.getInt("patient_id"));
        patient.setUser(patientUser);
        patient.setGender(Gender.valueOf(rs.getString("patient_gender").toUpperCase()));
        patient.setDate_of_birth(rs.getDate("patient_dob"));
        patient.setAddress(rs.getString("patient_address"));
        patient.setImage_url(rs.getString("patient_image"));
        patient.setCreated_at(rs.getTimestamp("patient_created_at"));

        HealthConsultation hc = new HealthConsultation();
        hc.setConsultation_id(rs.getInt("consultation_id"));
        hc.setDetail(rs.getString("detail"));
        hc.setCreated_at(rs.getTimestamp("created_at"));
        hc.setDoctor(doctor);
        hc.setPatient(patient);

        return hc;
    }
}
