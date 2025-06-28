/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import models.StatusUplate;

/**
 *
 * @author auiri
 */
public class StatusDAO {
    public static List<StatusUplate> getStatusesByRole(int roleId) {
        List<StatusUplate> list = new ArrayList<>();
        String sql = "SELECT * FROM status_definitions WHERE handled_by = ?";
        try (Connection conn = DBContext.makeConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, roleId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                StatusUplate s = new StatusUplate();
                s.setCode(rs.getInt("code"));
                s.setDescription(rs.getString("description"));
                s.setHandledBy(rs.getInt("handled_by"));
                list.add(s);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
    
}
