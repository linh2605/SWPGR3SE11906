/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller;


import dal.DBContext;
import dal.UserProfileDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.sql.Date;
import models.UserProfile;
import java.sql.Connection;
import java.io.File;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.Part;
import java.nio.file.Paths;


/**
 *
 * @author auiri
 */
@WebServlet("/ProfileServlet")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,       // 1MB
    maxFileSize = 5 * 1024 * 1024,         // 5MB
    maxRequestSize = 10 * 1024 * 1024      // 10MB
)
public class ProfileServlet extends HttpServlet {

    private static final String UPLOAD_DIR = "assets/uploads/avatars";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Object userIdObj = session.getAttribute("userId");
        Object roleIdObj = session.getAttribute("roleId");

        if (userIdObj == null || roleIdObj == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        int userId = Integer.parseInt(userIdObj.toString());
        int roleId = Integer.parseInt(roleIdObj.toString());

        try (Connection conn = DBContext.makeConnection()) {
            UserProfileDAO dao = new UserProfileDAO(conn);
            UserProfile profile = dao.getUserProfile(userId, roleId);

            request.setAttribute("profile", profile);

            switch (roleId) {
                case 1:
                    request.getRequestDispatcher("/views/patient/profile.jsp").forward(request, response);
                    break;
                case 2:
                    request.getRequestDispatcher("/views/doctor/profile.jsp").forward(request, response);
                    break;
                case 3:
                    request.getRequestDispatcher("/views/receptionist/profile.jsp").forward(request, response);
                    break;
                default:
                    response.sendError(403, "Vai trò không hợp lệ.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(500, "Lỗi server: " + e.getMessage());
        }
    }

    @Override
protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

    request.setCharacterEncoding("UTF-8");
    HttpSession session = request.getSession();
    Object userIdObj = session.getAttribute("userId");
    Object roleIdObj = session.getAttribute("roleId");

    if (userIdObj == null || roleIdObj == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }

    int userId = Integer.parseInt(userIdObj.toString());
    int roleId = Integer.parseInt(roleIdObj.toString());

    // Lấy dữ liệu cơ bản từ form
    String fullName = request.getParameter("fullName");
    String email = request.getParameter("email");
    String phone = request.getParameter("phone");
    String gender = request.getParameter("gender");
    String dob = request.getParameter("dob");
    String address = request.getParameter("address");
    String imageUrl = request.getParameter("imageUrl"); // nếu điền tay

    // Lấy thêm tất cả các field khác
    String degree = request.getParameter("degree");
    String experience = request.getParameter("experience");
    String specialtyId = request.getParameter("specialtyId");
    String shift = request.getParameter("shift");
    String status = request.getParameter("status");
    String department = request.getParameter("department");

    // Xử lý file upload (nếu có)
    Part filePart = request.getPart("avatarFile");
    if (filePart != null && filePart.getSize() > 0) {
        String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
        String appPath = getServletContext().getRealPath("");
        String uploadPath = appPath + File.separator + UPLOAD_DIR;

        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) uploadDir.mkdirs();

        String filePath = uploadPath + File.separator + fileName;
        filePart.write(filePath);

        imageUrl = request.getContextPath() + "/" + UPLOAD_DIR + "/" + fileName;
    }

    // Gán dữ liệu vào đối tượng profile
    UserProfile profile = new UserProfile();
    profile.setUserId(userId);
    profile.setRoleId(roleId);
    profile.setFullName(fullName);
    profile.setEmail(email);
    profile.setPhone(phone);
    profile.setGender(gender);
    profile.setDob(dob);
    profile.setAddress(address);
    profile.setImageUrl(imageUrl);
    profile.setDegree(degree);
    profile.setExperience(experience);
    profile.setSpecialtyId(specialtyId);
    profile.setShift(shift);
    profile.setStatus(status);
    profile.setDepartment(department);

    try (Connection conn = DBContext.makeConnection()) {
        UserProfileDAO dao = new UserProfileDAO(conn);
        dao.updateUserProfile(profile);

        response.sendRedirect(request.getContextPath() + "/ProfileServlet?success=true");
    } catch (Exception e) {
        e.printStackTrace();
        response.sendError(500, "Lỗi khi cập nhật hồ sơ: " + e.getMessage());
    }
}

}