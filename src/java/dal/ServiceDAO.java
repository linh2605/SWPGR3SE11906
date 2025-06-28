package dal;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import models.Service;
import models.ServiceType;
import java.util.ArrayList;
import java.util.List;

public class ServiceDAO {

    public static Service getServiceById(int serviceId) {
        String sql = "SELECT service_id, name, detail, price, type FROM services WHERE service_id = ?";
        try (Connection conn = DBContext.makeConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, serviceId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Service s = new Service();
                    s.setService_id(rs.getInt("service_id"));
                    s.setName(rs.getString("name"));
                    s.setDetail(rs.getString("detail"));
                    s.setPrice(rs.getLong("price"));
                    s.setType(ServiceType.valueOf(rs.getString("type")));
                    return s;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public static List<Service> getTopServices(int limit) {
        List<Service> list = new ArrayList<>();
        String sql = "SELECT service_id, name, detail, price, type FROM services LIMIT ?";
        try (Connection conn = DBContext.makeConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Service s = new Service();
                    s.setService_id(rs.getInt("service_id"));
                    s.setName(rs.getString("name"));
                    s.setDetail(rs.getString("detail"));
                    s.setPrice(rs.getLong("price"));
                    s.setType(models.ServiceType.valueOf(rs.getString("type")));
                    list.add(s);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public static List<Service> getTopPopularServices(int limit) {
        List<Service> list = new ArrayList<>();
        String sql = "SELECT s.service_id, s.name, s.detail, s.price, s.type, COUNT(a.appointment_id) as count " +
                "FROM services s LEFT JOIN appointments a ON s.service_id = a.service_id " +
                "GROUP BY s.service_id, s.name, s.detail, s.price, s.type " +
                "ORDER BY count DESC LIMIT ?";
        try (Connection conn = DBContext.makeConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Service s = new Service();
                    s.setService_id(rs.getInt("service_id"));
                    s.setName(rs.getString("name"));
                    s.setDetail(rs.getString("detail"));
                    s.setPrice(rs.getLong("price"));
                    s.setType(ServiceType.valueOf(rs.getString("type")));
                    list.add(s);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}
