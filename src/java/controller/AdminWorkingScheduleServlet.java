package controller;

import dal.WorkingScheduleDAO;
import dal.DoctorDao;
import dal.ShiftDAO;
import models.WorkingSchedule;
import models.Doctor;
import models.Shift;
import models.User;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name="AdminWorkingScheduleServlet", urlPatterns={"/admin/working-schedules"})
public class AdminWorkingScheduleServlet extends HttpServlet {
    
    private WorkingScheduleDAO scheduleDAO;
    private DoctorDao doctorDAO;
    private ShiftDAO shiftDAO;
    
    @Override
    public void init() {
        scheduleDAO = new WorkingScheduleDAO();
        doctorDAO = new DoctorDao();
        shiftDAO = new ShiftDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        // Use AuthHelper for unified authentication
        if (!utils.AuthHelper.hasRole(request, 4)) { // 4 = admin
            response.sendRedirect(request.getContextPath() + "/views/error/access-denied.jsp");
            return;
        }
        
        String action = request.getParameter("action");
        
        if (action == null) {
            action = "list";
        }
        
        switch (action) {
            case "list":
                listSchedules(request, response);
                break;
            case "add":
                showAddForm(request, response);
                break;
            case "edit":
                showEditForm(request, response);
                break;
            case "delete":
                deleteSchedule(request, response);
                break;
            case "detail":
                showDetail(request, response);
                break;
            default:
                listSchedules(request, response);
                break;
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        // Use AuthHelper for unified authentication
        if (!utils.AuthHelper.hasRole(request, 4)) { // 4 = admin
            response.sendRedirect(request.getContextPath() + "/views/error/access-denied.jsp");
            return;
        }
        
        String action = request.getParameter("action");
        
        switch (action) {
            case "add":
                addSchedule(request, response);
                break;
            case "update":
                updateSchedule(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/admin/working-schedules");
                break;
        }
    }
    
    private void listSchedules(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        List<WorkingSchedule> schedules = scheduleDAO.getAllSchedules();
        List<Doctor> doctors = doctorDAO.getAllDoctors();
        List<Shift> shifts = shiftDAO.getAllShifts();
        
        request.setAttribute("schedules", schedules);
        request.setAttribute("doctors", doctors);
        request.setAttribute("shifts", shifts);
        
        request.getRequestDispatcher("/views/admin/working-schedules.jsp").forward(request, response);
    }
    
    private void showAddForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        List<Doctor> doctors = doctorDAO.getAllDoctors();
        List<Shift> shifts = shiftDAO.getAllShifts();
        
        request.setAttribute("doctors", doctors);
        request.setAttribute("shifts", shifts);
        
        request.getRequestDispatcher("/views/admin/add-schedule.jsp").forward(request, response);
    }
    
    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            int scheduleId = Integer.parseInt(request.getParameter("id"));
            WorkingSchedule schedule = scheduleDAO.getScheduleById(scheduleId);
            
            if (schedule != null) {
                List<Doctor> doctors = doctorDAO.getAllDoctors();
                List<Shift> shifts = shiftDAO.getAllShifts();
                
                request.setAttribute("schedule", schedule);
                request.setAttribute("doctors", doctors);
                request.setAttribute("shifts", shifts);
                
                request.getRequestDispatcher("/views/admin/edit-schedule.jsp").forward(request, response);
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/working-schedules?error=schedule_not_found");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/working-schedules?error=invalid_id");
        }
    }
    
    private void showDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            int scheduleId = Integer.parseInt(request.getParameter("id"));
            WorkingSchedule schedule = scheduleDAO.getScheduleById(scheduleId);
            
            if (schedule != null) {
                request.setAttribute("schedule", schedule);
                request.getRequestDispatcher("/views/admin/schedule-detail.jsp").forward(request, response);
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/working-schedules?error=schedule_not_found");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/working-schedules?error=invalid_id");
        }
    }
    
    private void addSchedule(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            int doctorId = Integer.parseInt(request.getParameter("doctorId"));
            String weekDay = request.getParameter("weekDay");
            int shiftId = Integer.parseInt(request.getParameter("shiftId"));
            int maxPatients = Integer.parseInt(request.getParameter("maxPatients"));
            boolean isActive = "on".equals(request.getParameter("isActive"));
            
            // Validation
            if (weekDay == null || weekDay.trim().isEmpty()) {
                request.getSession().setAttribute("error", "Vui lòng chọn thứ!");
                response.sendRedirect(request.getContextPath() + "/admin/working-schedules?action=add");
                return;
            }
            
            // Kiểm tra trùng lặp
            if (scheduleDAO.checkScheduleExists(doctorId, weekDay, shiftId)) {
                request.getSession().setAttribute("error", "Bác sĩ đã có lịch làm việc cho thứ này và ca này!");
                response.sendRedirect(request.getContextPath() + "/admin/working-schedules?action=add");
                return;
            }
            
            WorkingSchedule schedule = new WorkingSchedule();
            schedule.setDoctorId(doctorId);
            schedule.setWeekDay(weekDay);
            schedule.setShiftId(shiftId);
            schedule.setMaxPatients(maxPatients);
            schedule.setActive(isActive);
            
            if (scheduleDAO.addSchedule(schedule)) {
                request.getSession().setAttribute("success", "Thêm lịch làm việc thành công!");
            } else {
                request.getSession().setAttribute("error", "Có lỗi xảy ra khi thêm lịch làm việc!");
            }
            
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("error", "Dữ liệu không hợp lệ!");
        }
        
        response.sendRedirect(request.getContextPath() + "/admin/working-schedules");
    }
    
    private void updateSchedule(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            int scheduleId = Integer.parseInt(request.getParameter("scheduleId"));
            int doctorId = Integer.parseInt(request.getParameter("doctorId"));
            String weekDay = request.getParameter("weekDay");
            int shiftId = Integer.parseInt(request.getParameter("shiftId"));
            int maxPatients = Integer.parseInt(request.getParameter("maxPatients"));
            boolean isActive = "on".equals(request.getParameter("isActive"));
            
            // Validation
            if (weekDay == null || weekDay.trim().isEmpty()) {
                request.getSession().setAttribute("error", "Vui lòng chọn thứ!");
                response.sendRedirect(request.getContextPath() + "/admin/working-schedules?action=edit&id=" + scheduleId);
                return;
            }
            
            // Kiểm tra trùng lặp (trừ schedule hiện tại)
            if (scheduleDAO.checkScheduleExists(doctorId, weekDay, shiftId, scheduleId)) {
                request.getSession().setAttribute("error", "Bác sĩ đã có lịch làm việc cho thứ này và ca này!");
                response.sendRedirect(request.getContextPath() + "/admin/working-schedules?action=edit&id=" + scheduleId);
                return;
            }
            
            WorkingSchedule schedule = new WorkingSchedule();
            schedule.setScheduleId(scheduleId);
            schedule.setDoctorId(doctorId);
            schedule.setWeekDay(weekDay);
            schedule.setShiftId(shiftId);
            schedule.setMaxPatients(maxPatients);
            schedule.setActive(isActive);
            
            if (scheduleDAO.updateSchedule(schedule)) {
                request.getSession().setAttribute("success", "Cập nhật lịch làm việc thành công!");
            } else {
                request.getSession().setAttribute("error", "Có lỗi xảy ra khi cập nhật lịch làm việc!");
            }
            
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("error", "Dữ liệu không hợp lệ!");
        }
        
        response.sendRedirect(request.getContextPath() + "/admin/working-schedules");
    }
    
    private void deleteSchedule(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            int scheduleId = Integer.parseInt(request.getParameter("id"));
            
            if (scheduleDAO.deleteSchedule(scheduleId)) {
                request.getSession().setAttribute("success", "Xóa lịch làm việc thành công!");
            } else {
                request.getSession().setAttribute("error", "Có lỗi xảy ra khi xóa lịch làm việc!");
            }
            
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("error", "ID không hợp lệ!");
        }
        
        response.sendRedirect(request.getContextPath() + "/admin/working-schedules");
    }
} 