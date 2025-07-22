package models;

/**
 * Class để lưu trữ thông tin trạng thái tài khoản
 */
public class AccountStatus {
    private boolean isActive;
    private String message;
    private String statusCode;
    
    public AccountStatus(boolean isActive, String message, String statusCode) {
        this.isActive = isActive;
        this.message = message;
        this.statusCode = statusCode;
    }
    
    // Getters
    public boolean isActive() {
        return isActive;
    }
    
    public String getMessage() {
        return message;
    }
    
    public String getStatusCode() {
        return statusCode;
    }
    
    // Setters
    public void setActive(boolean isActive) {
        this.isActive = isActive;
    }
    
    public void setMessage(String message) {
        this.message = message;
    }
    
    public void setStatusCode(String statusCode) {
        this.statusCode = statusCode;
    }
} 