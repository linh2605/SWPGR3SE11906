package Model1;

import java.time.LocalDateTime;
import lombok.*;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@ToString
public class Appointment {
    private int id;
//    private String doctor;
    private Doctor doctor;
//    private String patient;
    private Patient patient;
    private String status;
    private String dateTime; // bỏ
    private LocalDateTime appointmentDate;
    private String note;
    private LocalDateTime createdAt;
    private LocalDateTime updateAt;

    public void setDateTime(java.time.LocalDateTime dateTime) { // không cần
        this.dateTime = dateTime.format(java.time.format.DateTimeFormatter.ISO_LOCAL_DATE_TIME);
    }
} 