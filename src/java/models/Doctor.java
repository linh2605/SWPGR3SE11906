package models;

import java.sql.Date;
import java.sql.Timestamp;

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

    public Doctor() {}

    public int getDoctor_id() { return doctor_id; }
    public void setDoctor_id(int doctor_id) { this.doctor_id = doctor_id; }

    public User getUser() { return user; }
    public void setUser(User user) { this.user = user; }

    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }

    public Gender getGender() { return gender; }
    public void setGender(Gender gender) { this.gender = gender; }

    public Date getDob() { return dob; }
    public void setDob(Date dob) { this.dob = dob; }

    public String getImage_url() { return image_url; }
    public void setImage_url(String image_url) { this.image_url = image_url; }

    public Specialty getSpecialty() { return specialty; }
    public void setSpecialty(Specialty specialty) { this.specialty = specialty; }

    public String getDegree() { return degree; }
    public void setDegree(String degree) { this.degree = degree; }

    public String getExperience() { return experience; }
    public void setExperience(String experience) { this.experience = experience; }

    public Status getStatus() { return status; }
    public void setStatus(Status status) { this.status = status; }

    public Timestamp getCreated_at() { return created_at; }
    public void setCreated_at(Timestamp created_at) { this.created_at = created_at; }
}
