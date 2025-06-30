package models;

import lombok.*;

import java.sql.Timestamp;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@ToString
public class HealthConsultation {
    private int consultation_id;
    private Doctor doctor;
    private Patient patient;
    private String detail;
    private Timestamp created_at;
}
