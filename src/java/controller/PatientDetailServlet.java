package controller;

import dal.PatientDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import models.Patient;

import java.io.IOException;

@WebServlet("/patient")
public class PatientDetailServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        int patient_id = Integer.parseInt(req.getParameter("patient_id"));
        Patient patient = PatientDao.getPatientById(patient_id);
        req.setAttribute("patient", patient);
        req.getRequestDispatcher("/views/admin/patient-detail.jsp").forward(req, resp);
    }
}
