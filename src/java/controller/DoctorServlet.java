/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller;

import dal.PatientStatusDao;
import dal.StatusDAO;
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
@WebServlet("/doctorupdate")
public class DoctorServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // Lọc bệnh nhân mà bác sĩ có thể xử lý
        req.setAttribute("patients", PatientStatusDao.getByHandledRole(2));  // role_id = 2: bác sĩ
        req.setAttribute("statuses", StatusDAO.getStatusesByRole(2));  // Trạng thái dành cho bác sĩ
        req.getRequestDispatcher("/views/doctor/managestatus.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        try {
            int patientId = Integer.parseInt(req.getParameter("patientId"));
            int statusCode = Integer.parseInt(req.getParameter("statusCode"));
            int changedBy = (int) req.getSession().getAttribute("userId");

            // Cập nhật trạng thái
            PatientStatusDao.updateStatus(patientId, statusCode, changedBy);
            req.setAttribute("message", "Cập nhật trạng thái thành công!");

        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Lỗi cập nhật trạng thái!");
        }

        req.setAttribute("patients", PatientStatusDao.getByHandledRole(2));
        req.setAttribute("statuses", StatusDAO.getStatusesByRole(2));
        req.getRequestDispatcher("/views/doctor/managestatus.jsp").forward(req, resp);
    }
}

