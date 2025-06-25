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
import javax.mail.internet.MimeUtility; // ✅ Thêm dòng này để mã hóa tiêu đề

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

            // ✅ Sửa chỗ này: mã hóa subject để hỗ trợ tiếng Việt
            msg.setSubject(MimeUtility.encodeText(subject, "UTF-8", "B"));

            // ✅ Gửi nội dung với charset UTF-8
            msg.setContent(content, "text/plain; charset=UTF-8");

            Transport.send(msg);
        } catch (MessagingException e) {
            e.printStackTrace();
        } catch (Exception e) {  // Bắt thêm Exception cho MimeUtility.encodeText
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