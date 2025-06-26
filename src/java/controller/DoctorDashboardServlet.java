package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(name = "DoctorDashboardServlet", urlPatterns = {"/doctor/dashboard"})
public class DoctorDashboardServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("roleId") == null || (int) session.getAttribute("roleId") != 2) {
            response.sendRedirect(request.getContextPath() + "/views/home/login.jsp");
            return;
        }
        request.getRequestDispatcher("/views/doctor/doctor-dashboard.jsp").forward(request, response);
    }
}
