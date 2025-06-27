package models;

import java.time.LocalDateTime;

public class Appointment {
    private int id;
//    private String doctor;
    private Doctor doctor;
//    private String patient;
    private Patient patient;
    private String status;
    private String dateTime;
    private LocalDateTime appointmentDate;
    private String appointmentDateStr; // String version for compatibility
    private String appointmentTime; // Time as string
    private String notes;
    private LocalDateTime createdAt;
    private LocalDateTime updateAt;
    
    // Additional field for schedule change support
    private Doctor suggestedDoctor;

    // Constructors
    public Appointment() {
    }
    
    public Appointment(int id, Doctor doctor, Patient patient, String status, String dateTime, 
                      LocalDateTime appointmentDate, String appointmentDateStr, String appointmentTime, 
                      String notes, LocalDateTime createdAt, LocalDateTime updateAt) {
        this.id = id;
        this.doctor = doctor;
        this.patient = patient;
        this.status = status;
        this.dateTime = dateTime;
        this.appointmentDate = appointmentDate;
        this.appointmentDateStr = appointmentDateStr;
        this.appointmentTime = appointmentTime;
        this.notes = notes;
        this.createdAt = createdAt;
        this.updateAt = updateAt;
    }

    // Getters and Setters
    public int getId() {
        return id;
    }
    
    public void setId(int id) {
        this.id = id;
    }
    
    public Doctor getDoctor() {
        return doctor;
    }
    
    public void setDoctor(Doctor doctor) {
        this.doctor = doctor;
    }
    
    public Patient getPatient() {
        return patient;
    }
    
    public void setPatient(Patient patient) {
        this.patient = patient;
    }
    
    public String getStatus() {
        return status;
    }
    
    public void setStatus(String status) {
        this.status = status;
    }
    
    public String getDateTime() {
        return dateTime;
    }
    
    public void setDateTime(String dateTime) {
        this.dateTime = dateTime;
    }
    
    public LocalDateTime getAppointmentDateLocal() {
        return appointmentDate;
    }
    
    public void setAppointmentDateLocal(LocalDateTime appointmentDate) {
        this.appointmentDate = appointmentDate;
    }
    
    public LocalDateTime getCreatedAt() {
        return createdAt;
    }
    
    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }
    
    public LocalDateTime getUpdateAt() {
        return updateAt;
    }
    
    public void setUpdateAt(LocalDateTime updateAt) {
        this.updateAt = updateAt;
    }

    public void setDateTime(java.time.LocalDateTime dateTime) {
        this.dateTime = dateTime.format(java.time.format.DateTimeFormatter.ISO_LOCAL_DATE_TIME);
    }
    
    // Getters and setters for compatibility
    public String getAppointmentDate() {
        return appointmentDateStr;
    }
    
    public void setAppointmentDate(String appointmentDate) {
        this.appointmentDateStr = appointmentDate;
    }
    
    public String getAppointmentTime() {
        return appointmentTime;
    }
    
    public void setAppointmentTime(String appointmentTime) {
        this.appointmentTime = appointmentTime;
    }
    
    public String getNotes() {
        return notes;
    }
    
    public void setNotes(String notes) {
        this.notes = notes;
    }
    
    public Doctor getSuggestedDoctor() {
        return suggestedDoctor;
    }
    
    public void setSuggestedDoctor(Doctor suggestedDoctor) {
        this.suggestedDoctor = suggestedDoctor;
    }
    
    @Override
    public String toString() {
        return "Appointment{" +
                "id=" + id +
                ", doctor=" + doctor +
                ", patient=" + patient +
                ", status='" + status + '\'' +
                ", appointmentDate='" + appointmentDateStr + '\'' +
                ", appointmentTime='" + appointmentTime + '\'' +
                ", notes='" + notes + '\'' +
                '}';
    }
} 