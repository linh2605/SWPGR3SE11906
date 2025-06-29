package models;

public enum AppointmentStatus {
    PENDING("pending", "Chờ xác nhận"),
    CONFIRMED("confirmed", "Đã xác nhận"),
    IN_PROGRESS("in_progress", "Đang khám"),
    COMPLETED("completed", "Hoàn thành"),
    CANCELLED("cancelled", "Đã hủy"),
    NO_SHOW("no_show", "Không đến");

    private final String code;
    private final String displayName;

    AppointmentStatus(String code, String displayName) {
        this.code = code;
        this.displayName = displayName;
    }

    public String getCode() {
        return code;
    }

    public String getDisplayName() {
        return displayName;
    }

    public static AppointmentStatus fromCode(String code) {
        for (AppointmentStatus status : values()) {
            if (status.code.equals(code)) {
                return status;
            }
        }
        return PENDING; // Default
    }
} 