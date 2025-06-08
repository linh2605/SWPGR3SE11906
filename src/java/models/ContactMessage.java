package models;

import lombok.*;
import java.sql.Timestamp;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@ToString
public class ContactMessage {
    private int message_id;
    private String name;
    private String email;
    private String phone;
    private String subject;
    private String message;
    private String status;
    private String priority;
    private Integer assigned_to;
    private Timestamp created_at;
    private Timestamp updated_at;
} 