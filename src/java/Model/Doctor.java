package Model;

import java.sql.Date;
import java.sql.Timestamp;
import lombok.*;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@ToString
public class Doctor {
    public int doctor_id;
    public User user;
    public Gender gender;
    public Date dob;
    public String image_url;
    public Specialty specialty;
    public String degree;
    public String experience;
    public Status status;
    public Timestamp created_at;
    // test commit dev
}
