package controller.api;

import dal.PatientDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import models.Patient;
import org.json.JSONArray;
import org.json.JSONObject;

import java.io.IOException;
import java.util.List;

@WebServlet("/api/patients")
public class GetPatientApi extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        List<Patient> patients = PatientDao.getAllPatients();
        JSONArray jsonArray = new JSONArray();
        for (Patient patient : patients) {
            JSONObject obj = new JSONObject();
            obj.put("userId", patient.getUser().getUserId());
            obj.put("fullname", patient.getUser().getFullName());
            obj.put("email", patient.getUser().getEmail());
            obj.put("phone", patient.getUser().getPhone());
            obj.put("username", patient.getUser().getUsername());
            obj.put("patientId", patient.getPatient_id());
            obj.put("gender", patient.getGender());
            obj.put("date_of_birth",patient.getDate_of_birth());
            obj.put("image_url", patient.getImage_url());
            obj.put("address", patient.getAddress());
            obj.put("status_code", patient.getStatus_code());
            jsonArray.put(obj);
        }
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");
        resp.getWriter().write(jsonArray.toString());
    }
}
