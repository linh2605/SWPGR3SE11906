package controller;

import dal.FeedbackDAO;
import dal.PatientDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import models.Feedback;
import models.Patient;
import models.User;

import java.io.IOException;

@WebServlet("/patient/feedback")
public class FeedbackServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        if (req.getSession().getAttribute("user") != null){
            User user = (User) req.getSession().getAttribute("user");
            if (!(user.getRole().getName().equals("patient"))){
                resp.sendRedirect(req.getContextPath() + "/login?error=must be patient");
            } else {
                req.getRequestDispatcher("/views/patient/feedback.jsp").forward(req, resp);
            }
        } else {
            resp.sendRedirect(req.getContextPath() + "/login?error=must login");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        if (req.getSession().getAttribute("user") != null){
            User user = (User) req.getSession().getAttribute("user");
            if (!(user.getRole().getName().equals("patient"))){
                resp.sendRedirect(req.getContextPath() + "/login?error=must be patient");
            } else {
                Patient patient = PatientDao.getPatientByUserId(user.getUserId());
                int rate = Integer.parseInt(req.getParameter("rate"));
                String doctorFeedback = req.getParameter("doctorFeedback");
                String serviceFeedback = req.getParameter("serviceFeedback");
                String priceFeedback = req.getParameter("priceFeedback");
                String offerFeedback = req.getParameter("offerFeedback");
                Feedback feedback = new Feedback(rate, doctorFeedback, serviceFeedback, priceFeedback, offerFeedback, patient);
                FeedbackDAO.create(feedback);
                req.getSession().setAttribute("flash_success", "Feedback thành công.");
                resp.sendRedirect(req.getContextPath() + "/patient/feedback");
            }
        } else {
            resp.sendRedirect(req.getContextPath() + "/login?error=must login");
        }
    }
}
