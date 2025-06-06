package Model1;

import lombok.*;

import java.sql.Timestamp;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@ToString
public class User {
    private int user_id;
    private String username;
    private String password;
    private String fullname;
    private String email;
    private String phone;
    private Role role;
    private Timestamp created_at;
}
