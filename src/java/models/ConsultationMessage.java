package models;

import java.sql.Timestamp;

public class ConsultationMessage {
    private int message_id;
    private int session_id;
    private String message_content;
    private String message_type; // text, image, file
    private String sender_type; // patient, doctor
    private int sender_id;
    private boolean is_read;
    private Timestamp created_at;
    private Timestamp updated_at;

    public ConsultationMessage() {}

    public ConsultationMessage(int session_id, String message_content, String message_type, 
                              String sender_type, int sender_id) {
        this.session_id = session_id;
        this.message_content = message_content;
        this.message_type = message_type;
        this.sender_type = sender_type;
        this.sender_id = sender_id;
        this.is_read = false;
    }

    // Getters and Setters
    public int getMessage_id() { return message_id; }
    public void setMessage_id(int message_id) { this.message_id = message_id; }

    public int getSession_id() { return session_id; }
    public void setSession_id(int session_id) { this.session_id = session_id; }

    public String getMessage_content() { return message_content; }
    public void setMessage_content(String message_content) { this.message_content = message_content; }

    public String getMessage_type() { return message_type; }
    public void setMessage_type(String message_type) { this.message_type = message_type; }

    public String getSender_type() { return sender_type; }
    public void setSender_type(String sender_type) { this.sender_type = sender_type; }

    public int getSender_id() { return sender_id; }
    public void setSender_id(int sender_id) { this.sender_id = sender_id; }

    public boolean isIs_read() { return is_read; }
    public void setIs_read(boolean is_read) { this.is_read = is_read; }

    public Timestamp getCreated_at() { return created_at; }
    public void setCreated_at(Timestamp created_at) { this.created_at = created_at; }

    public Timestamp getUpdated_at() { return updated_at; }
    public void setUpdated_at(Timestamp updated_at) { this.updated_at = updated_at; }

    // Helper methods
    public boolean isFromPatient() { return "patient".equals(sender_type); }
    public boolean isFromDoctor() { return "doctor".equals(sender_type); }
    public boolean isTextMessage() { return "text".equals(message_type); }

    @Override
    public String toString() {
        return "ConsultationMessage{" +
                "message_id=" + message_id +
                ", session_id=" + session_id +
                ", message_content='" + (message_content != null ? message_content : "") + '\'' +
                ", message_type='" + (message_type != null ? message_type : "") + '\'' +
                ", sender_type='" + (sender_type != null ? sender_type : "") + '\'' +
                ", sender_id=" + sender_id +
                ", is_read=" + is_read +
                ", created_at=" + created_at +
                '}';
    }
} 