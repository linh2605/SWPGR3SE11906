package controller;

import dal.NewsDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import java.io.File;

import java.io.IOException;
import java.nio.file.Paths;
import java.time.LocalDateTime;
import models.News;
import models.User;

@WebServlet("/news/edit")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024, // 1MB
        maxFileSize = 5 * 1024 * 1024, // 5MB
        maxRequestSize = 10 * 1024 * 1024 // 10MB
)
public class NewsEditServlet extends HttpServlet {

    private static final String UPLOAD_DIR = "assets/uploads/news";

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        if (req.getParameter("id") != null 
                && req.getParameter("id").length() > 0) {
            int news_id = Integer.parseInt(req.getParameter("id"));
            News news = NewsDAO.getNewsById(news_id);
            System.out.println("news:" + news.getNewsID() + ":" + news.getTitle());
            if (news.getNewsID() != 0) {
                req.setAttribute("n", news);
                req.getRequestDispatcher("/views/home/edit-news.jsp").forward(req, resp);
            } else {
                req.setAttribute("errorMsg", "Không tìm thấy bài viết");
                req.getRequestDispatcher("/views/layouts/notification-page.jsp").forward(req, resp);
            }
        } else {
            req.setAttribute("errorMsg", "Không tìm thấy bài viết");
            req.getRequestDispatcher("/views/layouts/notification-page.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        if (!utils.AuthHelper.isAuthenticated(request)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        int newsID = Integer.parseInt(request.getParameter("newsID"));
        String title = request.getParameter("title");
        int createdByID = Integer.parseInt(request.getParameter("createdByID"));
        String createdBy = request.getParameter("createdBy");
        LocalDateTime createdAt = LocalDateTime.parse(request.getParameter("createdAt"));
        LocalDateTime updatedAt = LocalDateTime.parse(request.getParameter("updatedAt"));
        String shortDescription = request.getParameter("shortDescription");
        String description = request.getParameter("description");
        String imageUrl = request.getParameter("existingImageUrl");

        Part filePart = request.getPart("imageFile");
        if (filePart != null && filePart.getSize() > 0) {
            String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
            String appPath = getServletContext().getRealPath("");
            String uploadPath = appPath + File.separator + UPLOAD_DIR;

            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
            }

            String filePath = uploadPath + File.separator + fileName;
            filePart.write(filePath);

            imageUrl = request.getContextPath() + "/" + UPLOAD_DIR + "/" + fileName;
        }

        News news = new News();
        news.setNewsID(newsID);
        news.setTitle(title);
        news.setImagePreview(imageUrl);
        news.setShortDescription(shortDescription);
        news.setDescription(description);
        news.setCreatedAt(createdAt);
        news.setUpdatedAt(updatedAt);
        User u = new User();
        u.setUserId(createdByID);
        u.setFullName(createdBy);
        news.setCreatedBy(u);

        if (NewsDAO.update(news)) {
            response.sendRedirect(request.getContextPath() + "/news/edit?id=" + news.getNewsID() + "&success=true");
        } else {
            response.sendRedirect(request.getContextPath() + "/news/edit?id=" + news.getNewsID() + "&success=false");
        }
    }
}
