package controller;

import dal.ScheduleChangeDAO;
import dal.WorkingScheduleDAO;
import dal.ShiftDAO;
import models.ScheduleChange;
import models.WorkingSchedule;
import models.Shift;
import models.User;
import models.ShiftDisplay;
import java.io.IOException;
import java.sql.Date;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name="DoctorScheduleChangeServlet", urlPatterns={"/doctor/schedule-changes"})
public class DoctorScheduleChangeServlet extends HttpServlet {
    
    private ScheduleChangeDAO scheduleChangeDAO;
    private WorkingScheduleDAO workingScheduleDAO;
    private ShiftDAO shiftDAO;
    
    @Override
    public void init() {
        scheduleChangeDAO = new ScheduleChangeDAO();
        workingScheduleDAO = new WorkingScheduleDAO();
        shiftDAO = new ShiftDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        // Use AuthHelper for unified authentication
        if (!utils.AuthHelper.hasRole(request, 2)) { // 2 = doctor
            response.sendRedirect(request.getContextPath() + "/views/error/access-denied.jsp");
            return;
        }
        
        User user = utils.AuthHelper.getCurrentUser(request);
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/views/error/access-denied.jsp");
            return;
        }
        
        String action = request.getParameter("action");
        
        if (action == null) {
            action = "list";
        }
        
        switch (action) {
            case "list":
                listScheduleChanges(request, response);
                break;
            case "add":
                showAddForm(request, response);
                break;
            case "detail":
                showDetail(request, response);
                break;
            case "cancel":
                cancelScheduleChange(request, response);
                break;
            default:
                listScheduleChanges(request, response);
                break;
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Use AuthHelper for unified authentication
        if (!utils.AuthHelper.hasRole(request, 2)) { // 2 = doctor
            response.sendRedirect(request.getContextPath() + "/views/error/access-denied.jsp");
            return;
        }
        
        User user = utils.AuthHelper.getCurrentUser(request);
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/views/error/access-denied.jsp");
            return;
        }
        
        String action = request.getParameter("action");
        
        switch (action) {
            case "add":
                addScheduleChange(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/doctor/schedule-changes");
                break;
        }
    }
    
    private void listScheduleChanges(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Lấy doctor_id từ user_id
        int doctorId = workingScheduleDAO.getDoctorIdByUserId(((User) request.getSession().getAttribute("user")).getUserId());
        
        if (doctorId == -1) {
            request.getSession().setAttribute("error", "Không tìm thấy thông tin bác sĩ!");
            response.sendRedirect(request.getContextPath() + "/doctor/schedule");
            return;
        }
        
        List<ScheduleChange> changes = scheduleChangeDAO.getScheduleChangesByDoctorId(doctorId);
        List<WorkingSchedule> currentSchedules = workingScheduleDAO.getSchedulesByDoctorId(doctorId);
        
        request.setAttribute("changes", changes);
        request.setAttribute("currentSchedules", currentSchedules);
        
        request.getRequestDispatcher("/views/doctor/schedule-changes.jsp").forward(request, response);
    }
    
    private void showAddForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int doctorId = workingScheduleDAO.getDoctorIdByUserId(((User) request.getSession().getAttribute("user")).getUserId());
        if (doctorId == -1) {
            request.getSession().setAttribute("error", "Không tìm thấy thông tin bác sĩ!");
            response.sendRedirect(request.getContextPath() + "/doctor/schedule-changes");
            return;
        }
        List<WorkingSchedule> allCurrentSchedules = workingScheduleDAO.getSchedulesByDoctorId(doctorId);
        List<Shift> shifts = shiftDAO.getAllShifts();
        // Group theo shiftId
        java.util.Map<Integer, java.util.List<String>> shiftToWeekdays = new java.util.HashMap<>();
        java.util.Map<Integer, Shift> shiftMap = new java.util.HashMap<>();
        for (WorkingSchedule ws : allCurrentSchedules) {
            shiftMap.put(ws.getShiftId(), ws.getShift());
            shiftToWeekdays.computeIfAbsent(ws.getShiftId(), k -> new java.util.ArrayList<>()).add(ws.getWeekDay());
        }
        java.util.List<ShiftDisplay> shiftDisplays = new java.util.ArrayList<>();
        for (Integer shiftId : shiftToWeekdays.keySet()) {
            shiftDisplays.add(new ShiftDisplay(shiftMap.get(shiftId), shiftToWeekdays.get(shiftId)));
        }
        // Ca mới là các ca chưa làm
        java.util.Set<Integer> currentShiftIds = shiftToWeekdays.keySet();
        java.util.List<Shift> availableShifts = new java.util.ArrayList<>();
        for (Shift s : shifts) {
            if (!currentShiftIds.contains(s.getShiftId())) availableShifts.add(s);
        }
        request.setAttribute("shiftDisplays", shiftDisplays);
        request.setAttribute("shifts", availableShifts);
        request.getRequestDispatcher("/views/doctor/add-schedule-change.jsp").forward(request, response);
    }
    
    private void showDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            int changeId = Integer.parseInt(request.getParameter("id"));
            ScheduleChange change = scheduleChangeDAO.getScheduleChangeById(changeId);
            
            if (change != null) {
                // Kiểm tra xem yêu cầu có thuộc về bác sĩ này không
                int doctorId = workingScheduleDAO.getDoctorIdByUserId(((User) request.getSession().getAttribute("user")).getUserId());
                if (change.getDoctorId() == doctorId) {
                    request.setAttribute("change", change);
                    request.getRequestDispatcher("/views/doctor/schedule-change-detail.jsp").forward(request, response);
                } else {
                    response.sendRedirect(request.getContextPath() + "/doctor/schedule-changes?error=access_denied");
                }
            } else {
                response.sendRedirect(request.getContextPath() + "/doctor/schedule-changes?error=change_not_found");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/doctor/schedule-changes?error=invalid_id");
        }
    }
    
    private void addScheduleChange(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int doctorId = workingScheduleDAO.getDoctorIdByUserId(((User) request.getSession().getAttribute("user")).getUserId());
            if (doctorId == -1) {
                request.getSession().setAttribute("error", "Không tìm thấy thông tin bác sĩ!");
                response.sendRedirect(request.getContextPath() + "/doctor/schedule-changes?action=add");
                return;
            }
            int oldShiftId = Integer.parseInt(request.getParameter("oldShiftId"));
            int newShiftId = Integer.parseInt(request.getParameter("newShiftId"));
            String changeReason = request.getParameter("changeReason");
            Date effectiveDate = Date.valueOf(request.getParameter("effectiveDate"));
            Date endDate = null;
            if (request.getParameter("endDate") != null && !request.getParameter("endDate").trim().isEmpty()) {
                endDate = Date.valueOf(request.getParameter("endDate"));
            }
            // Lấy danh sách ca bác sĩ đang làm
            List<WorkingSchedule> allCurrentSchedules = workingScheduleDAO.getSchedulesByDoctorId(doctorId);
            java.util.Set<Integer> currentShiftIds = new java.util.HashSet<>();
            for (WorkingSchedule ws : allCurrentSchedules) {
                currentShiftIds.add(ws.getShiftId());
            }
            if (!currentShiftIds.contains(oldShiftId)) {
                request.getSession().setAttribute("error", "Ca hiện tại không hợp lệ!");
                response.sendRedirect(request.getContextPath() + "/doctor/schedule-changes?action=add");
                return;
            }
            if (currentShiftIds.contains(newShiftId)) {
                request.getSession().setAttribute("error", "Bạn đã làm ca này rồi!");
                response.sendRedirect(request.getContextPath() + "/doctor/schedule-changes?action=add");
                return;
            }
            // Kiểm tra đã có yêu cầu đổi ca dài hạn cho ca này chưa (pending/active)
            if (scheduleChangeDAO.hasActiveScheduleChangeForShift(doctorId, oldShiftId)) {
                request.getSession().setAttribute("error", "Bạn đã có yêu cầu đổi ca này đang chờ duyệt hoặc đang áp dụng!");
                response.sendRedirect(request.getContextPath() + "/doctor/schedule-changes?action=add");
                return;
            }
            if (changeReason == null || changeReason.trim().isEmpty()) {
                request.getSession().setAttribute("error", "Vui lòng nhập lý do đổi ca!");
                response.sendRedirect(request.getContextPath() + "/doctor/schedule-changes?action=add");
                return;
            }
            ScheduleChange change = new ScheduleChange(doctorId, oldShiftId, newShiftId, changeReason, effectiveDate, endDate);
            change.setType("change");
            if (scheduleChangeDAO.addScheduleChange(change)) {
                request.getSession().setAttribute("success", "Gửi yêu cầu thành công! Vui lòng chờ admin duyệt.");
            } else {
                request.getSession().setAttribute("error", "Có lỗi xảy ra khi gửi yêu cầu!");
            }
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("error", "Dữ liệu không hợp lệ!");
        } catch (IllegalArgumentException e) {
            request.getSession().setAttribute("error", "Ngày tháng không hợp lệ!");
        }
        response.sendRedirect(request.getContextPath() + "/doctor/schedule-changes");
    }
    
    private void cancelScheduleChange(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            int changeId = Integer.parseInt(request.getParameter("id"));
            ScheduleChange change = scheduleChangeDAO.getScheduleChangeById(changeId);
            
            if (change != null) {
                // Kiểm tra xem yêu cầu có thuộc về bác sĩ này không
                int doctorId = workingScheduleDAO.getDoctorIdByUserId(((User) request.getSession().getAttribute("user")).getUserId());
                if (change.getDoctorId() == doctorId && "pending".equals(change.getStatus())) {
                    if (scheduleChangeDAO.deleteScheduleChange(changeId)) {
                        request.getSession().setAttribute("success", "Hủy yêu cầu đổi ca thành công!");
                    } else {
                        request.getSession().setAttribute("error", "Có lỗi xảy ra khi hủy yêu cầu!");
                    }
                } else {
                    request.getSession().setAttribute("error", "Không thể hủy yêu cầu này!");
                }
            } else {
                request.getSession().setAttribute("error", "Không tìm thấy yêu cầu đổi ca!");
            }
            
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("error", "ID không hợp lệ!");
        }
        
        response.sendRedirect(request.getContextPath() + "/doctor/schedule-changes");
    }
} 