/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller;

import dal.PatientStatusDao;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 *
 * @author auiri
 */
@WebServlet("/update-status")
public class UpdateStatusServlet extends HttpServlet {
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        int patientId = Integer.parseInt(req.getParameter("patientId"));
        int statusCode = Integer.parseInt(req.getParameter("statusCode"));
        int userId = (int) req.getSession().getAttribute("userId");

        PatientStatusDao.updateStatus(patientId, statusCode, userId);
        resp.sendRedirect(req.getHeader("referer"));
    }
}
