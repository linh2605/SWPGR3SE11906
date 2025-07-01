package models;

import java.sql.Timestamp;

public class PatientStatusLog {
    private int logId;
    private int patientId;
    private int statusCode;
    private int changedBy;
    private Timestamp changedAt;

    public PatientStatusLog(int logId, int patientId, int statusCode, int changedBy, Timestamp changedAt) {
        this.logId = logId;
        this.patientId = patientId;
        this.statusCode = statusCode;
        this.changedBy = changedBy;
        this.changedAt = changedAt;
    }

    // Getters and Setters
    public int getLogId() {
        return logId;
    }

    public void setLogId(int logId) {
        this.logId = logId;
    }

    public int getPatientId() {
        return patientId;
    }

    public void setPatientId(int patientId) {
        this.patientId = patientId;
    }

    public int getStatusCode() {
        return statusCode;
    }

    public void setStatusCode(int statusCode) {
        this.statusCode = statusCode;
    }

    public int getChangedBy() {
        return changedBy;
    }

    public void setChangedBy(int changedBy) {
        this.changedBy = changedBy;
    }

    public Timestamp getChangedAt() {
        return changedAt;
    }

    public void setChangedAt(Timestamp changedAt) {
        this.changedAt = changedAt;
    }
}
