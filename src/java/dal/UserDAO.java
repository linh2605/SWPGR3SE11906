/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import models.Role;
import models.User;
import java.sql.*;

/**
 * User Data Access Object
 */
public class UserDAO {

    public static User login(String username, String password) {
        try (Connection connection = DBContext.makeConnection();
             PreparedStatement stmt = connection.prepareStatement(
                     "SELECT user_id, username, password, full_name, email, phone, u.role_id, " +
                             "r.name AS role_name, r.description AS role_description, created_at " +
                             "FROM users u JOIN roles r ON u.role_id = r.role_id " +
                             "WHERE username = ? OR email = ?")) {
            stmt.setString(1, username);
            stmt.setString(2, username);
            ResultSet resultSet = stmt.executeQuery();
            if (resultSet.next()) {
                // Assuming password is hashed
                if (resultSet.getString("password").equals(password)) {
                    return mappingUser(resultSet);
                }
            }
            return new User(); // Return empty User for wrong credentials
        } catch (SQLException e) {
            e.printStackTrace(); // Consider using a logger
            return new User();
        }
    }

    private static User mappingUser(ResultSet resultSet) throws SQLException {
        User user = new User();
        user.setUserId(resultSet.getInt("user_id"));
        user.setUsername(resultSet.getString("username"));
        user.setPassword(resultSet.getString("password"));
        user.setFullName(resultSet.getString("full_name"));
        user.setEmail(resultSet.getString("email"));
        user.setPhone(resultSet.getString("phone"));
        Role role = new Role();
        role.setRoleId(resultSet.getInt("role_id"));
        role.setName(resultSet.getString("role_name"));
        role.setDescription(resultSet.getString("role_description"));
        user.setRole(role);
        user.setCreatedAt(resultSet.getTimestamp("created_at"));
        return user;
    }

    public static void insertUser(User user) {
        String sql = "INSERT INTO users (username, password, full_name, email, phone, role_id) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBContext.makeConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            ps.setString(1, user.getUsername());
            ps.setString(2, user.getPassword()); // Ensure hashing before insertion
            ps.setString(3, user.getFullName());
            ps.setString(4, user.getEmail());
            ps.setString(5, user.getPhone());
            ps.setInt(6, user.getRole().getRoleId());

            int rows = ps.executeUpdate();
            if (rows > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        user.setUserId(rs.getInt(1));
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace(); // Consider using a logger
        }
    }

    public static boolean updateUser(User user) {
        String sql = "UPDATE users SET username = ?, password = ?, full_name = ?, email = ?, phone = ?, role_id = ? WHERE user_id = ?";
        try (Connection conn = DBContext.makeConnection();
             PreparedStatement st = conn.prepareStatement(sql)) {

            st.setString(1, user.getUsername());
            st.setString(2, user.getPassword()); // Ensure hashing if updating password
            st.setString(3, user.getFullName());
            st.setString(4, user.getEmail());
            st.setString(5, user.getPhone());
            st.setInt(6, user.getRole().getRoleId());
            st.setInt(7, user.getUserId());

            return st.executeUpdate() > 0; // Return true if update successful
        } catch (SQLException e) {
            e.printStackTrace(); // Consider using a logger
        }
        return false; // Return false if update fails
    }

    public static void deleteUser(int userId) {
        try (Connection connection = DBContext.makeConnection();
             PreparedStatement stmt = connection.prepareStatement("DELETE FROM users WHERE user_id = ?")) {
            stmt.setInt(1, userId);
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace(); // Consider using a logger
        }
    }

    public static User getByUsername(String username) {
        String sql = "SELECT * FROM users WHERE username = ?";
        try (Connection conn = DBContext.makeConnection();
             PreparedStatement st = conn.prepareStatement(sql)) {

            st.setString(1, username);
            ResultSet rs = st.executeQuery();

            if (rs.next()) {
                Role role = new Role();
                role.setRoleId(rs.getInt("role_id"));

                return new User(
                    rs.getString("username"),
                    rs.getString("password"),
                    rs.getInt("user_id"),
                    rs.getString("full_name"),
                    rs.getString("email"),
                    rs.getString("phone"),
                    role,
                    rs.getTimestamp("created_at")
                );
            }
        } catch (SQLException e) {
            e.printStackTrace(); // Nên dùng logger thực tế
        }
        return null;
    }

    public static User getByEmail(String email) {
        String sql = "SELECT * FROM users WHERE email = ?";
        try (Connection conn = DBContext.makeConnection();
             PreparedStatement st = conn.prepareStatement(sql)) {

            st.setString(1, email);
            ResultSet rs = st.executeQuery();

            if (rs.next()) {
                Role role = new Role();
                role.setRoleId(rs.getInt("role_id"));

                return new User(
                    rs.getString("username"),
                    rs.getString("password"),
                    rs.getInt("user_id"),
                    rs.getString("full_name"),
                    rs.getString("email"),
                    rs.getString("phone"),
                    role,
                    rs.getTimestamp("created_at")
                );
            }
        } catch (SQLException e) {
            e.printStackTrace(); // Nên dùng logger thực tế
        }
        return null;
    }
}
