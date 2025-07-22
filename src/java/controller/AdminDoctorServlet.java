package controller;

import Util.UploadImage;
import dal.*;
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
import java.time.LocalDate;
import java.util.List;

@WebServlet("/admin/doctor")
@MultipartConfig
public class AdminDoctorServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Use AuthHelper for unified authentication
        if (!utils.AuthHelper.hasRole(req, 4)) { // 4 = admin
            resp.sendRedirect(req.getContextPath() + "/views/error/access-denied.jsp");
            return;
        }
    
        List<Doctor> doctors = DoctorDao.getAllNonDeletedDoctors();
        List<Specialty> specialties = SpecialtyDao.getAllSpecialties();
        System.out.println("AdminDoctorServlet - Total doctors retrieved: " + doctors.size());
        
        // Debug: In ra thông tin từng bác sĩ
        for (Doctor doctor : doctors) {
            System.out.println("Doctor ID: " + doctor.getDoctor_id() + 
                             ", Name: " + doctor.getUser().getFullName() + 
                             ", Status: " + doctor.getStatus() + 
                             ", DeletedAt: " + doctor.getDeletedAt());
        }
        req.setAttribute("doctors", doctors);
        req.setAttribute("specialties", specialties);
        req.getRequestDispatcher("/views/admin/doctor-manager.jsp").forward(req, resp);
        
        if (req.getParameter("id") == null) {
            doctors = DoctorDao.getAllDoctors(); // chỉ gán lại, không khai báo lại kiểu
            specialties = SpecialtyDao.getAllSpecialties();
            System.out.println("check doctor size:" + doctors.size());
            req.setAttribute("doctors", doctors);
            req.setAttribute("specialties", specialties);
            req.getRequestDispatcher("/views/admin/doctor-manager.jsp").forward(req, resp);
        } else {
            int id = Integer.parseInt(req.getParameter("id"));
            Doctor doctor = DoctorDao.getDoctorById(id);
            List<Service> services = ServiceDAO.getServicesByDoctorId(doctor.getDoctor_id());
            doctor.setServices(services);
            req.setAttribute("doctor", doctor);
            req.getRequestDispatcher("/views/admin/doctor-detail.jsp").forward(req, resp);
        }

    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Use AuthHelper for unified authentication
        if (!utils.AuthHelper.hasRole(req, 4)) { // 4 = admin
            resp.sendRedirect(req.getContextPath() + "/views/error/access-denied.jsp");
            return;
        }
        
        HttpSession session = req.getSession();
        String username = req.getParameter("username");
        if (UserDAO.doesUsernameExist(username)) {
            session.setAttribute("flash_error", "Username "+username+" đã tồn tại.");
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

                Gender gender = Gender.valueOf(req.getParameter("gender").toUpperCase());
                Date dob = Date.valueOf(req.getParameter("dob"));
                String image_url = UploadImage.saveImage(req, "image");
                Specialty specialty = SpecialtyDao.getSpecialtyById(Integer.parseInt(req.getParameter("specialty_id")));
                String degree = req.getParameter("degree");
                String experience = req.getParameter("experience");
                Status status = Status.active;

                Doctor doctor = new Doctor(user, gender, dob, image_url, specialty, degree, experience, status);
                doctor.setContract_status(ContractStatus.valueOf(req.getParameter("contract_status")));
                doctor.setContract_start_date(LocalDate.parse(req.getParameter("contract_start_date")));
                doctor.setContract_end_date(LocalDate.parse(req.getParameter("contract_end_date")));
                DoctorDao.insertDoctor(doctor);

                session.setAttribute("flash_success", "Thêm bác sĩ thành công.");
                resp.sendRedirect(req.getContextPath() + "/admin/doctor");
            }
        }
    }
}
