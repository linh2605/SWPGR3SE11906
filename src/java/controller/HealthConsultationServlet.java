package controller;

import dal.DoctorDao;
import dal.HealthConsultationDAO;
import dal.PatientDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import models.Doctor;
import models.HealthConsultation;
import models.Patient;

import java.io.IOException;
import java.sql.Timestamp;
import java.time.Instant;
import java.util.List;

@WebServlet("/admin/health-consultation")
public class HealthConsultationServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Use AuthHelper for unified authentication
        if (!utils.AuthHelper.hasRole(req, 4)) { // 4 = admin
            resp.sendRedirect(req.getContextPath() + "/views/error/access-denied.jsp");
            return;
        }
        
        try {
            List<HealthConsultation> consultations = HealthConsultationDAO.getAll();
            List<Doctor> doctors = DoctorDao.getAllDoctors();
            List<Patient> patients = PatientDao.getAllPatients();

            req.setAttribute("consultations", consultations);
            req.setAttribute("doctors", doctors);
            req.setAttribute("patients", patients);
            req.getRequestDispatcher("/views/admin/health-consultation.jsp").forward(req, resp);
        } catch (Exception e) {
            throw new ServletException("Lỗi khi tải dữ liệu tư vấn", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Use AuthHelper for unified authentication
        if (!utils.AuthHelper.hasRole(req, 4)) { // 4 = admin
            resp.sendRedirect(req.getContextPath() + "/views/error/access-denied.jsp");
            return;
        }
        
        String action = req.getParameter("action");

        try {
            switch (action) {
                case "create" -> {
                    int doctorId = Integer.parseInt(req.getParameter("doctor_id"));
                    int patientId = Integer.parseInt(req.getParameter("patient_id"));
                    String detail = req.getParameter("detail");

                    Doctor doctor = new Doctor();
                    doctor.setDoctor_id(doctorId);
                    Patient patient = new Patient();
                    patient.setPatient_id(patientId);

                    HealthConsultation hc = new HealthConsultation();
                    hc.setDoctor(doctor);
                    hc.setPatient(patient);
                    hc.setDetail(detail);
                    hc.setCreated_at(Timestamp.from(Instant.now()));

                    HealthConsultationDAO.create(hc);
                }

                case "delete" -> {
                    int id = Integer.parseInt(req.getParameter("id"));
                    HealthConsultationDAO.delete(id);
                }

                case "update" -> {
                    int id = Integer.parseInt(req.getParameter("id"));
                    String detail = req.getParameter("detail");

                    HealthConsultation hc = new HealthConsultation();
                    hc.setConsultation_id(id);
                    hc.setDetail(detail);
                    HealthConsultationDAO.update(hc);
                }
            }
        } catch (Exception e) {
            throw new ServletException("Lỗi khi xử lý " + action, e);
        }

        resp.sendRedirect(req.getContextPath() + "/admin/health-consultation");
    }
}
