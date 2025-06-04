package controller.auth;

/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */


import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 *
 * @author ACER
 */
@WebServlet(urlPatterns={"/verify-otp"})
public class VerifiOTPServlet extends HttpServlet {
   
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
    } 

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        PrintWriter out = response.getWriter();
        String action = (String) request.getSession().getAttribute("action");
        int verifyStatus = EmailServices.verifyOTP(action, (String)request.getSession().getAttribute("otp"), request.getParameter("otp"), request);
        request.getSession().setAttribute("verifyStatus", verifyStatus);
        switch (verifyStatus) {
            case 1:
                out.print("{\"status\":\"success-forgotpassword\"}");
                break;
            case 2:
                out.print("{\"status\":\"success-emailverification\"}");
                break;
            case -1:
                out.print("{\"status\":\"error\", \"message\":\"OTP is incorrect\"}");
                break;
            case -2:
                out.print("{\"status\":\"error\", \"message\":\"OTP is expired\"}");
                break;
            default:
                break;
        }
    }

}
