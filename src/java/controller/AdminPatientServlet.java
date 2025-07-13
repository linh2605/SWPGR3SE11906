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
import jakarta.servlet.http.HttpSession;
import models.Gender;
import models.Patient;
import models.Role;
import models.User;

import java.io.IOException;
import java.sql.Date;
import java.util.List;

@WebServlet("/admin/patient")
@MultipartConfig
public class AdminPatientServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        List<Patient> patients = PatientDao.getAllPatients();
        req.setAttribute("patients", patients);
        req.getRequestDispatcher("/views/admin/patient_manager.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        String username = req.getParameter("username");
        if (UserDAO.doesUsernameExist(username)) {
            session.setAttribute("flash_error", "Username đã tồn tại.");
            resp.sendRedirect(req.getContextPath() + "/admin/patient");
        } else {
            String email = req.getParameter("email");
            if (UserDAO.doesEmailExist(email)) {
                session.setAttribute("flash_error", "Email đã tồn tại.");
                resp.sendRedirect(req.getContextPath() + "/admin/patient");
            } else {
                String password = req.getParameter("password");
                String fullname = req.getParameter("fullname");
                String phone = req.getParameter("phone");
                Role role = RoleDao.getRoleWithName("patient");
                User user = new User(username, password, fullname, email, phone, role);
                UserDAO.insertUser(user);
                Gender gender = Gender.valueOf(req.getParameter("gender").toUpperCase());
                Date date_of_birth = Date.valueOf(req.getParameter("date_of_birth"));
                String address = req.getParameter("address");
                String image_url = UploadImage.saveImage(req, "image");
                Patient patient = new Patient(user, gender, date_of_birth, address, image_url);
                PatientDao.createPatient(patient);
                session.setAttribute("flash_success", "Thêm bác sĩ thành công.");
                resp.sendRedirect(req.getContextPath() + "/admin/patient");
            }
        }
    }
}
