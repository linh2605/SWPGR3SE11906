package models;

import java.sql.Date;
import java.sql.Timestamp;

public class Patient {
    private int patient_id;
    private User user;
    private String fullName;
    private Gender gender;
    private Date date_of_birth;
    private String address;
    private String image_url;
    private Timestamp created_at;
    private int status_code;

    public Patient() {}

    public int getPatient_id() { return patient_id; }
    public void setPatient_id(int patient_id) { this.patient_id = patient_id; }

    public User getUser() { return user; }
    public void setUser(User user) { this.user = user; }

    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }

    public Gender getGender() { return gender; }
    public void setGender(Gender gender) { this.gender = gender; }

    public Date getDate_of_birth() { return date_of_birth; }
    public void setDate_of_birth(Date date_of_birth) { this.date_of_birth = date_of_birth; }

    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }

    public String getImage_url() { return image_url; }
    public void setImage_url(String image_url) { this.image_url = image_url; }

    public int getStatus_code() { return status_code; }
    public void setStatus_code(int status_code) { this.status_code = status_code; }

    public Timestamp getCreated_at() { return created_at; }
    public void setCreated_at(Timestamp created_at) { this.created_at = created_at; }

    public Patient(User user, Gender gender, Date date_of_birth, String address, String image_url) {
        this.user = user;
        this.gender = gender;
        this.date_of_birth = date_of_birth;
        this.address = address;
        this.image_url = image_url;
    }
}
