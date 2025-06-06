package models;

import java.sql.Date;
import java.sql.Timestamp;
import lombok.*;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@ToString
public class Doctor {
    private int doctor_id;
    private User user;
    private Gender gender;
    private Date dob;
    private String image_url;
    private Specialty specialty;
    private String degree;
    private String experience;
    private Status status;
    private Timestamp created_at;
}
