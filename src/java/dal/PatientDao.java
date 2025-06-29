package dal;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import models.Gender;
import models.Patient;
import models.Role;
import models.User;

public class PatientDao {

    public static List<Patient> getAllPatients() {
        List<Patient> patients = new ArrayList<>();
        String sql = "SELECT p.*, u.*, r.name AS role_name, r.description AS role_description "
                + "FROM patients p "
                + "JOIN users u ON p.user_id = u.user_id "
                + "JOIN roles r ON u.role_id = r.role_id";
        try (Connection conn = DBContext.makeConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                patients.add(mappingPatient(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return patients;
    }

    public static Patient getPatientById(int patient_id) {
        String sql = "SELECT p.*, u.*, r.name AS role_name, r.description AS role_description "
                + "FROM patients p "
                + "JOIN users u ON p.user_id = u.user_id "
                + "JOIN roles r ON u.role_id = r.role_id "
                + "WHERE p.patient_id = ?";
        try (Connection conn = DBContext.makeConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, patient_id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mappingPatient(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public static Patient getPatientByUserId(int userId) {
        String sql = "SELECT patient_id\n"
                + "	 , p.user_id\n"
                + "	 , u.full_name\n"
                + "	 , u.email\n"
                + "	 , u.phone\n"
                + "	 , gender\n"
                + "	 , date_of_birth\n"
                + "	 , address\n"
                + "	 , image_url\n"
                + "	 , p.created_at\n"
                + "  FROM patients p\n"
                + "	       JOIN users u\n"
                + "	       ON p.user_id = u.user_id\n"
                + " WHERE p.user_id = ?;";
        try (Connection conn = DBContext.makeConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Patient p = new Patient();
                p.setPatient_id(rs.getInt("patient_id"));
                p.setFullName(rs.getString("full_name"));
                User u = new User();
                u.setUserId(userId);
                u.setFullName(rs.getString("full_name"));
                u.setEmail(rs.getString("email"));
                u.setPhone(rs.getString("phone"));
                p.setUser(u);
                String genderStr = rs.getString("gender");
                if (genderStr != null && !genderStr.trim().isEmpty()) {
                    try {
                        p.setGender(Gender.valueOf(genderStr.toUpperCase()));
                    } catch (IllegalArgumentException e) {
                        System.err.println("Invalid gender value in database: " + genderStr);
                        p.setGender(Gender.OTHER);
                    }
                } else {
                    p.setGender(Gender.OTHER);
                }
                p.setDate_of_birth(rs.getDate("date_of_birth"));
                p.setAddress(rs.getString("address"));
                p.setImage_url(rs.getString("image_url"));
                p.setCreated_at(rs.getTimestamp("p.created_at"));
                
                return p;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public static boolean createPatient(Patient patient) {
        String sql = "INSERT INTO patients (user_id, gender, date_of_birth, address, image_url) "
                + "VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DBContext.makeConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, patient.getUser().getUserId());
            ps.setString(2, patient.getGender().toString());
            ps.setDate(3, patient.getDate_of_birth());
            ps.setString(4, patient.getAddress());
            ps.setString(5, patient.getImage_url());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    private static Patient mappingPatient(ResultSet rs) throws SQLException {
        Patient patient = new Patient();
        patient.setPatient_id(rs.getInt("patient_id"));
        String genderStr = rs.getString("gender");
        if (genderStr != null && !genderStr.trim().isEmpty()) {
            try {
                patient.setGender(Gender.valueOf(genderStr.toUpperCase()));
            } catch (IllegalArgumentException e) {
                System.err.println("Invalid gender value in database: " + genderStr);
                patient.setGender(Gender.OTHER);
            }
        } else {
            patient.setGender(Gender.OTHER);
        }
        patient.setDate_of_birth(rs.getDate("date_of_birth"));
        patient.setAddress(rs.getString("address"));
        patient.setImage_url(rs.getString("image_url"));
        patient.setCreated_at(rs.getTimestamp("p.created_at"));

        User user = new User();
        user.setUserId(rs.getInt("user_id"));
        user.setUsername(rs.getString("username"));
        user.setPassword(rs.getString("password"));
        user.setFullName(rs.getString("full_name"));
        user.setEmail(rs.getString("email"));
        user.setPhone(rs.getString("phone"));
        user.setCreatedAt(rs.getTimestamp("u.created_at"));

        Role role = new Role();
        role.setName(rs.getString("role_name"));
        role.setDescription(rs.getString("role_description"));
        user.setRole(role);

        patient.setUser(user);
        return patient;
    }

    public static boolean updatePatient(Patient patient) {
        String sql = "UPDATE patients SET gender = ?, date_of_birth = ?, address = ?, image_url = ? "
                + "WHERE patient_id = ?";
        try (Connection conn = DBContext.makeConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, patient.getGender().toString());
            ps.setDate(2, patient.getDate_of_birth());
            ps.setString(3, patient.getAddress());
            ps.setString(4, patient.getImage_url());
            ps.setInt(5, patient.getPatient_id());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}
