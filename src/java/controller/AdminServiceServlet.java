package controller;

import Util.UploadImage;
import dal.DoctorDao;
import dal.ServiceDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import models.Doctor;
import models.Service;
import models.ServiceType;
import models.ExaminationPackage;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/admin/examination-manage")
@MultipartConfig
public class AdminServiceServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Use AuthHelper for unified authentication
        if (!utils.AuthHelper.hasRole(req, 4)) { // 4 = admin
            resp.sendRedirect(req.getContextPath() + "/views/error/access-denied.jsp");
            return;
        }
        
        List<Doctor> doctors = DoctorDao.getAllDeletedDoctors();
        List<Service> services = ServiceDAO.getAll();
        List<ExaminationPackage> packages = new dal.ExaminationPackageDAO().getAll();
        req.setAttribute("doctors", doctors);
        req.setAttribute("services", services);
        req.setAttribute("packages", packages);
        req.getRequestDispatcher("/views/admin/service-manager.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Use AuthHelper for unified authentication
        if (!utils.AuthHelper.hasRole(req, 4)) { // 4 = admin
            resp.sendRedirect(req.getContextPath() + "/views/error/access-denied.jsp");
            return;
        }
        
        String action = req.getParameter("action");
        switch (action) {
            case "add" -> add(req, resp);
            case "edit" -> edit(req, resp);
            case "delete" -> delete(req, resp);
            default -> resp.sendError(404);
        }
    }

    public static void add(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String name = req.getParameter("name");
        String detail = req.getParameter("detail");
        long price = (long) Double.parseDouble(req.getParameter("price"));
        String[] doctorIds = req.getParameterValues("doctorIds");
        List<Doctor> doctors = parseDoctorList(doctorIds);
        
        // Kiểm tra có ảnh upload không
        boolean hasImage = req.getPart("image") != null && req.getPart("image").getSize() > 0;

        Service service = new Service(name, detail, price, ServiceType.SPECIALIST, "", doctors);
        int packageId = ServiceDAO.create(service);
        
        // Nếu có ảnh, lưu với tên file theo package_id
        if (hasImage && packageId > 0) {
            try {
                String imageUrl = Util.UploadImage.savePackageImage(req, "image", packageId);
                new dal.ExaminationPackageDAO().updateImageUrl(packageId, imageUrl);
            } catch (Exception e) {
                System.out.println("Lỗi lưu ảnh: " + e.getMessage());
            }
        }
        
        req.getSession().setAttribute("flash_success", "Thêm mới thành công.");
        resp.sendRedirect(req.getContextPath() + "/admin/examination-manage");
    }

    public static void edit(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        int id = Integer.parseInt(req.getParameter("id"));
        Service service = ServiceDAO.getServiceById(id);
        if (service == null) {
            req.getSession().setAttribute("flash_error", "Cập nhật không thành công.");
        } else {
            String name = req.getParameter("name");
            String detail = req.getParameter("detail");
            long price = (long) Double.parseDouble(req.getParameter("price"));
            String[] doctorIds = req.getParameterValues("doctorIds");
            List<Doctor> doctors = parseDoctorList(doctorIds);

            service.setName(name);
            service.setDetail(detail);
            service.setPrice(price);
            service.setDoctors(doctors);
            
            // Upload ảnh mới nếu có
            if (req.getPart("image") != null && req.getPart("image").getSize() > 0) {
                try {
                    String imageUrl = Util.UploadImage.savePackageImage(req, "image", service.getServiceId());
                    new dal.ExaminationPackageDAO().updateImageUrl(service.getServiceId(), imageUrl);
                } catch (Exception e) {
                    System.out.println("Lỗi lưu ảnh: " + e.getMessage());
                }
            }

            ServiceDAO.update(service);
            req.getSession().setAttribute("flash_success", "Cập nhật thành công.");
        }
        resp.sendRedirect(req.getContextPath() + "/admin/examination-manage");
    }

    public static void delete(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        int id = Integer.parseInt(req.getParameter("id"));
        ServiceDAO.delete(id);
        req.getSession().setAttribute("flash_success", "Xóa thành công.");
        resp.sendRedirect(req.getContextPath() + "/admin/examination-manage");
    }

    private static List<Doctor> parseDoctorList(String[] ids) {
        List<Doctor> list = new ArrayList<>();
        if (ids != null) {
            for (String id : ids) {
                try {
                    int sid = Integer.parseInt(id);
                    list.add(new Doctor(sid));
                } catch (NumberFormatException ignored) {}
            }
        }
        return list;
    }
}
