package models;

import lombok.*;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@ToString
public class Feedback {
    private int id;
    private int rate;
    private String doctorFeedback;
    private String serviceFeedback;
    private String priceFeedback;
    private String offerFeedback;
    private Patient patient;

    public Feedback(int rate, String doctorFeedback, String serviceFeedback, String priceFeedback, String offerFeedback, Patient patient) {
        this.rate = rate;
        this.doctorFeedback = doctorFeedback;
        this.serviceFeedback = serviceFeedback;
        this.priceFeedback = priceFeedback;
        this.offerFeedback = offerFeedback;
        this.patient = patient;
    }
}
