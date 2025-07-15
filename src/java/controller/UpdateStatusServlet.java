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
        // Use AuthHelper for unified authentication (for medical staff only)
        if (!utils.AuthHelper.isAuthenticated(req)) {
            resp.sendRedirect(req.getContextPath() + "/views/error/access-denied.jsp");
            return;
        }
        
        Integer roleId = utils.AuthHelper.getCurrentUserRoleId(req);
        if (roleId == null || (roleId != 2 && roleId != 3 && roleId != 5)) { // Doctor, Receptionist, Technician only
            resp.sendRedirect(req.getContextPath() + "/views/error/access-denied.jsp");
            return;
        }
        
        int patientId = Integer.parseInt(req.getParameter("patientId"));
        int statusCode = Integer.parseInt(req.getParameter("statusCode"));
        Integer userId = utils.AuthHelper.getCurrentUserId(req);
        if (userId == null) {
            resp.sendRedirect(req.getContextPath() + "/views/error/access-denied.jsp");
            return;
        }

        PatientStatusDao.updateStatus(patientId, statusCode, userId);
        resp.sendRedirect(req.getHeader("referer"));
    }
}
