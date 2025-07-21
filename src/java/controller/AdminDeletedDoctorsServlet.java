package controller;

import dal.DoctorDao;
import dal.SpecialtyDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import models.Doctor;
import models.Specialty;

@WebServlet(name="AdminDeletedDoctorsServlet", urlPatterns={"/admin/deleted-doctors"})
public class AdminDeletedDoctorsServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (java.io.PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet AdminDeletedDoctorsServlet</title>");  
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet AdminDeletedDoctorsServlet at " + request.getContextPath () + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    } 

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        try {
            // Lấy danh sách bác sĩ đã xóa mềm
            List<Doctor> deletedDoctors = DoctorDao.getSoftDeletedDoctors();
            
            // Lấy danh sách chuyên khoa cho form
            List<Specialty> specialties = SpecialtyDao.getAllSpecialties();
            
            // Set attributes
            request.setAttribute("deletedDoctors", deletedDoctors);
            request.setAttribute("specialties", specialties);
            
            // Forward đến JSP
            request.getRequestDispatcher("/views/admin/deleted-doctors.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error loading deleted doctors: " + e.getMessage());
        }
    } 

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Servlet for displaying soft deleted doctors";
    }
} 