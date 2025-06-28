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
@WebServlet("/technicianupdate")
public class TechnicianServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // Lọc bệnh nhân mà technician có thể xử lý (được phân quyền theo trạng thái)
        req.setAttribute("patients", PatientStatusDao.getByHandledRole(5));  // role_id = 5: technician
        req.setAttribute("statuses", StatusDAO.getStatusesByRole(5));  // Trạng thái dành cho technician
        req.getRequestDispatcher("/views/technician/managestatus.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        try {
            int patientId = Integer.parseInt(req.getParameter("patientId"));
            int statusCode = Integer.parseInt(req.getParameter("statusCode"));
            int changedBy = (int) req.getSession().getAttribute("userId");

            // Cập nhật trạng thái bệnh nhân và ghi lại log
            PatientStatusDao.updateStatus(patientId, statusCode, changedBy);
            req.setAttribute("message", "Cập nhật trạng thái thành công!");

        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Lỗi cập nhật trạng thái!");
        }

        // Reload lại danh sách bệnh nhân sau khi cập nhật
        req.setAttribute("patients", PatientStatusDao.getByHandledRole(5));  // role_id = 5: technician
        req.setAttribute("statuses", StatusDAO.getStatusesByRole(5));  // Trạng thái dành cho technician
        req.getRequestDispatcher("/views/technician/managestatus.jsp").forward(req, resp);
    }
}

