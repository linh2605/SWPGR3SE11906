package controller;

import dal.ScheduleChangeDAO;
import dal.WorkingScheduleDAO;
import dal.AppointmentDao;
import dal.DoctorDao;
import dal.ShiftDAO;
import models.ScheduleChange;
import models.User;
import models.Doctor;
import models.Appointment;
import models.Shift;
import models.WorkingSchedule;
import controller.auth.util.EmailServices;
import java.io.IOException;
import java.sql.Date;
import java.util.List;
import java.util.ArrayList;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name="AdminScheduleChangeServlet", urlPatterns={"/admin/schedule-changes"})
public class AdminScheduleChangeServlet extends HttpServlet {
    private ScheduleChangeDAO scheduleChangeDAO;
    private WorkingScheduleDAO workingScheduleDAO;
    private DoctorDao doctorDao;
    private ShiftDAO shiftDAO;
    private AppointmentDao appointmentDao;

    @Override
    public void init() throws ServletException {
        scheduleChangeDAO = new ScheduleChangeDAO();
        workingScheduleDAO = new WorkingScheduleDAO();
        doctorDao = new DoctorDao();
        shiftDAO = new ShiftDAO();
        appointmentDao = new AppointmentDao();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null || user.getRole().getRoleId() != 4) { // 4 = admin
            response.sendRedirect(request.getContextPath() + "/views/home/login.jsp?error=access_denied");
            return;
        }
        String action = request.getParameter("action");
        if (action == null) action = "list";
        switch (action) {
            case "detail":
                showDetail(request, response);
                break;
            default:
                listScheduleChanges(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null || user.getRole().getRoleId() != 4) {
            response.sendRedirect(request.getContextPath() + "/views/home/login.jsp?error=access_denied");
            return;
        }
        String action = request.getParameter("action");
        if ("process".equals(action)) {
            processScheduleChangeApproval(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/schedule-changes");
        }
    }

    private void listScheduleChanges(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<ScheduleChange> changes = scheduleChangeDAO.getAll();
        request.setAttribute("changes", changes);
        request.getRequestDispatcher("/views/admin/schedule-changes.jsp").forward(request, response);
    }

    private void showDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int changeId = Integer.parseInt(request.getParameter("id"));
            ScheduleChange change = scheduleChangeDAO.getById(changeId);
            if (change == null) {
                request.getSession().setAttribute("error", "Không tìm thấy yêu cầu đổi ca!");
                response.sendRedirect(request.getContextPath() + "/admin/schedule-changes");
                return;
            }
            // Lấy danh sách appointment bị ảnh hưởng
            List<Appointment> affectedAppointments = appointmentDao.findAppointmentsByDoctorAndDateRange(
                change.getDoctor().getDoctor_id(), 
                change.getEffectiveDate().toString(), 
                change.getEndDate() != null ? change.getEndDate().toString() : "2099-12-31"
            );
            // Gợi ý bác sĩ thay thế cho từng appointment
            for (Appointment appt : affectedAppointments) {
                Doctor suggested = appointmentDao.findAvailableDoctorForAppointment(
                    appt.getDoctor().getSpecialty().getSpecialty_id(),
                    appt.getAppointmentDate(),
                    appt.getAppointmentTime(),
                    change.getDoctor().getDoctor_id()
                );
                appt.setSuggestedDoctor(suggested);
            }
            request.setAttribute("change", change);
            request.setAttribute("affectedAppointments", affectedAppointments);
            request.getRequestDispatcher("/views/admin/schedule-change-detail.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/schedule-changes?error=invalid_id");
        }
    }

    private void processScheduleChangeApproval(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int changeId = Integer.parseInt(request.getParameter("changeId"));
        String action = request.getParameter("action");
        
        ScheduleChange change = scheduleChangeDAO.getById(changeId);
        if (change == null) {
            request.setAttribute("error", "Không tìm thấy yêu cầu đổi ca");
            doGet(request, response);
            return;
        }
        
        if ("approve".equals(action)) {
            // Cập nhật working schedule - sử dụng method có sẵn
            workingScheduleDAO.updateScheduleChangeForDoctor(
                change.getDoctor().getDoctor_id(),
                change.getNewShift().getShiftId(),
                change.getEffectiveDate().toString(),
                change.getEndDate() != null ? change.getEndDate().toString() : null
            );
            
            // Xử lý các lịch hẹn bị ảnh hưởng
            List<Appointment> affectedAppointments = appointmentDao.findAppointmentsByDoctorAndDateRange(
                change.getDoctor().getDoctor_id(), 
                change.getEffectiveDate().toString(), 
                change.getEndDate() != null ? change.getEndDate().toString() : "2099-12-31"
            );
            
            List<Appointment> reassignedAppointments = new ArrayList<>();
            List<Appointment> cancelledAppointments = new ArrayList<>();
            
            for (Appointment appt : affectedAppointments) {
                // Tìm bác sĩ thay thế
                Doctor replacementDoctor = appointmentDao.findAvailableDoctorForAppointment(
                    appt.getDoctor().getSpecialty().getSpecialty_id(),
                    appt.getAppointmentDate(),
                    appt.getAppointmentTime(),
                    change.getDoctor().getDoctor_id()
                );
                
                if (replacementDoctor != null) {
                    // Chuyển lịch hẹn sang bác sĩ khác
                    appointmentDao.updateAppointmentDoctor(appt.getId(), replacementDoctor.getDoctor_id());
                    reassignedAppointments.add(appt);
                    
                    // Gửi email thông báo
                    EmailServices.sendAppointmentReassigned(appt, replacementDoctor);
                } else {
                    // Huỷ lịch hẹn nếu không tìm được bác sĩ thay thế
                    appointmentDao.cancelAppointment(appt.getId());
                    cancelledAppointments.add(appt);
                    
                    // Gửi email thông báo
                    EmailServices.sendAppointmentCancelled(appt);
                }
            }
            
            // Cập nhật trạng thái schedule change
            change.setStatus("approved");
            scheduleChangeDAO.update(change);
            
            // Gửi email thông báo cho bác sĩ
            EmailServices.sendScheduleChangeApproved(change, reassignedAppointments, cancelledAppointments);
            
            request.setAttribute("success", "Đã duyệt yêu cầu đổi ca thành công. " + 
                reassignedAppointments.size() + " lịch hẹn được chuyển, " + 
                cancelledAppointments.size() + " lịch hẹn bị huỷ.");
                
        } else if ("reject".equals(action)) {
            // Cập nhật trạng thái schedule change
            change.setStatus("rejected");
            scheduleChangeDAO.update(change);
            
            // Gửi email thông báo cho bác sĩ
            EmailServices.sendScheduleChangeRejected(change);
            
            request.setAttribute("success", "Đã từ chối yêu cầu đổi ca");
        }
        
        doGet(request, response);
    }
} 