package dal;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import models.MedicalRecord;

/**
 * Lớp DAO xử lý các thao tác với hồ sơ bệnh án
 */
public class MedicalRecordDAO {

    // Thêm hồ sơ bệnh án mới
    public static void addMedicalRecord(MedicalRecord record) {
        String sql = """
            INSERT INTO medical_records (patient_id, doctor_id, diagnosis, treatment, prescription, created_at, updated_at)
            VALUES (?, ?, ?, ?, ?, NOW(), NOW())
        """;

        try (Connection conn = DBContext.makeConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, record.getPatientId());
            ps.setInt(2, record.getDoctorId());
            ps.setString(3, record.getDiagnosis());
            ps.setString(4, record.getTreatment());
            ps.setString(5, record.getPrescription());
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Lấy hồ sơ bệnh án theo recordId
    public static MedicalRecord getMedicalRecord(int recordId) {
        String sql = """
            SELECT * FROM medical_records WHERE record_id = ?
        """;

        try (Connection conn = DBContext.makeConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, recordId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return new MedicalRecord(
                        rs.getInt("record_id"),
                        rs.getInt("patient_id"),
                        rs.getInt("doctor_id"),
                        rs.getString("diagnosis"),
                        rs.getString("treatment"),
                        rs.getString("prescription"),
                        rs.getString("created_at"),
                        rs.getString("updated_at")
                );
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;
    }

    // Cập nhật hồ sơ bệnh án
    public static void updateMedicalRecord(MedicalRecord record) {
        String sql = """
            UPDATE medical_records
            SET diagnosis = ?, treatment = ?, prescription = ?, updated_at = NOW()
            WHERE record_id = ?
        """;

        try (Connection conn = DBContext.makeConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, record.getDiagnosis());
            ps.setString(2, record.getTreatment());
            ps.setString(3, record.getPrescription());
            ps.setInt(4, record.getRecordId());
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Xóa hồ sơ bệnh án
    public static void deleteMedicalRecord(int recordId) {
        String sql = """
            DELETE FROM medical_records WHERE record_id = ?
        """;

        try (Connection conn = DBContext.makeConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, recordId);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Lấy danh sách hồ sơ bệnh án của bệnh nhân
    public static List<MedicalRecord> getMedicalRecordsByPatientId(int patientId) {
        List<MedicalRecord> list = new ArrayList<>();
        String sql = """
            SELECT * FROM medical_records WHERE patient_id = ?
        """;

        try (Connection conn = DBContext.makeConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, patientId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                MedicalRecord record = new MedicalRecord(
                        rs.getInt("record_id"),
                        rs.getInt("patient_id"),
                        rs.getInt("doctor_id"),
                        rs.getString("diagnosis"),
                        rs.getString("treatment"),
                        rs.getString("prescription"),
                        rs.getString("created_at"),
                        rs.getString("updated_at")
                );
                list.add(record);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }

    // Lấy tên đầy đủ của bác sĩ
    public static String getDoctorFullName(int doctorId) {
        String sql = """
            SELECT u.full_name
            FROM doctors d
            JOIN users u ON d.user_id = u.user_id
            WHERE d.doctor_id = ?
        """;

        try (Connection conn = DBContext.makeConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, doctorId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getString("full_name");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // Lấy tên đầy đủ của bệnh nhân
    public static String getPatientFullName(int patientId) {
        String sql = """
            SELECT u.full_name
            FROM patients p
            JOIN users u ON p.user_id = u.user_id
            WHERE p.patient_id = ?
        """;

        try (Connection conn = DBContext.makeConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, patientId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getString("full_name");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
}
