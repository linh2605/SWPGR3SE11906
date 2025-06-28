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
            List<Appointment> affectedAppointments = AppointmentDao.findAppointmentsByDoctorAndDateRange(
                change.getDoctorId(), 
                change.getEffectiveDate().toString(), 
                change.getEndDate() != null ? change.getEndDate().toString() : "2099-12-31"
            );
            // Gợi ý bác sĩ thay thế cho từng appointment (an toàn null)
            for (Appointment appt : affectedAppointments) {
                Integer specialtyId = null;
                if (appt.getDoctor() != null && appt.getDoctor().getSpecialty() != null) {
                    specialtyId = appt.getDoctor().getSpecialty().getSpecialtyId();
                }
                if (specialtyId != null) {
                    Doctor suggested = AppointmentDao.findAvailableDoctorForAppointment(
                        specialtyId,
                        appt.getAppointmentDate(),
                        appt.getAppointmentTime(),
                        change.getDoctorId()
                    );
                    appt.setSuggestedDoctor(suggested);
                } else {
                    appt.setSuggestedDoctor(null);
                }
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
        String decision = request.getParameter("decision");
        System.out.println("[DEBUG] processScheduleChangeApproval: changeId=" + changeId + ", decision=" + decision);
        
        ScheduleChange change = scheduleChangeDAO.getById(changeId);
        if (change == null) {
            System.out.println("[DEBUG] Không tìm thấy yêu cầu đổi ca với changeId=" + changeId);
            request.setAttribute("error", "Không tìm thấy yêu cầu đổi ca");
            doGet(request, response);
            return;
        }
        
        if ("approve".equals(decision)) {
            System.out.println("[DEBUG] Duyệt yêu cầu đổi ca: " + change);
            boolean success = workingScheduleDAO.updateScheduleShiftForDoctor(
                change.getDoctorId(),
                change.getOldShiftId(),
                change.getNewShiftId(),
                change.getEffectiveDate().toString(),
                change.getEndDate() != null ? change.getEndDate().toString() : null
            );
            System.out.println("[DEBUG] updateScheduleShiftForDoctor result: " + success);
            if (!success) {
                System.out.println("[DEBUG] Không thể cập nhật ca làm việc cho bác sĩ");
                request.setAttribute("error", "Không thể cập nhật ca làm việc. Vui lòng thử lại.");
                doGet(request, response);
                return;
            }
            List<Appointment> affectedAppointments = AppointmentDao.findAppointmentsByDoctorAndDateRange(
                change.getDoctorId(), 
                change.getEffectiveDate().toString(), 
                change.getEndDate() != null ? change.getEndDate().toString() : "2099-12-31"
            );
            System.out.println("[DEBUG] Số lịch hẹn bị ảnh hưởng: " + affectedAppointments.size());
            List<Appointment> reassignedAppointments = new ArrayList<>();
            List<Appointment> cancelledAppointments = new ArrayList<>();
            for (Appointment appt : affectedAppointments) {
                Integer specialtyId = null;
                if (appt.getDoctor() != null && appt.getDoctor().getSpecialty() != null) {
                    specialtyId = appt.getDoctor().getSpecialty().getSpecialtyId();
                }
                Doctor replacementDoctor = null;
                if (specialtyId != null) {
                    replacementDoctor = AppointmentDao.findAvailableDoctorForAppointment(
                        specialtyId,
                        appt.getAppointmentDate(),
                        appt.getAppointmentTime(),
                        change.getDoctorId()
                    );
                }
                if (replacementDoctor != null) {
                    System.out.println("[DEBUG] Chuyển lịch hẹn " + appt.getId() + " sang bác sĩ " + replacementDoctor.getDoctor_id());
                    AppointmentDao.updateAppointmentDoctor(appt.getId(), replacementDoctor.getDoctor_id());
                    reassignedAppointments.add(appt);
                    EmailServices.sendAppointmentReassigned(appt, replacementDoctor);
                } else {
                    System.out.println("[DEBUG] Huỷ lịch hẹn " + appt.getId() + " do không có bác sĩ thay thế");
                    AppointmentDao.cancelAppointment(appt.getId());
                    cancelledAppointments.add(appt);
                    EmailServices.sendAppointmentCancelled(appt);
                }
            }
            change.setStatus("approved");
            scheduleChangeDAO.update(change);
            EmailServices.sendScheduleChangeApproved(change, reassignedAppointments, cancelledAppointments);
            System.out.println("[DEBUG] Đã duyệt yêu cầu đổi ca thành công.");
            request.setAttribute("success", "Đã duyệt yêu cầu đổi ca thành công.");
        } else if ("reject".equals(decision)) {
            System.out.println("[DEBUG] Từ chối yêu cầu đổi ca: " + change);
            change.setStatus("rejected");
            scheduleChangeDAO.update(change);
            EmailServices.sendScheduleChangeRejected(change);
            System.out.println("[DEBUG] Đã từ chối yêu cầu đổi ca.");
            request.setAttribute("success", "Đã từ chối yêu cầu đổi ca");
        } else {
            System.out.println("[DEBUG] Quyết định không hợp lệ: " + decision);
        }
        doGet(request, response);
    }
} 