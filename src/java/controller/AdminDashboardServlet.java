package controller;

import dal.WorkingScheduleDAO;
import dal.ScheduleExceptionDAO;
import dal.DoctorDao;
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
        int totalSchedules = wsDao.countAllSchedules();
        int activeSchedules = wsDao.countActiveSchedules();
        int pendingExceptions = exDao.countPendingExceptions();
        int totalDoctors = doctorDao.countAllDoctors();
        int availableDoctors = doctorDao.countAvailableDoctors();
        int urgentExceptions = exDao.countUrgentExceptions();
        // Thời gian phản hồi TB: chưa có logic, để 0
        int avgResponseTime = 0;

        if ("activities".equals(action)) {
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            // Lấy hoạt động gần đây thực tế (ví dụ: 5 hoạt động mới nhất)
            List<String> activities = new ArrayList<>();
            // TODO: Truy vấn thực tế, tạm thời trả về chuỗi mẫu
            activities.add("{\"type\":\"schedule\",\"title\":\"Thêm lịch làm việc cho Dr. Nguyễn Văn A\",\"time\":\"2 phút trước\"}");
            activities.add("{\"type\":\"exception\",\"title\":\"Duyệt yêu cầu ngoại lệ của Dr. Trần Thị B\",\"time\":\"15 phút trước\"}");
            activities.add("{\"type\":\"doctor\",\"title\":\"Cập nhật thông tin Dr. Lê Văn C\",\"time\":\"1 giờ trước\"}");
            activities.add("{\"type\":\"system\",\"title\":\"Sao lưu dữ liệu hệ thống\",\"time\":\"2 giờ trước\"}");
            StringBuilder json = new StringBuilder();
            json.append("{\"activities\": [");
            for (int i = 0; i < activities.size(); i++) {
                json.append(activities.get(i));
                if (i < activities.size() - 1) json.append(",");
            }
            json.append("]}");
            response.getWriter().write(json.toString());
            return;
        } else if ("data".equals(action)) {
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            // Lấy hoạt động gần đây thực tế (tạm thời trả về mẫu)
            List<String> activities = new ArrayList<>();
            activities.add("{\"type\":\"schedule\",\"title\":\"Thêm lịch làm việc cho Dr. Nguyễn Văn A\",\"time\":\"2 phút trước\"}");
            activities.add("{\"type\":\"exception\",\"title\":\"Duyệt yêu cầu ngoại lệ của Dr. Trần Thị B\",\"time\":\"15 phút trước\"}");
            activities.add("{\"type\":\"doctor\",\"title\":\"Cập nhật thông tin Dr. Lê Văn C\",\"time\":\"1 giờ trước\"}");
            activities.add("{\"type\":\"system\",\"title\":\"Sao lưu dữ liệu hệ thống\",\"time\":\"2 giờ trước\"}");
            StringBuilder json = new StringBuilder();
            json.append("{");
            json.append(String.format("\"statistics\": {\"totalSchedules\": %d, \"activeSchedules\": %d, \"pendingExceptions\": %d, \"totalDoctors\": %d},", totalSchedules, activeSchedules, pendingExceptions, totalDoctors));
            json.append(String.format("\"quickStats\": {\"availableDoctors\": %d, \"urgentExceptions\": %d, \"avgResponseTime\": %d},", availableDoctors, urgentExceptions, avgResponseTime));
            json.append("\"recentActivities\": [");
            for (int i = 0; i < activities.size(); i++) {
                json.append(activities.get(i));
                if (i < activities.size() - 1) json.append(",");
            }
            json.append("]}");
            response.getWriter().write(json.toString());
            return;
        }
        // Render dashboard JSP như cũ
        request.setAttribute("totalSchedules", totalSchedules);
        request.setAttribute("activeSchedules", activeSchedules);
        request.setAttribute("pendingExceptions", pendingExceptions);
        request.setAttribute("totalDoctors", totalDoctors);
        request.getRequestDispatcher("/views/admin/admin-dashboard.jsp").forward(request, response);
    }
} 