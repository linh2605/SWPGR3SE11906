/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.auth;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.User;

/**
 *
 * @author ACER
 */
@WebServlet(name = "ResendOTPServletJQuery", urlPatterns = {"/ResendOTP"})
public class ResendOTPServletJQuery extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("user-resetpassword");
        request.getSession().setAttribute("otp", EmailServices.sendOTPResetPassword(user));
        request.getSession().setAttribute("expireTime", System.currentTimeMillis() + 600000);
        PrintWriter out = response.getWriter();
        out.print("OTP sent <br>");
        out.print("<button onclick=\"resendOTP()\" id=\"resendBtn\" class=\"btn btn-sm btn-secondary\" disabled>Resend OTP</button>");
    }

}
