package Model;

import java.sql.Date;
import java.sql.Timestamp;

public class Doctor {
    public int doctor_id;
    public User user;
    public Gender gender;
    public Date dob;
    public Specialty specialty;
    public String degree;
    public String experience;
    public Status status;
    public Timestamp created_at;
}
