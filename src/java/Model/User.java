package Model;

import java.sql.Timestamp;

public class User {
    public int user_id;
    public String username;
    public String password;
    public String fullname;
    public String email;
    public String phone;
    public Role role;
    public Timestamp created_at;
}
