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

        if (!utils.AuthHelper.isAuthenticated(request)) {
            response.sendRedirect(request.getContextPath() + "/login");
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
