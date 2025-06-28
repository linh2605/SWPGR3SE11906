package dal;

import models.Appointment;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import models.PaymentStatus;
import models.Service;
import models.ServiceType;
import models.User;

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
        String sql = "SELECT a.appointment_id\n"
                + "	 , a.patient_id\n"
                + "	 , u1.full_name  AS patient_name\n"
                + "	 , a.doctor_id\n"
                + "	 , u2.full_name AS doctor_name\n"
                + "	 , appointment_date\n"
                + "	 , a.status\n"
                + "	 , a.note\n"
                + "	 , a.created_at\n"
                + "	 , updated_at\n"
                + "	 , a.service_id\n"
                + "	 , s.name       AS service_name\n"
                + "	 , s.detail     AS service_detail\n"
                + "	 , s.price      AS service_price\n"
                + "	 , s.type       AS service_type\n"
                + "	 , a.payment_status\n"
                + "  FROM appointments a\n"
                + "	       JOIN patients p\n"
                + "	       ON a.patient_id = p.patient_id\n"
                + "	       JOIN users u1\n"
                + "	       ON u1.user_id = p.user_id\n"
                + "	       JOIN doctors d\n"
                + "	       ON a.doctor_id = d.doctor_id\n"
                + "	       JOIN users u2\n"
                + "	       ON d.user_id = u2.user_id\n"
                + "	       JOIN services s\n"
                + "	       ON a.service_id = s.service_id\n"
                + " WHERE appointment_id = ?";
        System.out.println(sql);
        try (Connection conn = DBContext.makeConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Appointment appt = new Appointment();
                    appt.setId(rs.getInt("appointment_id"));
                    appt.setAppointmentDate(rs.getTimestamp("appointment_date").toLocalDateTime());
                    appt.setStatus(rs.getString("status"));
                    appt.setNote(rs.getString("note"));
                    appt.setPaymentStatus(PaymentStatus.valueOf(rs.getString("payment_status")));

                    models.Patient patient = new models.Patient();
                    patient.setPatient_id(rs.getInt("patient_id"));
                    User u1 = new User();
                    u1.setFullName(rs.getString("patient_name"));
                    patient.setUser(u1);
                    appt.setPatient(patient);

                    models.Doctor doctor = new models.Doctor();
                    doctor.setDoctor_id(rs.getInt("doctor_id"));
                    User u2 = new User();
                    u2.setFullName(rs.getString("doctor_name"));
                    doctor.setUser(u2);
                    appt.setDoctor(doctor);

                    Service s = new Service();
                    s.setService_id(rs.getInt("service_id"));
                    s.setName(rs.getString("service_name"));
                    s.setDetail(rs.getString("service_detail"));
                    s.setPrice(rs.getLong("service_price"));
                    s.setType(ServiceType.valueOf(rs.getString("service_type")));
                    appt.setService(ServiceDAO.getServiceById(rs.getInt("service_id")));
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
}
