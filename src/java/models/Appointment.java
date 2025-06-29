package models;

import java.time.LocalDateTime;

public class Appointment {
    private int id;
    private Patient patient;
    private Doctor doctor;
    private Service service;
    private LocalDateTime appointmentDateTime;
    private AppointmentStatus status;
    private String note;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    private PaymentStatus paymentStatus;

    // Constructors
    public Appointment() {
        this.status = AppointmentStatus.PENDING;
        this.paymentStatus = PaymentStatus.PENDING;
    }

    public Appointment(int id, Patient patient, Doctor doctor, Service service, LocalDateTime appointmentDateTime, AppointmentStatus status, String note) {
        this.id = id;
        this.patient = patient;
        this.doctor = doctor;
        this.service = service;
        this.appointmentDateTime = appointmentDateTime;
        this.status = status != null ? status : AppointmentStatus.PENDING;
        this.note = note;
        this.paymentStatus = PaymentStatus.PENDING;
    }

    // Getters and Setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public Patient getPatient() {
        return patient;
    }

    public void setPatient(Patient patient) {
        this.patient = patient;
    }

    public Doctor getDoctor() {
        return doctor;
    }

    public void setDoctor(Doctor doctor) {
        this.doctor = doctor;
    }

    public Service getService() {
        return service;
    }

    public void setService(Service service) {
        this.service = service;
    }

    public LocalDateTime getAppointmentDateTime() {
        return appointmentDateTime;
    }

    public void setAppointmentDateTime(LocalDateTime appointmentDateTime) {
        this.appointmentDateTime = appointmentDateTime;
    }

    public AppointmentStatus getStatus() {
        return status;
    }

    public void setStatus(AppointmentStatus status) {
        this.status = status;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public LocalDateTime getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(LocalDateTime updatedAt) {
        this.updatedAt = updatedAt;
    }

    public PaymentStatus getPaymentStatus() {
        return paymentStatus;
    }

    public void setPaymentStatus(PaymentStatus paymentStatus) {
        this.paymentStatus = paymentStatus;
    }

    @Override
    public String toString() {
        return "Appointment{" + "id=" + id + ", patient=" + patient + ", doctor=" + doctor + ", service=" + service + ", appointmentDateTime=" + appointmentDateTime + ", status=" + status + ", note=" + note + '}';
    }
} 