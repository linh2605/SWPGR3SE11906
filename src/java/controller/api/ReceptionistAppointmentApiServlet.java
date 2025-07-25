package controller.api;

import dal.AppointmentDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import models.Appointment;
import com.google.gson.Gson;
import java.io.IOException;
import java.util.List;
import java.util.ArrayList;

@WebServlet({"/api/receptionist/appointments", "/api/receptionist/appointments/status"})
public class ReceptionistAppointmentApiServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json;charset=UTF-8");
        // Use AuthHelper for unified authentication
        if (!utils.AuthHelper.isAuthenticated(request)) {
            response.setStatus(401);
            response.getWriter().write("[]");
            return;
        }
        
        Integer roleId = utils.AuthHelper.getCurrentUserRoleId(request);
        if (roleId == null || roleId != 3) {
            response.setStatus(403);
            response.getWriter().write("[]");
            return;
        }
        List<Appointment> appointments = AppointmentDao.getAllAppointments(1, 1000);
        List<Object> events = new ArrayList<>();
        for (Appointment appt : appointments) {
            String patientName = (appt.getPatient() != null && appt.getPatient().getUser() != null) ? appt.getPatient().getUser().getFullName() : "";
            String serviceName = (appt.getService() != null) ? appt.getService().getName() : "";
            String status = (appt.getStatus() != null) ? appt.getStatus().getDisplayName() : "";
            String statusCode = (appt.getStatus() != null) ? appt.getStatus().getCode() : "";
            String paymentStatus = (appt.getPaymentStatus() != null) ? appt.getPaymentStatus().name() : "";
            String start = appt.getAppointmentDateTime() != null ? appt.getAppointmentDateTime().toString() : "";
            String date = appt.getAppointmentDateTime() != null ? appt.getAppointmentDateTime().toLocalDate().toString() : "";
            events.add(new java.util.HashMap<String, Object>() {{
                put("id", appt.getId());
                put("queueNumber", appt.getQueueNumber());
                put("date", date);
                put("shiftId", appt.getShiftId());
                put("patientName", patientName);
                put("serviceName", serviceName);
                put("status", status);
                put("statusCode", statusCode);
                put("paymentStatus", paymentStatus);
                put("note", appt.getNote());
                put("start", start); // cho FullCalendar
                put("title", serviceName + (patientName.isEmpty() ? "" : (" - " + patientName)));
                put("allDay", false);
            }});
        }
        response.getWriter().write(new Gson().toJson(events));
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String path = request.getServletPath();
        if ("/api/receptionist/appointments/status".equals(path)) {
            response.setContentType("application/json;charset=UTF-8");
            // Use AuthHelper for unified authentication
            if (!utils.AuthHelper.isAuthenticated(request)) {
                response.setStatus(401);
                response.getWriter().write("{\"success\":false,\"message\":\"Unauthorized\"}");
                return;
            }
            
            Integer roleId = utils.AuthHelper.getCurrentUserRoleId(request);
            if (roleId == null || roleId != 3) {
                response.setStatus(403);
                response.getWriter().write("{\"success\":false,\"message\":\"Forbidden\"}");
                return;
            }
            try {
                StringBuilder sb = new StringBuilder();
                String line;
                while ((line = request.getReader().readLine()) != null) {
                    sb.append(line);
                }
                String body = sb.toString();
                Gson gson = new Gson();
                java.util.Map<String, Object> map = gson.fromJson(body, java.util.Map.class);
                int id = ((Number) map.get("id")).intValue();
                String status = (String) map.get("status");
                
                System.out.println("DEBUG: Received request to update appointment " + id + " to status: " + status);
                
                // Kiểm tra trạng thái cọc trước khi xác nhận
                Appointment appt = dal.AppointmentDao.getAppointmentById(id);
                if (appt == null) {
                    System.out.println("DEBUG: Appointment not found with ID: " + id);
                    response.getWriter().write("{\"success\":false,\"message\":\"Không tìm thấy lịch hẹn!\"}");
                    return;
                }
                
                System.out.println("DEBUG: Found appointment with payment status: " + appt.getPaymentStatus());
                
                // Debug: Kiểm tra trạng thái bệnh nhân trước khi cập nhật
                dal.PatientStatusDao.debugPatientStatus(appt.getPatient().getPatient_id());
                
                if (status.equals("confirmed")) {
                    // Chỉ cho phép xác nhận nếu đã cọc
                    if (appt.getPaymentStatus() != models.PaymentStatus.RESERVED && appt.getPaymentStatus() != models.PaymentStatus.PAID) {
                        System.out.println("DEBUG: Payment not completed, cannot confirm");
                        response.getWriter().write("{\"success\":false,\"message\":\"Bệnh nhân chưa cọc, không thể xác nhận!\"}");
                        return;
                    }
                    // Sử dụng hàm mới với status code 3 (Đang đợi khám)
                    System.out.println("DEBUG: Calling updateAppointmentStatusByCode with status code 3");
                    boolean ok = dal.AppointmentDao.updateAppointmentStatusByCode(id, 3);
                    System.out.println("DEBUG: Update result: " + ok);
                    
                    // Cập nhật trạng thái bệnh nhân thành "Đang đợi khám" (status_code = 3)
                    if (ok) {
                        Integer currentUserId = utils.AuthHelper.getCurrentUserId(request);
                        System.out.println("DEBUG: About to update patient status - Patient ID: " + appt.getPatient().getPatient_id() + ", Status Code: 3, Changed By: " + currentUserId);
                        dal.PatientStatusDao.updateStatus(appt.getPatient().getPatient_id(), 3, currentUserId);
                        System.out.println("DEBUG: Updated patient status to 'Đang đợi khám'");
                        
                        // Debug: Kiểm tra trạng thái bệnh nhân sau khi cập nhật
                        dal.PatientStatusDao.debugPatientStatus(appt.getPatient().getPatient_id());
                    } else {
                        System.out.println("DEBUG: Appointment status update failed, skipping patient status update");
                    }
                    
                    response.getWriter().write("{\"success\":" + ok + "}");
                } else if (status.equals("new")) {
                    // Xử lý trường hợp status "new" - chuyển sang "pending"
                    System.out.println("DEBUG: Converting 'new' to 'pending'");
                    boolean ok = dal.AppointmentDao.updateAppointmentStatus(id, "pending");
                    System.out.println("DEBUG: Update result: " + ok);
                    response.getWriter().write("{\"success\":" + ok + "}");
                } else {
                    // Cho các trạng thái khác, vẫn dùng hàm cũ
                    System.out.println("DEBUG: Using old updateAppointmentStatus for status: " + status);
                    boolean ok = dal.AppointmentDao.updateAppointmentStatus(id, status);
                    response.getWriter().write("{\"success\":" + ok + "}");
                }
            } catch (Exception e) {
                response.getWriter().write("{\"success\":false,\"message\":\"Error: " + e.getMessage() + "\"}");
            }
            return;
        }
        // fallback: do nothing for other POSTs
        response.setStatus(404);
        response.getWriter().write("{\"success\":false,\"message\":\"Not found\"}");
    }
} 