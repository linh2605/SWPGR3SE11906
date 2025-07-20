package controller;

import dal.ServiceDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import models.Service;

import java.io.IOException;

@WebServlet("/service-detail")
public class ServiceDetailServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        int package_id = Integer.parseInt(req.getParameter("id"));
        Service service = ServiceDAO.getServiceById(package_id); // ServiceDAO đã map package_id thành service_id
        req.setAttribute("service", service);
        req.getRequestDispatcher("/views/home/service-detail.jsp").forward(req, resp);
    }
} 