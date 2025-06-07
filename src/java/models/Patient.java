package models;

import java.sql.Date;
import java.sql.Timestamp;

import lombok.*;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@ToString
public class Patient {
    private int patient_id;
    private User user;
    private Gender gender;
    private Date date_of_birth;
    private String address;
    private String image_url;
    private Timestamp created_at;
    public Patient(User user, Gender gender, Date date_of_birth, String address, String image_url) {
        this.user = user;
        this.gender = gender;
        this.date_of_birth = date_of_birth;
        this.address = address;
        this.image_url = image_url;
    }
}
