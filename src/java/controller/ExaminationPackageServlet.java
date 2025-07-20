package controller;

import dal.ExaminationPackageDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import models.ExaminationPackage;

@WebServlet(name = "ExaminationPackageServlet", urlPatterns = {"/examination-packages"})
public class ExaminationPackageServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        ExaminationPackageDAO packageDAO = new ExaminationPackageDAO();
        List<ExaminationPackage> packages = packageDAO.getAll();
        request.setAttribute("packages", packages);
        request.getRequestDispatcher("/views/home/examination-packages.jsp").forward(request, response);
    }
} 