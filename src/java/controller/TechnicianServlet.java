package controller;

import dal.PatientStatusDao;
import dal.PatientStatusLogDao;
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
import models.PatientStatusLog;

@WebServlet("/technicianupdate")
public class TechnicianServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // Use AuthHelper for unified authentication  
        if (!utils.AuthHelper.hasRole(req, 5)) { // 5 = technician
            resp.sendRedirect(req.getContextPath() + "/views/error/access-denied.jsp");
            return;
        }

        // Lọc bệnh nhân mà technician có thể xử lý (được phân quyền theo trạng thái)
        List<PatientStatus> patients = PatientStatusDao.getByHandledRole(5);  // role_id = 5: technician
        req.setAttribute("statuses", StatusDAO.getStatusesByRole(5));  // Trạng thái dành cho technician

        // Lấy log mới nhất của mỗi bệnh nhân từ patient_status_logs
        for (PatientStatus patient : patients) {
            List<PatientStatusLog> logs = PatientStatusLogDao.getLogsByPatientId(patient.getPatientId());
            if (!logs.isEmpty()) {
                PatientStatusLog latestLog = logs.get(logs.size() - 1);  // lấy log mới nhất
                patient.setStatusCode(latestLog.getStatusCode());  // Cập nhật trạng thái từ log mới nhất
                patient.setChangedAt(latestLog.getChangedAt());    // Cập nhật thời gian thay đổi từ log mới nhất
            }
        }

        // Sắp xếp danh sách bệnh nhân theo trạng thái ưu tiên: Đang chờ kết quả xét nghiệm -> Đang xét nghiệm -> Đang chờ bệnh nhân xét nghiệm
        patients.sort((p1, p2) -> {
            if (p1.getStatusCode() == 7 && p2.getStatusCode() != 7) return -1;  // Đang chờ kết quả xét nghiệm đứng đầu
            if (p1.getStatusCode() == 6 && p2.getStatusCode() != 6) return -1;  // Đang xét nghiệm đứng sau
            if (p1.getStatusCode() == 5 && p2.getStatusCode() != 5) return -1;  // Đang chờ bệnh nhân xét nghiệm đứng sau nữa
            return Integer.compare(p1.getStatusCode(), p2.getStatusCode());  // So sánh các trạng thái còn lại
        });

        req.setAttribute("patients", patients);
        req.getRequestDispatcher("/views/technician/managestatus.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // Use AuthHelper for unified authentication  
        if (!utils.AuthHelper.hasRole(req, 5)) { // 5 = technician
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
        List<PatientStatus> patients = PatientStatusDao.getByHandledRole(5);  // role_id = 5: technician

        // Lấy log mới nhất của mỗi bệnh nhân từ patient_status_logs
        for (PatientStatus patient : patients) {
            List<PatientStatusLog> logs = PatientStatusLogDao.getLogsByPatientId(patient.getPatientId());
            if (!logs.isEmpty()) {
                PatientStatusLog latestLog = logs.get(logs.size() - 1);  // lấy log mới nhất
                patient.setStatusCode(latestLog.getStatusCode());  // Cập nhật trạng thái từ log mới nhất
                patient.setChangedAt(latestLog.getChangedAt());    // Cập nhật thời gian thay đổi từ log mới nhất
            }
        }

        // Sắp xếp lại danh sách bệnh nhân theo trạng thái ưu tiên
        patients.sort((p1, p2) -> {
            if (p1.getStatusCode() == 7 && p2.getStatusCode() != 7) return -1;  // Đang chờ kết quả xét nghiệm đứng đầu
            if (p1.getStatusCode() == 6 && p2.getStatusCode() != 6) return -1;  // Đang xét nghiệm đứng sau
            if (p1.getStatusCode() == 5 && p2.getStatusCode() != 5) return -1;  // Đang chờ bệnh nhân xét nghiệm đứng sau nữa
            return Integer.compare(p1.getStatusCode(), p2.getStatusCode());  // So sánh các trạng thái còn lại
        });

        req.setAttribute("patients", patients);
        req.getRequestDispatcher("/views/technician/managestatus.jsp").forward(req, resp);
    }
}
