package controller;

import dal.DoctorDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import models.Status;

import java.io.IOException;
import java.io.PrintWriter;

@WebServlet("/admin/doctor/status")
public class AdminUpdateDoctorStatusServlet extends HttpServlet {
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Use AuthHelper for unified authentication
        if (!utils.AuthHelper.hasRole(request, 4)) { // 4 = admin
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied");
            return;
        }
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        
        try {
            // Lấy parameters
            int doctorId = Integer.parseInt(request.getParameter("doctorId"));
            String statusStr = request.getParameter("status");
            
            // Validate status
            if (!"active".equalsIgnoreCase(statusStr) && !"inactive".equalsIgnoreCase(statusStr)) {
                out.print("{\"success\": false, \"message\": \"Trạng thái không hợp lệ\"}");
                return;
            }
            
            // Convert status string to Status enum
            Status status = "active".equalsIgnoreCase(statusStr) ? Status.active : Status.inactive;
            
            // Lấy doctor hiện tại
            models.Doctor doctor = DoctorDao.getDoctorById(doctorId);
            if (doctor == null) {
                out.print("{\"success\": false, \"message\": \"Không tìm thấy bác sĩ\"}");
                return;
            }
            
            // Cập nhật status
            doctor.setStatus(status);
            boolean success = DoctorDao.updateDoctor(doctor);
            
            if (success) {
                out.print("{\"success\": true, \"message\": \"Cập nhật trạng thái thành công\"}");
            } else {
                out.print("{\"success\": false, \"message\": \"Cập nhật trạng thái thất bại\"}");
            }
            
        } catch (NumberFormatException e) {
            out.print("{\"success\": false, \"message\": \"ID bác sĩ không hợp lệ\"}");
        } catch (Exception e) {
            e.printStackTrace();
            out.print("{\"success\": false, \"message\": \"Lỗi server: " + e.getMessage() + "\"}");
        }
    }
} 