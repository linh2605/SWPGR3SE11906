package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Cookie;
import utils.AuthHelper;
import utils.JWTUtil;
import models.User;
import java.io.IOException;

/**
 * Servlet to handle JWT token refresh
 */
@WebServlet("/jwt/refresh")
public class JWTRefreshServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Check if user is authenticated via session
        User currentUser = AuthHelper.getCurrentUser(request);
        if (currentUser == null) {
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "User not authenticated");
            return;
        }
        
        try {
            // Generate new JWT token
            String newToken = JWTUtil.generateToken(currentUser);
            
            // Set new JWT cookie
            Cookie jwtCookie = new Cookie("jwt_token", newToken);
            jwtCookie.setHttpOnly(true);
            
            // Set cookie expiration based on role
            int roleId = currentUser.getRole().getRoleId();
            if (roleId == 1) { // Patient
                jwtCookie.setMaxAge(4 * 60 * 60); // 4 hours
            } else { // Admin, Doctor, Receptionist, Technician
                jwtCookie.setMaxAge(24 * 60 * 60); // 24 hours
            }
            
            jwtCookie.setPath("/");
            response.addCookie(jwtCookie);
            
            // Return success response
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write("{\"status\":\"success\",\"message\":\"Token refreshed successfully\"}");
            
        } catch (Exception e) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error refreshing token");
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
} 