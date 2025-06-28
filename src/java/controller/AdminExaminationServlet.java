package controller;

import dal.ExaminationPackageDao;
import dal.SpecialtyDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import models.ExaminationPackage;
import models.Specialty;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/admin/examination-manage")
public class AdminExaminationServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        List<Specialty> specialties = SpecialtyDao.getAllSpecialties();
        req.setAttribute("specialties", specialties);

        String id = req.getParameter("id");
        if (id == null) {
            List<ExaminationPackage> examinationPackages = ExaminationPackageDao.getAll();
            req.setAttribute("examinationPackages", examinationPackages);
            req.getRequestDispatcher("/views/admin/examination-package-manager.jsp").forward(req, resp);
        } else {
            ExaminationPackage examinationPackage = ExaminationPackageDao.getById(Integer.parseInt(id));
            req.setAttribute("examinationPackage", examinationPackage);
            req.getRequestDispatcher("/views/admin/examination-package-detail.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
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
        String description = req.getParameter("description");
        double price = Double.parseDouble(req.getParameter("price"));
        int duration = Integer.parseInt(req.getParameter("duration"));
        String[] specialtyIds = req.getParameterValues("specialty_ids");
        List<Specialty> specialties = parseSpecialtyList(specialtyIds);

        ExaminationPackage examinationPackage = new ExaminationPackage(0, name, description, specialties, price, duration);
        ExaminationPackageDao.insert(examinationPackage);
        req.getSession().setAttribute("flash_success", "Thêm mới thành công.");
        resp.sendRedirect(req.getContextPath() + "/admin/examination-manage");
    }

    public static void edit(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        int id = Integer.parseInt(req.getParameter("id"));
        ExaminationPackage examinationPackage = ExaminationPackageDao.getById(id);
        if (examinationPackage == null) {
            req.getSession().setAttribute("flash_error", "Cập nhật không thành công.");
        } else {
            String name = req.getParameter("name");
            String description = req.getParameter("description");
            double price = Double.parseDouble(req.getParameter("price"));
            int duration = Integer.parseInt(req.getParameter("duration"));
            String[] specialtyIds = req.getParameterValues("specialty_ids");
            List<Specialty> specialties = parseSpecialtyList(specialtyIds);

            examinationPackage.setName(name);
            examinationPackage.setDescription(description);
            examinationPackage.setPrice(price);
            examinationPackage.setDuration(duration);
            examinationPackage.setSpecialties(specialties);

            ExaminationPackageDao.update(examinationPackage);
            req.getSession().setAttribute("flash_success", "Cập nhật thành công.");
        }
        resp.sendRedirect(req.getContextPath() + "/admin/examination-manage");
    }

    public static void delete(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        int id = Integer.parseInt(req.getParameter("id"));
        ExaminationPackageDao.delete(id);
        req.getSession().setAttribute("flash_success", "Xóa thành công.");
        resp.sendRedirect(req.getContextPath() + "/admin/examination-manage");
    }

    private static List<Specialty> parseSpecialtyList(String[] ids) {
        List<Specialty> list = new ArrayList<>();
        if (ids != null) {
            for (String id : ids) {
                try {
                    int sid = Integer.parseInt(id);
                    list.add(new Specialty(sid, null, null));
                } catch (NumberFormatException ignored) {}
            }
        }
        return list;
    }
}
