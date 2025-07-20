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
import models.News;
import utils.AuthHelper;

@WebServlet("/news/create")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024, // 1MB
        maxFileSize = 5 * 1024 * 1024, // 5MB
        maxRequestSize = 10 * 1024 * 1024 // 10MB
)
public class NewsAddServlet extends HttpServlet {

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
        
        News news = new News();
        news.setCreatedBy(AuthHelper.getCurrentUser(request));
        request.setAttribute("n", news);
        request.getRequestDispatcher("/views/home/add-news.jsp").forward(request, response);

    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Use AuthHelper for unified authentication: 2-doctor, 3-receptionist, 4-admin, 5-technician
        if (!utils.AuthHelper.hasRole(request, 2)
                && !utils.AuthHelper.hasRole(request, 3)
                && !utils.AuthHelper.hasRole(request, 4)
                && !utils.AuthHelper.hasRole(request, 5)) {
            response.sendRedirect(request.getContextPath() + "/views/error/access-denied.jsp");
            return;
        }
        
        request.setCharacterEncoding("UTF-8");
        if (!utils.AuthHelper.isAuthenticated(request)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String title = request.getParameter("title").trim();
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
        news.setCreatedBy(AuthHelper.getCurrentUser(request));
        news.setImagePreview(imageUrl);

        // validate truong du lieu
        String errMsg = "";
        errMsg += title.isEmpty() ? "<span>Tiêu đề bài viết không được để trống!</span>" : "";
        errMsg += shortDescription.trim().isEmpty() ? "<span>Nội dung chính không được để trống!</span>\n" : "";
        errMsg += description.trim().isEmpty() ? "<span>Nội dung bài viết không được để trống!</span>" : "";
        if (!errMsg.isEmpty()) {
            request.setAttribute("errMsg", errMsg);
            request.setAttribute("n", news);
            request.getRequestDispatcher("/views/home/add-news.jsp").forward(request, response);
            return;
        }

        news.setTitle(title);
        news.setShortDescription(shortDescription);
        news.setDescription(description);

        if (NewsDAO.insert(news)) {
            response.sendRedirect(request.getContextPath() + "/news?addSuccess=true");
        } else {
            request.setAttribute("errMsg", "Đăng bài viết thất bại: Lỗi hệ thống!");
            request.setAttribute("n", news);
            request.getRequestDispatcher("/views/home/add-news.jsp").forward(request, response);
        }
    }
}
