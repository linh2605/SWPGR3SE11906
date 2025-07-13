
package controller;

import dal.DoctorDao;
import dal.PatientDao;
import dal.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import models.User;

import java.io.IOException;

@WebServlet("/admin/user/delete")
public class AdminDeleteUserServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        int user_id = Integer.parseInt(req.getParameter("userId"));
        System.out.println("check user id" + user_id);
        User user = UserDAO.getByUserId(user_id);
        if (user != null) {
            UserDAO.deleteUser(user_id);
            if (user.getRole().getRoleId() == 1) {
                PatientDao.deletePatient(user_id);
            }
            if (user.getRole().getRoleId() == 2) {
                DoctorDao.deleteDoctor(user_id);
            }
            req.getSession().setAttribute("flash_success", "Xóa người dùng thành công.");
            resp.sendRedirect(req.getHeader("referer"));
        } else {
            req.getSession().setAttribute("flash_error", "Người dùng không tồn tại.");
            resp.sendRedirect(req.getHeader("referer"));
        }
    }
}
