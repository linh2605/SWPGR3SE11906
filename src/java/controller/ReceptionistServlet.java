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
@WebServlet("/receptionistuplate")
public class ReceptionistServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Lọc bệnh nhân mà lễ tân có thể xử lý
        req.setAttribute("patients", PatientStatusDao.getByHandledRole(3)); // role_id = 3: receptionist
        req.setAttribute("statuses", StatusDAO.getStatusesByRole(3)); // Trạng thái dành cho lễ tân
        req.getRequestDispatcher("/views/receptionist/managestatus.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            int patientId = Integer.parseInt(req.getParameter("patientId"));
            int statusCode = Integer.parseInt(req.getParameter("statusCode"));
            
            // Lấy ID người thay đổi từ session (giả sử user đã đăng nhập)
            int changedBy = (int) req.getSession().getAttribute("userId");

            // Cập nhật trạng thái bệnh nhân và ghi lại log
            PatientStatusDao.updateStatus(patientId, statusCode, changedBy);

            req.setAttribute("message", "Cập nhật trạng thái thành công!");

        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Lỗi cập nhật trạng thái!");
        }

        // Reload lại dữ liệu như doGet
        req.setAttribute("patients", PatientStatusDao.getByHandledRole(3)); // role_id = 3: receptionist
        req.setAttribute("statuses", StatusDAO.getStatusesByRole(3)); // Trạng thái dành cho lễ tân
        req.getRequestDispatcher("/views/receptionist/managestatus.jsp").forward(req, resp);
    }
}

