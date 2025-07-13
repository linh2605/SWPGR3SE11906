/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import models.Role;
import models.User;
import models.UserRegister;

/**
 * User Data Access Object
 */
public class UserDAO {

    public static User login(String usernameOrEmail, String passwordHashed) {
    try (Connection connection = DBContext.makeConnection();
         PreparedStatement stmt = connection.prepareStatement(
                 "SELECT user_id, username, password, full_name, email, phone, u.role_id, " +
                         "r.name AS role_name, r.description AS role_description, created_at " +
                         "FROM users u JOIN roles r ON u.role_id = r.role_id " +
                         "WHERE username = ? OR email = ?")) {
        stmt.setString(1, usernameOrEmail);
        stmt.setString(2, usernameOrEmail);
        ResultSet resultSet = stmt.executeQuery();
        if (resultSet.next()) {
            if (resultSet.getString("password").equals(passwordHashed)) {
                return mappingUser(resultSet);
            }
        }
        return null;
    } catch (SQLException e) {
        e.printStackTrace();
        return null;
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
        if (user.getPassword() != null && !user.getPassword().isEmpty()) {
            String sql = "UPDATE users SET username = ?, password = ?, full_name = ?, email = ?, phone = ? WHERE user_id = ?";
            try (Connection conn = DBContext.makeConnection();
                 PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setString(1, user.getUsername());
                ps.setString(2, user.getPassword());
                ps.setString(3, user.getFullName());
                ps.setString(4, user.getEmail());
                ps.setString(5, user.getPhone());
                ps.setInt(6, user.getUserId());
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
                ps.setString(2, user.getFullName());
                ps.setString(3, user.getEmail());
                ps.setString(4, user.getPhone());
                ps.setInt(5, user.getUserId());
                return ps.executeUpdate() > 0;
            } catch (Exception e) {
                e.printStackTrace();
                return false;
            }
        }
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
    
    public static boolean doesUsernameExist(String username) {
        String sql = "SELECT 1 FROM users WHERE username = ?";
        try (
                Connection conn = DBContext.makeConnection();
                PreparedStatement ps = conn.prepareStatement(sql)
        ) {
            ps.setString(1, username);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    public static boolean doesEmailExist(String email) {
        String sql = "SELECT 1 FROM users WHERE email = ?";
        try (
                Connection conn = DBContext.makeConnection();
                PreparedStatement ps = conn.prepareStatement(sql)
        ) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    public static boolean doesUsernameExistExcept(int userId, String username) {
        String sql = "SELECT 1 FROM users WHERE username = ? AND user_id != ?";
        try (
                Connection conn = DBContext.makeConnection();
                PreparedStatement ps = conn.prepareStatement(sql)
        ) {
            ps.setString(1, username);
            ps.setInt(2, userId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    public static boolean doesEmailExistExcept(int userId, String email) {
        String sql = "SELECT 1 FROM users WHERE email = ? AND user_id != ?";
        try (
                Connection conn = DBContext.makeConnection();
                PreparedStatement ps = conn.prepareStatement(sql)
        ) {
            ps.setString(1, email);
            ps.setInt(2, userId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
   public boolean checkUserExist(String username, String email) {
    String sql = "SELECT * FROM users WHERE username = ? OR email = ?";
    try (Connection con = DBContext.makeConnection();
         PreparedStatement ps = con.prepareStatement(sql)) {
        ps.setString(1, username);
        ps.setString(2, email);
        ResultSet rs = ps.executeQuery();
        return rs.next();
    } catch (SQLException e) {
        e.printStackTrace();
    }
    return false;
}

public int registerNewUser(UserRegister reg) {
    String sql = "INSERT INTO users (username, password, full_name, email, phone, role_id) VALUES (?, ?, ?, ?, ?, 1)";
    try (Connection conn = DBContext.makeConnection();
         PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

        ps.setString(1, reg.getUsername());
        ps.setString(2, reg.getPassword());
        ps.setString(3, reg.getFullName());
        ps.setString(4, reg.getEmail());
        ps.setString(5, reg.getPhone());
        ps.executeUpdate();

        ResultSet rs = ps.getGeneratedKeys();
        if (rs.next()) {
            return rs.getInt(1);
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
    return -1;
}

public void insertPatient(int userId) {
    String sql = "INSERT INTO patients (user_id) VALUES (?)";
    try (Connection conn = DBContext.makeConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {
        ps.setInt(1, userId);
        ps.executeUpdate();
    } catch (SQLException e) {
        e.printStackTrace();
    }
}



public User findByEmail(String email) {
    String sql = "SELECT * FROM users WHERE email = ?";
    try (Connection con = DBContext.makeConnection();
         PreparedStatement ps = con.prepareStatement(sql)) {
        ps.setString(1, email);
        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
            return new User(
                rs.getString("username"),
                rs.getString("password"),
                rs.getInt("user_id"),
                rs.getString("full_name"),
                rs.getString("email"),
                rs.getString("phone"),
                null,
                rs.getTimestamp("created_at")
            );
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
    return null;
}
public void updatePasswordByEmail(String email, String newPassword) {
    String sql = "UPDATE users SET password = ? WHERE email = ?";
    try (Connection con = DBContext.makeConnection();
         PreparedStatement ps = con.prepareStatement(sql)) {
        ps.setString(1, newPassword);
        ps.setString(2, email);
        ps.executeUpdate();
    } catch (SQLException e) {
        e.printStackTrace();
    }
}
public void updateOtp(String email, String otp) {
    String sql = "INSERT INTO otp_verification (email, otp, expiry, is_verified) " +
                 "VALUES (?, ?, DATE_ADD(NOW(), INTERVAL 5 MINUTE), 0)";
    try (Connection con = DBContext.makeConnection();
         PreparedStatement ps = con.prepareStatement(sql)) {
        ps.setString(1, email);
        ps.setString(2, otp);
        ps.executeUpdate();
    } catch (SQLException e) {
        e.printStackTrace();
    }
}
public boolean verifyOTP(String email, String otp) {
    String sql = "SELECT * FROM otp_verification WHERE email = ? AND otp = ? AND expiry > NOW() AND is_verified = 0";
    try (Connection con = DBContext.makeConnection();
         PreparedStatement ps = con.prepareStatement(sql)) {
        ps.setString(1, email);
        ps.setString(2, otp);
        ResultSet rs = ps.executeQuery();
        return rs.next(); // true nếu có dòng thỏa mãn
    } catch (Exception e) {
        e.printStackTrace();
    }
    return false;
}


public void activateUser(String email) {
    String sql = "UPDATE otp_verification SET is_verified = 1 WHERE email = ?";
    try (Connection con = DBContext.makeConnection();
         PreparedStatement ps = con.prepareStatement(sql)) {
        ps.setString(1, email);
        ps.executeUpdate();
    } catch (Exception e) {
        e.printStackTrace();
    }
}
public void saveOtpOnly(String email, String otp) {
    String sql = "INSERT INTO otp_verification (email, otp, expiry, is_verified) VALUES (?, ?, DATE_ADD(NOW(), INTERVAL 5 MINUTE), 0)";
    try (Connection conn = DBContext.makeConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {
        ps.setString(1, email);
        ps.setString(2, otp);
        ps.executeUpdate();
    } catch (Exception e) {
        e.printStackTrace();
    }
}






 
}
