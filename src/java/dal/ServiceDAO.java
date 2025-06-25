package dal;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import models.Service;
import models.ServiceType;

public class ServiceDAO {

    public static Service getServiceById(int id) {
        String sql = "SELECT service_id, name, detail, price, type\n"
                + "  FROM services\n"
                + " WHERE service_id = ?";
        try (Connection conn = DBContext.makeConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Service s = new Service();
                    s.setService_id(rs.getInt("service_id"));
                    s.setName(rs.getString("name"));
                    s.setDetail(rs.getString("name"));
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
}
