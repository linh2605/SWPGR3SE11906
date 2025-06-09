/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller.auth;



import jakarta.servlet.http.HttpServletRequest;
import java.security.SecureRandom;
import java.util.Properties;
import javax.mail.Message;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import models.User;


/**
 *
 * @author auiri
 */
public class EmailServices {

    public static boolean send(String emailTo, String emailSubject, String emailContent) {
        final String email = "G3Hospitalgroup6@gmail.com";
        final String pass = "zwlv ppud mzeo pwuy";
        Properties prop = new Properties();
        prop.put("mail.smtp.host", "smtp.gmail.com");
        prop.put("mail.smtp.port", "587");
        prop.put("mail.smtp.auth", "true");
        prop.put("mail.smtp.starttls.enable", "true");

        Session session = Session.getInstance(prop, new javax.mail.Authenticator() {
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(email, pass);
            }
        });
        try {
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(email));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(emailTo));
            message.setSubject(emailSubject);
            message.setText(emailContent);
            Transport.send(message);
            System.out.println("Email sent sucessfully to [" + emailTo + "]");
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public static String getOTP() {
        SecureRandom random = new SecureRandom();
        StringBuilder otp = new StringBuilder(6);
        for (int i = 0; i < 6; i++) {
            otp.append(random.nextInt(10));
        }
        return otp.toString();
    }

    public static String sendOTPResetPassword(User user) {
        String OTP = EmailServices.getOTP();
        String subject = "Password Reset Request for " + user.getFullname() + "\n";
        String message = "Dear " + user.getFullname() + ",\n"
                + "\n"
                + "We received a request to reset your password for G3 Hospital.\n"
                + "\n"
                + "Your OTP: " + OTP + "\n"
                + "\n"
                + "Please use this OTP to continue with your password reset process. If you did not request a password reset, please ignore this email or contact our support team immediately.\n"
                + "\n"
                + "For security reasons, this OTP will expire in 10 minutes.\n"
                + "\n"
                + "Thank you .\n"
                + "\n"
                + "Best regards,\n"
                + "G3 Hospital";
        if (send(user.getEmail(), subject, message)) {
            return OTP;
        }
        return null;
    }

    public static int verifyOTP(String action, String otp, String providedOTP, HttpServletRequest request) {
        if (!otp.equals(providedOTP)) {
            return -1;
        }
        if (System.currentTimeMillis() >= ((long) request.getSession().getAttribute("expireTime"))) {
            return -2;
        }
        if (action.equals("forgot-password")) {
            return 1;
        } else if (action.equals("email-verification")) {
            return 2;
        }
        return 0;
    }

    public static boolean sendRefundUpdate(User user, int refundStatus, String reason) {
        String subject = "";
        String message = "";
        switch (refundStatus) {
            case 1:
                subject = "Refund Approved";
                message = "Refund was approved";
                break;
            case -1:
                subject = "Refund Declined";
                message = "Refund was declined\n"
                        + "Reason: " + reason;
                break;
            default:
                return false;
        }
        return send(user.getEmail(), subject, message);
    }

    public static String SendOTPConfirmEmail(User user) {
        String OTP = EmailServices.getOTP();
        String subject = "Your verify code is " + OTP + "\n";
        String message = "Dear " + user.getFullname() + ",\n"
                + "\n"
                + "Use this OTP to verify your account in G3 Hospital.\n"
                + "\n"
                + "Your OTP: " + OTP + "\n"
                + "\n"
                + "Please use this OTP to continue with your registation.\n"
                + "\n"
                + "For security reasons, this OTP will expire in 10 minutes.\n"
                + "\n"
                + "Thank you .\n"
                + "\n"
                + "Best regards,\n"
                + "G3 Hospital";
        if (send(user.getEmail(), subject, message)) {
            return OTP;
        }
        return null;
    }

}