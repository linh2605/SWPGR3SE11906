package models;

import java.sql.Date;
import java.sql.Timestamp;

public class ScheduleException {
    private int exceptionId;
    private int doctorId;
    private Date exceptionDate;
    private String exceptionType;
    private Integer newShiftId; // Có thể null
    private String reason;
    private String status;
    private Timestamp createdAt;

    // Thêm đối tượng Shift để join và hiển thị thông tin
    private Shift newShift;

    // Constructor
    public ScheduleException() {
    }
    
    public ScheduleException(int exceptionId, int doctorId, Date exceptionDate, String exceptionType,
                           Integer newShiftId, String reason, Timestamp createdAt) {
        this.exceptionId = exceptionId;
        this.doctorId = doctorId;
        this.exceptionDate = exceptionDate;
        this.exceptionType = exceptionType;
        this.newShiftId = newShiftId;
        this.reason = reason;
        this.createdAt = createdAt;
    }
    
    // Getters and Setters
    public int getExceptionId() {
        return exceptionId;
    }
    
    public void setExceptionId(int exceptionId) {
        this.exceptionId = exceptionId;
    }
    
    public int getDoctorId() {
        return doctorId;
    }
    
    public void setDoctorId(int doctorId) {
        this.doctorId = doctorId;
    }
    
    public Date getExceptionDate() {
        return exceptionDate;
    }
    
    public void setExceptionDate(Date exceptionDate) {
        this.exceptionDate = exceptionDate;
    }
    
    public String getExceptionType() {
        return exceptionType;
    }
    
    public void setExceptionType(String exceptionType) {
        this.exceptionType = exceptionType;
    }
    
    public Integer getNewShiftId() {
        return newShiftId;
    }
    
    public void setNewShiftId(Integer newShiftId) {
        this.newShiftId = newShiftId;
    }
    
    public String getReason() {
        return reason;
    }
    
    public void setReason(String reason) {
        this.reason = reason;
    }
    
    public String getStatus() {
        return status;
    }
    
    public void setStatus(String status) {
        this.status = status;
    }
    
    public Timestamp getCreatedAt() {
        return createdAt;
    }
    
    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
    
    public Shift getNewShift() {
        return newShift;
    }
    
    public void setNewShift(Shift newShift) {
        this.newShift = newShift;
    }
} 