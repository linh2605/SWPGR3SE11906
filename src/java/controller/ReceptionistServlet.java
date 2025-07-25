package controller;

import dal.PatientStatusDao;
import dal.StatusDAO;
import java.io.IOException;
import java.util.Comparator;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import models.PatientStatus; // Import lớp mô hình PatientStatus

@WebServlet("/receptionistuplate")
public class ReceptionistServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        // Use AuthHelper for unified authentication  
        if (!utils.AuthHelper.hasRole(req, 3)) { // 3 = receptionist
            resp.sendRedirect(req.getContextPath() + "/views/error/access-denied.jsp");
            return;
        }

        // Lọc bệnh nhân mà lễ tân có thể xử lý
        dal.PatientStatusDao.fixConfirmedAppointments();
        List<PatientStatus> patients = PatientStatusDao.getByHandledRole(3);  // role_id = 3: receptionist
        req.setAttribute("statuses", StatusDAO.getStatusesByRole(3));  // Trạng thái dành cho lễ tân

        // Sắp xếp danh sách bệnh nhân
        patients.sort(new Comparator<PatientStatus>() {
            @Override
            public int compare(PatientStatus p1, PatientStatus p2) {
                // Sắp xếp theo statusCode: Đã khám xong đợi thanh toán -> Check-in -> New
                if (p1.getStatusCode() == 9 && p2.getStatusCode() != 9) return -1;  // Đã khám xong đợi thanh toán đứng đầu
                if (p1.getStatusCode() == 2 && p2.getStatusCode() != 2) return -1;  // Check-in đứng sau
                if (p1.getStatusCode() == 1 && p2.getStatusCode() != 1) return -1;  // New đứng sau nữa
                return Integer.compare(p1.getStatusCode(), p2.getStatusCode());  // Sắp xếp tăng dần nếu các trạng thái còn lại giống nhau
            }
        });

        req.setAttribute("patients", patients);
        req.getRequestDispatcher("/views/receptionist/managestatus.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        // Use AuthHelper for unified authentication  
        if (!utils.AuthHelper.hasRole(req, 3)) { // 3 = receptionist
            resp.sendRedirect(req.getContextPath() + "/views/error/access-denied.jsp");
            return;
        }

        try {
            int patientId = Integer.parseInt(req.getParameter("patientId"));
            int statusCode = Integer.parseInt(req.getParameter("statusCode"));
            Integer changedBy = utils.AuthHelper.getCurrentUserId(req);
            if (changedBy == null) {
                req.setAttribute("error", "Không thể xác định người dùng!");
                return;
            }

            // Cập nhật trạng thái bệnh nhân và ghi lại log
            PatientStatusDao.updateStatus(patientId, statusCode, changedBy);
            req.setAttribute("message", "Cập nhật trạng thái thành công!");

        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Lỗi cập nhật trạng thái!");
        }

        // Reload lại danh sách bệnh nhân sau khi cập nhật
        List<PatientStatus> patients = PatientStatusDao.getByHandledRole(3);  // role_id = 3: receptionist

        // Sắp xếp lại danh sách bệnh nhân
        patients.sort(new Comparator<PatientStatus>() {
            @Override
            public int compare(PatientStatus p1, PatientStatus p2) {
                // Sắp xếp theo statusCode: Đã khám xong đợi thanh toán -> Check-in -> New
                if (p1.getStatusCode() == 9 && p2.getStatusCode() != 9) return -1;  // Đã khám xong đợi thanh toán đứng đầu
                if (p1.getStatusCode() == 2 && p2.getStatusCode() != 2) return -1;  // Check-in đứng sau
                if (p1.getStatusCode() == 1 && p2.getStatusCode() != 1) return -1;  // New đứng sau nữa
                return Integer.compare(p1.getStatusCode(), p2.getStatusCode());  // Sắp xếp tăng dần nếu các trạng thái còn lại giống nhau
            }
        });

        req.setAttribute("patients", patients);
        req.getRequestDispatcher("/views/receptionist/managestatus.jsp").forward(req, resp);
    }
}
