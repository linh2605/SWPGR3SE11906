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

@WebServlet("/admin/doctor/update")
@MultipartConfig
public class AdminUpdateDoctorServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        int doctor_id = Integer.parseInt(req.getParameter("doctor_id"));
        Doctor doctor = DoctorDao.getDoctorById(doctor_id);
        User user = doctor.getUser();
        String username = req.getParameter("username");
        String password = req.getParameter("password");
        String fullname = req.getParameter("fullname");
        String email = req.getParameter("email");
        String phone = req.getParameter("phone");
        user.setUsername(username);
        user.setPassword(password);
        user.setFullname(fullname);
        user.setEmail(email);
        user.setPhone(phone);
        UserDAO.updateUser(doctor.getUser());
        Gender gender = Gender.valueOf(req.getParameter("gender"));
        Date dob = Date.valueOf(req.getParameter("dob"));
        Specialty specialty = SpecialtyDao.getSpecialtyById(Integer.parseInt(req.getParameter("specialty_id")));
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