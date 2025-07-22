package models;

import java.sql.Timestamp;
import java.text.NumberFormat;
import java.util.Locale;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class ExaminationPackage {
    private int packageId;
    private String name;
    private String description;
    private double price;
    private int duration;
    private String imageUrl;
    private boolean isActive;
    private Timestamp createdAt;
    private Timestamp updatedAt;
    
    public String getFormattedPrice() {
        NumberFormat formatter = NumberFormat.getCurrencyInstance(new Locale("vi", "VN"));
        return formatter.format(price);
    }
    
    public String getFormattedDuration() {
        int hours = duration / 60;
        int minutes = duration % 60;
        if (hours > 0) {
            return String.format("%d giờ %d phút", hours, minutes);
        }
        return String.format("%d phút", minutes);
    }
} 