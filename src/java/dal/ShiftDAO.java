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
                shifts.add(shift);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return shifts;
    }
} 