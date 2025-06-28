package controller;

import dal.DoctorDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import models.Doctor;

import java.io.IOException;

@WebServlet("/doctor-detail")
public class DoctorDetailServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        int doctor_id = Integer.parseInt(req.getParameter("id"));
        Doctor doctor = DoctorDao.getDoctorById(doctor_id);
        req.setAttribute("doctor", doctor);
        req.getRequestDispatcher("/views/home/doctor-detail.jsp").forward(req, resp);
    }
}
