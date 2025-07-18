package controller;

import dal.NewsDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/news/delete")
public class NewsDeleteServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        // Use AuthHelper for unified authentication: 2-doctor, 3-receptionist, 4-admin, 5-technician
        if (!utils.AuthHelper.hasRole(request, 2)
                && !utils.AuthHelper.hasRole(request, 3)
                && !utils.AuthHelper.hasRole(request, 4)
                && !utils.AuthHelper.hasRole(request, 5)) {
            response.sendRedirect(request.getContextPath() + "/views/error/access-denied.jsp");
            return;
        }

        int newsID = Integer.parseInt(request.getParameter("newsID"));

        if (NewsDAO.delete(newsID)) {
            response.sendRedirect(request.getContextPath() + "/news?deleteSuccess=true");
        } else {
            response.sendRedirect(request.getContextPath() + "/news?deleteSuccess=false");
        }
    }
}
