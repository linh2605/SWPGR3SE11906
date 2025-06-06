
package controller;

import Util.UploadImage;
import dal.DoctorDao;
import dal.SpecialtyDao;
import dal.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import models.*;

import java.io.IOException;
import java.sql.Date;
import java.util.List;

@WebServlet("/admin/doctor")
@MultipartConfig
public class AdminDoctorServlet extends HttpServlet{
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        List<Doctor> doctors = DoctorDao.getAllDoctors();
        List<Specialty> specialties = SpecialtyDao.getAllSpecialties();
        req.setAttribute("doctors", doctors);
        req.setAttribute("specialties", specialties);
        req.getRequestDispatcher("/views/admin/doctor-manager.jsp").forward(req, resp);
    }
}