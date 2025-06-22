package dal;

import models.WorkingSchedule;
import models.Shift;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Time;
import java.util.ArrayList;
import java.util.List;

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
        String sql = "SELECT ws.*, s.name AS shift_name, s.start_time, s.end_time " +
                     "FROM working_schedules ws " +
                     "JOIN shifts s ON ws.shift_id = s.shift_id " +
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
                schedules.add(schedule);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return schedules;
    }
    
    // Các phương thức add, update, delete, checkExists sẽ được admin sử dụng
    // và sẽ được phát triển trong phần của admin.
    // Tạm thời có thể giữ lại hoặc xóa đi để cho gọn.
    // Ở đây tôi sẽ xóa đi để chỉ giữ lại phần cần thiết cho vai trò bác sĩ.
} 