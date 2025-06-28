package dal;

import models.Appointment;
import models.Doctor;
import models.Patient;
import models.Specialty;
import models.Status;
import models.User;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class AppointmentDao {

    public static List<Appointment> getAppointmentsByPatientId(int patientId, int page, int size) {
        System.out.println("[DEBUG] getAppointmentsByPatientId: patientId=" + patientId + ", page=" + page + ", size=" + size);
        List<Appointment> appointments = new ArrayList<>();
        String sql = "SELECT a.appointment_id, a.appointment_date, ud.full_name AS doctor_name, up.full_name AS patient_name, a.status "
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
                System.out.println("[DEBUG] Number of rows returned: " + count);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return appointments;
    }

    public static List<Appointment> getAppointmentsByDoctorId(int doctorId, int page, int size) {
        List<Appointment> appointments = new ArrayList<>();
        String sql = "SELECT a.appointment_id, a.appointment_date, ud.full_name AS doctor_name, up.full_name AS patient_name, a.status "
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

    public static List<Appointment> getAllAppointments(int page, int size) {
        List<Appointment> appointments = new ArrayList<>();
        String sql = "SELECT a.appointment_id, a.appointment_date, ud.full_name AS doctor_name, up.full_name AS patient_name, a.status "
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
            ps.setString(4, appointment.getNotes());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
    private static Appointment mappingAppointment(ResultSet rs) throws SQLException { 
        Appointment appt = new Appointment();
        appt.setId(rs.getInt("appointment_id"));

        // Ngày giờ
        java.sql.Timestamp timestamp = rs.getTimestamp("appointment_date");
        if (timestamp != null) {
            java.time.LocalDateTime dateTime = timestamp.toLocalDateTime();
            appt.setAppointmentDateTime(dateTime);
            appt.setAppointmentDate(dateTime.toLocalDate().toString());
            appt.setAppointmentTime(dateTime.toLocalTime().toString());
        }
        appt.setStatus(rs.getString("status"));

        // Bác sĩ
        models.Doctor doctor = new models.Doctor();
        doctor.setFullName(rs.getString("doctor_name"));
        appt.setDoctor(doctor);

        // Bệnh nhân
        models.Patient patient = new models.Patient();
        patient.setFullName(rs.getString("patient_name"));
        appt.setPatient(patient);

        return appt;
    }

    // Find all appointments of a doctor in date range
    public List<Appointment> findAppointmentsByDoctorAndDateRange(int doctorId, String startDate, String endDate) {
        // TODO: Implement proper appointment finding when Lombok issues are resolved
        // For now, return empty list to avoid compilation errors
        return new ArrayList<>();
    }

    // Tìm bác sĩ có thể thay thế cho một lịch hẹn
    public Doctor findAvailableDoctorForAppointment(int specialtyId, String appointmentDate, String appointmentTime, int excludeDoctorId) {
        String sql = "SELECT d.*, u.*, s.* FROM doctors d "
                + "INNER JOIN users u ON d.user_id = u.user_id "
                + "INNER JOIN specialties s ON d.specialty_id = s.specialty_id "
                + "INNER JOIN working_schedules ws ON d.doctor_id = ws.doctor_id "
                + "INNER JOIN shifts sh ON ws.shift_id = sh.shift_id "
                + "WHERE d.specialty_id = ? AND d.doctor_id != ? "
                + "AND ws.week_day = DAYOFWEEK(?) "
                + "AND ? BETWEEN sh.start_time AND sh.end_time "
                + "AND d.status = 'active' "
                + "AND NOT EXISTS (SELECT 1 FROM schedule_exceptions se WHERE se.doctor_id = d.doctor_id AND se.exception_date = ?) "
                + "LIMIT 1";
        
        try (Connection conn = DBContext.makeConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, specialtyId);
            ps.setInt(2, excludeDoctorId);
            ps.setString(3, appointmentDate);
            ps.setString(4, appointmentTime);
            ps.setString(5, appointmentDate);
            
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapResultSetToDoctor(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // Cập nhật bác sĩ cho lịch hẹn
    public boolean updateAppointmentDoctor(int appointmentId, int newDoctorId) {
        String sql = "UPDATE appointments SET doctor_id = ? WHERE appointment_id = ?";
        try (Connection conn = DBContext.makeConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, newDoctorId);
            ps.setInt(2, appointmentId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // Huỷ lịch hẹn
    public boolean cancelAppointment(int appointmentId) {
        String sql = "UPDATE appointments SET status_id = 4 WHERE appointment_id = ?"; // 4 = Cancelled
        try (Connection conn = DBContext.makeConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, appointmentId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // Helper method để map ResultSet thành Doctor object
    private Doctor mapResultSetToDoctor(ResultSet rs) throws SQLException {
        Doctor doctor = new Doctor();
        doctor.setDoctor_id(rs.getInt("d.doctor_id"));
        
        User user = new User();
        user.setUserId(rs.getInt("u.user_id"));
        user.setUsername(rs.getString("u.username"));
        user.setEmail(rs.getString("u.email"));
        user.setFullName(rs.getString("u.full_name"));
        user.setPhone(rs.getString("u.phone"));
        user.setCreatedAt(rs.getTimestamp("u.created_at"));
        
        Specialty specialty = new Specialty();
        specialty.setSpecialty_id(rs.getInt("s.specialty_id"));
        specialty.setName(rs.getString("s.name"));
        specialty.setDescription(rs.getString("s.description"));
        
        doctor.setUser(user);
        doctor.setSpecialty(specialty);
        
        return doctor;
    }

    // Helper method để map ResultSet thành Appointment object
    private Appointment mapResultSetToAppointment(ResultSet rs) throws SQLException {
        Appointment appointment = new Appointment();
        appointment.setId(rs.getInt("a.appointment_id"));
        appointment.setAppointmentDate(rs.getString("a.appointment_date"));
        appointment.setAppointmentTime(rs.getString("a.appointment_time"));
        appointment.setNotes(rs.getString("a.note"));
        
        // Map Patient
        Patient patient = new Patient();
        patient.setPatient_id(rs.getInt("p.patient_id"));
        
        User patientUser = new User();
        patientUser.setUserId(rs.getInt("u.user_id"));
        patientUser.setUsername(rs.getString("u.username"));
        patientUser.setEmail(rs.getString("u.email"));
        patientUser.setFullName(rs.getString("u.full_name"));
        patientUser.setPhone(rs.getString("u.phone"));
        patientUser.setCreatedAt(rs.getTimestamp("u.created_at"));
        
        patient.setUser(patientUser);
        appointment.setPatient(patient);
        
        // Map Doctor
        Doctor doctor = mapResultSetToDoctor(rs);
        appointment.setDoctor(doctor);
        
        // Map Status
        appointment.setStatus(rs.getString("st.name"));
        
        return appointment;
    }

    public int countAppointmentsByDoctor(int doctorId) {
        String sql = "SELECT COUNT(*) FROM appointments WHERE doctor_id = ?";
        try (Connection conn = DBContext.makeConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, doctorId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
}
