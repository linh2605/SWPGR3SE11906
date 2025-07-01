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
    SELECT p.patient_id, u.full_name, s.code, s.description, ps.changed_at
    FROM patients p
    JOIN users u ON p.user_id = u.user_id
    JOIN status_definitions s ON p.status_code = s.code
    JOIN patient_status_logs ps ON p.patient_id = ps.patient_id
    WHERE s.next_handled_by = ?  -- Điều kiện này để lọc theo vai trò
    AND ps.changed_at = (
        SELECT MAX(changed_at)
        FROM patient_status_logs
        WHERE patient_id = p.patient_id
    )  -- Lọc chỉ lấy log mới nhất của mỗi bệnh nhân
    ORDER BY ps.changed_at ASC
    """;

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
