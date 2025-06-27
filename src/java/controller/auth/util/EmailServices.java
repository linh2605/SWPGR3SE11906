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
import models.Appointment;
import models.Doctor;
import models.ScheduleChange;

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

    // Gửi email khi lịch hẹn được chuyển sang bác sĩ khác
    public static void sendAppointmentReassigned(models.Appointment appt, models.Doctor newDoctor) {
        if (appt == null || appt.getPatient() == null || appt.getPatient().getUser() == null) return;
        String to = appt.getPatient().getUser().getEmail();
        String subject = "Lịch hẹn của bạn đã được chuyển sang bác sĩ khác";
        String content = String.format(
            "Xin chào %s,\n\nLịch hẹn của bạn vào ngày %s đã được chuyển sang bác sĩ %s do bác sĩ cũ đổi ca.\nThông tin bác sĩ mới: %s.\nNếu bạn không đồng ý, vui lòng liên hệ lại bệnh viện.\n\nTrân trọng!",
            appt.getPatient().getUser().getFullName(),
            appt.getAppointmentDate(),
            newDoctor.getUser().getFullName(),
            newDoctor.getUser().getFullName()
        );
        sendEmail(to, subject, content);
    }

    // Gửi email khi lịch hẹn bị huỷ
    public static void sendAppointmentCancelled(models.Appointment appt) {
        if (appt == null || appt.getPatient() == null || appt.getPatient().getUser() == null) return;
        String to = appt.getPatient().getUser().getEmail();
        String subject = "Lịch hẹn của bạn đã bị huỷ";
        String content = String.format(
            "Xin chào %s,\n\nLịch hẹn của bạn vào ngày %s đã bị huỷ do bác sĩ đổi ca.\nVui lòng đặt lại lịch mới hoặc liên hệ bệnh viện để được hỗ trợ.\n\nTrân trọng!",
            appt.getPatient().getUser().getFullName(),
            appt.getAppointmentDate()
        );
        sendEmail(to, subject, content);
    }

    // Gửi email cho bác sĩ khi yêu cầu đổi ca được duyệt
    public static void sendScheduleChangeApproved(models.ScheduleChange change, java.util.List<models.Appointment> reassigned, java.util.List<models.Appointment> cancelled) {
        if (change == null || change.getDoctor() == null || change.getDoctor().getUser() == null) return;
        String to = change.getDoctor().getUser().getEmail();
        String subject = "Yêu cầu đổi ca của bạn đã được duyệt";
        StringBuilder content = new StringBuilder();
        content.append(String.format("Xin chào %s,\n\nYêu cầu đổi ca của bạn đã được duyệt.\nCa mới: %s (%s - %s), từ ngày %s đến %s.\n",
            change.getDoctor().getUser().getFullName(),
            change.getNewShift().getName(),
            change.getNewShift().getStartTime(),
            change.getNewShift().getEndTime(),
            change.getEffectiveDate(),
            change.getEndDate() != null ? change.getEndDate() : "Không xác định"
        ));
        if (reassigned != null && !reassigned.isEmpty()) {
            content.append("\nCác lịch hẹn đã được chuyển sang bác sĩ khác:\n");
            for (models.Appointment appt : reassigned) {
                content.append(String.format("- %s\n", appt.getAppointmentDate()));
            }
        }
        if (cancelled != null && !cancelled.isEmpty()) {
            content.append("\nCác lịch hẹn đã bị huỷ:\n");
            for (models.Appointment appt : cancelled) {
                content.append(String.format("- %s\n", appt.getAppointmentDate()));
            }
        }
        content.append("\nTrân trọng!");
        sendEmail(to, subject, content.toString());
    }

    // Gửi email cho bác sĩ khi yêu cầu đổi ca bị từ chối
    public static void sendScheduleChangeRejected(models.ScheduleChange change) {
        if (change == null || change.getDoctor() == null || change.getDoctor().getUser() == null) return;
        String to = change.getDoctor().getUser().getEmail();
        String subject = "Yêu cầu đổi ca của bạn đã bị từ chối";
        String content = String.format(
            "Xin chào %s,\n\nYêu cầu đổi ca của bạn đã bị từ chối.\nLý do: %s\n\nTrân trọng!",
            change.getDoctor().getUser().getFullName(),
            change.getChangeReason()
        );
        sendEmail(to, subject, content);
    }
}