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
        // Use AuthHelper for unified authentication
        if (!utils.AuthHelper.hasRole(req, 4)) { // 4 = admin
            resp.sendRedirect(req.getContextPath() + "/views/error/access-denied.jsp");
            return;
        }
        
        int doctor_id = Integer.parseInt(req.getParameter("doctor_id"));
        Doctor doctor = DoctorDao.getDoctorById(doctor_id);
        User user = doctor.getUser();
        int user_id = user.getUserId();

        String email = req.getParameter("email");

        if (UserDAO.doesEmailExistExcept(user_id, email)) {
            req.getSession().setAttribute("flash_error", "Email đang được sử dụng bởi user khác.");
            resp.sendRedirect(req.getContextPath() + "/admin/doctor");
            return;
        }

        String password = req.getParameter("password");
        String fullname = req.getParameter("fullname");
        String phone = req.getParameter("phone");

        user.setPassword(password);
        user.setFullName(fullname);
        user.setEmail(email);
        user.setPhone(phone);
        UserDAO.updateUser(user);

        Gender gender = Gender.valueOf(req.getParameter("gender").toUpperCase());
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

        String contractStartDate = req.getParameter("update_contract_start_date");
        String contractEndDate = req.getParameter("update_contract_end_date");
        doctor.setContract_start_date(contractStartDate != null && !contractStartDate.isEmpty() ? java.time.LocalDate.parse(contractStartDate) : null);
        doctor.setContract_end_date(contractEndDate != null && !contractEndDate.isEmpty() ? java.time.LocalDate.parse(contractEndDate) : null);

        if (req.getPart("image") != null && req.getPart("image").getSize() > 0) {
            String image_url = UploadImage.saveImage(req, "image");
            doctor.setImage_url(image_url);
        }

        DoctorDao.updateDoctor(doctor);

        req.getSession().setAttribute("flash_success", "Cập nhật bác sĩ thành công.");
        resp.sendRedirect(req.getContextPath() + "/admin/doctor");
    }

}