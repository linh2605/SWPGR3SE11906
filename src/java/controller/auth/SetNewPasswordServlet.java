/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller.auth;

import dal.UserDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import models.User;

/**
 *
 * @author auiri
 */
@WebServlet(name="SetNewPasswordServlet", urlPatterns={"/set-new-pass"})
public class SetNewPasswordServlet extends HttpServlet {
   
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
    } 

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        
        String password = request.getParameter("newPassword");
        User user = (User) request.getSession().getAttribute("user-resetpassword");
        user.setPassword(Encode.toSHA1(password));
        new UserDAO().updateUser(user);
        request.getSession().invalidate();
        response.sendRedirect("auth/login");
    }

}
