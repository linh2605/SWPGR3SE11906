package models;

import java.sql.Date;
import java.sql.Timestamp;
import java.time.LocalDate;
import java.util.List;

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
    private ContractStatus contract_status;
    private LocalDate contract_start_date;
    private LocalDate contract_end_date;
    private Timestamp created_at;
    private Timestamp deletedAt;
    private List<Service> services;
    
    public ContractStatus getContract_status() {
        return contract_status;
    }

    public void setContract_status(ContractStatus contract_status) {
        this.contract_status = contract_status;
    }

    public LocalDate getContract_start_date() {
        return contract_start_date;
    }

    public void setContract_start_date(LocalDate contract_start_date) {
        this.contract_start_date = contract_start_date;
    }

    public LocalDate getContract_end_date() {
        return contract_end_date;
    }

    public void setContract_end_date(LocalDate contract_end_date) {
        this.contract_end_date = contract_end_date;
    }

    public Doctor() {}
    
    public Doctor(int doctor_id) {
        this.doctor_id = doctor_id;
    }

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

    public List<Service> getServices() { return services; }
    public void setServices(List<Service> services) { this.services = services; }
    
    public Timestamp getDeletedAt() { return deletedAt; }
    public void setDeletedAt(Timestamp deletedAt) { this.deletedAt = deletedAt; }
    
    @Override
    public String toString() {
        return "Doctor{" +
                "doctor_id=" + doctor_id +
                ", user=" + (user != null ? user.getUserId() : "null") +
                ", fullName='" + (fullName != null ? fullName : "") + '\'' +
                ", gender=" + (gender != null ? gender.name() : "null") +
                ", dob=" + dob +
                ", image_url='" + (image_url != null ? image_url : "") + '\'' +
                ", specialty=" + (specialty != null ? specialty.getName() : "null") +
                ", degree='" + (degree != null ? degree : "") + '\'' +
                ", experience='" + (experience != null ? experience : "") + '\'' +
                ", status=" + (status != null ? status.name() : "null") +
                '}';
    }
}
