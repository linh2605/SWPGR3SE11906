package dal;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import models.ExaminationPackage;

public class ExaminationPackageDAO extends DBContext {
    public List<ExaminationPackage> getAll() {
        List<ExaminationPackage> list = new ArrayList<>();
        String sql = "SELECT * FROM examination_packages ORDER BY package_id";
        
        try (Connection conn = DBContext.makeConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                ExaminationPackage pkg = new ExaminationPackage();
                pkg.setPackageId(rs.getInt("package_id"));
                pkg.setName(rs.getString("name"));
                pkg.setDescription(rs.getString("description"));
                pkg.setPrice(rs.getDouble("price"));
                pkg.setDuration(rs.getInt("duration"));
                pkg.setImageUrl(rs.getString("image_url"));
                list.add(pkg);
            }
        } catch (SQLException e) {
            System.out.println("Error getting examination packages: " + e.getMessage());
        }
        return list;
    }
    
    public List<ExaminationPackage> getTop3() {
        List<ExaminationPackage> list = new ArrayList<>();
        String sql = "SELECT * FROM examination_packages ORDER BY package_id DESC LIMIT 3";
        
        try (Connection conn = DBContext.makeConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                ExaminationPackage pkg = new ExaminationPackage();
                pkg.setPackageId(rs.getInt("package_id"));
                pkg.setName(rs.getString("name"));
                pkg.setDescription(rs.getString("description"));
                pkg.setPrice(rs.getDouble("price"));
                pkg.setDuration(rs.getInt("duration"));
                pkg.setImageUrl(rs.getString("image_url"));
                list.add(pkg);
            }
        } catch (SQLException e) {
            System.out.println("Error getting top examination packages: " + e.getMessage());
        }
        return list;
    }

    public void updateImageUrl(int packageId, String imageUrl) {
        String sql = "UPDATE examination_packages SET image_url = ? WHERE package_id = ?";
        try (Connection conn = DBContext.makeConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, imageUrl);
            ps.setInt(2, packageId);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
} 