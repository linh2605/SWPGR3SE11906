package models;

import java.sql.Date;
import java.sql.Timestamp;
import java.util.List;
import lombok.*;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@ToString
public class Doctor {

    private int doctor_id;
    private User user;
    private String fullName;
    private Gender gender;
    private Date dob;
    private String image_url;
    private Specialty specialty;
    private String degree;
    private String experience;
    private Status status;
    private Timestamp created_at;
    private List<Service> services;
    
    public Doctor(User user, Gender gender, Date dob, String image_url, Specialty specialty, String degree, String experience, Status status) {
        this.user = user;
        this.gender = gender;
        this.dob = dob;
        this.image_url = image_url;
        this.specialty = specialty;
        this.degree = degree;
        this.experience = experience;
        this.status = status;
    }
}
