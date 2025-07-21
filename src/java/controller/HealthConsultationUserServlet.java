package controller;

import dal.HealthConsultationDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import models.HealthConsultation;

import java.io.IOException;
import java.util.List;

@WebServlet("/health-consultation")
public class HealthConsultationUserServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            List<HealthConsultation> consultations = HealthConsultationDAO.getAll();
            req.setAttribute("consultations", consultations);
            req.getRequestDispatcher("/views/home/health-consultation.jsp").forward(req, resp);
        } catch (Exception e) {
            throw new ServletException("Lỗi khi tải dữ liệu tư vấn", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        doGet(req, resp);
    }
} 