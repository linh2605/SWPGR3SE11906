package models;

import java.sql.Timestamp;

public class PatientStatus {
    private int patientId;
    private String fullName;
    private int statusCode;
    private String statusDescription;
    private Timestamp changedAt;  // Thêm trường thời gian thay đổi trạng thái

    // Constructor
    public PatientStatus(int patientId, String fullName, int statusCode, String statusDescription, Timestamp changedAt) {
        this.patientId = patientId;
        this.fullName = fullName;
        this.statusCode = statusCode;
        this.statusDescription = statusDescription;
        this.changedAt = changedAt;
    }

    // Getters and Setters
    public int getPatientId() {
        return patientId;
    }

    public void setPatientId(int patientId) {
        this.patientId = patientId;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public int getStatusCode() {
        return statusCode;
    }

    public void setStatusCode(int statusCode) {
        this.statusCode = statusCode;
    }

    public String getStatusDescription() {
        return statusDescription;
    }

    public void setStatusDescription(String statusDescription) {
        this.statusDescription = statusDescription;
    }

    public Timestamp getChangedAt() {
        return changedAt;
    }

    public void setChangedAt(Timestamp changedAt) {
        this.changedAt = changedAt;
    }
}
