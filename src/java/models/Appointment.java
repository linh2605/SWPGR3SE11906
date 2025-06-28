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
    private String note;
    private LocalDateTime createdAt;
    private LocalDateTime updateAt;
    private Service service;
    private PaymentStatus paymentStatus;
    private String appointmentDateStr;
    private String notes;
    private String appointmentTime;
    private Doctor suggestedDoctor;

    public Appointment() {}

    public Appointment(int id, Doctor doctor, Patient patient, String status, String dateTime, LocalDateTime appointmentDate, String note, LocalDateTime createdAt, LocalDateTime updateAt, Service service, PaymentStatus paymentStatus, String appointmentDateStr, String notes, String appointmentTime, Doctor suggestedDoctor) {
        this.id = id;
        this.doctor = doctor;
        this.patient = patient;
        this.status = status;
        this.dateTime = dateTime;
        this.appointmentDate = appointmentDate;
        this.note = note;
        this.createdAt = createdAt;
        this.updateAt = updateAt;
        this.service = service;
        this.paymentStatus = paymentStatus;
        this.appointmentDateStr = appointmentDateStr;
        this.notes = notes;
        this.appointmentTime = appointmentTime;
        this.suggestedDoctor = suggestedDoctor;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public Doctor getDoctor() { return doctor; }
    public void setDoctor(Doctor doctor) { this.doctor = doctor; }

    public Patient getPatient() { return patient; }
    public void setPatient(Patient patient) { this.patient = patient; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getDateTime() { return dateTime; }
    public void setDateTime(String dateTime) { this.dateTime = dateTime; }
    public void setDateTime(LocalDateTime dateTime) { this.dateTime = dateTime.format(java.time.format.DateTimeFormatter.ISO_LOCAL_DATE_TIME); }

    public LocalDateTime getAppointmentDateTime() { return appointmentDate; }
    public void setAppointmentDateTime(LocalDateTime appointmentDate) { this.appointmentDate = appointmentDate; }
    public void setAppointmentDate(String appointmentDate) { this.appointmentDateStr = appointmentDate; }
    public String getAppointmentDate() { return appointmentDateStr; }

    public String getNote() { return note; }
    public void setNote(String note) { this.note = note; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

    public LocalDateTime getUpdateAt() { return updateAt; }
    public void setUpdateAt(LocalDateTime updateAt) { this.updateAt = updateAt; }

    public Service getService() { return service; }
    public void setService(Service service) { this.service = service; }

    public PaymentStatus getPaymentStatus() { return paymentStatus; }
    public void setPaymentStatus(PaymentStatus paymentStatus) { this.paymentStatus = paymentStatus; }

    public String getNotes() { return notes; }
    public void setNotes(String notes) { this.notes = notes; }

    public String getAppointmentTime() { return appointmentTime; }
    public void setAppointmentTime(String appointmentTime) { this.appointmentTime = appointmentTime; }

    public Doctor getSuggestedDoctor() { return suggestedDoctor; }
    public void setSuggestedDoctor(Doctor suggestedDoctor) { this.suggestedDoctor = suggestedDoctor; }
} 