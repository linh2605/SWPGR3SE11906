package controller.api;

import dal.DoctorDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import models.Doctor;
import org.json.JSONArray;
import org.json.JSONObject;

import java.io.IOException;
import java.util.List;

@WebServlet("/api/doctors")
public class GetDoctorApi extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        List<Doctor> doctors = DoctorDao.getAllDoctors();
        JSONArray jsonArray = new JSONArray();
        for (Doctor doctor : doctors) {
            JSONObject obj = new JSONObject();
            obj.put("doctorId", doctor.getDoctor_id());
            obj.put("userId", doctor.getUser().getUserId());
            obj.put("username", doctor.getUser().getUsername());
            obj.put("image_url", doctor.getImage_url());
            obj.put("fullname", doctor.getUser().getFullName());
            obj.put("email", doctor.getUser().getEmail());
            obj.put("phone", doctor.getUser().getPhone());
            obj.put("gender", doctor.getGender());
            obj.put("dob", doctor.getDob());
            obj.put("speciality_id", doctor.getSpecialty().getSpecialtyId());
            obj.put("speciality_name", doctor.getSpecialty().getName());
            obj.put("degree", doctor.getDegree());
            obj.put("experience", doctor.getExperience());
            obj.put("status", doctor.getStatus());
            obj.put("contract_status", doctor.getContract_status());
            obj.put("contract_start_date", doctor.getContract_start_date());
            obj.put("contract_end_date", doctor.getContract_end_date());
            jsonArray.put(obj);
        }
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");
        resp.getWriter().write(jsonArray.toString());
    }
}
