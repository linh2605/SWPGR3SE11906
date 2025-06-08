package controller;

import dal.ContactMessageDAO;
import models.ContactMessage;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "ContactServlet", urlPatterns = {"/contact"})
public class ContactServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        
        try {
            // Get form data
            String name = request.getParameter("name");
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");
            String subject = request.getParameter("subject");
            String message = request.getParameter("message");
            
            // Validate input
            if (name == null || name.trim().isEmpty() ||
                email == null || email.trim().isEmpty() ||
                phone == null || phone.trim().isEmpty() ||
                subject == null || subject.trim().isEmpty() ||
                message == null || message.trim().isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/views/info/contact_us.jsp?status=error&message=missing_fields");
                return;
            }
            
            // Create message object
            ContactMessage contactMessage = new ContactMessage();
            contactMessage.setName(name.trim());
            contactMessage.setEmail(email.trim());
            contactMessage.setPhone(phone.trim());
            contactMessage.setSubject(subject.trim());
            contactMessage.setMessage(message.trim());
            
            // Save to database
            ContactMessageDAO dao = new ContactMessageDAO();
            boolean success = dao.createMessage(contactMessage);
            
            // Redirect with status
            if (success) {
                response.sendRedirect(request.getContextPath() + "/views/info/contact_us.jsp?status=success");
            } else {
                response.sendRedirect(request.getContextPath() + "/views/info/contact_us.jsp?status=error&message=database_error");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/views/info/contact_us.jsp?status=error&message=system_error");
        }
    }
} 