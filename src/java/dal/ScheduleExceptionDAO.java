package dal;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import models.ScheduleException;
import models.Shift;

public class ScheduleExceptionDAO extends DBContext {
    
    public List<ScheduleException> getExceptionsByDoctorId(int doctorId) {
        List<ScheduleException> exceptions = new ArrayList<>();
        String sql = "SELECT se.*, s.name AS shift_name, s.start_time, s.end_time " +
                     "FROM schedule_exceptions se " +
                     "LEFT JOIN shifts s ON se.new_shift_id = s.shift_id " +
                     "WHERE se.doctor_id = ? " +
                     "ORDER BY se.exception_date DESC";
        
        try (Connection conn = DBContext.makeConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, doctorId);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                ScheduleException exception = new ScheduleException();
                exception.setExceptionId(rs.getInt("exception_id"));
                exception.setDoctorId(rs.getInt("doctor_id"));
                exception.setExceptionDate(rs.getDate("exception_date"));
                exception.setExceptionType(rs.getString("exception_type"));
                exception.setNewShiftId(rs.getObject("new_shift_id", Integer.class));
                exception.setReason(rs.getString("reason"));
                exception.setStatus(rs.getString("status"));
                exception.setCreatedAt(rs.getTimestamp("created_at"));
                
                if (exception.getNewShiftId() != null) {
                    Shift shift = new Shift();
                    shift.setShiftId(exception.getNewShiftId());
                    shift.setName(rs.getString("shift_name"));
                    shift.setStartTime(rs.getTime("start_time"));
                    shift.setEndTime(rs.getTime("end_time"));
                    exception.setNewShift(shift);
                }
                
                exceptions.add(exception);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return exceptions;
    }
    
    public ScheduleException getExceptionById(int exceptionId) {
        String sql = "SELECT * FROM schedule_exceptions WHERE exception_id = ?";
        
        try (Connection conn = DBContext.makeConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, exceptionId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                ScheduleException exception = new ScheduleException();
                exception.setExceptionId(rs.getInt("exception_id"));
                exception.setDoctorId(rs.getInt("doctor_id"));
                exception.setExceptionDate(rs.getDate("exception_date"));
                exception.setExceptionType(rs.getString("exception_type"));
                exception.setNewShiftId(rs.getObject("new_shift_id", Integer.class));
                exception.setReason(rs.getString("reason"));
                exception.setStatus(rs.getString("status"));
                exception.setCreatedAt(rs.getTimestamp("created_at"));
                
                return exception;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return null;
    }
    
    public boolean addException(ScheduleException exception) {
        String sql = "INSERT INTO schedule_exceptions (doctor_id, exception_date, exception_type, new_shift_id, reason, status) VALUES (?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DBContext.makeConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, exception.getDoctorId());
            ps.setDate(2, exception.getExceptionDate());
            ps.setString(3, exception.getExceptionType());
            ps.setObject(4, exception.getNewShiftId());
            ps.setString(5, exception.getReason());
            ps.setString(6, exception.getStatus());
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public boolean updateException(ScheduleException exception) {
        String sql = "UPDATE schedule_exceptions SET exception_date = ?, exception_type = ?, new_shift_id = ?, reason = ?, status = ? WHERE exception_id = ?";
        
        try (Connection conn = DBContext.makeConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setDate(1, exception.getExceptionDate());
            ps.setString(2, exception.getExceptionType());
            ps.setObject(3, exception.getNewShiftId());
            ps.setString(4, exception.getReason());
            ps.setString(5, exception.getStatus());
            ps.setInt(6, exception.getExceptionId());
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public boolean deleteException(int exceptionId) {
        String sql = "DELETE FROM schedule_exceptions WHERE exception_id = ?";
        
        try (Connection conn = DBContext.makeConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, exceptionId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public boolean checkExceptionExists(int doctorId, java.sql.Date exceptionDate) {
        String sql = "SELECT COUNT(*) FROM schedule_exceptions WHERE doctor_id = ? AND exception_date = ?";
        
        try (Connection conn = DBContext.makeConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, doctorId);
            ps.setDate(2, exceptionDate);
            
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return false;
    }
    
    // Method để lấy tất cả schedule exceptions cho admin
    public List<ScheduleException> getAllExceptions() {
        List<ScheduleException> exceptions = new ArrayList<>();
        String sql = "SELECT se.*, s.name AS shift_name, s.start_time, s.end_time, " +
                     "d.user_id, u.full_name AS doctor_name " +
                     "FROM schedule_exceptions se " +
                     "LEFT JOIN shifts s ON se.new_shift_id = s.shift_id " +
                     "JOIN doctors d ON se.doctor_id = d.doctor_id " +
                     "JOIN users u ON d.user_id = u.user_id " +
                     "ORDER BY se.created_at DESC";
        
        try (Connection conn = DBContext.makeConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                ScheduleException exception = new ScheduleException();
                exception.setExceptionId(rs.getInt("exception_id"));
                exception.setDoctorId(rs.getInt("doctor_id"));
                exception.setExceptionDate(rs.getDate("exception_date"));
                exception.setExceptionType(rs.getString("exception_type"));
                exception.setNewShiftId(rs.getObject("new_shift_id", Integer.class));
                exception.setReason(rs.getString("reason"));
                exception.setStatus(rs.getString("status"));
                exception.setCreatedAt(rs.getTimestamp("created_at"));
                
                if (exception.getNewShiftId() != null) {
                    Shift shift = new Shift();
                    shift.setShiftId(exception.getNewShiftId());
                    shift.setName(rs.getString("shift_name"));
                    shift.setStartTime(rs.getTime("start_time"));
                    shift.setEndTime(rs.getTime("end_time"));
                    exception.setNewShift(shift);
                }
                
                exceptions.add(exception);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return exceptions;
    }
    
    public List<ScheduleException> getExceptionsWithFilter(Integer doctorId, String status, java.sql.Date date, String keyword) {
        List<ScheduleException> exceptions = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT se.*, s.name AS shift_name, s.start_time, s.end_time, d.user_id, u.full_name AS doctor_name FROM schedule_exceptions se LEFT JOIN shifts s ON se.new_shift_id = s.shift_id JOIN doctors d ON se.doctor_id = d.doctor_id JOIN users u ON d.user_id = u.user_id WHERE 1=1");
        List<Object> params = new ArrayList<>();
        if (doctorId != null && doctorId > 0) {
            sql.append(" AND se.doctor_id = ?");
            params.add(doctorId);
        }
        if (status != null && !status.isEmpty()) {
            sql.append(" AND se.status = ?");
            params.add(status);
        }
        if (date != null) {
            sql.append(" AND se.exception_date = ?");
            params.add(date);
        }
        if (keyword != null && !keyword.isEmpty()) {
            sql.append(" AND (u.full_name LIKE ? OR se.reason LIKE ?)");
            params.add("%" + keyword + "%");
            params.add("%" + keyword + "%");
        }
        sql.append(" ORDER BY se.created_at DESC");
        try (Connection conn = DBContext.makeConnection(); PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                ScheduleException exception = new ScheduleException();
                exception.setExceptionId(rs.getInt("exception_id"));
                exception.setDoctorId(rs.getInt("doctor_id"));
                exception.setExceptionDate(rs.getDate("exception_date"));
                exception.setExceptionType(rs.getString("exception_type"));
                exception.setNewShiftId(rs.getObject("new_shift_id", Integer.class));
                exception.setReason(rs.getString("reason"));
                exception.setStatus(rs.getString("status"));
                exception.setCreatedAt(rs.getTimestamp("created_at"));
                exception.setDoctorName(rs.getString("doctor_name"));
                if (exception.getNewShiftId() != null) {
                    Shift shift = new Shift();
                    shift.setShiftId(exception.getNewShiftId());
                    shift.setName(rs.getString("shift_name"));
                    shift.setStartTime(rs.getTime("start_time"));
                    shift.setEndTime(rs.getTime("end_time"));
                    exception.setNewShift(shift);
                    exception.setNewShiftName(rs.getString("shift_name"));
                } else {
                    exception.setNewShiftName("Không có");
                }
                exceptions.add(exception);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return exceptions;
    }
    
    public int countPendingExceptionsByDoctor(int doctorId) {
        String sql = "SELECT COUNT(*) FROM schedule_exceptions WHERE doctor_id = ? AND status = 'Chờ duyệt'";
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
    
    public int countPendingExceptions() {
        String sql = "SELECT COUNT(*) FROM schedule_exceptions WHERE status = 'Chờ duyệt'";
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
    
    // Đếm số ngoại lệ khẩn cấp đang chờ duyệt
    public int countUrgentExceptions() {
        String sql = "SELECT COUNT(*) FROM schedule_exceptions WHERE exception_type = 'Khẩn cấp' AND status = 'Chờ duyệt'";
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
} 