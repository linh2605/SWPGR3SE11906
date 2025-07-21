package controller;

import dal.ConsultationSessionDAO;
import dal.ConsultationMessageDAO;
import dal.DoctorDao;
import dal.PatientDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import models.*;
import utils.AuthHelper;

import java.io.IOException;
import java.sql.Timestamp;
import java.time.Instant;
import java.util.List;
import java.util.ArrayList;

@WebServlet("/consultation-chat")
public class ConsultationChatServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Kiểm tra đăng nhập
        User currentUser = AuthHelper.getCurrentUser(req);
        if (currentUser == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        try {
            String action = req.getParameter("action");
            
            if ("view-session".equals(action)) {
                // Xem phiên tư vấn cụ thể
                int sessionId = Integer.parseInt(req.getParameter("session_id"));
                viewConsultationSession(req, resp, sessionId, currentUser);
            } else {
                // Hiển thị danh sách phiên tư vấn
                showConsultationList(req, resp, currentUser);
            }
        } catch (Exception e) {
            throw new ServletException("Lỗi khi tải dữ liệu tư vấn", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        System.out.println("=== doPost method called ===");
        
        // Kiểm tra đăng nhập
        User currentUser = AuthHelper.getCurrentUser(req);
        System.out.println("Current user: " + (currentUser != null ? currentUser.getUserId() : "null"));
        
        if (currentUser == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");

        try {
            String action = req.getParameter("action");
            System.out.println("Action parameter: " + action);
            
            if (action == null) {
                System.out.println("Action is null, returning error");
                resp.getWriter().write("{\"success\": false, \"message\": \"Action parameter is required\"}");
                return;
            }
            
            switch (action) {
                case "create-session":
                    System.out.println("Calling createNewSession...");
                    createNewSession(req, resp, currentUser);
                    break;
                case "send-message":
                    sendMessage(req, resp, currentUser);
                    break;
                case "mark-read":
                    markMessagesAsRead(req, resp, currentUser);
                    break;
                case "complete-session":
                    completeSession(req, resp, currentUser);
                    break;
                default:
                    System.out.println("Invalid action: " + action);
                    resp.getWriter().write("{\"success\": false, \"message\": \"Invalid action: " + action + "\"}");
            }
        } catch (Exception e) {
            System.err.println("Exception in doPost: " + e.getMessage());
            System.err.println("Exception type: " + e.getClass().getName());
            e.printStackTrace();
            
            String errorMessage = e.getMessage() != null ? e.getMessage().replace("\"", "\\\"") : "Unknown error";
            resp.getWriter().write("{\"success\": false, \"message\": \"" + errorMessage + "\"}");
        }
    }

    private void showConsultationList(HttpServletRequest req, HttpServletResponse resp, User currentUser) throws Exception {
        List<ConsultationSession> sessions;
        
        if (currentUser.getRole().getRoleId() == 1) { // Patient
            // Lấy phiên tư vấn của bệnh nhân
            Patient patient = PatientDao.getPatientByUserId(currentUser.getUserId());
            if (patient != null) {
                sessions = ConsultationSessionDAO.getSessionsByPatient(patient.getPatient_id());
            } else {
                sessions = new ArrayList<>();
            }
        } else if (currentUser.getRole().getRoleId() == 2) { // Doctor
            // Lấy phiên tư vấn của bác sĩ
            Doctor doctor = DoctorDao.getDoctorByUserId(currentUser.getUserId());
            if (doctor != null) {
                sessions = ConsultationSessionDAO.getSessionsByDoctor(doctor.getDoctor_id());
            } else {
                sessions = new ArrayList<>();
            }
        } else {
            sessions = new ArrayList<>();
        }

        req.setAttribute("sessions", sessions);
        req.setAttribute("currentUser", currentUser);
        req.getRequestDispatcher("/views/consultation/consultation-list.jsp").forward(req, resp);
    }

    private void viewConsultationSession(HttpServletRequest req, HttpServletResponse resp, int sessionId, User currentUser) throws Exception {
        ConsultationSession session = ConsultationSessionDAO.getSessionById(sessionId);
        if (session == null) {
            resp.sendRedirect(req.getContextPath() + "/consultation-chat");
            return;
        }

        // Kiểm tra quyền truy cập
        if (currentUser.getRole().getRoleId() == 1) { // Patient
            Patient patient = PatientDao.getPatientByUserId(currentUser.getUserId());
            if (patient == null || patient.getPatient_id() != session.getPatient().getPatient_id()) {
                resp.sendRedirect(req.getContextPath() + "/consultation-chat");
                return;
            }
        } else if (currentUser.getRole().getRoleId() == 2) { // Doctor
            Doctor doctor = DoctorDao.getDoctorByUserId(currentUser.getUserId());
            if (doctor == null || doctor.getDoctor_id() != session.getDoctor().getDoctor_id()) {
                resp.sendRedirect(req.getContextPath() + "/consultation-chat");
                return;
            }
        }

        // Lấy tin nhắn
        List<ConsultationMessage> messages = ConsultationMessageDAO.getMessagesBySession(sessionId);
        
        // Đánh dấu tin nhắn đã đọc
        if (currentUser.getRole().getRoleId() == 1) {
            Patient patient = PatientDao.getPatientByUserId(currentUser.getUserId());
            ConsultationMessageDAO.markAllAsRead(sessionId, "patient", patient.getPatient_id());
        } else if (currentUser.getRole().getRoleId() == 2) {
            Doctor doctor = DoctorDao.getDoctorByUserId(currentUser.getUserId());
            ConsultationMessageDAO.markAllAsRead(sessionId, "doctor", doctor.getDoctor_id());
        }

        req.setAttribute("session", session);
        req.setAttribute("messages", messages);
        req.setAttribute("currentUser", currentUser);
        req.getRequestDispatcher("/views/consultation/consultation-chat.jsp").forward(req, resp);
    }

    private void createNewSession(HttpServletRequest req, HttpServletResponse resp, User currentUser) throws Exception {
        try {
            System.out.println("=== Starting createNewSession ===");
            
            if (currentUser.getRole().getRoleId() != 1) { // Chỉ bệnh nhân mới tạo phiên tư vấn
                resp.setContentType("application/json");
                resp.setCharacterEncoding("UTF-8");
                resp.getWriter().write("{\"success\":false,\"message\":\"Chỉ bệnh nhân mới có thể tạo phiên tư vấn\"}");
                return;
            }

            int doctorId = Integer.parseInt(req.getParameter("doctor_id"));
            String patientMessage = req.getParameter("patient_message");
            String patientSymptoms = req.getParameter("patient_symptoms");

            System.out.println("Parameters - Doctor ID: " + doctorId + ", User ID: " + currentUser.getUserId());
            System.out.println("Patient message: " + patientMessage);
            System.out.println("Patient symptoms: " + patientSymptoms);

            Patient patient = PatientDao.getPatientByUserId(currentUser.getUserId());
            Doctor doctor = DoctorDao.getDoctorById(doctorId);

            System.out.println("Patient found: " + (patient != null));
            System.out.println("Doctor found: " + (doctor != null));

            if (patient == null || doctor == null) {
                resp.setContentType("application/json");
                resp.setCharacterEncoding("UTF-8");
                resp.getWriter().write("{\"success\":false,\"message\":\"Không tìm thấy thông tin bệnh nhân hoặc bác sĩ\"}");
                return;
            }

            // Tạo phiên tư vấn mới
            ConsultationSession session = new ConsultationSession();
            session.setPatient(patient);
            session.setDoctor(doctor);
            session.setStatus("pending");
            session.setPatient_message(patientMessage != null ? patientMessage : "");
            session.setPatient_symptoms(patientSymptoms != null ? patientSymptoms : "");

            System.out.println("Creating session in database...");
            int sessionId = ConsultationSessionDAO.createSession(session);
            System.out.println("Session created with ID: " + sessionId);
            
            if (sessionId > 0) {
                // Tạo tin nhắn đầu tiên từ bệnh nhân
                ConsultationMessage firstMessage = new ConsultationMessage();
                firstMessage.setSession_id(sessionId);
                firstMessage.setMessage_content(patientMessage != null ? patientMessage : "");
                firstMessage.setMessage_type("text");
                firstMessage.setSender_type("patient");
                firstMessage.setSender_id(patient.getPatient_id());
                
                int messageId = ConsultationMessageDAO.addMessage(firstMessage);
                System.out.println("First message created with ID: " + messageId);
                
                resp.setContentType("application/json");
                resp.setCharacterEncoding("UTF-8");
                resp.getWriter().write("{\"success\":true,\"session_id\":" + sessionId + ",\"message\":\"Tạo phiên tư vấn thành công\"}");
            } else {
                resp.setContentType("application/json");
                resp.setCharacterEncoding("UTF-8");
                resp.getWriter().write("{\"success\":false,\"message\":\"Tạo phiên tư vấn thất bại\"}");
            }
            
        } catch (Exception e) {
            System.err.println("Error in createNewSession: " + e.getMessage());
            System.err.println("Exception type: " + e.getClass().getName());
            e.printStackTrace();
            
            resp.setContentType("application/json");
            resp.setCharacterEncoding("UTF-8");
            resp.getWriter().write("{\"success\":false,\"message\":\"Lỗi hệ thống: " + e.getClass().getSimpleName() + "\"}");
        }
    }

    private void sendMessage(HttpServletRequest req, HttpServletResponse resp, User currentUser) throws Exception {
        int sessionId = Integer.parseInt(req.getParameter("session_id"));
        String messageContent = req.getParameter("message_content");

        ConsultationSession session = ConsultationSessionDAO.getSessionById(sessionId);
        if (session == null) {
            resp.getWriter().write("{\"success\": false, \"message\": \"Không tìm thấy phiên tư vấn\"}");
            return;
        }

        ConsultationMessage message = new ConsultationMessage();
        message.setSession_id(sessionId);
        message.setMessage_content(messageContent);
        message.setMessage_type("text");

        if (currentUser.getRole().getRoleId() == 1) { // Patient
            Patient patient = PatientDao.getPatientByUserId(currentUser.getUserId());
            if (patient == null || patient.getPatient_id() != session.getPatient().getPatient_id()) {
                resp.getWriter().write("{\"success\": false, \"message\": \"Không có quyền gửi tin nhắn\"}");
                return;
            }
            message.setSender_type("patient");
            message.setSender_id(patient.getPatient_id());
        } else if (currentUser.getRole().getRoleId() == 2) { // Doctor
            Doctor doctor = DoctorDao.getDoctorByUserId(currentUser.getUserId());
            if (doctor == null || doctor.getDoctor_id() != session.getDoctor().getDoctor_id()) {
                resp.getWriter().write("{\"success\": false, \"message\": \"Không có quyền gửi tin nhắn\"}");
                return;
            }
            message.setSender_type("doctor");
            message.setSender_id(doctor.getDoctor_id());
        } else {
            resp.getWriter().write("{\"success\": false, \"message\": \"Không có quyền gửi tin nhắn\"}");
            return;
        }

        int messageId = ConsultationMessageDAO.addMessage(message);
        
        if (messageId > 0) {
            // Cập nhật trạng thái phiên tư vấn thành active
            ConsultationSessionDAO.updateSessionStatus(sessionId, "active");
            resp.getWriter().write("{\"success\": true, \"message_id\": " + messageId + ", \"message\": \"Gửi tin nhắn thành công\"}");
        } else {
            resp.getWriter().write("{\"success\": false, \"message\": \"Gửi tin nhắn thất bại\"}");
        }
    }

    private void markMessagesAsRead(HttpServletRequest req, HttpServletResponse resp, User currentUser) throws Exception {
        int sessionId = Integer.parseInt(req.getParameter("session_id"));
        
        if (currentUser.getRole().getRoleId() == 1) { // Patient
            Patient patient = PatientDao.getPatientByUserId(currentUser.getUserId());
            if (patient != null) {
                ConsultationMessageDAO.markAllAsRead(sessionId, "patient", patient.getPatient_id());
            }
        } else if (currentUser.getRole().getRoleId() == 2) { // Doctor
            Doctor doctor = DoctorDao.getDoctorByUserId(currentUser.getUserId());
            if (doctor != null) {
                ConsultationMessageDAO.markAllAsRead(sessionId, "doctor", doctor.getDoctor_id());
            }
        }

        resp.getWriter().write("{\"success\": true, \"message\": \"Đã đánh dấu đã đọc\"}");
    }

    private void completeSession(HttpServletRequest req, HttpServletResponse resp, User currentUser) throws Exception {
        if (currentUser.getRole().getRoleId() != 2) { // Chỉ bác sĩ mới hoàn thành phiên tư vấn
            resp.getWriter().write("{\"success\": false, \"message\": \"Chỉ bác sĩ mới có thể hoàn thành phiên tư vấn\"}");
            return;
        }

        int sessionId = Integer.parseInt(req.getParameter("session_id"));
        
        ConsultationSession session = ConsultationSessionDAO.getSessionById(sessionId);
        if (session == null) {
            resp.getWriter().write("{\"success\": false, \"message\": \"Không tìm thấy phiên tư vấn\"}");
            return;
        }

        // Kiểm tra bác sĩ có quyền hoàn thành phiên tư vấn này không
        Doctor doctor = DoctorDao.getDoctorByUserId(currentUser.getUserId());
        if (doctor == null || doctor.getDoctor_id() != session.getDoctor().getDoctor_id()) {
            resp.getWriter().write("{\"success\": false, \"message\": \"Không có quyền hoàn thành phiên tư vấn này\"}");
            return;
        }

        boolean success = ConsultationSessionDAO.updateSessionStatus(sessionId, "completed");
        
        if (success) {
            resp.getWriter().write("{\"success\": true, \"message\": \"Hoàn thành phiên tư vấn thành công\"}");
        } else {
            resp.getWriter().write("{\"success\": false, \"message\": \"Hoàn thành phiên tư vấn thất bại\"}");
        }
    }
} 