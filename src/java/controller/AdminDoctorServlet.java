package controller;

import Util.UploadImage;
import dal.DoctorDao;
import dal.RoleDao;
import dal.SpecialtyDao;
import dal.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import models.*;

import java.io.IOException;
import java.sql.Date;
import java.util.List;

@WebServlet("/admin/doctor")
@MultipartConfig
public class AdminDoctorServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        List<Doctor> doctors = DoctorDao.getAllDoctors();
        List<Specialty> specialties = SpecialtyDao.getAllSpecialties();
        req.setAttribute("doctors", doctors);
        req.setAttribute("specialties", specialties);
        req.getRequestDispatcher("/views/admin/doctor-manager.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        String username = req.getParameter("username");
        if (UserDAO.doesUsernameExist(username)) {
            session.setAttribute("flash_error", "Username đã tồn tại.");
            resp.sendRedirect(req.getContextPath() + "/admin/doctor");
        } else {
            String email = req.getParameter("email");
            if (UserDAO.doesEmailExist(email)) {
                session.setAttribute("flash_error", "Email đã tồn tại.");
                resp.sendRedirect(req.getContextPath() + "/admin/doctor");
            } else {
                String password = req.getParameter("password");
                String fullname = req.getParameter("fullname");
                String phone = req.getParameter("phone");
                Role role = RoleDao.getRoleWithName("doctor");
                User user = new User(username, password, fullname, email, phone, role);
                UserDAO.insertUser(user);

                Gender gender = Gender.valueOf(req.getParameter("gender"));
                Date dob = Date.valueOf(req.getParameter("dob"));
                String image_url = UploadImage.saveImage(req, "image");
                Specialty specialty = SpecialtyDao.getSpecialtyById(Integer.parseInt(req.getParameter("specialty_id")));
                String degree = req.getParameter("degree");
                String experience = req.getParameter("experience");
                Status status = Status.active;

                Doctor doctor = new Doctor(user, gender, dob, image_url, specialty, degree, experience, status);
                DoctorDao.insertDoctor(doctor);

                session.setAttribute("flash_success", "Thêm bác sĩ thành công.");
                resp.sendRedirect(req.getContextPath() + "/admin/doctor");
            }
        }
    }
}
