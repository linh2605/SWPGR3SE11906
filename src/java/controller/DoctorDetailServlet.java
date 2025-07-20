package controller;

import dal.DoctorDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import models.Doctor;

import java.io.IOException;

@WebServlet("/doctors/view")
public class DoctorDetailServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        if (req.getParameter("id") != null
                && req.getParameter("id").length() > 0) {
            int doctor_id = Integer.parseInt(req.getParameter("id"));
            Doctor doctor = DoctorDao.getDoctorById(doctor_id);
            if (doctor.getDoctor_id() != 0) {
//                System.out.println("Doctor ID: " + doctor.getDoctor_id());
                req.setAttribute("d", doctor);
                req.getRequestDispatcher("/views/home/doctor-detail.jsp").forward(req, resp);
            } else {
                req.setAttribute("errorMsg", "Không tìm thấy bác sĩ");
                req.getRequestDispatcher("/views/layouts/notification-page.jsp").forward(req, resp);
            }
        } else {
            req.setAttribute("errorMsg", "Không tìm thấy bác sĩ");
            req.getRequestDispatcher("/views/layouts/notification-page.jsp").forward(req, resp);
        }
    }
}
