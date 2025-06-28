package models;

public class StatusUplate {
    private int code;
    private String description;
    private int handledBy;
    private int nextHandledBy;  // Thêm trường này để lưu vai trò xử lý tiếp theo

    // Getter and Setter
    public int getCode() { return code; }
    public void setCode(int code) { this.code = code; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public int getHandledBy() { return handledBy; }
    public void setHandledBy(int handledBy) { this.handledBy = handledBy; }

    public int getNextHandledBy() { return nextHandledBy; }
    public void setNextHandledBy(int nextHandledBy) { this.nextHandledBy = nextHandledBy; }
}
