/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller.auth.util;

import java.util.Properties;
import javax.mail.Authenticator;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

/**
 *
 * @author auiri
 */
public class EmailServices {

    private static final String FROM = "G3Hospitalgroup6@gmail.com";
    private static final String PASSWORD = "zwlv ppud mzeo pwuy";

    private static Session getSession() {
        Properties props = new Properties();
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");

        return Session.getInstance(props, new Authenticator() {
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(FROM, PASSWORD);
            }
        });
    }

    public static void sendEmail(String to, String subject, String content) {
        try {
            Message msg = new MimeMessage(getSession());
            msg.setFrom(new InternetAddress(FROM));
            msg.setRecipients(Message.RecipientType.TO, InternetAddress.parse(to));
            msg.setSubject(subject);
            msg.setText(content);
            Transport.send(msg);
        } catch (MessagingException e) {
            e.printStackTrace();
        }
    }

    public static void sendOtpEmail(String to, String otp) {
        sendEmail(to, "Xác nhận đăng ký tài khoản", "Mã OTP của bạn là: " + otp + ". Mã sẽ hết hạn sau 5 phút.");
    }

    public static void sendResetPasswordLink(String to, String link) {
        sendEmail(to, "Đặt lại mật khẩu", "Click vào liên kết sau để đặt lại mật khẩu: " + link);
    }
}
