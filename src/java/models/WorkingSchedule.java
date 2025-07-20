package models;

import java.sql.Timestamp;

public class WorkingSchedule {
    private int scheduleId;
    private int doctorId;
    private String weekDay;
    private int shiftId;
    private int maxPatients;
    private boolean isActive;
    private Timestamp createdAt;
    private Timestamp updatedAt;
    
    // Thêm đối tượng Shift để chứa thông tin chi tiết về ca làm
    private Shift shift;
    
    // Thêm tên bác sĩ để hiển thị
    private String doctorName;

    // Constructor
    public WorkingSchedule() {
    }
    
    public WorkingSchedule(int scheduleId, int doctorId, String weekDay, int shiftId, int maxPatients, boolean isActive, Timestamp createdAt, Timestamp updatedAt) {
        this.scheduleId = scheduleId;
        this.doctorId = doctorId;
        this.weekDay = weekDay;
        this.shiftId = shiftId;
        this.maxPatients = maxPatients;
        this.isActive = isActive;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
    }
    
    // Getters and Setters
    public int getScheduleId() {
        return scheduleId;
    }
    
    public void setScheduleId(int scheduleId) {
        this.scheduleId = scheduleId;
    }
    
    public int getDoctorId() {
        return doctorId;
    }
    
    public void setDoctorId(int doctorId) {
        this.doctorId = doctorId;
    }
    
    public String getWeekDay() {
        return weekDay;
    }
    
    public void setWeekDay(String weekDay) {
        this.weekDay = weekDay;
    }
    
    public int getShiftId() {
        return shiftId;
    }
    
    public void setShiftId(int shiftId) {
        this.shiftId = shiftId;
    }
    
    public int getMaxPatients() {
        return maxPatients;
    }
    
    public void setMaxPatients(int maxPatients) {
        this.maxPatients = maxPatients;
    }
    
    public boolean isActive() {
        return isActive;
    }
    
    public void setActive(boolean active) {
        isActive = active;
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

    public Shift getShift() {
        return shift;
    }

    public void setShift(Shift shift) {
        this.shift = shift;
    }
    
    public String getDoctorName() {
        return doctorName;
    }
    
    public void setDoctorName(String doctorName) {
        this.doctorName = doctorName;
    }
} 