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
import models.User;

import java.io.IOException;
import java.sql.Date;

@WebServlet("/admin/patient/update")
@MultipartConfig
public class AdminUpdatePatientServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        int patient_id = Integer.parseInt(req.getParameter("patient_id"));
        Patient patient = PatientDao.getPatientById(patient_id);
        assert patient != null;
        User user = patient.getUser();
        int user_id = user.getUserId();

        String username = req.getParameter("username");
        String email = req.getParameter("email");

        if (UserDAO.doesUsernameExistExcept(user_id, username)) {
            req.getSession().setAttribute("flash_error", "Username đã tồn tại.");
            resp.sendRedirect(req.getContextPath() + "/admin/patient");
            return;
        }

        if (UserDAO.doesEmailExistExcept(user_id, email)) {
            req.getSession().setAttribute("flash_error", "Email đã tồn tại.");
            resp.sendRedirect(req.getContextPath() + "/admin/patient");
            return;
        }

        String password = req.getParameter("password");
        String fullname = req.getParameter("fullname");
        String phone = req.getParameter("phone");

        user.setUsername(username);
        user.setPassword(password);
        user.setFullName(fullname);
        user.setEmail(email);
        user.setPhone(phone);
        user.setRole(RoleDao.getRoleWithName("patient"));

        UserDAO.updateUser(user);

        Gender gender = Gender.valueOf(req.getParameter("gender").toUpperCase());
        Date date_of_birth = Date.valueOf(req.getParameter("date_of_birth"));
        String address = req.getParameter("address");

        patient.setGender(gender);
        patient.setDate_of_birth(date_of_birth);
        patient.setAddress(address);

        if (req.getPart("image") != null && req.getPart("image").getSize() > 0) {
            String image_url = UploadImage.saveImage(req, "image");
            patient.setImage_url(image_url);
        }

        PatientDao.updatePatient(patient);

        req.getSession().setAttribute("flash_success", "Cập nhật bệnh nhân thành công.");
        resp.sendRedirect(req.getContextPath() + "/admin/patient");
    }
}

