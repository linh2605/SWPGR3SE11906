package models;

import lombok.*;

import java.util.List;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@ToString
public class ExaminationPackage {
    private int packageId;
    private String name;
    private String description;
    private List<Specialty> specialties;
    private double price;
    private int duration; // minutes
}
