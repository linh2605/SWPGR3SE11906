package dal;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import models.Specialty;

public class SpecialtyDao {

    public static List<Specialty> getAllSpecialties() {
        List<Specialty> list = new ArrayList<>();
        String sql = "SELECT specialty_id, name, description FROM specialties";

        try (Connection conn = DBContext.makeConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Specialty specialty = new Specialty();
                specialty.setSpecialtyId(rs.getInt("specialty_id"));
                specialty.setName(rs.getString("name"));
                specialty.setDescription(rs.getString("description"));
                list.add(specialty);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public static Specialty getSpecialtyById(int id) {
        String sql = "SELECT specialty_id, name, description FROM specialties WHERE specialty_id = ?";

        try (Connection conn = DBContext.makeConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Specialty specialty = new Specialty();
                    specialty.setSpecialtyId(rs.getInt("specialty_id"));
                    specialty.setName(rs.getString("name"));
                    specialty.setDescription(rs.getString("description"));
                    return specialty;
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null; // Not found or error
    }

    public static HashMap<Specialty, Integer> getSpecialtiesWithDoctorCount() {
        HashMap<Specialty, Integer> map = new HashMap<>();
        String sql = "SELECT s.specialty_id\n"
                + "	 , s.name\n"
                + "	 , s.description\n"
                + "	 , COUNT(d.doctor_id) AS doctor_count\n"
                + "  FROM specialties s\n"
                + "	       LEFT JOIN doctors d\n"
                + "	       ON s.specialty_id = d.specialty_id AND d.status = 'active'\n"
                + " GROUP BY s.specialty_id, s.name, s.description;";

        try (Connection conn = DBContext.makeConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Specialty specialty = new Specialty();
                    specialty.setSpecialtyId(rs.getInt("specialty_id"));
                    specialty.setName(rs.getString("name"));
                    specialty.setDescription(rs.getString("description"));
                    Integer count = rs.getInt("doctor_count");
                    map.put(specialty, count);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return map;
    }
}
