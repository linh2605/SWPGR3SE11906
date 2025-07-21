/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dal.UserDAO;
import models.User;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 *
 * @author New_user
 */
@WebServlet(name = "LoginServlet", urlPatterns = {"/login"})
public class LoginServlet extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet LoginServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet LoginServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/views/home/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = controller.auth.util.Encode.toSHA1(request.getParameter("password"));
        User user = UserDAO.login(username, password);

        if (user != null && user.getUserId() != 0) {
            // Kiểm tra trạng thái tài khoản
            models.AccountStatus accountStatus = dal.UserDAO.checkAccountStatus(user.getUserId());
            
            if (!accountStatus.isActive()) {
                // Tài khoản bị vô hiệu hóa
                request.setAttribute("error", accountStatus.getMessage());
                request.setAttribute("accountDisabled", true);
                request.setAttribute("contactPhone", "0976054728");
                request.setAttribute("contactEmail", "admin@g3hospital.com");
                request.getRequestDispatcher("/views/home/login.jsp").forward(request, response);
                return;
            }
            
            HttpSession session = request.getSession();
            session.setAttribute("user", user);
            session.setAttribute("userId", user.getUserId());
            session.setAttribute("roleId", user.getRole().getRoleId());
            session.setAttribute("role", user.getRole().getName());
            
            // NEW: Generate JWT token
            try {
                String jwtToken = utils.JWTUtil.generateToken(user);
                
                // Set JWT in response header (for API clients)
                response.setHeader("Authorization", "Bearer " + jwtToken);
                
                // Set JWT in cookie (for web clients) with role-based expiration
                jakarta.servlet.http.Cookie jwtCookie = new jakarta.servlet.http.Cookie("jwt_token", jwtToken);
                jwtCookie.setHttpOnly(true);
                
                // Set cookie expiration based on role
                int roleId = user.getRole().getRoleId();
                if (roleId == 1) { // Patient
                    jwtCookie.setMaxAge(4 * 60 * 60); // 4 hours for patients
                    System.out.println("JWT token generated for PATIENT: " + user.getUsername() + " (4 hours expiration)");
                } else { // Admin, Doctor, Receptionist, Technician
                    jwtCookie.setMaxAge(24 * 60 * 60); // 24 hours for others
                    System.out.println("JWT token generated for " + user.getRole().getName().toUpperCase() + ": " + user.getUsername() + " (24 hours expiration)");
                }
                
                jwtCookie.setPath("/");
                response.addCookie(jwtCookie);
                
            } catch (Exception e) {
                System.err.println("Error generating JWT token: " + e.getMessage());
                // Continue with normal flow even if JWT generation fails
            }
            
            int roleId = user.getRole().getRoleId();
            if (roleId == 4) { // admin
                response.sendRedirect(request.getContextPath() + "/admin/dashboard");
            } else if (roleId == 2) { // doctor
                // Set doctorId for doctor users
                dal.WorkingScheduleDAO workingScheduleDAO = new dal.WorkingScheduleDAO();
                int doctorId = workingScheduleDAO.getDoctorIdByUserId(user.getUserId());
                session.setAttribute("doctorId", doctorId);
                response.sendRedirect(request.getContextPath() + "/doctor/dashboard");
            } else if (roleId == 3) { // receptionist
                response.sendRedirect(request.getContextPath() + "/receptionist/dashboard");
            } else if (roleId == 5) { // technician
                response.sendRedirect(request.getContextPath() + "/technician/dashboard");
            } else {
                response.sendRedirect(request.getContextPath() + "/home");
            }
        } else {
            request.setAttribute("error", "Sai tên đăng nhập hoặc mật khẩu!");
            request.getRequestDispatcher("/views/home/login.jsp").forward(request, response);
        }
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
