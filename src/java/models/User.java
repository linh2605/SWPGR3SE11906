package models;

import lombok.*;

import java.sql.Timestamp;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@ToString
public class User {
    private int user_id;
    private int RoleID;
    private String username;
    private String password;
    private String fullname;
    private String email;
    private String phone;
    private Role role;
    private Timestamp created_at;

    // Constructing with role
    public User(String username, String password, String fullname, String email, String phone, Role role) {
        this.username = username;
        this.password = password;
        this.fullname = fullname;
        this.email = email;
        this.phone = phone;
        this.role = role;
    }
    public User(String username, String password, int user_id, String fullname, String email, String phone, Role role, String email1, Timestamp created_at) {
        this.user_id = user_id;
        this.username = username;
        this.password = password;
        this.fullname = fullname;
        this.email = email;
        this.phone = phone;
        this.role = role;
        this.created_at = created_at;
    }
    
    
    // Setter for user_id
    public void setId(int user_id) {
        this.user_id = user_id;
    }
    
    // Setter for RoleID
    public void setRoleID(int roleID) {
        this.RoleID = roleID;
    }
}
