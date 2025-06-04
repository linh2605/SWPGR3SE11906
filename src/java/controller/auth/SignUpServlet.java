/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.auth;

import controller.customer.Header;
import dal.UserDao;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;

/**
 *
 * @author ADMIN
 */
@WebServlet(name = "SignUpServlet", urlPatterns = {"/auth/signup"})
public class SignUpServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (request.getSession().getAttribute("verifyStatus") != null && (int) request.getSession().getAttribute("verifyStatus") == 2) {
            User user = (User) request.getSession().getAttribute("user-registation");
            request.getSession().invalidate();
            new UserDao().createUser(user);
            request.getSession().setAttribute("usersession", user);
            response.sendRedirect("../homepage");
            return;
        }
        Header.Load(request, response);
        request.getRequestDispatcher("login-register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        UserDao ud = new UserDao();
        String fullname = request.getParameter("fullname").trim();
        String username = request.getParameter("username").trim();
        String email = request.getParameter("email").trim();
        if (ud.getByEmail(email) != null) {
            request.setAttribute("fullname", fullname);
            request.setAttribute("username", username);
            request.setAttribute("email", email);
            request.setAttribute("errmsgemail", "This email already links to another account!");
            request.getRequestDispatcher("login-register.jsp").forward(request, response);
            return;
        }
        if (ud.getByUsername(username) != null) {
            request.setAttribute("fullname", fullname);
            request.setAttribute("username", username);
            request.setAttribute("email", email);
            request.setAttribute("errmsgusername", "This username already exists!");
            request.getRequestDispatcher("login-register.jsp").forward(request, response);
            return;
        }
        String password = request.getParameter("password");
        String repassword = request.getParameter("repassword");

        if (password.equals(repassword)) {
            password = Encode.toSHA1(password);
        }
        User user = new User(username, password, 4, "assets/profile.png", fullname, "Other", null, email, null);
        
        String OTP = EmailServices.SendOTPConfirmEmail(user);
        if (OTP != null) {
            HttpSession session = request.getSession();
            session.setAttribute("otp", OTP);
            session.setAttribute("expireTime", System.currentTimeMillis() + 600000);
            session.setAttribute("action", "email-verification");
            session.setAttribute("user-registation", user);
            request.getRequestDispatcher("EnterOtp.jsp").forward(request, response);
        }
    }

}
