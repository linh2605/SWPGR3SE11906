
package controller;

import dal.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/admin/user/delete")
public class AdminDeleteUserServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        int user_id = Integer.parseInt(req.getParameter("userId"));
        UserDAO.deleteUser(user_id);
        req.getSession().setAttribute("flash_success", "Xóa người dùng thành công.");
        resp.sendRedirect(req.getHeader("referer"));
    }
}
