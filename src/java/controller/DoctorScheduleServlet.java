package controller;

import dal.WorkingScheduleDAO;
import dal.ScheduleExceptionDAO;
import dal.ShiftDAO;
import models.WorkingSchedule;
import models.ScheduleException;
import models.User;
import models.Shift;
import java.io.IOException;
import java.sql.Time;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name="DoctorScheduleServlet", urlPatterns={"/doctor-schedule"})
public class DoctorScheduleServlet extends HttpServlet {
    
    private WorkingScheduleDAO scheduleDAO;
    private ScheduleExceptionDAO exceptionDAO;
    private ShiftDAO shiftDAO;
    
    @Override
    public void init() {
        scheduleDAO = new WorkingScheduleDAO();
        exceptionDAO = new ScheduleExceptionDAO();
        shiftDAO = new ShiftDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        // Kiểm tra quyền truy cập
        if (user == null || user.getRole().getRoleId() != 2) {
            response.sendRedirect(request.getContextPath() + "/views/home/login.jsp?error=access_denied");
            return;
        }
        
        String action = request.getParameter("action");
        
        if (action == null) {
            action = "view";
        }
        
        switch (action) {
            case "view":
                viewSchedule(request, response, user);
                break;
            case "exceptions":
                viewExceptions(request, response, user);
                break;
            case "add-exception":
                showAddExceptionForm(request, response);
                break;
            case "edit-exception":
                showEditExceptionForm(request, response);
                break;
            case "delete-exception":
                deleteException(request, response);
                break;
            default:
                viewSchedule(request, response, user);
                break;
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        // Kiểm tra quyền truy cập
        if (user == null || user.getRole().getRoleId() != 2) {
            response.sendRedirect(request.getContextPath() + "/views/home/login.jsp?error=access_denied");
            return;
        }
        
        String action = request.getParameter("action");
        
        switch (action) {
            case "add-exception":
                addException(request, response, user);
                break;
            case "update-exception":
                updateException(request, response, user);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/doctor-schedule");
                break;
        }
    }
    
    private void viewSchedule(HttpServletRequest request, HttpServletResponse response, User user) 
            throws ServletException, IOException {
        
        // Lấy doctor_id từ user
        int doctorId = getDoctorIdFromUser(user);
        
        List<WorkingSchedule> schedules = scheduleDAO.getSchedulesByDoctorId(doctorId);
        List<ScheduleException> exceptions = exceptionDAO.getExceptionsByDoctorId(doctorId);
        
        request.setAttribute("schedules", schedules);
        request.setAttribute("exceptions", exceptions);
        request.getRequestDispatcher("/views/doctor/schedule.jsp").forward(request, response);
    }
    
    private void viewExceptions(HttpServletRequest request, HttpServletResponse response, User user) 
            throws ServletException, IOException {
        
        int doctorId = getDoctorIdFromUser(user);
        List<ScheduleException> exceptions = exceptionDAO.getExceptionsByDoctorId(doctorId);
        
        request.setAttribute("exceptions", exceptions);
        request.getRequestDispatcher("/views/doctor/exceptions.jsp").forward(request, response);
    }
    
    private void showAddForm(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Chức năng này đã bị loại bỏ cho bác sĩ
        response.sendRedirect(request.getContextPath() + "/doctor-schedule?error=access_denied");
    }
    
    private void showEditForm(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Chức năng này đã bị loại bỏ cho bác sĩ
        response.sendRedirect(request.getContextPath() + "/doctor-schedule?error=access_denied");
    }
    
    private void showAddExceptionForm(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        List<Shift> shifts = shiftDAO.getAllShifts();
        request.setAttribute("shifts", shifts);
        request.getRequestDispatcher("/views/doctor/add-exception.jsp").forward(request, response);
    }
    
    private void showEditExceptionForm(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        int exceptionId = Integer.parseInt(request.getParameter("id"));
        ScheduleException exception = exceptionDAO.getExceptionById(exceptionId);
        
        if (exception != null && "Chờ duyệt".equals(exception.getStatus())) {
            List<Shift> shifts = shiftDAO.getAllShifts();
            request.setAttribute("shifts", shifts);
            request.setAttribute("exception", exception);
            request.getRequestDispatcher("/views/doctor/edit-exception.jsp").forward(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/doctor-schedule?action=exceptions&error=not_editable");
        }
    }
    
    private void addSchedule(HttpServletRequest request, HttpServletResponse response, User user) 
            throws ServletException, IOException {
        // Chức năng này đã bị loại bỏ cho bác sĩ
        response.sendRedirect(request.getContextPath() + "/doctor-schedule?error=access_denied");
    }
    
    private void updateSchedule(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Chức năng này đã bị loại bỏ cho bác sĩ
        response.sendRedirect(request.getContextPath() + "/doctor-schedule?error=access_denied");
    }
    
    private void deleteSchedule(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Chức năng này đã bị loại bỏ cho bác sĩ
        response.sendRedirect(request.getContextPath() + "/doctor-schedule?error=access_denied");
    }
    
    private void addException(HttpServletRequest request, HttpServletResponse response, User user) 
            throws ServletException, IOException {
        
        try {
            int doctorId = getDoctorIdFromUser(user);
            String exceptionDateStr = request.getParameter("exceptionDate");
            String exceptionType = request.getParameter("exceptionType");
            String newShiftIdStr = request.getParameter("newShiftId");
            String reason = request.getParameter("reason");
            
            // Parse date
            SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
            java.sql.Date exceptionDate = new java.sql.Date(dateFormat.parse(exceptionDateStr).getTime());
            
            // Kiểm tra xem exception đã tồn tại chưa
            if (exceptionDAO.checkExceptionExists(doctorId, exceptionDate)) {
                request.setAttribute("error", "Đã có ngoại lệ cho ngày này!");
                List<Shift> shifts = shiftDAO.getAllShifts();
                request.setAttribute("shifts", shifts);
                request.getRequestDispatcher("/views/doctor/add-exception.jsp").forward(request, response);
                return;
            }
            
            ScheduleException exception = new ScheduleException();
            exception.setDoctorId(doctorId);
            exception.setExceptionDate(exceptionDate);
            exception.setExceptionType(exceptionType);
            exception.setReason(reason);
            exception.setStatus("Chờ duyệt"); // Trạng thái mặc định
            
            if ("Thay đổi giờ làm".equals(exceptionType) && newShiftIdStr != null && !newShiftIdStr.isEmpty()) {
                exception.setNewShiftId(Integer.parseInt(newShiftIdStr));
            }
            
            if (exceptionDAO.addException(exception)) {
                response.sendRedirect(request.getContextPath() + "/doctor-schedule?action=exceptions&success=added");
            } else {
                request.setAttribute("error", "Có lỗi xảy ra khi thêm ngoại lệ!");
                List<Shift> shifts = shiftDAO.getAllShifts();
                request.setAttribute("shifts", shifts);
                request.getRequestDispatcher("/views/doctor/add-exception.jsp").forward(request, response);
            }
            
        } catch (ParseException e) {
            request.setAttribute("error", "Định dạng ngày tháng không hợp lệ!");
            List<Shift> shifts = shiftDAO.getAllShifts();
            request.setAttribute("shifts", shifts);
            request.getRequestDispatcher("/views/doctor/add-exception.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Ca làm việc mới không hợp lệ!");
            List<Shift> shifts = shiftDAO.getAllShifts();
            request.setAttribute("shifts", shifts);
            request.getRequestDispatcher("/views/doctor/add-exception.jsp").forward(request, response);
        }
    }
    
    private void updateException(HttpServletRequest request, HttpServletResponse response, User user) 
            throws ServletException, IOException {
        
        try {
            int exceptionId = Integer.parseInt(request.getParameter("exceptionId"));
            
            // Lấy thông tin ngoại lệ hiện tại để kiểm tra
            ScheduleException existingException = exceptionDAO.getExceptionById(exceptionId);
            int doctorId = getDoctorIdFromUser(user);
            
            if (existingException == null || existingException.getDoctorId() != doctorId || !"Chờ duyệt".equals(existingException.getStatus())) {
                response.sendRedirect(request.getContextPath() + "/doctor-schedule?action=exceptions&error=update_failed");
                return;
            }

            String exceptionDateStr = request.getParameter("exceptionDate");
            String exceptionType = request.getParameter("exceptionType");
            String newShiftIdStr = request.getParameter("newShiftId");
            String reason = request.getParameter("reason");
            
            // Parse date
            SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
            java.sql.Date exceptionDate = new java.sql.Date(dateFormat.parse(exceptionDateStr).getTime());
            
            ScheduleException exception = new ScheduleException();
            exception.setExceptionId(exceptionId);
            exception.setExceptionDate(exceptionDate);
            exception.setExceptionType(exceptionType);
            exception.setReason(reason);
            exception.setStatus("Chờ duyệt"); // Giữ nguyên trạng thái chờ duyệt khi cập nhật
            
            if ("Thay đổi giờ làm".equals(exceptionType) && newShiftIdStr != null && !newShiftIdStr.isEmpty()) {
                exception.setNewShiftId(Integer.parseInt(newShiftIdStr));
            } else {
                exception.setNewShiftId(null); // Nếu là nghỉ phép thì không có ca mới
            }
            
            if (exceptionDAO.updateException(exception)) {
                response.sendRedirect(request.getContextPath() + "/doctor-schedule?action=exceptions&success=updated");
            } else {
                request.setAttribute("error", "Có lỗi xảy ra khi cập nhật ngoại lệ!");
                List<Shift> shifts = shiftDAO.getAllShifts();
                request.setAttribute("shifts", shifts);
                request.setAttribute("exception", exception); // Gửi lại exception để điền form
                request.getRequestDispatcher("/views/doctor/edit-exception.jsp").forward(request, response);
            }
            
        } catch (ParseException e) {
            int exceptionId = Integer.parseInt(request.getParameter("exceptionId"));
            request.setAttribute("error", "Định dạng ngày tháng không hợp lệ!");
            request.setAttribute("exception", exceptionDAO.getExceptionById(exceptionId));
            List<Shift> shifts = shiftDAO.getAllShifts();
            request.setAttribute("shifts", shifts);
            request.getRequestDispatcher("/views/doctor/edit-exception.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            int exceptionId = Integer.parseInt(request.getParameter("exceptionId"));
            request.setAttribute("error", "ID hoặc ca làm việc không hợp lệ!");
            request.setAttribute("exception", exceptionDAO.getExceptionById(exceptionId));
            List<Shift> shifts = shiftDAO.getAllShifts();
            request.setAttribute("shifts", shifts);
            request.getRequestDispatcher("/views/doctor/edit-exception.jsp").forward(request, response);
        }
    }
    
    private void deleteException(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            int exceptionId = Integer.parseInt(request.getParameter("id"));
            HttpSession session = request.getSession();
            User user = (User) session.getAttribute("user");
            int doctorId = getDoctorIdFromUser(user);
            
            ScheduleException existingException = exceptionDAO.getExceptionById(exceptionId);
            
            if (existingException != null && existingException.getDoctorId() == doctorId && "Chờ duyệt".equals(existingException.getStatus())) {
                if (exceptionDAO.deleteException(exceptionId)) {
                    response.sendRedirect(request.getContextPath() + "/doctor-schedule?action=exceptions&success=deleted");
                } else {
                    response.sendRedirect(request.getContextPath() + "/doctor-schedule?action=exceptions&error=delete_failed");
                }
            } else {
                response.sendRedirect(request.getContextPath() + "/doctor-schedule?action=exceptions&error=delete_failed");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/doctor-schedule?action=exceptions&error=invalid_id");
        }
    }
    
    private int getDoctorIdFromUser(User user) {
        return scheduleDAO.getDoctorIdByUserId(user.getUserId());
    }
} 