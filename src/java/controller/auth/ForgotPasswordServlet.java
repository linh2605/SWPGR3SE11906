/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller.auth;

import controller.auth.util.EmailServices;
import dal.UserDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.net.URLEncoder;
import models.User;

/**
 *
 * @author auiri
 */
@WebServlet("/views/home/forgot-password")
public class ForgotPasswordServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/views/home/forgot_password.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        UserDAO dao = new UserDAO();
        User user = dao.findByEmail(email);

        if (user == null) {
            request.setAttribute("error", "Email không tồn tại.");
        } else {
            String link = "http://localhost:9999/ClinicManagementSystem/views/home/resetPassword.jsp?email=" + URLEncoder.encode(email, "UTF-8");
            EmailServices.sendResetPasswordLink(email, link);
            request.setAttribute("message", "Hãy kiểm tra email để đặt lại mật khẩu.");
        }

        request.getRequestDispatcher("/views/home/forgot_password.jsp").forward(request, response);
    }
}

