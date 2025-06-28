package controller.auth;

import controller.auth.util.EmailServices;
import controller.auth.util.OTPUtil;
import dal.UserDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import models.UserRegister;

@WebServlet("/enter-otp")
public class EnterOTPServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/views/home/EnterOTP.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String otp = request.getParameter("otp");
        String action = request.getParameter("action");

        UserDAO dao = new UserDAO();

        if ("resend".equals(action)) {
            // Gửi lại OTP
            String newOtp = OTPUtil.generateOTP();
            dao.updateOtp(email, newOtp);
            EmailServices.sendOtpEmail(email, newOtp);

            request.setAttribute("message", "Mã OTP mới đã được gửi lại.");
            request.setAttribute("email", email);
            request.getRequestDispatcher("/views/home/EnterOTP.jsp").forward(request, response);
            return;
        }

        // Kiểm tra OTP hợp lệ
        boolean isValid = dao.verifyOTP(email, otp);
        if (!isValid) {
            request.setAttribute("error", "Mã OTP không chính xác hoặc đã hết hạn.");
            request.setAttribute("email", email);
            request.getRequestDispatcher("/views/home/EnterOTP.jsp").forward(request, response);
            return;
        }

        // Đăng ký người dùng mới
        HttpSession session = request.getSession();
        UserRegister reg = (UserRegister) session.getAttribute("pendingUser");

        if (reg != null) {
            int userId = dao.registerNewUser(reg);   // insert vào bảng users
            dao.activateUser(email);                 // kích hoạt tài khoản
            dao.insertPatient(userId);               // mặc định role_id = 1 => chèn vào bảng patients
            session.removeAttribute("pendingUser");
        }

        response.sendRedirect("login?verified=1");
    }
}
