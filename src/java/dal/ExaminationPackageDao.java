package dal;

import models.ExaminationPackage;
import models.Specialty;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ExaminationPackageDao {

    public static List<ExaminationPackage> getAll() {
        List<ExaminationPackage> list = new ArrayList<>();
        String sql = "SELECT * FROM examination_packages";

        try (Connection conn = DBContext.makeConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                int packageId = rs.getInt("package_id");
                List<Specialty> specialties = getSpecialtiesByPackageId(packageId);
                ExaminationPackage e = new ExaminationPackage(
                        packageId,
                        rs.getString("name"),
                        rs.getString("description"),
                        specialties,
                        rs.getDouble("price"),
                        rs.getInt("duration")
                );
                list.add(e);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }

    public static ExaminationPackage getById(int id) {
        String sql = "SELECT * FROM examination_packages WHERE package_id = ?";
        try (Connection conn = DBContext.makeConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    List<Specialty> specialties = getSpecialtiesByPackageId(id);
                    return new ExaminationPackage(
                            rs.getInt("package_id"),
                            rs.getString("name"),
                            rs.getString("description"),
                            specialties,
                            rs.getDouble("price"),
                            rs.getInt("duration")
                    );
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;
    }

    public static boolean insert(ExaminationPackage e) {
        String sql = "INSERT INTO examination_packages(name, description, price, duration) VALUES (?, ?, ?, ?)";
        try (Connection conn = DBContext.makeConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setString(1, e.getName());
            ps.setString(2, e.getDescription());
            ps.setDouble(3, e.getPrice());
            ps.setInt(4, e.getDuration());

            int rows = ps.executeUpdate();
            if (rows > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        int generatedId = rs.getInt(1);
                        insertSpecialties(conn, generatedId, e.getSpecialties());
                    }
                }
                return true;
            }

        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return false;
    }

    public static boolean update(ExaminationPackage e) {
        String sql = "UPDATE examination_packages SET name = ?, description = ?, price = ?, duration = ? WHERE package_id = ?";
        try (Connection conn = DBContext.makeConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, e.getName());
            ps.setString(2, e.getDescription());
            ps.setDouble(3, e.getPrice());
            ps.setInt(4, e.getDuration());
            ps.setInt(5, e.getPackageId());

            int rows = ps.executeUpdate();
            if (rows > 0) {
                // Cập nhật lại danh sách chuyên khoa
                deleteSpecialties(conn, e.getPackageId());
                insertSpecialties(conn, e.getPackageId(), e.getSpecialties());
                return true;
            }

        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return false;
    }

    public static boolean delete(int id) {
        String sql = "DELETE FROM examination_packages WHERE package_id = ?";
        try (Connection conn = DBContext.makeConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            return ps.executeUpdate() > 0;

        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return false;
    }

    private static List<Specialty> getSpecialtiesByPackageId(int packageId) throws SQLException {
        List<Specialty> list = new ArrayList<>();
        String sql = "SELECT s.specialty_id, s.name, s.description FROM specialties s " +
                "JOIN examination_package_specialities eps ON s.specialty_id = eps.speciality_id WHERE eps.package_id = ?";
        try (Connection conn = DBContext.makeConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, packageId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Specialty s = new Specialty(
                            rs.getInt("specialty_id"),
                            rs.getString("name"),
                            rs.getString("description")
                    );
                    list.add(s);
                }
            }
        }
        return list;
    }

    private static void insertSpecialties(Connection conn, int packageId, List<Specialty> specialties) throws SQLException {
        String sql = "INSERT INTO examination_package_specialities(package_id, speciality_id) VALUES (?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            for (Specialty s : specialties) {
                ps.setInt(1, packageId);
                ps.setInt(2, s.getSpecialty_id());
                ps.addBatch();
            }
            ps.executeBatch();
        }
    }

    private static void deleteSpecialties(Connection conn, int packageId) throws SQLException {
        String sql = "DELETE FROM examination_package_specialities WHERE package_id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, packageId);
            ps.executeUpdate();
        }
    }
}
