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
    
    public static void deletePatient(int userId){
        try {
            // Since patients table doesn't have status column, we'll delete the record
            String sql = "DELETE FROM patients WHERE user_id = ?";
            Connection conn = DBContext.makeConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);
            ps.executeUpdate();
        } catch (Exception e){
            e.printStackTrace();
        }
    }
    
    // Xóa mềm bệnh nhân
    public static boolean softDeletePatient(int patientId) {
        try {
            String sql = "UPDATE patients SET deleted_at = NOW() WHERE patient_id = ?";
            Connection conn = DBContext.makeConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, patientId);
            int result = ps.executeUpdate();
            System.out.println("PatientDao.softDeletePatient() - Soft deleted patient with patient_id: " + patientId + ", rows affected: " + result);
            return result > 0;
        } catch (Exception e) {
            e.printStackTrace();
            System.err.println("Error in PatientDao.softDeletePatient(): " + e.getMessage());
            return false;
        }
    }
    
    // Khôi phục bệnh nhân đã xóa mềm
    public static boolean restorePatient(int userId) {
        try {
            String sql = "UPDATE patients SET deleted_at = NULL WHERE user_id = ?";
            Connection conn = DBContext.makeConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);
            int result = ps.executeUpdate();
            System.out.println("PatientDao.restorePatient() - Restored patient with user_id: " + userId + ", rows affected: " + result);
            return result > 0;
        } catch (Exception e) {
            e.printStackTrace();
            System.err.println("Error in PatientDao.restorePatient(): " + e.getMessage());
            return false;
        }
    }
    
    // Cập nhật trạng thái bệnh nhân
    public static boolean updatePatientStatus(int patientId, String status) {
        try {
            String sql = "UPDATE patients SET status = ? WHERE patient_id = ?";
            Connection conn = DBContext.makeConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, status);
            ps.setInt(2, patientId);
            int result = ps.executeUpdate();
            System.out.println("PatientDao.updatePatientStatus() - Updated patient status: " + patientId + " to " + status + ", rows affected: " + result);
            return result > 0;
        } catch (Exception e) {
            e.printStackTrace();
            System.err.println("Error in PatientDao.updatePatientStatus(): " + e.getMessage());
            return false;
        }
    }

    public static List<Patient> getAllPatients() {
        List<Patient> patients = new ArrayList<>();
        String sql = "SELECT p.*, u.*, r.name AS role_name, r.description AS role_description "
                + "FROM patients p "
                + "JOIN users u ON p.user_id = u.user_id "
                + "JOIN roles r ON u.role_id = r.role_id "
                + "WHERE p.deleted_at IS NULL";
        try (Connection conn = DBContext.makeConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                patients.add(mappingPatient(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return patients;
    }
    
    // Lấy tất cả bệnh nhân chưa xóa mềm
    public static List<Patient> getAllNonDeletedPatients() {
        List<Patient> patients = new ArrayList<>();
        String sql = "SELECT p.patient_id, p.user_id, p.gender, p.date_of_birth, p.address, p.image_url, p.status_code, p.status, p.deleted_at, p.created_at, "
                + "u.username, u.password, u.full_name, u.email, u.phone, u.created_at as u_created_at, "
                + "r.name AS role_name, r.description AS role_description "
                + "FROM patients p "
                + "JOIN users u ON p.user_id = u.user_id "
                + "JOIN roles r ON u.role_id = r.role_id "
                + "WHERE p.deleted_at IS NULL "
                + "ORDER BY p.patient_id";
        try (Connection conn = DBContext.makeConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                patients.add(mappingPatient(rs));
            }
            System.out.println("PatientDao.getAllNonDeletedPatients() - Retrieved " + patients.size() + " patients (not deleted)");
        } catch (Exception e) {
            e.printStackTrace();
            System.err.println("Error in PatientDao.getAllNonDeletedPatients(): " + e.getMessage());
        }
        return patients;
    }
    
    // Lấy tất cả bệnh nhân đã xóa mềm
    public static List<Patient> getSoftDeletedPatients() {
        List<Patient> patients = new ArrayList<>();
        String sql = "SELECT p.patient_id, p.user_id, p.gender, p.date_of_birth, p.address, p.image_url, p.status_code, p.status, p.deleted_at, p.created_at, "
                + "u.username, u.password, u.full_name, u.email, u.phone, u.created_at as u_created_at, "
                + "r.name AS role_name, r.description AS role_description "
                + "FROM patients p "
                + "JOIN users u ON p.user_id = u.user_id "
                + "JOIN roles r ON u.role_id = r.role_id "
                + "WHERE p.deleted_at IS NOT NULL "
                + "ORDER BY p.deleted_at DESC";
        try (Connection conn = DBContext.makeConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                patients.add(mappingPatient(rs));
            }
            System.out.println("PatientDao.getSoftDeletedPatients() - Retrieved " + patients.size() + " soft deleted patients");
        } catch (Exception e) {
            e.printStackTrace();
            System.err.println("Error in PatientDao.getSoftDeletedPatients(): " + e.getMessage());
        }
        return patients;
    }

    public static Patient getPatientById(int patient_id) {
        String sql = "SELECT p.*, u.*, r.name AS role_name, r.description AS role_description "
                + "FROM patients p "
                + "JOIN users u ON p.user_id = u.user_id "
                + "JOIN roles r ON u.role_id = r.role_id "
                + "WHERE p.patient_id = ? AND p.deleted_at IS NULL";
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
        System.out.println("PatientDao.getPatientByUserId() called with userId: " + userId);
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
                + " WHERE p.user_id = ? AND p.deleted_at IS NULL;";
        try (Connection conn = DBContext.makeConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                System.out.println("Patient found in database");
                Patient p = new Patient();
                p.setPatient_id(rs.getInt("patient_id"));
                
                String fullName = rs.getString("full_name");
                System.out.println("Full name from DB: " + fullName);
                p.setFullName(fullName);
                
                User u = new User();
                u.setUserId(userId);
                u.setFullName(fullName);
                u.setEmail(rs.getString("email"));
                u.setPhone(rs.getString("phone"));
                p.setUser(u);
                
                String genderStr = rs.getString("gender");
                System.out.println("Gender from DB: " + genderStr);
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
                
                System.out.println("Patient object created successfully");
                return p;
            } else {
                System.out.println("No patient found for userId: " + userId);
            }
        } catch (Exception e) {
            System.err.println("Error in getPatientByUserId: " + e.getMessage());
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
        
        // Map cột status từ database
        try {
            patient.setStatus(rs.getString("status"));
        } catch (SQLException e) {
            patient.setStatus("active"); // Default value nếu cột chưa tồn tại
        }
        
        // Xử lý created_at - có thể không tồn tại trong database
        try {
            patient.setCreated_at(rs.getTimestamp("p.created_at"));
        } catch (SQLException e) {
            try {
                patient.setCreated_at(rs.getTimestamp("created_at"));
            } catch (SQLException e2) {
                patient.setCreated_at(null);
            }
        }
        
        // Xử lý deleted_at - có thể không tồn tại trong database
        // Thêm field deleted_at vào Patient model nếu cần
        // patient.setDeletedAt(rs.getTimestamp("deleted_at"));

        User user = new User();
        user.setUserId(rs.getInt("user_id"));
        user.setUsername(rs.getString("username"));
        user.setPassword(rs.getString("password"));
        user.setFullName(rs.getString("full_name"));
        user.setEmail(rs.getString("email"));
        user.setPhone(rs.getString("phone"));
        
        // Xử lý u.created_at - có thể không tồn tại trong database
        try {
            user.setCreatedAt(rs.getTimestamp("u_created_at"));
        } catch (SQLException e) {
            try {
                user.setCreatedAt(rs.getTimestamp("u.created_at"));
            } catch (SQLException e2) {
                user.setCreatedAt(null);
            }
        }

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
    
    public static int countAllPatients() {
        String sql = "SELECT COUNT(*) FROM patients WHERE deleted_at IS NULL";
        try (Connection conn = DBContext.makeConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql); 
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }
    
    public static void main(String[] args) {
        System.out.println(getAllPatients().size());
    }
}
