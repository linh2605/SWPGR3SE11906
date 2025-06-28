package controller;

import dal.DoctorDao;
import dal.ServiceDAO;
import models.Doctor;
import models.Service;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "HomeServlet", urlPatterns = {"/home", "/index.jsp", "/"})
public class HomeServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<Doctor> doctors = DoctorDao.getAllDoctors();
        if (doctors.size() > 6) doctors = doctors.subList(0, 6);
        List<Service> services = ServiceDAO.getTopServices(6);
        List<Service> popularServices = ServiceDAO.getTopPopularServices(3);
        request.setAttribute("doctors", doctors);
        request.setAttribute("services", services);
        request.setAttribute("popularServices", popularServices);
        request.getRequestDispatcher("/views/home/index.jsp").forward(request, response);
    }
} 