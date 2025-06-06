package models;

import lombok.*;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@ToString
public class Appointment {
    private int id;
    private String doctor;
    private String patient;
    private String status;
    private String dateTime;

    public void setDateTime(java.time.LocalDateTime dateTime) {
        this.dateTime = dateTime.format(java.time.format.DateTimeFormatter.ISO_LOCAL_DATE_TIME);
    }
} 