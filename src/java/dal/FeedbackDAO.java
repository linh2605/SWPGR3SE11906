package dal;

import models.Feedback;
import models.Gender;
import models.Patient;
import models.User;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;

public class FeedbackDAO {
    public static List<Feedback> getAll() {
        List<Feedback> list = new ArrayList<>();
        String sql = "SELECT f.*, p.*, u.* " +
                "FROM feedback f " +
                "JOIN patients p ON f.patient_id = p.patient_id " +
                "JOIN users u ON p.user_id = u.user_id";
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

    public static boolean create(Feedback fb) {
        String sql = "INSERT INTO feedback(rate, doctor_feedback, service_feedback, price_feedback, offer_feedback, patient_id) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection con = DBContext.makeConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, fb.getRate());
            ps.setString(2, fb.getDoctorFeedback());
            ps.setString(3, fb.getServiceFeedback());
            ps.setString(4, fb.getPriceFeedback());
            ps.setString(5, fb.getOfferFeedback());
            ps.setInt(6, fb.getPatient().getPatient_id());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public static boolean update(Feedback fb) {
        String sql = "UPDATE feedback SET rate = ?, doctor_feedback = ?, service_feedback = ?, price_feedback = ?, offer_feedback = ?, patient_id = ? WHERE feedback_id = ?";
        try (Connection con = DBContext.makeConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, fb.getRate());
            ps.setString(2, fb.getDoctorFeedback());
            ps.setString(3, fb.getServiceFeedback());
            ps.setString(4, fb.getPriceFeedback());
            ps.setString(5, fb.getOfferFeedback());
            ps.setInt(6, fb.getPatient().getPatient_id());
            ps.setInt(7, fb.getId());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public static boolean delete(int id) {
        String sql = "DELETE FROM feedback WHERE feedback_id = ?";
        try (Connection con = DBContext.makeConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    private static Feedback extractFeedback(ResultSet rs) throws SQLException {
        Feedback fb = new Feedback();
        fb.setId(rs.getInt("feedback_id"));
        fb.setRate(rs.getInt("rate"));
        fb.setDoctorFeedback(rs.getString("doctor_feedback"));
        fb.setServiceFeedback(rs.getString("service_feedback"));
        fb.setPriceFeedback(rs.getString("price_feedback"));
        fb.setOfferFeedback(rs.getString("offer_feedback"));

        // Lấy thông tin User
        User u = new User();
        u.setUserId(rs.getInt("user_id")); // từ bảng users
        u.setUsername(rs.getString("username"));
        u.setFullName(rs.getString("full_name"));
        u.setEmail(rs.getString("email"));
        u.setPhone(rs.getString("phone"));
        u.setRoleId(rs.getInt("role_id"));

        // Lấy thông tin Patient
        Patient p = new Patient();
        p.setPatient_id(rs.getInt("patient_id")); // từ bảng patients
        p.setGender(Gender.valueOf(rs.getString("gender").toUpperCase(Locale.ITALY)));
        p.setDate_of_birth(rs.getDate("date_of_birth"));
        p.setAddress(rs.getString("address"));
        p.setImage_url(rs.getString("image_url"));
        p.setUser(u); // gắn User vào Patient

        fb.setPatient(p); // gắn Patient vào Feedback

        return fb;
    }

    public static List<Feedback> getByPatientId(int patientId) {
        List<Feedback> list = new ArrayList<>();
        String sql = "SELECT f.*, p.*, u.* " +
                "FROM feedback f " +
                "JOIN patients p ON f.patient_id = p.patient_id " +
                "JOIN users u ON p.user_id = u.user_id WHERE p.patient_id = ?";
        try (Connection con = DBContext.makeConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, patientId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Feedback fb = extractFeedback(rs);
                    list.add(fb);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}
