package controller;

import java.io.IOException;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import dal.AppointmentDao;
import models.Appointment;

@WebServlet({"/getAllAppointments", "/receptionist/appointments"})
public class ReceptionistAppointmentServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("[DEBUG] ReceptionistAppointmentServlet được gọi!");
        // Use AuthHelper for unified authentication
        if (!utils.AuthHelper.hasRole(request, 3)) { // 3 = receptionist
            response.sendRedirect(request.getContextPath() + "/views/error/access-denied.jsp");
            return;
        }
        // Lễ tân xem toàn bộ lịch hẹn, không cần filter theo user
        List<Appointment> appointments = AppointmentDao.getAllAppointments(1, 1000);
        System.out.println("[DEBUG] Số lịch hẹn lễ tân lấy được: " + appointments.size());
        for (Appointment appt : appointments) {
            System.out.println("[DEBUG] Appointment ID: " + appt.getId()
                + ", BN: " + (appt.getPatient() != null && appt.getPatient().getUser() != null ? appt.getPatient().getUser().getFullName() : "null")
                + ", Doctor: " + (appt.getDoctor() != null && appt.getDoctor().getUser() != null ? appt.getDoctor().getUser().getFullName() : "null")
                + ", Date: " + (appt.getAppointmentDateTime() != null ? appt.getAppointmentDateTime().toString() : "null")
                + ", Status: " + (appt.getStatus() != null ? appt.getStatus().getDisplayName() : "null")
            );
        }
        request.setAttribute("appointments", appointments);
        request.getRequestDispatcher("/views/appointment/receptionistDashboard.jsp").forward(request, response);
    }
}