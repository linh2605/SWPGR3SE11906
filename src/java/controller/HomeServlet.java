package controller;

import dal.DoctorDao;
import dal.NewsDAO;
import dal.ServiceDAO;
import models.Doctor;
import models.Service;
import utils.AuthHelper;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import models.News;

@WebServlet(name = "HomeServlet", urlPatterns = {"/home", "/index.jsp", "/"})
public class HomeServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Check if user is authenticated and redirect staff to their dashboard
        Integer roleId = utils.AuthHelper.getCurrentUserRoleId(request);
        if (roleId != null) {
            // Redirect staff users to their dashboard (Patient can stay on homepage)
            switch (roleId) {
                case 2: // Doctor
                    response.sendRedirect(request.getContextPath() + "/doctor/dashboard");
                    return;
                case 3: // Receptionist
                    response.sendRedirect(request.getContextPath() + "/receptionist/dashboard");
                    return;
                case 4: // Admin
                    response.sendRedirect(request.getContextPath() + "/admin/dashboard");
                    return;
                case 5: // Technician
                    response.sendRedirect(request.getContextPath() + "/technician/dashboard");
                    return;
                // Case 1 (Patient) - let them stay on homepage
            }
        }
        
        // Show homepage for patients and guests
        List<Doctor> doctors = DoctorDao.getAllDoctors();
        if (doctors.size() > 6) {
            doctors = doctors.subList(0, 6);
        }
        List<Service> services = ServiceDAO.getTopServices(6);
        List<Service> popularServices = ServiceDAO.getTopPopularServices(3);
        List<News> lastestNews = NewsDAO.getLastestNewsLimit(4);
        request.setAttribute("doctors", doctors);
        request.setAttribute("services", services);
        request.setAttribute("popularServices", popularServices);
        request.setAttribute("lastestNews", lastestNews);

        request.getRequestDispatcher("/views/home/index.jsp").forward(request, response);
    }
}
