package dal;

import models.Specialty;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
public class SpecialtyDao {
    public static List<Specialty> getAllSpecialties() {
        List<Specialty> list = new ArrayList<>();
        String sql = "SELECT specialty_id, name, description FROM specialties";

        try (Connection conn = DBContext.makeConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Specialty specialty = new Specialty();
                specialty.setSpecialty_id(rs.getInt("specialty_id"));
                specialty.setName(rs.getString("name"));
                specialty.setDescription(rs.getString("description"));
                list.add(specialty);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }
}
