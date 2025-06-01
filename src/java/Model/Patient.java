package Model;

import java.sql.Date;
import java.sql.Timestamp;

import lombok.*;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@ToString
public class Patient {
    public int patient_id;
    public User user;
    public Gender gender;
    public Date date_of_birth;
    public String address;
    public String image_url;
    public Timestamp created_at;
}
