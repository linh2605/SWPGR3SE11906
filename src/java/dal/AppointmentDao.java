package dal;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.List;

import models.Appointment;
import models.AppointmentStatus;
import models.Doctor;
import models.PaymentStatus;
import models.Service;
import models.ServiceType;
import models.Shift;
import models.User;

public class AppointmentDao {

    public static List<Appointment> getAppointmentsByPatientId(int patientId, int page, int size) {
        System.out.println("[DEBUG] getAppointmentsByPatientId: patientId=" + patientId + ", page=" + page + ", size=" + size);
        List<Appointment> appointments = new ArrayList<>();
        String sql = "SELECT a.appointment_id, a.appointment_date, a.shift_id, a.queue_number, a.note, a.created_at, a.updated_at, "
                + "ud.full_name AS doctor_name, up.full_name AS patient_name, a.status, a.service_id, a.payment_status, "
                + "s.name AS shift_name "
                + "FROM appointments a "
                + "JOIN doctors d ON a.doctor_id = d.doctor_id "
                + "JOIN users ud ON d.user_id = ud.user_id "
                + "JOIN patients p ON a.patient_id = p.patient_id "
                + "JOIN users up ON p.user_id = up.user_id "
                + "JOIN shifts s ON a.shift_id = s.shift_id "
                + "WHERE a.patient_id = ? "
                + "ORDER BY a.appointment_date DESC, a.shift_id, a.queue_number "
                + "LIMIT ? OFFSET ?";
        try (Connection conn = DBContext.makeConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, patientId);
            stmt.setInt(2, size);
            stmt.setInt(3, (page - 1) * size);
            try (ResultSet rs = stmt.executeQuery()) {
                int count = 0;
                while (rs.next()) {
                    try {
                        appointments.add(mappingAppointment(rs));
                        count++;
                    } catch (Exception e) {
                        System.out.println("[ERROR] mappingAppointment: " + e.getMessage());
                        e.printStackTrace();
                    }
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
        String sql = "SELECT a.appointment_id, a.appointment_date, a.shift_id, a.queue_number, a.note, a.created_at, a.updated_at, "
                + "a.status, a.service_id, s.name AS service_name, s.detail AS service_detail, s.price AS service_price, s.type AS service_type, "
                + "a.payment_status, "
                + "a.patient_id, p.user_id AS patient_user_id, up.full_name AS patient_name, "
                + "a.doctor_id, d.user_id AS doctor_user_id, ud.full_name AS doctor_name "
                + "FROM appointments a "
                + "JOIN doctors d ON a.doctor_id = d.doctor_id "
                + "JOIN users ud ON d.user_id = ud.user_id "
                + "JOIN patients p ON a.patient_id = p.patient_id "
                + "JOIN users up ON p.user_id = up.user_id "
                + "LEFT JOIN services s ON a.service_id = s.service_id "
                + "WHERE a.doctor_id = ? "
                + "ORDER BY a.appointment_date DESC, a.shift_id, a.queue_number "
                + "LIMIT ? OFFSET ?";
        try (Connection conn = DBContext.makeConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, doctorId);
            stmt.setInt(2, size);
            stmt.setInt(3, (page - 1) * size);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Appointment appt = new Appointment();
                    appt.setId(rs.getInt("appointment_id"));
                    appt.setAppointmentDateTime(rs.getTimestamp("appointment_date").toLocalDateTime());
                    appt.setShiftId(rs.getInt("shift_id"));
                    appt.setQueueNumber(rs.getInt("queue_number"));
                    appt.setStatus(AppointmentStatus.fromCode(rs.getString("status")));
                    appt.setNote(rs.getString("note"));
                    appt.setPaymentStatus(PaymentStatus.valueOf(rs.getString("payment_status")));

                    // Set patient info
                    models.Patient patient = new models.Patient();
                    patient.setPatient_id(rs.getInt("patient_id"));
                    User patientUser = new User();
                    patientUser.setUserId(rs.getInt("patient_user_id"));
                    patientUser.setFullName(rs.getString("patient_name"));
                    patient.setUser(patientUser);
                    appt.setPatient(patient);

                    // Set doctor info
                    models.Doctor doctor = new models.Doctor();
                    doctor.setDoctor_id(rs.getInt("doctor_id"));
                    User doctorUser = new User();
                    doctorUser.setUserId(rs.getInt("doctor_user_id"));
                    doctorUser.setFullName(rs.getString("doctor_name"));
                    doctor.setUser(doctorUser);
                    appt.setDoctor(doctor);

                    // Set service info
                    if (rs.getInt("service_id") > 0) {
                        Service service = new Service();
                        service.setServiceId(rs.getInt("service_id"));
                        service.setName(rs.getString("service_name"));
                        service.setDetail(rs.getString("service_detail"));
                        service.setPrice(rs.getLong("service_price"));
                        service.setType(ServiceType.valueOf(rs.getString("service_type")));
                        appt.setService(service);
                    }

                    appointments.add(appt);
                }
            }
        } catch (Exception e) {
            System.out.println("[ERROR] getAppointmentsByDoctorId: " + e.getMessage());
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
                + "	 , a.shift_id\n"
                + "	 , a.queue_number\n"
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
                + "	 , sh.name      AS shift_name\n"
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
                + "	       JOIN shifts sh\n"
                + "	       ON a.shift_id = sh.shift_id\n"
                + " WHERE appointment_id = ?";
        System.out.println(sql);
        try (Connection conn = DBContext.makeConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Appointment appt = new Appointment();
                    appt.setId(rs.getInt("appointment_id"));
                    appt.setAppointmentDateTime(rs.getTimestamp("appointment_date").toLocalDateTime());
                    appt.setShiftId(rs.getInt("shift_id"));
                    appt.setQueueNumber(rs.getInt("queue_number"));
                    appt.setStatus(AppointmentStatus.fromCode(rs.getString("status")));
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
                    s.setServiceId(rs.getInt("service_id"));
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
        String sql = "SELECT a.appointment_id, a.appointment_date, a.shift_id, a.queue_number, a.note, a.created_at, a.updated_at, "
                + "a.status, a.service_id, a.payment_status, "
                + "a.patient_id, p.user_id AS patient_user_id, up.full_name AS patient_name, up.username AS patient_username, up.email AS patient_email, up.phone AS patient_phone, "
                + "a.doctor_id, d.user_id AS doctor_user_id, ud.full_name AS doctor_name "
                + "FROM appointments a "
                + "JOIN doctors d ON a.doctor_id = d.doctor_id "
                + "JOIN users ud ON d.user_id = ud.user_id "
                + "JOIN patients p ON a.patient_id = p.patient_id "
                + "JOIN users up ON p.user_id = up.user_id "
                + "ORDER BY a.appointment_date DESC, a.shift_id, a.queue_number "
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
        System.out.println("[DEBUG] AppointmentDao.createAppointment() - Starting");
        System.out.println("[DEBUG] - Patient ID: " + appointment.getPatient().getPatient_id());
        System.out.println("[DEBUG] - Doctor ID: " + appointment.getDoctor().getDoctor_id());
        System.out.println("[DEBUG] - Service ID: " + appointment.getService().getServiceId());
        System.out.println("[DEBUG] - Appointment Date: " + appointment.getAppointmentDateTime());
        System.out.println("[DEBUG] - Note: " + appointment.getNote());
        
        // Xác định shift_id và queue_number
        int shiftId = determineShiftId(appointment.getAppointmentDateTime());
        int queueNumber = getNextQueueNumber(appointment.getDoctor().getDoctor_id(), appointment.getAppointmentDateTime().toLocalDate(), shiftId);
        
        String sql = "INSERT INTO appointments(patient_id, doctor_id, service_id, appointment_date, shift_id, queue_number, note, status, payment_status, created_at)\n"
                + "VALUES (?, ?, ?, ?, ?, ?, ?, 'pending', 'pending', NOW());";
        try (Connection conn = DBContext.makeConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, appointment.getPatient().getPatient_id());
            ps.setInt(2, appointment.getDoctor().getDoctor_id());
            ps.setInt(3, appointment.getService().getServiceId());
            ps.setTimestamp(4, java.sql.Timestamp.valueOf(appointment.getAppointmentDateTime()));
            ps.setInt(5, shiftId);
            ps.setInt(6, queueNumber);
            ps.setString(7, appointment.getNote());
            
            System.out.println("[DEBUG] Executing SQL: " + sql);
            System.out.println("[DEBUG] - Shift ID: " + shiftId);
            System.out.println("[DEBUG] - Queue Number: " + queueNumber);
            int result = ps.executeUpdate();
            System.out.println("[DEBUG] SQL execution result: " + result + " rows affected");
            
            return result > 0;
        } catch (Exception e) {
            System.out.println("[DEBUG] Exception in createAppointment: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    private static Appointment mappingAppointment(ResultSet rs) throws SQLException {
        System.out.println("[DEBUG] mappingAppointment: id=" + rs.getInt("appointment_id"));
        Appointment appt = new Appointment();
        appt.setId(rs.getInt("appointment_id"));
        appt.setAppointmentDateTime(rs.getTimestamp("appointment_date").toLocalDateTime());
        appt.setShiftId(rs.getInt("shift_id"));
        appt.setQueueNumber(rs.getInt("queue_number"));
        appt.setStatus(AppointmentStatus.fromCode(rs.getString("status")));
        appt.setNote(rs.getString("note"));
        if (rs.getObject("created_at") != null) appt.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
        if (rs.getObject("updated_at") != null) appt.setUpdatedAt(rs.getTimestamp("updated_at").toLocalDateTime());
        if (rs.getObject("payment_status") != null) appt.setPaymentStatus(PaymentStatus.valueOf(rs.getString("payment_status")));

        // Doctor
        models.Doctor doctor = new models.Doctor();
        if (hasColumn(rs, "doctor_id")) doctor.setDoctor_id(rs.getInt("doctor_id"));
        User doctorUser = new User();
        if (hasColumn(rs, "doctor_user_id")) doctorUser.setUserId(rs.getInt("doctor_user_id"));
        if (hasColumn(rs, "doctor_name")) doctorUser.setFullName(rs.getString("doctor_name"));
        doctor.setUser(doctorUser);
        appt.setDoctor(doctor);

        // Patient
        models.Patient patient = new models.Patient();
        if (hasColumn(rs, "patient_id")) patient.setPatient_id(rs.getInt("patient_id"));
        User patientUser = new User();
        if (hasColumn(rs, "patient_user_id")) patientUser.setUserId(rs.getInt("patient_user_id"));
        if (hasColumn(rs, "patient_name")) patientUser.setFullName(rs.getString("patient_name"));
        if (hasColumn(rs, "patient_username")) patientUser.setUsername(rs.getString("patient_username"));
        if (hasColumn(rs, "patient_email")) patientUser.setEmail(rs.getString("patient_email"));
        if (hasColumn(rs, "patient_phone")) patientUser.setPhone(rs.getString("patient_phone"));
        patient.setUser(patientUser);
        appt.setPatient(patient);

        // Service
        if (hasColumn(rs, "service_id") && rs.getObject("service_id") != null) {
            Service service = ServiceDAO.getServiceById(rs.getInt("service_id"));
            appt.setService(service);
        }

        System.out.println("[DEBUG] mappingAppointment: DONE id=" + appt.getId());
        return appt;
    }

    // Helper để kiểm tra cột có tồn tại trong ResultSet không
    private static boolean hasColumn(ResultSet rs, String columnName) {
        try {
            rs.findColumn(columnName);
            return true;
        } catch (SQLException e) {
            return false;
        }
    }

    // Thêm method để xác định shift_id dựa trên thời gian
    private static int determineShiftId(LocalDateTime dateTime) {
        int hour = dateTime.getHour();
        if (hour >= 8 && hour < 12) {
            return 1; // Sáng
        } else if (hour >= 13 && hour < 17) {
            return 2; // Chiều
        } else if (hour >= 17 && hour < 22) {
            return 3; // Tối
        } else {
            return 1; // Mặc định ca sáng
        }
    }

    // Thêm method để lấy số thứ tự tiếp theo trong ca
    private static int getNextQueueNumber(int doctorId, java.time.LocalDate date, int shiftId) {
        String sql = "SELECT COALESCE(MAX(queue_number), 0) + 1 FROM appointments " +
                    "WHERE doctor_id = ? AND DATE(appointment_date) = ? AND shift_id = ?";
        try (Connection conn = DBContext.makeConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, doctorId);
            stmt.setDate(2, java.sql.Date.valueOf(date));
            stmt.setInt(3, shiftId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 1; // Mặc định là bệnh nhân đầu tiên
    }

    public static boolean updateAppointmentStatus(int id, String status) {
        String sql = "UPDATE appointments SET status = ?, updated_at = NOW() WHERE appointment_id = ?";
        try (Connection conn = DBContext.makeConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, id);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public static boolean updateAppointmentPaymentStatus(int id, PaymentStatus status) {
        String sql = "UPDATE appointments SET payment_status = ?, updated_at = NOW() WHERE appointment_id = ?";
        try (Connection conn = DBContext.makeConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status.name());
            ps.setInt(2, id);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public static int countAppointmentsByDoctor(int doctorId) {
        String sql = "SELECT COUNT(*) FROM appointments WHERE doctor_id = ?";
        try (Connection conn = DBContext.makeConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
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

    public static List<Appointment> findAppointmentsByDoctorAndDateRange(int doctorId, String fromDate, String toDate) {
        List<Appointment> appointments = new ArrayList<>();
        String sql = "SELECT a.appointment_id, a.appointment_date, ud.full_name AS doctor_name, up.full_name AS patient_name, a.status, a.service_id, a.payment_status "
                + "FROM appointments a "
                + "JOIN doctors d ON a.doctor_id = d.doctor_id "
                + "JOIN users ud ON d.user_id = ud.user_id "
                + "JOIN patients p ON a.patient_id = p.patient_id "
                + "JOIN users up ON p.user_id = up.user_id "
                + "WHERE a.doctor_id = ? AND DATE(a.appointment_date) BETWEEN ? AND ? "
                + "ORDER BY a.appointment_date";
        try (Connection conn = DBContext.makeConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, doctorId);
            stmt.setString(2, fromDate);
            stmt.setString(3, toDate);
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

    public static Doctor findAvailableDoctorForAppointment(int specialtyId, String appointmentDate, String appointmentTime, int excludeDoctorId) {
        String sql = "SELECT d.doctor_id, u.full_name, d.specialty_id FROM doctors d "
                + "JOIN users u ON d.user_id = u.user_id "
                + "WHERE d.specialty_id = ? AND d.doctor_id != ? "
                + "AND d.doctor_id NOT IN ("
                + "    SELECT doctor_id FROM appointments "
                + "    WHERE DATE(appointment_date) = ? AND TIME(appointment_date) = ?"
                + ") LIMIT 1";
        try (Connection conn = DBContext.makeConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, specialtyId);
            stmt.setInt(2, excludeDoctorId);
            stmt.setString(3, appointmentDate);
            stmt.setString(4, appointmentTime);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Doctor doctor = new Doctor();
                    doctor.setDoctor_id(rs.getInt("doctor_id"));
                    User user = new User();
                    user.setFullName(rs.getString("full_name"));
                    doctor.setUser(user);
                    return doctor;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public static boolean updateAppointmentDoctor(int appointmentId, int newDoctorId) {
        String sql = "UPDATE appointments SET doctor_id = ?, updated_at = NOW() WHERE appointment_id = ?";
        try (Connection conn = DBContext.makeConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, newDoctorId);
            ps.setInt(2, appointmentId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public static boolean cancelAppointment(int appointmentId) {
        String sql = "UPDATE appointments SET status = 'cancelled', updated_at = NOW() WHERE appointment_id = ?";
        try (Connection conn = DBContext.makeConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, appointmentId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // ================== VALIDATION METHODS ===================
    
    /**
     * Kiểm tra slot có sẵn cho doctor trong ca làm việc (ngày + shift)
     */
    public static boolean isSlotAvailable(int doctorId, LocalDateTime dateTime) {
        // Lấy thông tin ca làm việc (shift) của bác sĩ vào ngày này
        String weekDayVN = getVietnameseWeekDay(dateTime.toLocalDate());
        int shiftId = getShiftIdForDoctorAndDate(doctorId, weekDayVN, dateTime.toLocalTime());
        if (shiftId == -1) return false;
        // Lấy thời gian bắt đầu/kết thúc ca
        Shift shift = new dal.ShiftDAO().getShiftById(shiftId);
        if (shift == null) return false;
        LocalTime start = shift.getStartTime().toLocalTime();
        LocalTime end = shift.getEndTime().toLocalTime();
        // Đếm số lịch hẹn của bác sĩ trong ngày + ca này
        String sql = "SELECT COUNT(*) FROM appointments WHERE doctor_id = ? AND DATE(appointment_date) = ? AND TIME(appointment_date) >= ? AND TIME(appointment_date) < ? AND status NOT IN ('cancelled', 'no_show')";
        try (Connection conn = DBContext.makeConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, doctorId);
            stmt.setDate(2, java.sql.Date.valueOf(dateTime.toLocalDate()));
            stmt.setTime(3, java.sql.Time.valueOf(start));
            stmt.setTime(4, java.sql.Time.valueOf(end));
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    int count = rs.getInt(1);
                    int maxPatients = getMaxPatientsForDoctorAndShift(doctorId, weekDayVN, shiftId);
                    return count < maxPatients;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // Lấy shiftId của bác sĩ theo ngày và giờ (dựa vào working_schedules)
    private static int getShiftIdForDoctorAndDate(int doctorId, String weekDayVN, LocalTime time) {
        String sql = "SELECT ws.shift_id, s.start_time, s.end_time FROM working_schedules ws JOIN shifts s ON ws.shift_id = s.shift_id WHERE ws.doctor_id = ? AND ws.week_day = ? AND ws.is_active = 1 AND ? >= s.start_time AND ? < s.end_time";
        try (Connection conn = DBContext.makeConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, doctorId);
            stmt.setString(2, weekDayVN);
            stmt.setTime(3, java.sql.Time.valueOf(time));
            stmt.setTime(4, java.sql.Time.valueOf(time));
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("shift_id");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return -1;
    }

    // Lấy max_patients cho doctor trong ca làm việc (ngày + shift)
    private static int getMaxPatientsForDoctorAndShift(int doctorId, String weekDayVN, int shiftId) {
        String sql = "SELECT ws.max_patients FROM working_schedules ws WHERE ws.doctor_id = ? AND ws.week_day = ? AND ws.shift_id = ? AND ws.is_active = 1";
        try (Connection conn = DBContext.makeConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, doctorId);
            stmt.setString(2, weekDayVN);
            stmt.setInt(3, shiftId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("max_patients");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    // Hàm chuyển LocalDate sang week_day tiếng Việt
    private static String getVietnameseWeekDay(java.time.LocalDate date) {
        switch (date.getDayOfWeek()) {
            case MONDAY: return "Thứ 2";
            case TUESDAY: return "Thứ 3";
            case WEDNESDAY: return "Thứ 4";
            case THURSDAY: return "Thứ 5";
            case FRIDAY: return "Thứ 6";
            case SATURDAY: return "Thứ 7";
            case SUNDAY: return "Chủ nhật";
            default: return "";
        }
    }
    
    /**
     * Kiểm tra doctor có cung cấp service không
     */
    public static boolean canDoctorProvideService(int doctorId, int serviceId) {
        String sql = "SELECT COUNT(*) FROM doctor_services WHERE doctor_id = ? AND service_id = ?";
        try (Connection conn = DBContext.makeConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, doctorId);
            stmt.setInt(2, serviceId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
    
    /**
     * Lấy max_patients cho doctor trong shift
     */
    private static int getMaxPatientsForDoctor(int doctorId, LocalDateTime dateTime) {
        String sql = "SELECT ws.max_patients FROM working_schedules ws " +
                    "JOIN shifts s ON ws.shift_id = s.shift_id " +
                    "WHERE ws.doctor_id = ? AND ws.week_day = DAYNAME(?) " +
                    "AND TIME(?) BETWEEN s.start_time AND s.end_time " +
                    "AND ws.is_active = 1";
        try (Connection conn = DBContext.makeConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, doctorId);
            stmt.setTimestamp(2, Timestamp.valueOf(dateTime));
            stmt.setTimestamp(3, Timestamp.valueOf(dateTime));
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("max_patients");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0; // Default to 0 if no schedule found
    }
    
    /**
     * Kiểm tra doctor có lịch làm việc vào tuần (tiếng Việt) và ca làm việc này không
     */
    public static boolean isDoctorAvailableByWeekDayAndShift(int doctorId, String weekDay, int shiftId) {
        String sql = "SELECT COUNT(*) FROM working_schedules ws " +
                    "WHERE ws.doctor_id = ? AND ws.week_day = ? AND ws.shift_id = ? AND ws.is_active = 1";
        try (Connection conn = DBContext.makeConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, doctorId);
            stmt.setString(2, weekDay);
            stmt.setInt(3, shiftId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
    
    // Thêm methods cho dashboard
    public static int countAppointmentsByDate(java.time.LocalDate date) {
        String sql = "SELECT COUNT(*) FROM appointments WHERE DATE(appointment_date) = ?";
        try (Connection conn = DBContext.makeConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setDate(1, java.sql.Date.valueOf(date));
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
    
    public static List<Appointment> getRecentAppointments(int limit) {
        List<Appointment> appointments = new ArrayList<>();
        String sql = "SELECT a.appointment_id, a.appointment_date, a.shift_id, a.queue_number, a.note, a.created_at, a.updated_at, "
                + "a.status, a.service_id, a.payment_status, "
                + "a.patient_id, p.user_id AS patient_user_id, up.full_name AS patient_name, "
                + "a.doctor_id, d.user_id AS doctor_user_id, ud.full_name AS doctor_name, "
                + "s.name AS service_name "
                + "FROM appointments a "
                + "JOIN doctors d ON a.doctor_id = d.doctor_id "
                + "JOIN users ud ON d.user_id = ud.user_id "
                + "JOIN patients p ON a.patient_id = p.patient_id "
                + "JOIN users up ON p.user_id = up.user_id "
                + "JOIN services s ON a.service_id = s.service_id "
                + "ORDER BY a.appointment_date DESC, a.created_at DESC "
                + "LIMIT ?";
        try (Connection conn = DBContext.makeConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, limit);
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
    
    public static int countAllAppointments() {
        String sql = "SELECT COUNT(*) FROM appointments";
        try (Connection conn = DBContext.makeConnection(); 
             PreparedStatement stmt = conn.prepareStatement(sql); 
             ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }
    
    public static int countPendingAppointments() {
        String sql = "SELECT COUNT(*) FROM appointments WHERE status = 'pending'";
        try (Connection conn = DBContext.makeConnection(); 
             PreparedStatement stmt = conn.prepareStatement(sql); 
             ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }
}
