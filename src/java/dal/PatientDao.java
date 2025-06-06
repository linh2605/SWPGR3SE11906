package dal;

import dal.DBContext;
import models.Gender;
import models.Patient;
import models.Role;
import models.User;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class PatientDao {
    public static List<Patient> getAllPatients() {
        List<Patient> patients = new ArrayList<>();
        String sql = "SELECT p.*, u.*, r.name AS role_name, r.description AS role_description " +
                "FROM patients p " +
                "JOIN users u ON p.user_id = u.user_id " +
                "JOIN roles r ON u.role_id = r.role_id";
        try (Connection conn = DBContext.makeConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                patients.add(mappingPatient(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return patients;
    }
    public static Patient getPatientById(int patient_id) {
        String sql = "SELECT p.*, u.*, r.name AS role_name, r.description AS role_description " +
                "FROM patients p " +
                "JOIN users u ON p.user_id = u.user_id " +
                "JOIN roles r ON u.role_id = r.role_id " +
                "WHERE p.patient_id = ?";
        try (Connection conn = DBContext.makeConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
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
    public static boolean createPatient(Patient patient) {
        String sql = "INSERT INTO patients (user_id, gender, date_of_birth, address, image_url) " +
                "VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DBContext.makeConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, patient.getUser().getUser_id());
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
    public static boolean deletePatient(int patient_id) {
        String sql = "DELETE FROM patients WHERE patient_id = ?";
        try (Connection conn = DBContext.makeConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, patient_id);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    private static Patient mappingPatient(ResultSet rs) throws SQLException {
        Patient patient = new Patient();
        patient.setPatient_id(rs.getInt("patient_id"));
        patient.setGender(Gender.valueOf(rs.getString("gender")));
        patient.setDate_of_birth(rs.getDate("date_of_birth"));
        patient.setAddress(rs.getString("address"));
        patient.setImage_url(rs.getString("image_url"));
        patient.setCreated_at(rs.getTimestamp("created_at"));

        User user = new User();
        user.setUser_id(rs.getInt("user_id"));
        user.setUsername(rs.getString("username"));
        user.setPassword(rs.getString("password"));
        user.setFullname(rs.getString("full_name"));
        user.setEmail(rs.getString("email"));
        user.setPhone(rs.getString("phone"));
        user.setCreated_at(rs.getTimestamp("users.created_at"));

        Role role = new Role();
        role.setName(rs.getString("role_name"));
        role.setDescription(rs.getString("role_description"));
        user.setRole(role);

        patient.setUser(user);
        return patient;
    }
}
