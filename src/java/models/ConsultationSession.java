package models;

import java.sql.Timestamp;

public class ConsultationSession {
    private int session_id;
    private Patient patient;
    private Doctor doctor;
    private String status; // pending, active, completed, cancelled
    private Timestamp created_at;
    private Timestamp updated_at;
    private String patient_message;
    private String patient_symptoms;

    public ConsultationSession() {}

    public ConsultationSession(int session_id, Patient patient, Doctor doctor, String status, 
                              Timestamp created_at, Timestamp updated_at, String patient_message, String patient_symptoms) {
        this.session_id = session_id;
        this.patient = patient;
        this.doctor = doctor;
        this.status = status;
        this.created_at = created_at;
        this.updated_at = updated_at;
        this.patient_message = patient_message;
        this.patient_symptoms = patient_symptoms;
    }

    // Getters and Setters
    public int getSession_id() { return session_id; }
    public void setSession_id(int session_id) { this.session_id = session_id; }

    public Patient getPatient() { return patient; }
    public void setPatient(Patient patient) { this.patient = patient; }

    public Doctor getDoctor() { return doctor; }
    public void setDoctor(Doctor doctor) { this.doctor = doctor; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public Timestamp getCreated_at() { return created_at; }
    public void setCreated_at(Timestamp created_at) { this.created_at = created_at; }

    public Timestamp getUpdated_at() { return updated_at; }
    public void setUpdated_at(Timestamp updated_at) { this.updated_at = updated_at; }

    public String getPatient_message() { return patient_message; }
    public void setPatient_message(String patient_message) { this.patient_message = patient_message; }

    public String getPatient_symptoms() { return patient_symptoms; }
    public void setPatient_symptoms(String patient_symptoms) { this.patient_symptoms = patient_symptoms; }

    // Helper methods
    public boolean isPending() { return "pending".equals(status); }
    public boolean isActive() { return "active".equals(status); }
    public boolean isCompleted() { return "completed".equals(status); }
    public boolean isCancelled() { return "cancelled".equals(status); }

    public String getStatusDisplay() {
        if (status == null) return "Không xác định";
        switch (status) {
            case "pending": return "Chờ phản hồi";
            case "active": return "Đang tư vấn";
            case "completed": return "Đã hoàn thành";
            case "cancelled": return "Đã hủy";
            default: return status;
        }
    }
    
    @Override
    public String toString() {
        return "ConsultationSession{" +
                "session_id=" + session_id +
                ", patient=" + (patient != null ? patient.getPatient_id() : "null") +
                ", doctor=" + (doctor != null ? doctor.getDoctor_id() : "null") +
                ", status='" + (status != null ? status : "") + '\'' +
                ", created_at=" + created_at +
                ", updated_at=" + updated_at +
                ", patient_message='" + (patient_message != null ? patient_message : "") + '\'' +
                ", patient_symptoms='" + (patient_symptoms != null ? patient_symptoms : "") + '\'' +
                '}';
    }
} 