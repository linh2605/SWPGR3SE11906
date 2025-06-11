package models;

import lombok.*;

import java.sql.Timestamp;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@ToString
public class User {
    private int userId;
    private int roleId;
    private String username;
    private String password;
    private String fullName;
    private String email;
    private String phone;
    private Role role;
    private Timestamp createdAt;

    // Constructor với role
    public User(String username, String password, String fullName, String email, String phone, Role role) {
        this.username = username;
        this.password = password;
        this.fullName = fullName;
        this.email = email;
        this.phone = phone;
        this.role = role;
    }

    // Constructor đầy đủ
    public User(String username, String password, int userId, String fullName, String email, String phone, Role role, Timestamp createdAt) {
        this.userId = userId;
        this.username = username;
        this.password = password;
        this.fullName = fullName;
        this.email = email;
        this.phone = phone;
        this.role = role;
        this.createdAt = createdAt;
    }
}
