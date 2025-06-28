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
        String sql = """
        SELECT p.patient_id, u.full_name, s.code, s.description
        FROM patients p
        JOIN users u ON p.user_id = u.user_id
        JOIN status_definitions s ON p.status_code = s.code
        WHERE s.next_handled_by = ?  -- Điều kiện này để lọc theo vai trò
    """;

        try (Connection conn = DBContext.makeConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, roleId);  // Lọc theo vai trò của user (lễ tân, bác sĩ...)
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                PatientStatus psObj = new PatientStatus();
                psObj.setPatientId(rs.getInt("patient_id"));
                psObj.setFullName(rs.getString("full_name"));
                psObj.setStatusCode(rs.getInt("code"));
                psObj.setStatusDescription(rs.getString("description"));
                list.add(psObj);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public static void updateStatus(int patientId, int statusCode, int changedBy) {
        String updatePatientStatus = "UPDATE patients SET status_code = ? WHERE patient_id = ?";
        String logStatusChange = "INSERT INTO patient_status_logs(patient_id, status_code, changed_by, changed_at) VALUES (?, ?, ?, NOW())";

        try (Connection conn = DBContext.makeConnection()) {
            conn.setAutoCommit(false);
            try (PreparedStatement ps1 = conn.prepareStatement(updatePatientStatus); PreparedStatement ps2 = conn.prepareStatement(logStatusChange)) {

                // Cập nhật trạng thái bệnh nhân
                ps1.setInt(1, statusCode);
                ps1.setInt(2, patientId);
                ps1.executeUpdate();

                // Ghi log thay đổi trạng thái
                ps2.setInt(1, patientId);
                ps2.setInt(2, statusCode);
                ps2.setInt(3, changedBy);
                ps2.executeUpdate();

                conn.commit();
            } catch (SQLException e) {
                conn.rollback();
                throw e;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

}
