package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(name = "TechnicianDashboardServlet", urlPatterns = {"/technician/dashboard"})
public class TechnicianDashboardServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("roleId") == null || (int) session.getAttribute("roleId") != 5) {
            response.sendRedirect(request.getContextPath() + "/views/home/login.jsp");
            return;
        }
        request.getRequestDispatcher("/views/technican/technician-dashboard.jsp").forward(request, response);
    }
}