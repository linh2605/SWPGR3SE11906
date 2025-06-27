package models;

import java.sql.Date;
import java.sql.Timestamp;

public class ScheduleChange {
    private int changeId;
    private int doctorId;
    private int oldShiftId;
    private int newShiftId;
    private String changeReason;
    private Date effectiveDate;
    private Date endDate;
    private String status; // pending, approved, rejected, active, completed
    private Integer approvedBy;
    private Timestamp approvedAt;
    private Timestamp createdAt;
    private Timestamp updatedAt;
    
    // Additional fields for display
    private Doctor doctor;
    private Shift oldShift;
    private Shift newShift;
    private User approvedByUser;
    
    public ScheduleChange() {
    }
    
    public ScheduleChange(int doctorId, int oldShiftId, int newShiftId, String changeReason, Date effectiveDate, Date endDate) {
        this.doctorId = doctorId;
        this.oldShiftId = oldShiftId;
        this.newShiftId = newShiftId;
        this.changeReason = changeReason;
        this.effectiveDate = effectiveDate;
        this.endDate = endDate;
        this.status = "pending";
    }
    
    // Getters and Setters
    public int getChangeId() {
        return changeId;
    }
    
    public void setChangeId(int changeId) {
        this.changeId = changeId;
    }
    
    public int getDoctorId() {
        return doctorId;
    }
    
    public void setDoctorId(int doctorId) {
        this.doctorId = doctorId;
    }
    
    public int getOldShiftId() {
        return oldShiftId;
    }
    
    public void setOldShiftId(int oldShiftId) {
        this.oldShiftId = oldShiftId;
    }
    
    public int getNewShiftId() {
        return newShiftId;
    }
    
    public void setNewShiftId(int newShiftId) {
        this.newShiftId = newShiftId;
    }
    
    public String getChangeReason() {
        return changeReason;
    }
    
    public void setChangeReason(String changeReason) {
        this.changeReason = changeReason;
    }
    
    public Date getEffectiveDate() {
        return effectiveDate;
    }
    
    public void setEffectiveDate(Date effectiveDate) {
        this.effectiveDate = effectiveDate;
    }
    
    public Date getEndDate() {
        return endDate;
    }
    
    public void setEndDate(Date endDate) {
        this.endDate = endDate;
    }
    
    public String getStatus() {
        return status;
    }
    
    public void setStatus(String status) {
        this.status = status;
    }
    
    public Integer getApprovedBy() {
        return approvedBy;
    }
    
    public void setApprovedBy(Integer approvedBy) {
        this.approvedBy = approvedBy;
    }
    
    public Timestamp getApprovedAt() {
        return approvedAt;
    }
    
    public void setApprovedAt(Timestamp approvedAt) {
        this.approvedAt = approvedAt;
    }
    
    public Timestamp getCreatedAt() {
        return createdAt;
    }
    
    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
    
    public Timestamp getUpdatedAt() {
        return updatedAt;
    }
    
    public void setUpdatedAt(Timestamp updatedAt) {
        this.updatedAt = updatedAt;
    }
    
    // Additional getters and setters for display fields
    public Doctor getDoctor() {
        return doctor;
    }
    
    public void setDoctor(Doctor doctor) {
        this.doctor = doctor;
    }
    
    public Shift getOldShift() {
        return oldShift;
    }
    
    public void setOldShift(Shift oldShift) {
        this.oldShift = oldShift;
    }
    
    public Shift getNewShift() {
        return newShift;
    }
    
    public void setNewShift(Shift newShift) {
        this.newShift = newShift;
    }
    
    public User getApprovedByUser() {
        return approvedByUser;
    }
    
    public void setApprovedByUser(User approvedByUser) {
        this.approvedByUser = approvedByUser;
    }
    
    // Helper methods
    public String getStatusDisplay() {
        switch (status) {
            case "pending":
                return "Chờ duyệt";
            case "approved":
                return "Đã duyệt";
            case "rejected":
                return "Từ chối";
            case "active":
                return "Đang áp dụng";
            case "completed":
                return "Hoàn thành";
            default:
                return status;
        }
    }
    
    public String getStatusBadgeClass() {
        switch (status) {
            case "pending":
                return "bg-warning";
            case "approved":
                return "bg-success";
            case "rejected":
                return "bg-danger";
            case "active":
                return "bg-primary";
            case "completed":
                return "bg-secondary";
            default:
                return "bg-secondary";
        }
    }
    
    @Override
    public String toString() {
        return "ScheduleChange{" +
                "changeId=" + changeId +
                ", doctorId=" + doctorId +
                ", oldShiftId=" + oldShiftId +
                ", newShiftId=" + newShiftId +
                ", changeReason='" + changeReason + '\'' +
                ", effectiveDate=" + effectiveDate +
                ", endDate=" + endDate +
                ", status='" + status + '\'' +
                '}';
    }
} 