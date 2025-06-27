package dal;

import models.ScheduleChange;
import models.Doctor;
import models.Shift;
import models.User;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Date;
import java.util.ArrayList;
import java.util.List;

public class ScheduleChangeDAO extends DBContext {
    
    public List<ScheduleChange> getAllScheduleChanges() {
        List<ScheduleChange> changes = new ArrayList<>();
        String sql = "SELECT sc.*, d.user_id, u.full_name AS doctor_name, " +
                     "os.name AS old_shift_name, os.start_time AS old_start_time, os.end_time AS old_end_time, " +
                     "ns.name AS new_shift_name, ns.start_time AS new_start_time, ns.end_time AS new_end_time, " +
                     "au.full_name AS approved_by_name " +
                     "FROM schedule_changes sc " +
                     "JOIN doctors d ON sc.doctor_id = d.doctor_id " +
                     "JOIN users u ON d.user_id = u.user_id " +
                     "JOIN shifts os ON sc.old_shift_id = os.shift_id " +
                     "JOIN shifts ns ON sc.new_shift_id = ns.shift_id " +
                     "LEFT JOIN users au ON sc.approved_by = au.user_id " +
                     "ORDER BY sc.created_at DESC";
        
        try (Connection conn = DBContext.makeConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                ScheduleChange change = mapResultSetToScheduleChange(rs);
                changes.add(change);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return changes;
    }
    
    public List<ScheduleChange> getScheduleChangesByDoctorId(int doctorId) {
        List<ScheduleChange> changes = new ArrayList<>();
        String sql = "SELECT sc.*, d.user_id, u.full_name AS doctor_name, " +
                     "os.name AS old_shift_name, os.start_time AS old_start_time, os.end_time AS old_end_time, " +
                     "ns.name AS new_shift_name, ns.start_time AS new_start_time, ns.end_time AS new_end_time, " +
                     "au.full_name AS approved_by_name " +
                     "FROM schedule_changes sc " +
                     "JOIN doctors d ON sc.doctor_id = d.doctor_id " +
                     "JOIN users u ON d.user_id = u.user_id " +
                     "JOIN shifts os ON sc.old_shift_id = os.shift_id " +
                     "JOIN shifts ns ON sc.new_shift_id = ns.shift_id " +
                     "LEFT JOIN users au ON sc.approved_by = au.user_id " +
                     "WHERE sc.doctor_id = ? " +
                     "ORDER BY sc.created_at DESC";
        
        try (Connection conn = DBContext.makeConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, doctorId);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                ScheduleChange change = mapResultSetToScheduleChange(rs);
                changes.add(change);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return changes;
    }
    
    public ScheduleChange getScheduleChangeById(int changeId) {
        String sql = "SELECT sc.*, d.user_id, u.full_name AS doctor_name, " +
                     "os.name AS old_shift_name, os.start_time AS old_start_time, os.end_time AS old_end_time, " +
                     "ns.name AS new_shift_name, ns.start_time AS new_start_time, ns.end_time AS new_end_time, " +
                     "au.full_name AS approved_by_name " +
                     "FROM schedule_changes sc " +
                     "JOIN doctors d ON sc.doctor_id = d.doctor_id " +
                     "JOIN users u ON d.user_id = u.user_id " +
                     "JOIN shifts os ON sc.old_shift_id = os.shift_id " +
                     "JOIN shifts ns ON sc.new_shift_id = ns.shift_id " +
                     "LEFT JOIN users au ON sc.approved_by = au.user_id " +
                     "WHERE sc.change_id = ?";
        
        try (Connection conn = DBContext.makeConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, changeId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                return mapResultSetToScheduleChange(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return null;
    }
    
    public boolean addScheduleChange(ScheduleChange change) {
        String sql = "INSERT INTO schedule_changes (doctor_id, old_shift_id, new_shift_id, change_reason, " +
                     "effective_date, end_date, status, created_at, updated_at) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, NOW(), NOW())";
        
        try (Connection conn = DBContext.makeConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, change.getDoctorId());
            ps.setInt(2, change.getOldShiftId());
            ps.setInt(3, change.getNewShiftId());
            ps.setString(4, change.getChangeReason());
            ps.setDate(5, change.getEffectiveDate());
            ps.setDate(6, change.getEndDate());
            ps.setString(7, change.getStatus());
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public boolean updateScheduleChangeStatus(int changeId, String status, Integer approvedBy) {
        String sql = "UPDATE schedule_changes SET status = ?, approved_by = ?, approved_at = NOW(), updated_at = NOW() " +
                     "WHERE change_id = ?";
        
        try (Connection conn = DBContext.makeConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, status);
            if (approvedBy != null) {
                ps.setInt(2, approvedBy);
            } else {
                ps.setNull(2, java.sql.Types.INTEGER);
            }
            ps.setInt(3, changeId);
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public boolean deleteScheduleChange(int changeId) {
        String sql = "DELETE FROM schedule_changes WHERE change_id = ?";
        
        try (Connection conn = DBContext.makeConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, changeId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public List<ScheduleChange> getPendingScheduleChanges() {
        List<ScheduleChange> changes = new ArrayList<>();
        String sql = "SELECT sc.*, d.user_id, u.full_name AS doctor_name, " +
                     "os.name AS old_shift_name, os.start_time AS old_start_time, os.end_time AS old_end_time, " +
                     "ns.name AS new_shift_name, ns.start_time AS new_start_time, ns.end_time AS new_end_time, " +
                     "au.full_name AS approved_by_name " +
                     "FROM schedule_changes sc " +
                     "JOIN doctors d ON sc.doctor_id = d.doctor_id " +
                     "JOIN users u ON d.user_id = u.user_id " +
                     "JOIN shifts os ON sc.old_shift_id = os.shift_id " +
                     "JOIN shifts ns ON sc.new_shift_id = ns.shift_id " +
                     "LEFT JOIN users au ON sc.approved_by = au.user_id " +
                     "WHERE sc.status = 'pending' " +
                     "ORDER BY sc.created_at ASC";
        
        try (Connection conn = DBContext.makeConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                ScheduleChange change = mapResultSetToScheduleChange(rs);
                changes.add(change);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return changes;
    }
    
    public boolean hasActiveScheduleChange(int doctorId) {
        String sql = "SELECT COUNT(*) FROM schedule_changes " +
                     "WHERE doctor_id = ? AND status IN ('approved', 'active') " +
                     "AND effective_date <= CURDATE() AND (end_date IS NULL OR end_date >= CURDATE())";
        
        try (Connection conn = DBContext.makeConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, doctorId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return false;
    }
    
    private ScheduleChange mapResultSetToScheduleChange(ResultSet rs) throws SQLException {
        ScheduleChange change = new ScheduleChange();
        change.setChangeId(rs.getInt("change_id"));
        change.setDoctorId(rs.getInt("doctor_id"));
        change.setOldShiftId(rs.getInt("old_shift_id"));
        change.setNewShiftId(rs.getInt("new_shift_id"));
        change.setChangeReason(rs.getString("change_reason"));
        change.setEffectiveDate(rs.getDate("effective_date"));
        change.setEndDate(rs.getDate("end_date"));
        change.setStatus(rs.getString("status"));
        change.setApprovedBy(rs.getObject("approved_by") != null ? rs.getInt("approved_by") : null);
        change.setApprovedAt(rs.getTimestamp("approved_at"));
        change.setCreatedAt(rs.getTimestamp("created_at"));
        change.setUpdatedAt(rs.getTimestamp("updated_at"));
        
        // Map Doctor
        Doctor doctor = new Doctor();
        doctor.setDoctor_id(rs.getInt("doctor_id"));
        User doctorUser = new User();
        doctorUser.setUserId(rs.getInt("user_id"));
        doctorUser.setFullName(rs.getString("doctor_name"));
        doctor.setUser(doctorUser);
        change.setDoctor(doctor);
        
        // Map Old Shift
        Shift oldShift = new Shift();
        oldShift.setShiftId(rs.getInt("old_shift_id"));
        oldShift.setName(rs.getString("old_shift_name"));
        oldShift.setStartTime(rs.getTime("old_start_time"));
        oldShift.setEndTime(rs.getTime("old_end_time"));
        change.setOldShift(oldShift);
        
        // Map New Shift
        Shift newShift = new Shift();
        newShift.setShiftId(rs.getInt("new_shift_id"));
        newShift.setName(rs.getString("new_shift_name"));
        newShift.setStartTime(rs.getTime("new_start_time"));
        newShift.setEndTime(rs.getTime("new_end_time"));
        change.setNewShift(newShift);
        
        // Map Approved By User
        if (rs.getObject("approved_by") != null) {
            User approvedByUser = new User();
            approvedByUser.setUserId(rs.getInt("approved_by"));
            approvedByUser.setFullName(rs.getString("approved_by_name"));
            change.setApprovedByUser(approvedByUser);
        }
        
        return change;
    }
} 