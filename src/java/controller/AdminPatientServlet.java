package controller;

import Util.UploadImage;
import dal.PatientDao;
import dal.RoleDao;
import dal.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import models.Gender;
import models.Patient;
import models.Role;
import models.User;

import java.io.IOException;
import java.sql.Date;
import java.util.List;


@WebServlet("/admin/patient")
@MultipartConfig
public class AdminPatientServlet extends HttpServlet{
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        List<Patient> patients = PatientDao.getAllPatients();
        req.setAttribute("patients", patients);
        req.getRequestDispatcher("/views/admin/patient_manager.jsp").forward(req, resp);
    }
}
