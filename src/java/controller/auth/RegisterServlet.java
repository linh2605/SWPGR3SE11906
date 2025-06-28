package controller.auth;

import controller.auth.util.EmailServices;
import controller.auth.util.Encode;
import controller.auth.util.OTPUtil;
import dal.UserDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import models.UserRegister;

@WebServlet("/views/home/register")
public class RegisterServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/views/home/register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Tạo đối tượng đăng ký mới
        UserRegister reg = new UserRegister(
                request.getParameter("username"),
                Encode.toSHA1(request.getParameter("password")),
                request.getParameter("fullName"),
                request.getParameter("email"),
                request.getParameter("phone")
        );

        UserDAO dao = new UserDAO();

        // Kiểm tra tài khoản đã tồn tại
        if (dao.checkUserExist(reg.getUsername(), reg.getEmail())) {
            request.setAttribute("error", "Username hoặc Email đã tồn tại.");
            request.getRequestDispatcher("/views/home/register.jsp").forward(request, response);
            return;
        }

        // Tạo và gửi OTP
        String otp = OTPUtil.generateOTP();
        dao.saveOtpOnly(reg.getEmail(), otp); // Lưu OTP tạm thời (chưa đăng ký tài khoản)
        EmailServices.sendOtpEmail(reg.getEmail(), otp);

        // Lưu tạm thông tin người dùng
        HttpSession session = request.getSession();
        session.setAttribute("pendingUser", reg);

        // Chuyển đến trang xác minh OTP (do servlet EnterOTPServlet xử lý)
        response.sendRedirect(request.getContextPath() + "/enter-otp?email=" + reg.getEmail());
    }
}
