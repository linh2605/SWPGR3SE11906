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
import java.util.List;

@WebServlet("/patient/feedback")
public class FeedbackServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        if (req.getSession().getAttribute("user") != null){
            User user = (User) req.getSession().getAttribute("user");
            if (!"patient".equals(user.getRole().getName())){
                resp.sendRedirect(req.getContextPath() + "/login?error=must be patient");
                return;
            }

            String action = req.getParameter("action");
            if ("add".equals(action)) {
                req.getRequestDispatcher("/views/patient/add-feedback.jsp").forward(req, resp);
            } else {
                // Lấy danh sách feedback của bệnh nhân hiện tại
                Patient patient = PatientDao.getPatientByUserId(user.getUserId());
                List<Feedback> feedbacks = FeedbackDAO.getByPatientId(patient.getPatient_id());
                req.setAttribute("feedbacks", feedbacks);
                req.getRequestDispatcher("/views/patient/list-feedback.jsp").forward(req, resp);
            }

        } else {
            resp.sendRedirect(req.getContextPath() + "/login?error=must login");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        User user = (User) req.getSession().getAttribute("user");

        if (user == null || !"patient".equals(user.getRole().getName())) {
            resp.sendRedirect(req.getContextPath() + "/login?error=must login as patient");
            return;
        }

        Patient patient = PatientDao.getPatientByUserId(user.getUserId());

        switch (action) {
            case "add":
                handleAdd(req, patient);
                req.getSession().setAttribute("flash_success", "Gửi feedback thành công.");
                break;

            case "update":
                handleUpdate(req, patient);
                req.getSession().setAttribute("flash_success", "Cập nhật feedback thành công.");
                break;

            case "delete":
                handleDelete(req);
                req.getSession().setAttribute("flash_success", "Xóa feedback thành công.");
                break;

            default:
                req.getSession().setAttribute("flash_error", "Hành động không hợp lệ.");
                break;
        }

        resp.sendRedirect(req.getContextPath() + "/patient/feedback");
    }
    private void handleAdd(HttpServletRequest req, Patient patient) {
        int rate = Integer.parseInt(req.getParameter("rate"));
        String doctorFeedback = req.getParameter("doctorFeedback");
        String serviceFeedback = req.getParameter("serviceFeedback");
        String priceFeedback = req.getParameter("priceFeedback");
        String offerFeedback = req.getParameter("offerFeedback");

        Feedback feedback = new Feedback(rate, doctorFeedback, serviceFeedback, priceFeedback, offerFeedback, patient);
        FeedbackDAO.create(feedback);
    }

    private void handleUpdate(HttpServletRequest req, Patient patient) {
        int id = Integer.parseInt(req.getParameter("id"));
        int rate = Integer.parseInt(req.getParameter("rate"));
        String doctorFeedback = req.getParameter("doctorFeedback");
        String serviceFeedback = req.getParameter("serviceFeedback");
        String priceFeedback = req.getParameter("priceFeedback");
        String offerFeedback = req.getParameter("offerFeedback");

        Feedback updated = new Feedback(id, rate, doctorFeedback, serviceFeedback, priceFeedback, offerFeedback, patient);
        FeedbackDAO.update(updated);
    }

    private void handleDelete(HttpServletRequest req) {
        int id = Integer.parseInt(req.getParameter("id"));
        FeedbackDAO.delete(id);
    }
}
