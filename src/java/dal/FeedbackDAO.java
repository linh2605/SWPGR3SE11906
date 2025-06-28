package dal;

import models.Feedback;
import models.Patient;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
public class FeedbackDAO {
    public static List<Feedback> getAll() {
        List<Feedback> list = new ArrayList<>();
        String sql = "SELECT * FROM feedback";
        try (Connection con = DBContext.makeConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Feedback fb = extractFeedback(rs);
                list.add(fb);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public static Feedback getById(int id) {
        String sql = "SELECT * FROM feedback WHERE feedback_id = ?";
        try (Connection con = DBContext.makeConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return extractFeedback(rs);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
    private static Feedback extractFeedback(ResultSet rs) throws SQLException {
        Feedback fb = new Feedback();
        fb.setId(rs.getInt("feedback_id"));
        fb.setRate(rs.getInt("rate"));
        fb.setDoctorFeedback(rs.getString("doctor_feedback"));
        fb.setServiceFeedback(rs.getString("service_feedback"));
        fb.setPriceFeedback(rs.getString("price_feedback"));
        fb.setOfferFeedback(rs.getString("offer_feedback"));

        Patient p = new Patient();
        p.setPatient_id(rs.getInt("patient_id"));
        fb.setPatient(p);

        return fb;
    }
}
