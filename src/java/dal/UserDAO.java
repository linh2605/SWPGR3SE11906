/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import models.Role;
import models.User;
import java.sql.*;

/**
 *
 * @author admin
 */
public class UserDAO {

    public static User login(String username, String password) {
        try {
            Connection connection = DBContext.makeConnection();
            PreparedStatement stmt = connection.prepareStatement(
                    "SELECT user_id\n"
                    + "	 , username\n"
                    + "	 , password\n"
                    + "	 , full_name\n"
                    + "	 , email\n"
                    + "	 , phone\n"
                    + "	 , u.role_id\n"
                    + "	 , r.name        AS role_name\n"
                    + "	 , r.description AS role_description\n"
                    + "	 , created_at\n"
                    + "  FROM users u\n"
                    + "	       JOIN roles r\n"
                    + "	       ON u.role_id = r.role_id\n"
                    + " WHERE username = ?\n"
                    + "	OR email = ?");
            stmt.setString(1, username);
            stmt.setString(2, username);
            ResultSet resultSet = stmt.executeQuery();
            User user = new User();
            if (resultSet.next()) {
                if (resultSet.getString("password").equals(password)) {
                    user = mappingUser(resultSet);
                    return user;
                }
                return new User(); // wrong password
            }
            return user;
        } catch (Exception e) {
            e.printStackTrace();
            return new User();
        }
    }

    private static User mappingUser(ResultSet resultSet) throws SQLException {
        User user = new User();
        user.setUser_id(resultSet.getInt("user_id"));
        user.setUsername(resultSet.getString("username"));
        user.setPassword(resultSet.getString("password"));
        user.setFullname(resultSet.getString("full_name"));
        user.setEmail(resultSet.getString("email"));
        user.setPhone(resultSet.getString("phone"));
        Role role = new Role();
        role.setRole_id(resultSet.getInt("role_id"));
        role.setName(resultSet.getString("role_name"));
        role.setDescription(resultSet.getString("role_description"));
        user.setRole(role);
        user.setCreated_at(resultSet.getTimestamp("created_at"));
        return user;
    }
    public static void insertUser(User user) {
        String sql = "INSERT INTO users (username, password, full_name, email, phone, role_id) " +
                "VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBContext.makeConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, user.getUsername());
            ps.setString(2, user.getPassword());
            ps.setString(3, user.getFullname());
            ps.setString(4, user.getEmail());
            ps.setString(5, user.getPhone());
            ps.setInt(6, user.getRole().getRole_id());

            int rows = ps.executeUpdate();
            if (rows > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        user.setUser_id(rs.getInt(1));
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    public static boolean updateUser(User user) {
        if (user.getPassword() != null && !user.getPassword().isEmpty()) {
            String sql = "UPDATE users SET username = ?, password = ?, full_name = ?, email = ?, phone = ? WHERE user_id = ?";
            try (Connection conn = DBContext.makeConnection();
                 PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setString(1, user.getUsername());
                ps.setString(2, user.getPassword());
                ps.setString(3, user.getFullname());
                ps.setString(4, user.getEmail());
                ps.setString(5, user.getPhone());
                ps.setInt(6, user.getUser_id());
                return ps.executeUpdate() > 0;
            } catch (Exception e) {
                e.printStackTrace();
                return false;
            }
        } else {
            String sql = "UPDATE users SET username = ?, full_name = ?, email = ?, phone = ? WHERE user_id = ?";
            try (Connection conn = DBContext.makeConnection();
                 PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setString(1, user.getUsername());
                ps.setString(2, user.getFullname());
                ps.setString(3, user.getEmail());
                ps.setString(4, user.getPhone());
                ps.setInt(5, user.getUser_id());
                return ps.executeUpdate() > 0;
            } catch (Exception e) {
                e.printStackTrace();
                return false;
            }
        }
    }
    public static void deleteUser(int user_id){
        try {
            Connection connection = DBContext.makeConnection();
            PreparedStatement stmt = connection.prepareStatement("DELETE FROM users WHERE user_id = ?");
            stmt.setInt(1, user_id);
            stmt.executeUpdate();
        } catch (Exception e){
            e.printStackTrace();
        }
    }
}
