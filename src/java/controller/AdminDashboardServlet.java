package controller;

import dal.WorkingScheduleDAO;
import dal.ScheduleExceptionDAO;
import dal.DoctorDao;
import dal.AppointmentDao;
import dal.PatientDao;
import dal.ContactMessageDAO;
import models.WorkingSchedule;
import models.ScheduleException;
import models.Appointment;
import models.ContactMessage;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.sql.Date;
import java.time.LocalDate;
import java.time.LocalDateTime;
import com.google.gson.Gson;
import com.google.gson.JsonObject;

@WebServlet(name = "AdminDashboardServlet", urlPatterns = {"/admin/dashboard"})
public class AdminDashboardServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Use AuthHelper for unified authentication
        if (!utils.AuthHelper.hasRole(request, 4)) { // 4 = admin
            response.sendRedirect(request.getContextPath() + "/views/error/access-denied.jsp");
            return;
        }
        
        String action = request.getParameter("action");
        WorkingScheduleDAO wsDao = new WorkingScheduleDAO();
        ScheduleExceptionDAO exDao = new ScheduleExceptionDAO();
        DoctorDao doctorDao = new DoctorDao();
        AppointmentDao appointmentDao = new AppointmentDao();
        PatientDao patientDao = new PatientDao();
        ContactMessageDAO contactDao = new ContactMessageDAO();
        
        // Lấy dữ liệu thống kê chính từ database
        int totalSchedules = wsDao.countAllSchedules();
        int activeSchedules = wsDao.countActiveSchedules();
        int pendingExceptions = exDao.countPendingExceptions();
        int totalDoctors = doctorDao.countAllDoctors();
        int availableDoctors = doctorDao.countAvailableDoctors();
        int urgentExceptions = exDao.countUrgentExceptions();
        
        // Lấy dữ liệu thống kê mới từ database
        int totalPatients = patientDao.countAllPatients();
        int totalAppointments = appointmentDao.countAllAppointments();
        int pendingAppointments = appointmentDao.countPendingAppointments();
        int totalContacts = contactDao.countAllMessages();
        int unreadContacts = contactDao.countUnreadMessages();
        double avgResponseTime = contactDao.getAverageResponseTime();

        if ("activities".equals(action)) {
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            
            // Lấy hoạt động gần đây thực tế từ database
            List<JsonObject> activities = getRecentActivities();
            
            JsonObject result = new JsonObject();
            result.add("activities", new Gson().toJsonTree(activities));
            response.getWriter().write(result.toString());
            return;
            
        } else if ("data".equals(action)) {
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            
            // Lấy hoạt động gần đây thực tế
            List<JsonObject> activities = getRecentActivities();
            
            JsonObject result = new JsonObject();
            
            // Thống kê chính
            JsonObject statistics = new JsonObject();
            statistics.addProperty("totalSchedules", totalSchedules);
            statistics.addProperty("activeSchedules", activeSchedules);
            statistics.addProperty("pendingExceptions", pendingExceptions);
            statistics.addProperty("totalDoctors", totalDoctors);
            statistics.addProperty("totalPatients", totalPatients);
            statistics.addProperty("totalAppointments", totalAppointments);
            statistics.addProperty("pendingAppointments", pendingAppointments);
            statistics.addProperty("totalContacts", totalContacts);
            statistics.addProperty("unreadContacts", unreadContacts);
            
            // Thống kê nhanh
            JsonObject quickStats = new JsonObject();
            quickStats.addProperty("availableDoctors", availableDoctors);
            quickStats.addProperty("urgentExceptions", urgentExceptions);
            quickStats.addProperty("avgResponseTime", Math.round(avgResponseTime * 100.0) / 100.0);
            
            result.add("statistics", statistics);
            result.add("quickStats", quickStats);
            result.add("recentActivities", new Gson().toJsonTree(activities));
            
            response.getWriter().write(result.toString());
            return;
        }
        
        // Render dashboard JSP với dữ liệu động
        request.setAttribute("totalSchedules", totalSchedules);
        request.setAttribute("activeSchedules", activeSchedules);
        request.setAttribute("pendingExceptions", pendingExceptions);
        request.setAttribute("totalDoctors", totalDoctors);
        request.setAttribute("totalPatients", totalPatients);
        request.setAttribute("totalAppointments", totalAppointments);
        request.setAttribute("pendingAppointments", pendingAppointments);
        request.setAttribute("totalContacts", totalContacts);
        request.setAttribute("unreadContacts", unreadContacts);
        request.setAttribute("availableDoctors", availableDoctors);
        request.setAttribute("urgentExceptions", urgentExceptions);
        request.setAttribute("avgResponseTime", Math.round(avgResponseTime * 100.0) / 100.0);
        
        request.getRequestDispatcher("/views/admin/admin-dashboard.jsp").forward(request, response);
    }
    
    private List<JsonObject> getRecentActivities() {
        List<JsonObject> activities = new ArrayList<>();
        
        try {
            // Lấy các hoạt động gần đây từ database
            // 1. Lịch làm việc mới được tạo
            WorkingScheduleDAO wsDao = new WorkingScheduleDAO();
            List<WorkingSchedule> recentSchedules = wsDao.getRecentSchedules(3);
            for (WorkingSchedule schedule : recentSchedules) {
                JsonObject activity = new JsonObject();
                activity.addProperty("type", "schedule");
                activity.addProperty("title", "Thêm lịch làm việc cho " + schedule.getDoctorName());
                activity.addProperty("time", formatTimeAgo(schedule.getCreatedAt()));
                activities.add(activity);
            }
            
            // 2. Yêu cầu ngoại lệ mới
            ScheduleExceptionDAO exDao = new ScheduleExceptionDAO();
            List<ScheduleException> recentExceptions = exDao.getRecentExceptions(3);
            for (ScheduleException exception : recentExceptions) {
                JsonObject activity = new JsonObject();
                activity.addProperty("type", "exception");
                activity.addProperty("title", "Yêu cầu ngoại lệ từ " + exception.getDoctorName());
                activity.addProperty("time", formatTimeAgo(exception.getCreatedAt()));
                activities.add(activity);
            }
            
            // 3. Lịch hẹn mới
            List<Appointment> recentAppointments = AppointmentDao.getRecentAppointments(3);
            for (Appointment appointment : recentAppointments) {
                JsonObject activity = new JsonObject();
                activity.addProperty("type", "appointment");
                String patientName = appointment.getPatient() != null ? appointment.getPatient().getUser().getFullName() : "Không xác định";
                activity.addProperty("title", "Lịch hẹn mới cho " + patientName);
                activity.addProperty("time", formatTimeAgo(appointment.getCreatedAt()));
                activities.add(activity);
            }
            
            // 4. Tin nhắn liên hệ mới
            ContactMessageDAO contactDao = new ContactMessageDAO();
            List<ContactMessage> recentContacts = contactDao.getRecentMessages(3);
            for (ContactMessage contact : recentContacts) {
                JsonObject activity = new JsonObject();
                activity.addProperty("type", "contact");
                activity.addProperty("title", "Tin nhắn mới từ " + contact.getName());
                activity.addProperty("time", formatTimeAgo(contact.getCreated_at()));
                activities.add(activity);
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            // Fallback: trả về dữ liệu mẫu nếu có lỗi
            JsonObject activity = new JsonObject();
            activity.addProperty("type", "system");
            activity.addProperty("title", "Hệ thống đang hoạt động bình thường");
            activity.addProperty("time", "Vừa xong");
            activities.add(activity);
        }
        
        return activities;
    }
    
    private String formatTimeAgo(java.sql.Timestamp timestamp) {
        if (timestamp == null) return "Không xác định";
        
        LocalDateTime now = LocalDateTime.now();
        LocalDateTime time = timestamp.toLocalDateTime();
        long diffInMinutes = java.time.Duration.between(time, now).toMinutes();
        
        if (diffInMinutes < 1) return "Vừa xong";
        if (diffInMinutes < 60) return diffInMinutes + " phút trước";
        if (diffInMinutes < 1440) return (diffInMinutes / 60) + " giờ trước";
        return (diffInMinutes / 1440) + " ngày trước";
    }
    
    private String formatTimeAgo(LocalDateTime dateTime) {
        if (dateTime == null) return "Không xác định";
        
        LocalDateTime now = LocalDateTime.now();
        long diffInMinutes = java.time.Duration.between(dateTime, now).toMinutes();
        
        if (diffInMinutes < 1) return "Vừa xong";
        if (diffInMinutes < 60) return diffInMinutes + " phút trước";
        if (diffInMinutes < 1440) return (diffInMinutes / 60) + " giờ trước";
        return (diffInMinutes / 1440) + " ngày trước";
    }
} 