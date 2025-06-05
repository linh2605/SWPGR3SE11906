package dal;

import model.Appointment;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import model.Doctor;
import model.Patient;

public class AppointmentDao {

    public static List<Appointment> getAppointmentsByPatientId(int patientId, int page, int size) {
        System.out.println("[DEBUG] getAppointmentsByPatientId: patientId=" + patientId + ", page=" + page + ", size=" + size);
        List<Appointment> appointments = new ArrayList<>();
        String sql = "SELECT appointment_id\n"
                + "	 , a.patient_id\n"
                + "	 , p.full_name AS patient_name\n"
                + "	 , a.doctor_id\n"
                + "	 , d.full_name AS doctor_name\n"
                + "	 , appointment_date\n"
                + "	 , a.status\n"
                + "	 , note\n"
                + "	 , a.created_at\n"
                + "	 , updated_at\n"
                + "  FROM appointments a\n"
                + "	       JOIN patients p\n"
                + "	       ON a.patient_id = p.patient_id\n"
                + "	       JOIN doctors d\n"
                + "	       ON a.doctor_id = d.doctor_id\n"
                + " WHERE a.patient_id = ?\n"
                + " ORDER BY appointment_date DESC\n"
                + " LIMIT ? OFFSET ?;";
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
        // limit = page size
        // offset = (page-1) * page size
        String sql = "SELECT appointment_id\n"
                + "	 , a.patient_id\n"
                + "	 , p.full_name AS patient_name\n"
                + "	 , a.doctor_id\n"
                + "	 , d.full_name AS doctor_name\n"
                + "	 , appointment_date\n"
                + "	 , a.status\n"
                + "	 , note\n"
                + "	 , a.created_at\n"
                + "	 , updated_at\n"
                + "  FROM appointments a\n"
                + "	       JOIN patients p\n"
                + "	       ON a.patient_id = p.patient_id\n"
                + "	       JOIN doctors d\n"
                + "	       ON a.doctor_id = d.doctor_id\n"
                + " WHERE a.doctor_id = ?\n"
                + " ORDER BY appointment_date DESC\n"
                + " LIMIT ? OFFSET ?;";

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

    public static List<Appointment> getAllAppointments(int page, int size) {
        // limit = page size
        // offset = (page-1) * page size
        List<Appointment> appointments = new ArrayList<>();
        String sql = "SELECT appointment_id\n"
                + "	 , a.patient_id\n"
                + "	 , p.full_name AS patient_name\n"
                + "	 , a.doctor_id\n"
                + "	 , d.full_name AS doctor_name\n"
                + "	 , appointment_date\n"
                + "	 , a.status\n"
                + "	 , note\n"
                + "	 , a.created_at\n"
                + "	 , updated_at\n"
                + "  FROM appointments a\n"
                + "	       JOIN patients p\n"
                + "	       ON a.patient_id = p.patient_id\n"
                + "	       JOIN doctors d\n"
                + "	       ON a.doctor_id = d.doctor_id\n"
                + " ORDER BY appointment_date DESC\n"
                + " LIMIT ? OFFSET ?;";
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

    // TODO: fix sau
    private static Appointment mappingAppointment(ResultSet rs) throws SQLException {
        Appointment appt = new Appointment();
        appt.setId(rs.getInt("appointment_id"));
        Patient patient = new Patient();
        patient.setPatient_id(rs.getInt("patient_id"));
        patient.setFullName(rs.getString("patient_name"));
        appt.setPatient(patient);
        Doctor doctor = new Doctor();
        doctor.setDoctor_id(rs.getInt("doctor_id"));
        doctor.setFullName(rs.getString("doctor_name"));
        appt.setDoctor(doctor);
        appt.setDateTime(rs.getTimestamp("appointment_date").toLocalDateTime());
        appt.setStatus(rs.getString("status"));
        appt.setNote(rs.getString("note"));
        appt.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
        appt.setUpdateAt(rs.getTimestamp("updated_at").toLocalDateTime());

        return appt;
    }
}
