package controller;

import Util.UploadImage;
import dal.DoctorDao;
import dal.RoleDao;
import dal.UserDAO;
import dal.SpecialtyDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import models.*;

import java.io.IOException;
import java.sql.Date;

@WebServlet("/admin/doctor/update")
@MultipartConfig
public class AdminUpdateDoctorServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        int doctor_id = Integer.parseInt(req.getParameter("doctor_id"));
        Doctor doctor = DoctorDao.getDoctorById(doctor_id);
        assert doctor != null;
        User user = doctor.getUser();
        String username = req.getParameter("username");
        String password = req.getParameter("password");
        String fullName = req.getParameter("fullname");
        String email = req.getParameter("email");
        String phone = req.getParameter("phone");
        user.setUsername(username);
        user.setPassword(password);
        user.setFullName(fullName);
        user.setEmail(email);
        user.setPhone(phone);
        user.setRole(RoleDao.getRoleWithName("doctor"));
        UserDAO.updateUser(doctor.getUser());
        Gender gender = Gender.valueOf(req.getParameter("gender"));
        Date dob = Date.valueOf(req.getParameter("dob"));
        int specialtyId = Integer.parseInt(req.getParameter("specialty_id"));
        Specialty specialty = SpecialtyDao.getSpecialtyById(specialtyId);
        String degree = req.getParameter("degree");
        String experience = req.getParameter("experience");
        Status status = Status.valueOf(req.getParameter("status"));
        doctor.setGender(gender);
        doctor.setDob(dob);
        doctor.setSpecialty(specialty);
        doctor.setDegree(degree);
        doctor.setExperience(experience);
        doctor.setStatus(status);
        if (req.getPart("image") != null && req.getPart("image").getSize() > 0) {
            String image_url = UploadImage.saveImage(req, "image");
            doctor.setImage_url(image_url);
        }
        DoctorDao.updateDoctor(doctor);
        resp.sendRedirect(req.getContextPath() + "/admin/doctor");
    }
}