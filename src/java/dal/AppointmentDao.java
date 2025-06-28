package dal;

import models.Appointment;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import models.Doctor;
import models.PaymentStatus;
import models.Service;

public class AppointmentDao {

    public static List<Appointment> getAppointmentsByPatientId(int patientId, int page, int size) {
        System.out.println("[DEBUG] getAppointmentsByPatientId: patientId=" + patientId + ", page=" + page + ", size=" + size);
        List<Appointment> appointments = new ArrayList<>();
        String sql = "SELECT a.appointment_id, a.appointment_date, ud.full_name AS doctor_name, up.full_name AS patient_name, a.status, a.service_id, a.payment_status "
                + "FROM appointments a "
                + "JOIN doctors d ON a.doctor_id = d.doctor_id "
                + "JOIN users ud ON d.user_id = ud.user_id "
                + "JOIN patients p ON a.patient_id = p.patient_id "
                + "JOIN users up ON p.user_id = up.user_id "
                + "WHERE a.patient_id = ? "
                + "ORDER BY a.appointment_date DESC "
                + "LIMIT ? OFFSET ?";
        try (Connection conn = DBContext.makeConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, patientId);
            stmt.setInt(2, size);
            stmt.setInt(3, (page - 1) * size);
            try (ResultSet rs = stmt.executeQuery()) {
                int count = 0;
                while (rs.next()) {
                    appointments.add(mappingAppointment(rs));
                    count++;
                }
                System.out.println("[DEBUG] Số dòng trả về: " + count);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return appointments;
    }

    public static List<Appointment> getAppointmentsByDoctorId(int doctorId, int page, int size) {
        List<Appointment> appointments = new ArrayList<>();
        String sql = "SELECT a.appointment_id, a.appointment_date, ud.full_name AS doctor_name, up.full_name AS patient_name, a.status, a.service_id, a.payment_status "
                + "FROM appointments a "
                + "JOIN doctors d ON a.doctor_id = d.doctor_id "
                + "JOIN users ud ON d.user_id = ud.user_id "
                + "JOIN patients p ON a.patient_id = p.patient_id "
                + "JOIN users up ON p.user_id = up.user_id "
                + "WHERE a.doctor_id = ? "
                + "ORDER BY a.appointment_date DESC "
                + "LIMIT ? OFFSET ?";
        try (Connection conn = DBContext.makeConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, doctorId);
            stmt.setInt(2, size);
            stmt.setInt(3, (page - 1) * size);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    appointments.add(mappingAppointment(rs));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return appointments;
    }

    public static Appointment getAppointmentById(int id) {
        String sql = "SELECT appointment_id\n"
                + " , patient_id\n"
                + " , doctor_id\n"
                + " , appointment_date\n"
                + " , status\n"
                + " , note\n"
                + " , created_at\n"
                + " , updated_at\n"
                + " , service_id\n"
                + " , payment_status\n"
                + "FROM appointments\n"
                + "WHERE appointment_id = ?";
        System.out.println(sql);
        try (Connection conn = DBContext.makeConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Appointment appt = new Appointment();
                    appt.setId(rs.getInt("appointment_id"));
                    appt.setDateTime(rs.getTimestamp("appointment_date").toLocalDateTime());
                    appt.setStatus(rs.getString("status"));

                    models.Doctor doctor = new models.Doctor();
                    doctor.setDoctor_id(rs.getInt("doctor_id"));
                    appt.setDoctor(doctor);
                    models.Patient patient = new models.Patient();
                    patient.setPatient_id(rs.getInt("patient_id"));
                    appt.setPatient(patient);

                    appt.setService(ServiceDAO.getServiceById(rs.getInt("service_id")));
                    appt.setPaymentStatus(PaymentStatus.valueOf(rs.getString("payment_status")));
                    return appt;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public static List<Appointment> getAllAppointments(int page, int size) {
        List<Appointment> appointments = new ArrayList<>();
        String sql = "SELECT a.appointment_id, a.appointment_date, ud.full_name AS doctor_name, up.full_name AS patient_name, a.status, a.service_id, a.payment_status "
                + "FROM appointments a "
                + "JOIN doctors d ON a.doctor_id = d.doctor_id "
                + "JOIN users ud ON d.user_id = ud.user_id "
                + "JOIN patients p ON a.patient_id = p.patient_id "
                + "JOIN users up ON p.user_id = up.user_id "
                + "ORDER BY a.appointment_date DESC "
                + "LIMIT ? OFFSET ?";
        try (Connection conn = DBContext.makeConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, size);
            stmt.setInt(2, (page - 1) * size);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    appointments.add(mappingAppointment(rs));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return appointments;
    }

    public static int getTotalAppointments() {
        String sql = "SELECT COUNT(*) FROM appointments";
        try (Connection conn = DBContext.makeConnection(); PreparedStatement stmt = conn.prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    public static boolean createAppointment(Appointment appointment) {
        String sql = "INSERT INTO appointments(patient_id, doctor_id, appointment_date, note)\n"
                + "VALUES (?, ?, ?, ?);";
        try (Connection conn = DBContext.makeConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, appointment.getPatient().getPatient_id());
            ps.setInt(2, appointment.getDoctor().getDoctor_id());
            ps.setTimestamp(3, Timestamp.valueOf(appointment.getAppointmentDate()));
            ps.setString(4, appointment.getNote());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    private static Appointment mappingAppointment(ResultSet rs) throws SQLException {
        Appointment appt = new Appointment();
        appt.setId(rs.getInt("appointment_id"));
        appt.setDateTime(rs.getTimestamp("appointment_date").toLocalDateTime());
        appt.setStatus(rs.getString("status"));

        // Doctor
        models.Doctor doctor = new models.Doctor();
        models.User doctorUser = new models.User();
        doctorUser.setFullName(rs.getString("doctor_name"));
        doctor.setUser(doctorUser);
        appt.setDoctor(doctor);

        // Patient
        models.Patient patient = new models.Patient();
        models.User patientUser = new models.User();
        patientUser.setFullName(rs.getString("patient_name"));
        patient.setUser(patientUser);
        appt.setPatient(patient);

        appt.setService(ServiceDAO.getServiceById(rs.getInt("service_id")));
        appt.setPaymentStatus(PaymentStatus.valueOf(rs.getString("payment_status")));

        return appt;
    }

    public static boolean updateAppointmentPaymentStatus(int id, PaymentStatus status) {
        String sql = "UPDATE appointments\n"
                + "   SET payment_status = ?\n"
                + " WHERE appointment_id = ?;";
        try (Connection conn = DBContext.makeConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, status.toString());
            stmt.setInt(2, id);
            return stmt.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public static int countAppointmentsByDoctor(int doctorId) {
        String sql = "SELECT COUNT(*) FROM appointments WHERE doctor_id = ?";
        try (Connection conn = DBContext.makeConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, doctorId);
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

    // ================== BỔ SUNG CHO ĐỔI CA ADMIN ===================
    /**
     * Lấy danh sách appointment của 1 bác sĩ trong khoảng ngày (dạng yyyy-MM-dd)
     */
    public static List<Appointment> findAppointmentsByDoctorAndDateRange(int doctorId, String fromDate, String toDate) {
        List<Appointment> appointments = new ArrayList<>();
        String sql = "SELECT * FROM appointments WHERE doctor_id = ? AND appointment_date >= ? AND appointment_date <= ? AND status = 'scheduled'";
        try (Connection conn = DBContext.makeConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, doctorId);
            stmt.setString(2, fromDate);
            stmt.setString(3, toDate);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Appointment appt = getAppointmentById(rs.getInt("appointment_id"));
                    if (appt != null) appointments.add(appt);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return appointments;
    }

    /**
     * Tìm bác sĩ cùng chuyên khoa, rảnh vào thời gian chỉ định, loại trừ 1 bác sĩ (bị đổi ca)
     */
    public static Doctor findAvailableDoctorForAppointment(int specialtyId, String appointmentDate, String appointmentTime, int excludeDoctorId) {
        String sql = "SELECT d.doctor_id FROM doctors d " +
                "JOIN working_schedules ws ON d.doctor_id = ws.doctor_id " +
                "JOIN shifts s ON ws.shift_id = s.shift_id " +
                "WHERE d.specialty_id = ? AND d.doctor_id != ? AND ws.week_day = DAYNAME(?) " +
                "AND s.start_time <= ? AND s.end_time > ? AND ws.is_active = 1 " +
                "AND d.status = 'active' " +
                "AND d.doctor_id NOT IN (SELECT doctor_id FROM appointments WHERE appointment_date = ? AND status = 'scheduled') " +
                "LIMIT 1";
        try (Connection conn = DBContext.makeConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, specialtyId);
            stmt.setInt(2, excludeDoctorId);
            stmt.setString(3, appointmentDate);
            stmt.setString(4, appointmentTime);
            stmt.setString(5, appointmentTime);
            stmt.setString(6, appointmentDate);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    int doctorId = rs.getInt("doctor_id");
                    return dal.DoctorDao.getDoctorById(doctorId);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Cập nhật bác sĩ cho appointment
     */
    public static boolean updateAppointmentDoctor(int appointmentId, int newDoctorId) {
        String sql = "UPDATE appointments SET doctor_id = ?, updated_at = NOW() WHERE appointment_id = ?";
        try (Connection conn = DBContext.makeConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, newDoctorId);
            stmt.setInt(2, appointmentId);
            return stmt.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Hủy appointment (chuyển status sang 'cancelled')
     */
    public static boolean cancelAppointment(int appointmentId) {
        String sql = "UPDATE appointments SET status = 'cancelled', updated_at = NOW() WHERE appointment_id = ?";
        try (Connection conn = DBContext.makeConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, appointmentId);
            return stmt.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
}
