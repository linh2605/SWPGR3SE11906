package models;

import java.util.List;
import lombok.*;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@ToString
public class Service {
    private int service_id;
    private String name;
    private String detail;
    private Long price;
    private ServiceType type;
    private List<Doctor> doctors;
}
