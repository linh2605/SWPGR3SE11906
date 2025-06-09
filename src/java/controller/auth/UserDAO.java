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
        String sql = "INSERT INTO users (username, password, full_name, email, phone, role_id) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBContext.makeConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            ps.setString(1, user.getUsername());
            ps.setString(2, user.getPassword()); // Ensure hashing before insertion
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
        } catch (SQLException e) {
            e.printStackTrace(); // Consider using a logger
        }
    }

    public static boolean updateUser(User u) {
        String sql = "UPDATE users SET username = ?, password = ?, full_name = ?, email = ?, phone = ?, role_id = ? WHERE user_id = ?";
        try (Connection conn = DBContext.makeConnection();
             PreparedStatement st = conn.prepareStatement(sql)) {

            st.setString(1, u.getUsername());
            st.setString(2, u.getPassword()); // Ensure hashing if updating password
            st.setString(3, u.getFullname());
            st.setString(4, u.getEmail());
            st.setString(5, u.getPhone());
            st.setInt(6, u.getRole().getRole_id());
            st.setInt(7, u.getUser_id());

            return st.executeUpdate() > 0; // Return true if update successful
        } catch (SQLException e) {
            e.printStackTrace(); // Consider using a logger
        }
        return false; // Return false if update fails
    }
    public static boolean createUser(User u) {
    String sql = "INSERT INTO users (username, password, full_name, email, phone, role_id) VALUES (?, ?, ?, ?, ?, ?)";
    
    try (Connection conn = DBContext.makeConnection();
         PreparedStatement st = conn.prepareStatement(sql)) {
        // Setting parameters for the prepared statement
        st.setString(1, u.getUsername());
        st.setString(2, u.getPassword()); // Ensure hashing if saving password
        st.setString(3, u.getFullname());
        st.setString(4, u.getEmail());
        st.setString(5, u.getPhone());
        st.setInt(6, u.getRole().getRole_id());
        // Execute the insert and return true if successful
        return st.executeUpdate() > 0; // Return true if insert successful
    } catch (SQLException e) {
        e.printStackTrace(); // Consider using a logging framework for error handling
    }
    
    // Return false if insert fails
    return false; 
}

    public static void deleteUser(int user_id) {
        try (Connection connection = DBContext.makeConnection();
             PreparedStatement stmt = connection.prepareStatement("DELETE FROM users WHERE user_id = ?")) {
            stmt.setInt(1, user_id);
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace(); // Consider using a logger
        }
    }
    public User getByUsername(String username) {
    String sql = "SELECT * FROM users WHERE username = ?";
    try (Connection conn = DBContext.makeConnection();
         PreparedStatement st = conn.prepareStatement(sql)) {

        st.setString(1, username);
        ResultSet rs = st.executeQuery();

        if (rs.next()) {
            Role role = new Role();
            role.setRole_id(rs.getInt("role_id"));

            return new User(
                rs.getString("username"),
                rs.getString("password"),
                rs.getInt("user_id"),
                rs.getString("full_name"),
                rs.getString("email"),
                rs.getString("phone"),
                role,
                rs.getString("profile_image"), // nếu có
                rs.getTimestamp("created_at")
            );
        }
    } catch (SQLException e) {
        e.printStackTrace(); // Nên dùng logger thực tế
    }
    return null;
}


    public User getByEmail(String email) {
    String sql = "SELECT * FROM users WHERE email = ?";
    try (Connection conn = DBContext.makeConnection();
         PreparedStatement st = conn.prepareStatement(sql)) {

        st.setString(1, email);
        ResultSet rs = st.executeQuery();

        if (rs.next()) {
            Role role = new Role();
            role.setRole_id(rs.getInt("role_id"));

            return new User(
                rs.getString("username"),
                rs.getString("password"),
                rs.getInt("user_id"),
                rs.getString("full_name"),
                rs.getString("email"),
                rs.getString("phone"),
                role,
                rs.getString("profile_image"), // nếu có
                rs.getTimestamp("created_at")
            );
        }
    } catch (SQLException e) {
        e.printStackTrace(); // Nên dùng logger thực tế
    }
    return null;
}


    public User getUser(String username, String password) {
    String sql = "SELECT * FROM `User` WHERE username = ? AND password = ?";
    
    try (Connection conn = DBContext.makeConnection();
         PreparedStatement st = conn.prepareStatement(sql)) {

        st.setString(1, username);
        st.setString(2, password);

        ResultSet rs = st.executeQuery();

        if (rs.next()) {
            User u = new User();
            u.setUser_id(rs.getInt("user_id"));
            u.setRoleID(rs.getInt("RoleID"));
            u.setUsername(rs.getString("username"));
            u.setPassword(rs.getString("password"));
            u.setFullname(rs.getString("fullname"));
            u.setEmail(rs.getString("email"));
            u.setPhone(rs.getString("phone"));
            u.setCreated_at(rs.getTimestamp("created_at"));

            // Nếu bạn có class Role và cần gán role:
            Role role = new Role();
            role.setRole_id(rs.getInt("RoleID"));
            u.setRole(role);

            return u;
        }

    } catch (SQLException e) {
        e.printStackTrace();
    }

    return null; // Không tìm thấy user hoặc có lỗi
}


    }

