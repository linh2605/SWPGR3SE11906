package dal;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import models.Shift;

public class ShiftDAO extends DBContext {

    public List<Shift> getAllShifts() {
        List<Shift> shifts = new ArrayList<>();
        String sql = "SELECT * FROM shifts ORDER BY start_time";
        
        try (Connection conn = DBContext.makeConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                Shift shift = new Shift();
                shift.setShiftId(rs.getInt("shift_id"));
                shift.setName(rs.getString("name"));
                shift.setStartTime(rs.getTime("start_time"));
                shift.setEndTime(rs.getTime("end_time"));
                shift.setDescription(rs.getString("description"));
                shifts.add(shift);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return shifts;
    }
    
    public Shift getShiftById(int shiftId) {
        String sql = "SELECT * FROM shifts WHERE shift_id = ?";
        
        try (Connection conn = DBContext.makeConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, shiftId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                Shift shift = new Shift();
                shift.setShiftId(rs.getInt("shift_id"));
                shift.setName(rs.getString("name"));
                shift.setStartTime(rs.getTime("start_time"));
                shift.setEndTime(rs.getTime("end_time"));
                shift.setDescription(rs.getString("description"));
                return shift;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return null;
    }
    
    public boolean addShift(Shift shift) {
        String sql = "INSERT INTO shifts (name, start_time, end_time, description) VALUES (?, ?, ?, ?)";
        
        try (Connection conn = DBContext.makeConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, shift.getName());
            ps.setTime(2, shift.getStartTime());
            ps.setTime(3, shift.getEndTime());
            ps.setString(4, shift.getDescription());
            
            int affectedRows = ps.executeUpdate();
            return affectedRows > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public boolean updateShift(Shift shift) {
        String sql = "UPDATE shifts SET name = ?, start_time = ?, end_time = ?, description = ? WHERE shift_id = ?";
        
        try (Connection conn = DBContext.makeConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, shift.getName());
            ps.setTime(2, shift.getStartTime());
            ps.setTime(3, shift.getEndTime());
            ps.setString(4, shift.getDescription());
            ps.setInt(5, shift.getShiftId());
            
            int affectedRows = ps.executeUpdate();
            return affectedRows > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public boolean deleteShift(int shiftId) {
        // Kiểm tra xem shift có được sử dụng trong working_schedules không
        if (isShiftUsedInSchedules(shiftId)) {
            return false; // Không thể xóa vì đang được sử dụng
        }
        
        String sql = "DELETE FROM shifts WHERE shift_id = ?";
        
        try (Connection conn = DBContext.makeConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, shiftId);
            
            int affectedRows = ps.executeUpdate();
            return affectedRows > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    private boolean isShiftUsedInSchedules(int shiftId) {
        String sql = "SELECT COUNT(*) FROM working_schedules WHERE shift_id = ?";
        
        try (Connection conn = DBContext.makeConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, shiftId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return false;
    }
    
    public boolean isShiftNameExists(String name, int excludeShiftId) {
        String sql = "SELECT COUNT(*) FROM shifts WHERE name = ? AND shift_id != ?";
        
        try (Connection conn = DBContext.makeConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, name);
            ps.setInt(2, excludeShiftId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return false;
    }
    
    public boolean isShiftNameExists(String name) {
        return isShiftNameExists(name, 0);
    }
} 