/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller.auth;

import controller.auth.util.Encode;
import dal.UserDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import models.User;

/**
 *
 * @author auiri
 */
@WebServlet("/new-password")
public class SetNewPasswordServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/views/home/newPassword.jsp").forward(request, response);
    }

@Override
protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

    String oldPassword = Encode.toSHA1(request.getParameter("oldPassword"));
    String newPassword = request.getParameter("newPassword");
    String confirmPassword = request.getParameter("confirmPassword");

    HttpSession session = request.getSession();
    User currentUser = (User) session.getAttribute("user");

    if (currentUser == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    // Kiểm tra mật khẩu cũ
    User verified = UserDAO.login(currentUser.getEmail(), oldPassword);
    if (verified == null) {
        request.setAttribute("error", "❌ Mật khẩu cũ không đúng!");
        request.getRequestDispatcher("/views/home/newPassword.jsp").forward(request, response);
        return;
    }

    // Kiểm tra xác nhận mật khẩu mới
    if (!newPassword.equals(confirmPassword)) {
        request.setAttribute("error", "❌ Mật khẩu xác nhận không khớp!");
        request.getRequestDispatcher("/views/home/newPassword.jsp").forward(request, response);
        return;
    }

    // Cập nhật mật khẩu mới
    String newPasswordHashed = Encode.toSHA1(newPassword);
    new UserDAO().updatePasswordByEmail(currentUser.getEmail(), newPasswordHashed);

    // ✅ Huỷ session cũ để bắt buộc đăng nhập lại
    session.invalidate();

    // Chuyển đến trang hiển thị thông báo đổi mật khẩu và đợi 5s chuyển về login
    request.setAttribute("redirectUrl", request.getContextPath() + "/login?fromReset=true");
    request.getRequestDispatcher("/views/home/passwordResetSuccess.jsp").forward(request, response);
}
}


