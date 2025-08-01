/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dal.DoctorDao;
import dal.SpecialtyDao;
import utils.AuthHelper;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import models.Doctor;
import models.Specialty;

/**
 *
 * @author New_user
 */
@WebServlet(name = "DoctorListServlet", urlPatterns = {"/doctors"})
public class DoctorListServlet extends HttpServlet {

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
            out.println("<title>Servlet DoctorListServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet DoctorListServlet at " + request.getContextPath() + "</h1>");
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
        // Doctor list is accessible to all users (staff can view for reference, patients/guests can browse)
        List<Doctor> doctors = DoctorDao.getAllDoctors();
        List<Specialty> specialties = SpecialtyDao.getAllSpecialties();
        HashMap<Specialty, Integer> specialtiesCount = SpecialtyDao.getSpecialtiesWithDoctorCount();
        int countAllSpecialties = 0;
        for (Map.Entry<Specialty, Integer> entry : specialtiesCount.entrySet()) {
            countAllSpecialties += entry.getValue();
        }

        // Debug information
        System.out.println("DoctorListServlet Debug:");
        System.out.println("Number of doctors retrieved: " + (doctors != null ? doctors.size() : "null"));
        System.out.println("Number of specialties: " + (specialties != null ? specialties.size() : "null"));
        System.out.println("Specialties count map size: " + (specialtiesCount != null ? specialtiesCount.size() : "null"));

        if (doctors != null && doctors.size() > 0) {
            System.out.println("First doctor: " + doctors.get(0).getUser().getFullName());
        }

        request.setAttribute("doctors", doctors);
        request.setAttribute("countAllSpecialties", countAllSpecialties);
        request.setAttribute("specialties", specialtiesCount);
        request.getRequestDispatcher("/views/home/doctor-list.jsp").forward(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
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
