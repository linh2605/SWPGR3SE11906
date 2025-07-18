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
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Use AuthHelper for unified authentication: 2-doctor, 3-receptionist, 4-admin, 5-technician
        if (!utils.AuthHelper.hasRole(request, 2)
                && !utils.AuthHelper.hasRole(request, 3)
                && !utils.AuthHelper.hasRole(request, 4)
                && !utils.AuthHelper.hasRole(request, 5)) {
            response.sendRedirect(request.getContextPath() + "/views/error/access-denied.jsp");
            return;
        }

        if (request.getParameter("id") != null
                && request.getParameter("id").length() > 0) {
            int news_id = Integer.parseInt(request.getParameter("id"));
            News news = NewsDAO.getNewsById(news_id);
            System.out.println("news:" + news.getNewsID() + ":" + news.getTitle());
            if (news.getNewsID() != 0) {
                request.setAttribute("n", news);
                request.getRequestDispatcher("/views/home/edit-news.jsp").forward(request, response);
            } else {
                request.setAttribute("errorMsg", "Không tìm thấy bài viết");
                request.getRequestDispatcher("/views/layouts/notification-page.jsp").forward(request, response);
            }
        } else {
            request.setAttribute("errorMsg", "Không tìm thấy bài viết");
            request.getRequestDispatcher("/views/layouts/notification-page.jsp").forward(request, response);
        }
    }

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
