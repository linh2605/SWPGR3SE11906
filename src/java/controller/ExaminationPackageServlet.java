package controller;

import dal.ExaminationPackageDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import models.ExaminationPackage;

import java.io.IOException;

@WebServlet("/package")
public class ExaminationPackageServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        int id = Integer.parseInt(req.getParameter("id"));
        ExaminationPackage examinationPackage = ExaminationPackageDao.getById(id);
        req.setAttribute("examinationPackage", examinationPackage);
        req.getRequestDispatcher("/views/admin/examination-package-detail.jsp").forward(req, resp);
    }
}
