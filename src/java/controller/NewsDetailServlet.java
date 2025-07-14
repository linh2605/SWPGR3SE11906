package controller;

import dal.NewsDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import models.News;

@WebServlet("/news/*")
public class NewsDetailServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String pathInfo = req.getPathInfo();
        if (pathInfo != null && pathInfo.length() > 1) {
            int news_id = Integer.parseInt(pathInfo.substring(1));
            News news = NewsDAO.getNewsById(news_id);
            System.out.println("news:" + news.getNewsID() + ":" + news.getTitle());
            if (news.getNewsID() != 0) {
                req.setAttribute("n", news);
                req.getRequestDispatcher("/views/home/news-detail.jsp").forward(req, resp);
            } else {
                req.setAttribute("errorMsg", "Không tìm thấy bài viết");
                req.getRequestDispatcher("/views/layouts/notification-page.jsp").forward(req, resp);
            }
        } else {
            req.setAttribute("errorMsg", "Không tìm thấy bài viết");
            req.getRequestDispatcher("/views/layouts/notification-page.jsp").forward(req, resp);
        }
    }
}
