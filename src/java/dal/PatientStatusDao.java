/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import models.PatientStatus;

/**
 *
 * @author auiri
 */
public class PatientStatusDao {

    public static List<PatientStatus> getByHandledRole(int roleId) {
    List<PatientStatus> list = new ArrayList<>();
    String sql = "SELECT p.patient_id, u.full_name, s.code, s.description, ps.changed_at " +
                "FROM patients p " +
                "JOIN users u ON p.user_id = u.user_id " +
                "JOIN status_definitions s ON p.status_code = s.code " +
                "JOIN patient_status_logs ps ON p.patient_id = ps.patient_id " +
                "WHERE s.next_handled_by = ? " +
                "AND ps.changed_at = ( " +
                "    SELECT MAX(changed_at) " +
                "    FROM patient_status_logs " +
                "    WHERE patient_id = p.patient_id " +
                ") " +
                "ORDER BY ps.changed_at ASC";

    System.out.println("DEBUG: Getting patients for role " + roleId + " with SQL: " + sql);

    try (Connection conn = DBContext.makeConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
        ps.setInt(1, roleId);  // Lọc theo vai trò của user (lễ tân, bác sĩ...)
        ResultSet rs = ps.executeQuery();

        while (rs.next()) {
            PatientStatus psObj = new PatientStatus(
                rs.getInt("patient_id"),
                rs.getString("full_name"),
                rs.getInt("code"),
                rs.getString("description"),
                rs.getTimestamp("changed_at")  // Thêm thời gian thay đổi trạng thái
            );
            list.add(psObj);
            System.out.println("DEBUG: Found patient: " + psObj.getFullName() + " with status: " + psObj.getStatusDescription());
        }
        
        System.out.println("DEBUG: Total patients found: " + list.size());
    } catch (Exception e) {
        System.out.println("DEBUG: Error in getByHandledRole: " + e.getMessage());
        e.printStackTrace();
    }

    return list;
}




    public static void updateStatus(int patientId, int statusCode, int changedBy) {
        String updatePatientStatus = "UPDATE patients SET status_code = ? WHERE patient_id = ?";
        String logStatusChange = "INSERT INTO patient_status_logs(patient_id, status_code, changed_by, changed_at) VALUES (?, ?, ?, NOW())";

        System.out.println("DEBUG: Updating patient " + patientId + " to status code " + statusCode + " by user " + changedBy);

        try (Connection conn = DBContext.makeConnection()) {
            conn.setAutoCommit(false);
            try (PreparedStatement ps1 = conn.prepareStatement(updatePatientStatus); PreparedStatement ps2 = conn.prepareStatement(logStatusChange)) {

                // Cập nhật trạng thái bệnh nhân
                ps1.setInt(1, statusCode);
                ps1.setInt(2, patientId);
                int rowsAffected1 = ps1.executeUpdate();
                System.out.println("DEBUG: Updated patients table, rows affected: " + rowsAffected1);

                // Ghi log thay đổi trạng thái
                ps2.setInt(1, patientId);
                ps2.setInt(2, statusCode);
                ps2.setInt(3, changedBy);
                int rowsAffected2 = ps2.executeUpdate();
                System.out.println("DEBUG: Inserted into patient_status_logs, rows affected: " + rowsAffected2);

                conn.commit();
                System.out.println("DEBUG: Patient status update completed successfully");
            } catch (SQLException e) {
                conn.rollback();
                System.out.println("DEBUG: Error updating patient status: " + e.getMessage());
                throw e;
            }
        } catch (Exception e) {
            System.out.println("DEBUG: Exception in updateStatus: " + e.getMessage());
            e.printStackTrace();
        }
    }
    
    // Thêm methods cho dashboard
    public static int countPatientsByStatus(int statusCode) {
        String sql = "SELECT COUNT(*) FROM patients WHERE status_code = ?";
        try (Connection conn = DBContext.makeConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, statusCode);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }
    
    public static List<PatientStatus> getPatientsByStatus(int statusCode) {
        List<PatientStatus> list = new ArrayList<>();
        String sql = "SELECT p.patient_id, u.full_name, s.code, s.description, ps.changed_at " +
                    "FROM patients p " +
                    "JOIN users u ON p.user_id = u.user_id " +
                    "JOIN status_definitions s ON p.status_code = s.code " +
                    "JOIN patient_status_logs ps ON p.patient_id = ps.patient_id " +
                    "WHERE p.status_code = ? " +
                    "AND ps.changed_at = ( " +
                    "    SELECT MAX(changed_at) " +
                    "    FROM patient_status_logs " +
                    "    WHERE patient_id = p.patient_id " +
                    ") " +
                    "ORDER BY ps.changed_at ASC";
        
        try (Connection conn = DBContext.makeConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, statusCode);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                PatientStatus psObj = new PatientStatus(
                    rs.getInt("patient_id"),
                    rs.getString("full_name"),
                    rs.getInt("code"),
                    rs.getString("description"),
                    rs.getTimestamp("changed_at")
                );
                list.add(psObj);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    /**
     * Debug function: Kiểm tra trạng thái hiện tại của bệnh nhân
     */
    public static void debugPatientStatus(int patientId) {
        String sql = "SELECT p.patient_id, u.full_name, p.status_code, s.description " +
                    "FROM patients p " +
                    "JOIN users u ON p.user_id = u.user_id " +
                    "LEFT JOIN status_definitions s ON p.status_code = s.code " +
                    "WHERE p.patient_id = ?";
        
        try (Connection conn = DBContext.makeConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, patientId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                System.out.println("DEBUG: Patient " + rs.getInt("patient_id") + 
                                 " (" + rs.getString("full_name") + ") " +
                                 "has status_code: " + rs.getInt("status_code") + 
                                 " (" + rs.getString("description") + ")");
            } else {
                System.out.println("DEBUG: Patient " + patientId + " not found");
            }
        } catch (Exception e) {
            System.out.println("DEBUG: Error checking patient status: " + e.getMessage());
            e.printStackTrace();
        }
    }

    /**
     * Fix function: Cập nhật trạng thái bệnh nhân cho tất cả appointment đã confirmed
     * nhưng chưa có status_code = 1 (New)
     */
    public static void fixConfirmedAppointments() {
        String sql = "SELECT DISTINCT p.patient_id, p.user_id " +
                    "FROM patients p " +
                    "JOIN appointments a ON p.patient_id = a.patient_id " +
                    "WHERE a.status = 'confirmed' " +
                    "AND (p.status_code IS NULL OR p.status_code != 1)";
        
        System.out.println("DEBUG: Fixing confirmed appointments...");
        
        try (Connection conn = DBContext.makeConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            
            int count = 0;
            while (rs.next()) {
                int patientId = rs.getInt("patient_id");
                int userId = rs.getInt("user_id");
                
                System.out.println("DEBUG: Fixing patient " + patientId + " (user " + userId + ")");
                updateStatus(patientId, 1, userId);
                count++;
            }
            
            System.out.println("DEBUG: Fixed " + count + " confirmed appointments");
        } catch (Exception e) {
            System.out.println("DEBUG: Error fixing confirmed appointments: " + e.getMessage());
            e.printStackTrace();
        }
    }

}
