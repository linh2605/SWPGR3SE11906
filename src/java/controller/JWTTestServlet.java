package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import utils.AuthHelper;
import utils.JWTUtil;
import models.User;

import java.io.IOException;
import java.io.PrintWriter;

/**
 * JWT Test Servlet for testing JWT functionality
 */
@WebServlet(name = "JWTTestServlet", urlPatterns = {"/test/jwt"})
public class JWTTestServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();
        
        try {
            // Get current user info
            User user = AuthHelper.getCurrentUser(request);
            Integer userId = AuthHelper.getCurrentUserId(request);
            Integer roleId = AuthHelper.getCurrentUserRoleId(request);
            String authSource = AuthHelper.getAuthSource(request);
            boolean isAuthenticated = AuthHelper.isAuthenticated(request);
            
            // Build JSON response
            StringBuilder json = new StringBuilder();
            json.append("{\n");
            json.append("  \"status\": \"success\",\n");
            json.append("  \"message\": \"JWT Test Endpoint\",\n");
            json.append("  \"authenticated\": ").append(isAuthenticated).append(",\n");
            json.append("  \"authSource\": \"").append(authSource).append("\",\n");
            json.append("  \"userId\": ").append(userId).append(",\n");
            json.append("  \"roleId\": ").append(roleId).append(",\n");
            
            if (user != null) {
                json.append("  \"user\": {\n");
                json.append("    \"id\": ").append(user.getUserId()).append(",\n");
                json.append("    \"username\": \"").append(user.getUsername()).append("\",\n");
                json.append("    \"fullName\": \"").append(user.getFullName()).append("\",\n");
                json.append("    \"email\": \"").append(user.getEmail()).append("\",\n");
                
                if (user.getRole() != null) {
                    json.append("    \"role\": {\n");
                    json.append("      \"id\": ").append(user.getRole().getRoleId()).append(",\n");
                    json.append("      \"name\": \"").append(user.getRole().getName()).append("\"\n");
                    json.append("    }\n");
                } else {
                    json.append("    \"role\": null\n");
                }
                
                json.append("  },\n");
            } else {
                json.append("  \"user\": null,\n");
            }
            
            // Test JWT token extraction
            String jwtToken = getJwtToken(request);
            json.append("  \"jwtToken\": ").append(jwtToken != null ? "\"present\"" : "null").append(",\n");
            
            // Test session
            String sessionId = (request.getSession(false) != null) ? request.getSession(false).getId() : null;
            json.append("  \"sessionId\": ").append(sessionId != null ? "\"present\"" : "null").append(",\n");
            
            json.append("  \"timestamp\": ").append(System.currentTimeMillis()).append("\n");
            json.append("}");
            
            out.print(json.toString());
            
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print("{\n");
            out.print("  \"status\": \"error\",\n");
            out.print("  \"message\": \"" + e.getMessage() + "\",\n");
            out.print("  \"timestamp\": " + System.currentTimeMillis() + "\n");
            out.print("}");
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();
        
        try {
            // This endpoint requires authentication
            if (!AuthHelper.isAuthenticated(request)) {
                response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                out.print("{\n");
                out.print("  \"status\": \"error\",\n");
                out.print("  \"message\": \"Authentication required\",\n");
                out.print("  \"timestamp\": " + System.currentTimeMillis() + "\n");
                out.print("}");
                return;
            }
            
            String action = request.getParameter("action");
            
            if ("validate".equals(action)) {
                // Validate current JWT token
                String token = getJwtToken(request);
                if (token != null) {
                    boolean isValid = !JWTUtil.isTokenExpired(token);
                    out.print("{\n");
                    out.print("  \"status\": \"success\",\n");
                    out.print("  \"message\": \"Token validation\",\n");
                    out.print("  \"valid\": " + isValid + ",\n");
                    out.print("  \"timestamp\": " + System.currentTimeMillis() + "\n");
                    out.print("}");
                } else {
                    out.print("{\n");
                    out.print("  \"status\": \"error\",\n");
                    out.print("  \"message\": \"No JWT token found\",\n");
                    out.print("  \"timestamp\": " + System.currentTimeMillis() + "\n");
                    out.print("}");
                }
                
            } else if ("info".equals(action)) {
                // Get detailed user info
                User user = AuthHelper.getCurrentUser(request);
                String authSource = AuthHelper.getAuthSource(request);
                
                out.print("{\n");
                out.print("  \"status\": \"success\",\n");
                out.print("  \"message\": \"User info\",\n");
                out.print("  \"authSource\": \"" + authSource + "\",\n");
                out.print("  \"user\": {\n");
                out.print("    \"id\": " + user.getUserId() + ",\n");
                out.print("    \"username\": \"" + user.getUsername() + "\",\n");
                out.print("    \"fullName\": \"" + user.getFullName() + "\",\n");
                out.print("    \"email\": \"" + user.getEmail() + "\",\n");
                out.print("    \"roleId\": " + user.getRole().getRoleId() + ",\n");
                out.print("    \"roleName\": \"" + user.getRole().getName() + "\"\n");
                out.print("  },\n");
                out.print("  \"timestamp\": " + System.currentTimeMillis() + "\n");
                out.print("}");
                
            } else {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                out.print("{\n");
                out.print("  \"status\": \"error\",\n");
                out.print("  \"message\": \"Invalid action. Use 'validate' or 'info'\",\n");
                out.print("  \"timestamp\": " + System.currentTimeMillis() + "\n");
                out.print("}");
            }
            
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print("{\n");
            out.print("  \"status\": \"error\",\n");
            out.print("  \"message\": \"" + e.getMessage() + "\",\n");
            out.print("  \"timestamp\": " + System.currentTimeMillis() + "\n");
            out.print("}");
        }
    }
    
    /**
     * Extract JWT token from request
     */
    private String getJwtToken(HttpServletRequest request) {
        // Try cookie first
        jakarta.servlet.http.Cookie[] cookies = request.getCookies();
        if (cookies != null) {
            for (jakarta.servlet.http.Cookie cookie : cookies) {
                if ("jwt_token".equals(cookie.getName())) {
                    return cookie.getValue();
                }
            }
        }
        
        // Try header
        String authHeader = request.getHeader("Authorization");
        if (authHeader != null && authHeader.startsWith("Bearer ")) {
            return authHeader.substring(7);
        }
        
        return null;
    }
    
    @Override
    public String getServletInfo() {
        return "JWT Test Servlet for testing JWT functionality";
    }
} 