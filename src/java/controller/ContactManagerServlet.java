/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nfs://.netbeans.org/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import dal.ContactMessageDAO;
import models.ContactMessage;
import java.util.List;

/**
 *
 * @author MMMM
 */
@WebServlet(name="ContactManagerServlet", urlPatterns={"/contactManager"})
public class ContactManagerServlet extends HttpServlet {
   
    /** 
     * Processes requests for both HTTP GET and POST methods.
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
            out.println("");
            out.println("");
            out.println("");
            out.println("");  
            out.println("");
            out.println("");
            out.println("Servlet ContactManagerServlet at " + request.getContextPath () + "");
            out.println("");
            out.println("");
        }
    } 

    // 
    /** 
     * Handles the HTTP GET method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        // Use AuthHelper for unified authentication
        if (!utils.AuthHelper.hasRole(request, 4)) { // 4 = admin
            response.sendRedirect(request.getContextPath() + "/views/error/access-denied.jsp");
            return;
        }
        
        String viewId = request.getParameter("view");
        ContactMessageDAO dao = new ContactMessageDAO();
        
        if (viewId != null) {
            try {
                int messageId = Integer.parseInt(viewId);
                ContactMessage message = dao.getMessageById(messageId);
                request.setAttribute("message", message);
                request.getRequestDispatcher("/views/admin/contactDetail.jsp").forward(request, response);
                return;
            } catch (NumberFormatException e) {
                e.printStackTrace();
            }
        }
        
        List<ContactMessage> messages = dao.getAllMessages();
        request.setAttribute("messages", messages);
        request.getRequestDispatcher("/views/admin/contactManager.jsp").forward(request, response);
    } 

    /** 
     * Handles the HTTP POST method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        // Use AuthHelper for unified authentication
        if (!utils.AuthHelper.hasRole(request, 4)) { // 4 = admin
            response.sendRedirect(request.getContextPath() + "/views/error/access-denied.jsp");
            return;
        }
        
        String action = request.getParameter("action");
        String idStr = request.getParameter("id");
        ContactMessageDAO dao = new ContactMessageDAO();
        
        try {
            if (action != null && idStr != null) {
                int id = Integer.parseInt(idStr);
                
                if ("updateStatus".equals(action)) {
                    String status = request.getParameter("status");
                    if (status != null) {
                        dao.updateMessageStatus(id, status);
                    }
                } else if ("updatePriority".equals(action)) {
                    String priority = request.getParameter("priority");
                    if (priority != null) {
                        dao.updateMessagePriority(id, priority);
                    }
                } else if ("delete".equals(action)) {
                    dao.deleteMessage(id);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        String viewId = request.getParameter("view");
        if (viewId != null) {
            response.sendRedirect(request.getContextPath() + "/contactManager?view=" + viewId);
        } else {
            response.sendRedirect(request.getContextPath() + "/contactManager");
        }
    }

    /** 
     * Returns a short description of the servlet.
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// 
}