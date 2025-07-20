package controller;

import dal.WorkingScheduleDAO;
import dal.DoctorDao;
import dal.ShiftDAO;
import dal.ScheduleExceptionDAO;
import models.WorkingSchedule;
import models.Doctor;
import models.Shift;
import models.User;
import models.ScheduleException;
import java.sql.Date;
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
    private ScheduleExceptionDAO exceptionDAO;
    
    @Override
    public void init() {
        scheduleDAO = new WorkingScheduleDAO();
        doctorDAO = new DoctorDao();
        shiftDAO = new ShiftDAO();
        exceptionDAO = new ScheduleExceptionDAO();
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
        
        if (action == null || action.equals("list")) {
            listSchedules(request, response);
        } else {
            switch (action) {
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
        
        // Lấy các tham số filter
        String doctorFilter = request.getParameter("doctorFilter");
        String dayFilter = request.getParameter("dayFilter");
        String shiftFilter = request.getParameter("shiftFilter");
        
        List<WorkingSchedule> schedules;
        
        // Áp dụng filter nếu có
        if ((doctorFilter != null && !doctorFilter.trim().isEmpty()) ||
            (dayFilter != null && !dayFilter.trim().isEmpty()) ||
            (shiftFilter != null && !shiftFilter.trim().isEmpty())) {
            
            schedules = scheduleDAO.getSchedulesWithFilters(doctorFilter, dayFilter, shiftFilter);
        } else {
            schedules = scheduleDAO.getAllSchedules();
        }
        
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
            
            // Validate ngày ngoại lệ (exception)
            List<ScheduleException> exceptions = exceptionDAO.getExceptionsByDoctorId(doctorId);
            for (ScheduleException ex : exceptions) {
                // Nếu exception có trạng thái đang chờ duyệt hoặc đã duyệt
                if ("Chờ duyệt".equals(ex.getStatus()) || "Đã duyệt".equals(ex.getStatus())) {
                    // Nếu exception trùng thứ (weekDay) với lịch làm việc đang thêm
                    java.util.Calendar cal = java.util.Calendar.getInstance();
                    cal.setTime(ex.getExceptionDate());
                    int exDayOfWeek = cal.get(java.util.Calendar.DAY_OF_WEEK);
                    int scheduleDayOfWeek = getDayOfWeek(weekDay);
                    if (exDayOfWeek == scheduleDayOfWeek) {
                        request.getSession().setAttribute("error", "Bác sĩ đã có ngoại lệ (" + ex.getExceptionType() + ") vào ngày này!");
                        response.sendRedirect(request.getContextPath() + "/admin/working-schedules?action=add");
                        return;
                    }
                }
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

            // Validate ngày ngoại lệ (exception)
            List<ScheduleException> exceptions = exceptionDAO.getExceptionsByDoctorId(doctorId);
            for (ScheduleException ex : exceptions) {
                if ("Chờ duyệt".equals(ex.getStatus()) || "Đã duyệt".equals(ex.getStatus())) {
                    java.util.Calendar cal = java.util.Calendar.getInstance();
                    cal.setTime(ex.getExceptionDate());
                    int exDayOfWeek = cal.get(java.util.Calendar.DAY_OF_WEEK);
                    int scheduleDayOfWeek = getDayOfWeek(weekDay);
                    if (exDayOfWeek == scheduleDayOfWeek) {
                        request.getSession().setAttribute("error", "Bác sĩ đã có ngoại lệ (" + ex.getExceptionType() + ") vào ngày này!");
                        response.sendRedirect(request.getContextPath() + "/admin/working-schedules?action=edit&id=" + scheduleId);
                        return;
                    }
                }
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

    // Hàm chuyển thứ tiếng Việt sang Calendar.DAY_OF_WEEK
    private int getDayOfWeek(String weekDay) {
        switch (weekDay.trim().toLowerCase()) {
            case "chủ nhật": return java.util.Calendar.SUNDAY;
            case "thứ 2": return java.util.Calendar.MONDAY;
            case "thứ 3": return java.util.Calendar.TUESDAY;
            case "thứ 4": return java.util.Calendar.WEDNESDAY;
            case "thứ 5": return java.util.Calendar.THURSDAY;
            case "thứ 6": return java.util.Calendar.FRIDAY;
            case "thứ 7": return java.util.Calendar.SATURDAY;
            default: return -1;
        }
    }
} 