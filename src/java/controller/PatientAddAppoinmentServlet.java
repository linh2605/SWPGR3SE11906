/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dal.AppointmentDao;
import dal.DoctorDao;
import dal.PatientDao;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.time.LocalDateTime;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;
import models.Appointment;
import models.Doctor;
import models.Patient;
import models.User;

/**
 *
 * @author New_user
 */
@WebServlet(name = "PatientAddAppoinmentServlet", urlPatterns = {"/appointment"})
public class PatientAddAppoinmentServlet extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet PatientAddAppoinmentServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet PatientAddAppoinmentServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        if (session.getAttribute("roleId") != null || session.getAttribute("userId") != null) {
            int roleId = (int) session.getAttribute("roleId");
            if (roleId == 1) { // 1: patient
                int userId = (int) session.getAttribute("userId");
                Patient patient = PatientDao.getPatientByUserId(userId);
                List<Doctor> doctors = DoctorDao.getAllDoctors();
                // sort theo chuyên khoa cho dễ nhìn
                Collections.sort(doctors, new Comparator<Doctor>() {
                    @Override
                    public int compare(Doctor d1, Doctor d2) {
                        int specialty_id1 = d1.getSpecialty().getSpecialty_id();
                        int specialty_id2 = d2.getSpecialty().getSpecialty_id();
                        if (specialty_id1 == specialty_id2) {
                            return d1.getDoctor_id() - d2.getDoctor_id();
                        } else {
                            return specialty_id1 - specialty_id2;
                        }
                    }
                });
                request.setAttribute("patient", patient);
                request.setAttribute("doctors", doctors);
            }
        } else {
            request.setAttribute("errorMsg", "Vui lòng đăng nhập để thực hiện thao tác này");
            request.getRequestDispatcher("/views/home/login.jsp").forward(request, response);
            return;
        }
        request.getRequestDispatcher("/views/appointment/make-appointment.jsp").forward(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String fullName = request.getParameter("fullName");
        String phone = request.getParameter("phone");
        String email = request.getParameter("email");

        int patientId = Integer.parseInt(request.getParameter("patientId"));
        int doctorId = Integer.parseInt(request.getParameter("doctor"));
        LocalDateTime appointmentDate = LocalDateTime.parse(request.getParameter("appointmentDate"));
        String note = request.getParameter("note").trim();
        Appointment appointment = new Appointment();
        Patient p = new Patient();
        p.setPatient_id(patientId);
        Doctor d = new Doctor();
        d.setDoctor_id(doctorId);
        appointment.setPatient(p);
        appointment.setDoctor(d);
        appointment.setAppointmentDate(appointmentDate.toString());
        appointment.setNotes(note);
        boolean isSuccess = AppointmentDao.createAppointment(appointment);
        if (isSuccess) {
            request.setAttribute("successMsg", "Đặt lịch khám thành công!");
            request.getRequestDispatcher("/views/layouts/notification-page.jsp").forward(request, response);
        } else {
            request.setAttribute("errorMsg", "Đặt lịch khám thất bại, vui lòng thử lại.");
            Patient patient = new Patient();
            patient.setPatient_id(patientId);
            patient.setFullName(fullName);
            User u = new User();
            u.setFullName(fullName);
            u.setPhone(phone);
            u.setEmail(email);
            patient.setUser(u);
            request.setAttribute("patient", patient);
            request.setAttribute("doctorId", doctorId);
            request.setAttribute("appointmentDate", appointmentDate);
            request.setAttribute("note", note);
            request.getRequestDispatcher("/views/appointment/make-appointment.jsp").forward(request, response);
        }
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
