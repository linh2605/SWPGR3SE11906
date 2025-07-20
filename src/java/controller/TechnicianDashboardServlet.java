package controller;

import dal.PatientStatusDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import models.PatientStatus;

import java.io.IOException;
import java.util.List;

@WebServlet("/technician/dashboard")
public class TechnicianDashboardServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Use AuthHelper for unified authentication
        if (!utils.AuthHelper.hasRole(request, 5)) { // 5 = technician
            response.sendRedirect(request.getContextPath() + "/views/error/access-denied.jsp");
            return;
        }
        
        try {
            // Lấy thống kê cho dashboard technician
            // Số bệnh nhân chờ xét nghiệm (status = 5: Chờ bệnh nhân xét nghiệm)
            int waitingTests = PatientStatusDao.countPatientsByStatus(5);
            
            // Số bệnh nhân đang xét nghiệm (status = 6: Đang xét nghiệm)
            int processingTests = PatientStatusDao.countPatientsByStatus(6);
            
            // Số bệnh nhân chờ kết quả (status = 7: Chờ lấy kết quả xét nghiệm)
            int waitingResults = PatientStatusDao.countPatientsByStatus(7);
            
            // Số bệnh nhân đã hoàn thành (status = 8: Đã lấy kết quả xét nghiệm)
            int completedTests = PatientStatusDao.countPatientsByStatus(8);
            
            // Lấy danh sách bệnh nhân cần xét nghiệm
            List<PatientStatus> testPatients = PatientStatusDao.getPatientsByStatus(5);
            
            // Lấy danh sách bệnh nhân đang xét nghiệm
            List<PatientStatus> processingTestPatients = PatientStatusDao.getPatientsByStatus(6);
            
            // Lấy danh sách bệnh nhân chờ kết quả
            List<PatientStatus> waitingResultPatients = PatientStatusDao.getPatientsByStatus(7);
            
            // Thống kê theo loại xét nghiệm (giả định - có thể mở rộng sau)
            int bloodTests = PatientStatusDao.countPatientsByStatus(5); // Giả sử tất cả đều là xét nghiệm máu
            int xrayTests = 0; // Có thể thêm logic phân loại sau
            int ultrasoundTests = 0; // Có thể thêm logic phân loại sau
            
            // Set attributes
            request.setAttribute("waitingTests", waitingTests);
            request.setAttribute("processingTests", processingTests);
            request.setAttribute("waitingResults", waitingResults);
            request.setAttribute("completedTests", completedTests);
            request.setAttribute("testPatients", testPatients);
            request.setAttribute("processingTestPatients", processingTestPatients);
            request.setAttribute("waitingResultPatients", waitingResultPatients);
            request.setAttribute("bloodTests", bloodTests);
            request.setAttribute("xrayTests", xrayTests);
            request.setAttribute("ultrasoundTests", ultrasoundTests);
            
            request.getRequestDispatcher("/views/technician/dashboard.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(500, "Lỗi server: " + e.getMessage());
        }
    }
} 