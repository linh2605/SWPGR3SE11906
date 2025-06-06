/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAO;

import Model.Role;
import Model.User;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

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
}
