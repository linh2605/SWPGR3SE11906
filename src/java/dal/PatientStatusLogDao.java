package dal;

import models.PatientStatusLog;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class PatientStatusLogDao {

    // Lấy các bản ghi log của bệnh nhân theo patient_id
    public static List<PatientStatusLog> getLogsByPatientId(int patientId) {
        List<PatientStatusLog> logs = new ArrayList<>();
        String query = "SELECT * FROM swp_db.patient_status_logs WHERE patient_id = ? ORDER BY changed_at ASC"; // Sắp xếp theo thời gian thay đổi

        try (Connection con = DBContext.makeConnection(); PreparedStatement ps = con.prepareStatement(query)) {
            ps.setInt(1, patientId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                int logId = rs.getInt("log_id");
                int statusCode = rs.getInt("status_code");
                int changedBy = rs.getInt("changed_by");
                Timestamp changedAt = rs.getTimestamp("changed_at");

                PatientStatusLog log = new PatientStatusLog(logId, patientId, statusCode, changedBy, changedAt);
                logs.add(log);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return logs;
    }
}
