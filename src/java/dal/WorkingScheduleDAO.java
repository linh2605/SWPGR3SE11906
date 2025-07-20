package dal;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import models.Shift;
import models.WorkingSchedule;

public class WorkingScheduleDAO extends DBContext {
    
    public int getDoctorIdByUserId(int userId) {
        String sql = "SELECT doctor_id FROM doctors WHERE user_id = ?";
        try (Connection conn = DBContext.makeConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt("doctor_id");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return -1; // Trả về -1 nếu không tìm thấy
    }
    
    public List<WorkingSchedule> getSchedulesByDoctorId(int doctorId) {
        List<WorkingSchedule> schedules = new ArrayList<>();
        String sql = "SELECT ws.*, s.name AS shift_name, s.start_time, s.end_time, " +
                     "u.full_name AS doctor_name " +
                     "FROM working_schedules ws " +
                     "JOIN shifts s ON ws.shift_id = s.shift_id " +
                     "JOIN doctors d ON ws.doctor_id = d.doctor_id " +
                     "JOIN users u ON d.user_id = u.user_id " +
                     "WHERE ws.doctor_id = ? " +
                     "ORDER BY ws.week_day, s.start_time";
        
        try (Connection conn = DBContext.makeConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, doctorId);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                WorkingSchedule schedule = new WorkingSchedule();
                schedule.setScheduleId(rs.getInt("schedule_id"));
                schedule.setDoctorId(rs.getInt("doctor_id"));
                schedule.setWeekDay(rs.getString("week_day"));
                schedule.setShiftId(rs.getInt("shift_id"));
                schedule.setMaxPatients(rs.getInt("max_patients"));
                schedule.setActive(rs.getBoolean("is_active"));
                schedule.setCreatedAt(rs.getTimestamp("created_at"));
                schedule.setUpdatedAt(rs.getTimestamp("updated_at"));
                
                Shift shift = new Shift();
                shift.setShiftId(rs.getInt("shift_id"));
                shift.setName(rs.getString("shift_name"));
                shift.setStartTime(rs.getTime("start_time"));
                shift.setEndTime(rs.getTime("end_time"));
                
                schedule.setShift(shift);
                schedule.setDoctorName(rs.getString("doctor_name"));
                schedules.add(schedule);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return schedules;
    }
    
    // Thêm các phương thức CRUD cho admin
    public List<WorkingSchedule> getAllSchedules() {
        List<WorkingSchedule> schedules = new ArrayList<>();
        String sql = "SELECT ws.*, s.name AS shift_name, s.start_time, s.end_time, " +
                     "d.user_id, u.full_name AS doctor_name " +
                     "FROM working_schedules ws " +
                     "JOIN shifts s ON ws.shift_id = s.shift_id " +
                     "JOIN doctors d ON ws.doctor_id = d.doctor_id " +
                     "JOIN users u ON d.user_id = u.user_id " +
                     "ORDER BY u.full_name, ws.week_day, s.start_time";
        
        try (Connection conn = DBContext.makeConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                WorkingSchedule schedule = new WorkingSchedule();
                schedule.setScheduleId(rs.getInt("schedule_id"));
                schedule.setDoctorId(rs.getInt("doctor_id"));
                schedule.setWeekDay(rs.getString("week_day"));
                schedule.setShiftId(rs.getInt("shift_id"));
                schedule.setMaxPatients(rs.getInt("max_patients"));
                schedule.setActive(rs.getBoolean("is_active"));
                schedule.setCreatedAt(rs.getTimestamp("created_at"));
                schedule.setUpdatedAt(rs.getTimestamp("updated_at"));
                
                Shift shift = new Shift();
                shift.setShiftId(rs.getInt("shift_id"));
                shift.setName(rs.getString("shift_name"));
                shift.setStartTime(rs.getTime("start_time"));
                shift.setEndTime(rs.getTime("end_time"));
                
                schedule.setShift(shift);
                schedule.setDoctorName(rs.getString("doctor_name"));
                schedules.add(schedule);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return schedules;
    }
    
    public WorkingSchedule getScheduleById(int scheduleId) {
        String sql = "SELECT ws.*, s.name AS shift_name, s.start_time, s.end_time, " +
                     "d.user_id, u.full_name AS doctor_name " +
                     "FROM working_schedules ws " +
                     "JOIN shifts s ON ws.shift_id = s.shift_id " +
                     "JOIN doctors d ON ws.doctor_id = d.doctor_id " +
                     "JOIN users u ON d.user_id = u.user_id " +
                     "WHERE ws.schedule_id = ?";
        
        try (Connection conn = DBContext.makeConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, scheduleId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                WorkingSchedule schedule = new WorkingSchedule();
                schedule.setScheduleId(rs.getInt("schedule_id"));
                schedule.setDoctorId(rs.getInt("doctor_id"));
                schedule.setWeekDay(rs.getString("week_day"));
                schedule.setShiftId(rs.getInt("shift_id"));
                schedule.setMaxPatients(rs.getInt("max_patients"));
                schedule.setActive(rs.getBoolean("is_active"));
                schedule.setCreatedAt(rs.getTimestamp("created_at"));
                schedule.setUpdatedAt(rs.getTimestamp("updated_at"));
                
                Shift shift = new Shift();
                shift.setShiftId(rs.getInt("shift_id"));
                shift.setName(rs.getString("shift_name"));
                shift.setStartTime(rs.getTime("start_time"));
                shift.setEndTime(rs.getTime("end_time"));
                
                schedule.setShift(shift);
                schedule.setDoctorName(rs.getString("doctor_name"));
                return schedule;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return null;
    }
    
    public boolean addSchedule(WorkingSchedule schedule) {
        String sql = "INSERT INTO working_schedules (doctor_id, week_day, shift_id, max_patients, is_active, created_at, updated_at) " +
                     "VALUES (?, ?, ?, ?, ?, NOW(), NOW())";
        
        try (Connection conn = DBContext.makeConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, schedule.getDoctorId());
            ps.setString(2, schedule.getWeekDay());
            ps.setInt(3, schedule.getShiftId());
            ps.setInt(4, schedule.getMaxPatients());
            ps.setBoolean(5, schedule.isActive());
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public boolean updateSchedule(WorkingSchedule schedule) {
        String sql = "UPDATE working_schedules SET doctor_id = ?, week_day = ?, shift_id = ?, " +
                     "max_patients = ?, is_active = ?, updated_at = NOW() " +
                     "WHERE schedule_id = ?";
        
        try (Connection conn = DBContext.makeConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, schedule.getDoctorId());
            ps.setString(2, schedule.getWeekDay());
            ps.setInt(3, schedule.getShiftId());
            ps.setInt(4, schedule.getMaxPatients());
            ps.setBoolean(5, schedule.isActive());
            ps.setInt(6, schedule.getScheduleId());
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public boolean deleteSchedule(int scheduleId) {
        String sql = "DELETE FROM working_schedules WHERE schedule_id = ?";
        
        try (Connection conn = DBContext.makeConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, scheduleId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public boolean checkScheduleExists(int doctorId, String weekDay, int shiftId) {
        String sql = "SELECT COUNT(*) FROM working_schedules WHERE doctor_id = ? AND week_day = ? AND shift_id = ?";
        
        try (Connection conn = DBContext.makeConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, doctorId);
            ps.setString(2, weekDay);
            ps.setInt(3, shiftId);
            
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return false;
    }
    
    public boolean checkScheduleExists(int doctorId, String weekDay, int shiftId, int excludeScheduleId) {
        String sql = "SELECT COUNT(*) FROM working_schedules WHERE doctor_id = ? AND week_day = ? AND shift_id = ? AND schedule_id != ?";
        
        try (Connection conn = DBContext.makeConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, doctorId);
            ps.setString(2, weekDay);
            ps.setInt(3, shiftId);
            ps.setInt(4, excludeScheduleId);
            
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return false;
    }
    
    // Method để cập nhật working schedule cho schedule change
    public boolean updateScheduleChangeForDoctor(int doctorId, int newShiftId, String effectiveDate, String endDate) {
        // Cập nhật tất cả working schedules của bác sĩ từ effectiveDate đến endDate
        String sql = "UPDATE working_schedules SET shift_id = ?, updated_at = NOW() " +
                     "WHERE doctor_id = ? AND week_day IN (1,2,3,4,5,6,7)";
        
        try (Connection conn = DBContext.makeConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, newShiftId);
            ps.setInt(2, doctorId);
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public int countSchedulesByDoctor(int doctorId) {
        String sql = "SELECT COUNT(*) FROM working_schedules WHERE doctor_id = ?";
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
    
    public int countActiveSchedulesByDoctor(int doctorId) {
        String sql = "SELECT COUNT(*) FROM working_schedules WHERE doctor_id = ? AND is_active = 1";
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
    
    // Method để hủy ca làm việc của bác sĩ
    public boolean cancelScheduleForDoctor(int doctorId, int shiftId, String effectiveDate, String endDate) {
        String sql = "UPDATE working_schedules SET is_active = 0, updated_at = NOW() " +
                     "WHERE doctor_id = ? AND shift_id = ?";
        
        // Nếu có endDate, chỉ hủy trong khoảng thời gian đó
        if (endDate != null && !endDate.isEmpty()) {
            sql += " AND created_at >= ? AND created_at <= ?";
        } else {
            sql += " AND created_at >= ?";
        }
        
        try (Connection conn = DBContext.makeConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, doctorId);
            ps.setInt(2, shiftId);
            ps.setString(3, effectiveDate);
            
            if (endDate != null && !endDate.isEmpty()) {
                ps.setString(4, endDate);
            }
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // Cập nhật shiftId của working schedule từ oldShiftId sang newShiftId cho bác sĩ
    public boolean updateScheduleShiftForDoctor(int doctorId, int oldShiftId, int newShiftId, String effectiveDate, String endDate) {
        String sql = "UPDATE working_schedules SET shift_id = ?, updated_at = NOW() " +
                     "WHERE doctor_id = ? AND shift_id = ?";
        
        try (Connection conn = DBContext.makeConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, newShiftId);
            ps.setInt(2, doctorId);
            ps.setInt(3, oldShiftId);
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public int countAllSchedules() {
        String sql = "SELECT COUNT(*) FROM working_schedules";
        try (Connection conn = DBContext.makeConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
    
    public int countActiveSchedules() {
        String sql = "SELECT COUNT(*) FROM working_schedules WHERE is_active = 1";
        try (Connection conn = DBContext.makeConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
    
    public List<WorkingSchedule> getSchedulesWithFilters(String doctorFilter, String dayFilter, String shiftFilter) {
        List<WorkingSchedule> schedules = new ArrayList<>();
        
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT ws.*, s.name AS shift_name, s.start_time, s.end_time, ");
        sql.append("d.user_id, u.full_name AS doctor_name ");
        sql.append("FROM working_schedules ws ");
        sql.append("JOIN shifts s ON ws.shift_id = s.shift_id ");
        sql.append("JOIN doctors d ON ws.doctor_id = d.doctor_id ");
        sql.append("JOIN users u ON d.user_id = u.user_id ");
        sql.append("WHERE 1=1 ");
        
        List<Object> params = new ArrayList<>();
        
        if (doctorFilter != null && !doctorFilter.trim().isEmpty()) {
            sql.append("AND ws.doctor_id = ? ");
            params.add(Integer.parseInt(doctorFilter));
        }
        
        if (dayFilter != null && !dayFilter.trim().isEmpty()) {
            sql.append("AND ws.week_day = ? ");
            params.add(dayFilter);
        }
        
        if (shiftFilter != null && !shiftFilter.trim().isEmpty()) {
            sql.append("AND ws.shift_id = ? ");
            params.add(Integer.parseInt(shiftFilter));
        }
        
        sql.append("ORDER BY u.full_name, ws.week_day, s.start_time");
        
        try (Connection conn = DBContext.makeConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            
            // Set parameters
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                WorkingSchedule schedule = new WorkingSchedule();
                schedule.setScheduleId(rs.getInt("schedule_id"));
                schedule.setDoctorId(rs.getInt("doctor_id"));
                schedule.setWeekDay(rs.getString("week_day"));
                schedule.setShiftId(rs.getInt("shift_id"));
                schedule.setMaxPatients(rs.getInt("max_patients"));
                schedule.setActive(rs.getBoolean("is_active"));
                schedule.setCreatedAt(rs.getTimestamp("created_at"));
                schedule.setUpdatedAt(rs.getTimestamp("updated_at"));
                
                Shift shift = new Shift();
                shift.setShiftId(rs.getInt("shift_id"));
                shift.setName(rs.getString("shift_name"));
                shift.setStartTime(rs.getTime("start_time"));
                shift.setEndTime(rs.getTime("end_time"));
                
                schedule.setShift(shift);
                schedule.setDoctorName(rs.getString("doctor_name"));
                schedules.add(schedule);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return schedules;
    }
} 