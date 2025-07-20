package models;

public enum ContractStatus {
    ACTIVE("Đang hiệu lực"),
    EXPIRED("Hết hạn"),
    SUSPENDED("Tạm nghỉ");

    private final String description;

    ContractStatus(String description) {
        this.description = description;
    }

    public String getDescription() {
        return description;
    }
}
