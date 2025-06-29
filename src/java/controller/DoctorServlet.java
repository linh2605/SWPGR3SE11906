/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller;

import dal.PatientStatusDao;
import dal.StatusDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import com.google.gson.Gson;
import java.util.List;
import models.PatientStatus;

/**
 *
 * @author auiri
 */
@WebServlet(name = "DoctorServlet", urlPatterns = {"/doctorupdate", "/doctor", "/getDoctorsByService", "/getDoctorsByServiceAndTime", "/getDoctorsByServiceAndDate"})
public class DoctorServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
        throws ServletException, IOException {
    String action = req.getServletPath();
    if ("/getDoctorsByService".equals(action)) {
        handleGetDoctorsByService(req, resp);
        return;
    }
    if ("/getDoctorsByServiceAndTime".equals(action)) {
        handleGetDoctorsByServiceAndTime(req, resp);
        return;
    }
    if ("/getDoctorsByServiceAndDate".equals(action)) {
        handleGetDoctorsByServiceAndDate(req, resp);
        return;
    }

    // Danh sách bệnh nhân mà bác sĩ có thể xử lý (role_id = 2)
    List<PatientStatus> patients = PatientStatusDao.getByHandledRole(2);
    req.setAttribute("statuses", StatusDAO.getStatusesByRole(2));

    // Sắp xếp theo trạng thái ưu tiên: Đang khám -> Đang chờ xét nghiệm -> v.v...
    patients.sort((p1, p2) -> {
        if (p1.getStatusCode() == 4 && p2.getStatusCode() != 4) return -1; // Đang khám lên đầu
        if (p1.getStatusCode() == 5 && p2.getStatusCode() != 5) return -1;
        if (p1.getStatusCode() == 6 && p2.getStatusCode() != 6) return -1;
        return Integer.compare(p1.getStatusCode(), p2.getStatusCode());
    });

    req.setAttribute("patients", patients);
    req.getRequestDispatcher("/views/doctor/managestatus.jsp").forward(req, resp);
}


    private void handleGetDoctorsByService(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String serviceIdStr = request.getParameter("serviceId");
        int serviceId = 0;
        try {
            serviceId = Integer.parseInt(serviceIdStr);
        } catch (Exception e) {
            response.setStatus(400);
            response.getWriter().write("[]");
            return;
        }
        List<models.Doctor> doctors = dal.DoctorDao.getDoctorsByServiceId(serviceId);
        response.setContentType("application/json;charset=UTF-8");
        response.getWriter().write(new Gson().toJson(doctors));
    }

    private void handleGetDoctorsByServiceAndTime(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String serviceIdStr = request.getParameter("serviceId");
        String datetimeStr = request.getParameter("datetime");
        int serviceId = 0;
        try {
            serviceId = Integer.parseInt(serviceIdStr);
        } catch (Exception e) {
            response.setStatus(400);
            response.getWriter().write("[]");
            return;
        }
        java.time.LocalDateTime dateTime = null;
        try {
            dateTime = java.time.LocalDateTime.parse(datetimeStr);
        } catch (Exception e) {
            response.setStatus(400);
            response.getWriter().write("[]");
            return;
        }
        List<models.Doctor> doctors = dal.DoctorDao.getDoctorsByServiceId(serviceId);
        // Lọc tiếp theo ca làm việc (nếu cần, có thể bỏ hoặc sửa lại logic cho phù hợp)
        List<models.Doctor> availableDoctors = new java.util.ArrayList<>();
        // TODO: Nếu muốn lọc theo ca làm việc, cần truyền thêm shiftId và week_day, hoặc bỏ đoạn này nếu không dùng endpoint này nữa
        // Hiện tại, chỉ trả về danh sách bác sĩ theo serviceId
        availableDoctors.addAll(doctors);
        response.setContentType("application/json;charset=UTF-8");
        response.getWriter().write(new com.google.gson.Gson().toJson(availableDoctors));
    }

    private void handleGetDoctorsByServiceAndDate(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String serviceIdStr = request.getParameter("serviceId");
        String dateStr = request.getParameter("date");
        String shiftIdStr = request.getParameter("shiftId");
        
        System.out.println("[DEBUG] handleGetDoctorsByServiceAndDate - Parameters:");
        System.out.println("[DEBUG] - serviceId: " + serviceIdStr);
        System.out.println("[DEBUG] - date: " + dateStr);
        System.out.println("[DEBUG] - shiftId: " + shiftIdStr);
        
        int serviceId = 0;
        int shiftId = 0;
        try {
            serviceId = Integer.parseInt(serviceIdStr);
            shiftId = Integer.parseInt(shiftIdStr);
        } catch (Exception e) {
            System.out.println("[DEBUG] Parameter parsing failed: " + e.getMessage());
            response.setStatus(400);
            response.getWriter().write("[]");
            return;
        }
        java.time.LocalDate date = null;
        try {
            date = java.time.LocalDate.parse(dateStr);
        } catch (Exception e) {
            System.out.println("[DEBUG] Date parsing failed: " + e.getMessage());
            response.setStatus(400);
            response.getWriter().write("[]");
            return;
        }
        // Chuyển ngày sang week_day tiếng Việt
        String weekDayVN = getVietnameseWeekDay(date);
        System.out.println("[DEBUG] Week day in Vietnamese: " + weekDayVN);
        
        List<models.Doctor> doctors = dal.DoctorDao.getDoctorsByServiceId(serviceId);
        System.out.println("[DEBUG] Total doctors for service " + serviceId + ": " + doctors.size());
        
        List<models.Doctor> availableDoctors = new java.util.ArrayList<>();
        for (models.Doctor d : doctors) {
            System.out.println("[DEBUG] Checking doctor " + d.getDoctor_id() + " (" + d.getUser().getFullName() + ")");
            boolean isAvailable = dal.AppointmentDao.isDoctorAvailableByWeekDayAndShift(d.getDoctor_id(), weekDayVN, shiftId);
            System.out.println("[DEBUG] - Available: " + isAvailable);
            if (isAvailable) {
                availableDoctors.add(d);
            }
        }
        
        System.out.println("[DEBUG] Available doctors: " + availableDoctors.size());
        response.setContentType("application/json;charset=UTF-8");
        response.getWriter().write(new com.google.gson.Gson().toJson(availableDoctors));
    }

    // Hàm chuyển đổi ngày sang week_day tiếng Việt
    private String getVietnameseWeekDay(java.time.LocalDate date) {
        switch (date.getDayOfWeek()) {
            case MONDAY: return "Thứ 2";
            case TUESDAY: return "Thứ 3";
            case WEDNESDAY: return "Thứ 4";
            case THURSDAY: return "Thứ 5";
            case FRIDAY: return "Thứ 6";
            case SATURDAY: return "Thứ 7";
            case SUNDAY: return "Chủ nhật";
            default: return "";
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            int patientId = Integer.parseInt(req.getParameter("patientId"));
            int statusCode = Integer.parseInt(req.getParameter("statusCode"));
            int changedBy = (int) req.getSession().getAttribute("userId");

            // Cập nhật trạng thái
            PatientStatusDao.updateStatus(patientId, statusCode, changedBy);
            req.setAttribute("message", "Cập nhật trạng thái thành công!");
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Lỗi cập nhật trạng thái!");
        }

        // Sau khi cập nhật, lấy lại danh sách bệnh nhân và sắp xếp lại
        List<PatientStatus> patientStatusList = PatientStatusDao.getByHandledRole(2);  // role_id = 2: bác sĩ

        // Sắp xếp lại theo yêu cầu
        patientStatusList.sort((ps1, ps2) -> {
            int ps1Status = ps1.getStatusCode();
            int ps2Status = ps2.getStatusCode();

            if (ps1Status == 4) return -1;  // Đang khám đứng đầu
            if (ps2Status == 4) return 1;

            if (ps1Status == 8 && ps2Status != 8) return -1;  // Đã lấy kết quả xét nghiệm đứng sau Đang khám
            if (ps2Status == 8 && ps1Status != 8) return 1;

            return 0;  // Các trạng thái còn lại giữ nguyên
        });

        req.setAttribute("patients", patientStatusList);
        req.getRequestDispatcher("/views/doctor/managestatus.jsp").forward(req, resp);
    }
}

