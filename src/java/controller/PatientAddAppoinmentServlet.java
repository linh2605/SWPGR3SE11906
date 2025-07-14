/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dal.AppointmentDao;
import dal.DoctorDao;
import dal.PatientDao;
import dal.ServiceDAO;
import dal.ShiftDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;
import models.Appointment;
import models.Doctor;
import models.Patient;
import models.Service;
import models.Shift;
import java.util.ArrayList;

/**
 *
 * @author New_user
 */
@WebServlet(name = "PatientAddAppoinmentServlet", urlPatterns = {"/appointment"})
public class PatientAddAppoinmentServlet extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet PatientAddAppoinmentServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet PatientAddAppoinmentServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            HttpSession session = request.getSession();
            if (session.getAttribute("roleId") == null || session.getAttribute("userId") == null) {
                request.setAttribute("errorMsg", "Vui lòng đăng nhập để thực hiện thao tác này");
                request.getRequestDispatcher("/views/home/login.jsp").forward(request, response);
                return;
            }

            int roleId = (int) session.getAttribute("roleId");
            if (roleId != 1) { // 1: patient
                request.setAttribute("errorMsg", "Chỉ bệnh nhân mới được đặt lịch");
                request.getRequestDispatcher("/views/home/login.jsp").forward(request, response);
                return;
            }

            int userId = (int) session.getAttribute("userId");
            Patient patient = PatientDao.getPatientByUserId(userId);
            if (patient == null || patient.getUser() == null) {
                request.setAttribute("errorMsg", "Không tìm thấy thông tin bệnh nhân.");
                request.getRequestDispatcher("/views/home/login.jsp").forward(request, response);
                return;
            }

            List<Doctor> doctors = DoctorDao.getAllDoctors();
            List<Service> services = ServiceDAO.getTopServices(10);
            List<Shift> shifts = new ShiftDAO().getAllShifts();

            if (doctors == null) {
                doctors = new ArrayList<>();
            }
            if (services == null) {
                services = new ArrayList<>();
            }
            if (shifts == null) {
                shifts = new ArrayList<>();
            }

            // sort theo chuyên khoa cho dễ nhìn
            Collections.sort(doctors, new Comparator<Doctor>() {
                @Override
                public int compare(Doctor d1, Doctor d2) {
                    if (d1.getSpecialty() == null || d2.getSpecialty() == null) {
                        return 0;
                    }
                    int specialty_id1 = d1.getSpecialty().getSpecialtyId();
                    int specialty_id2 = d2.getSpecialty().getSpecialtyId();
                    if (specialty_id1 == specialty_id2) {
                        return d1.getDoctor_id() - d2.getDoctor_id();
                    } else {
                        return specialty_id1 - specialty_id2;
                    }
                }
            });

            request.setAttribute("patient", patient);
            request.setAttribute("doctors", doctors);
            request.setAttribute("services", services);
            request.setAttribute("shifts", shifts);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMsg", "Có lỗi xảy ra khi tải trang đặt lịch: " + e.getMessage());
        }

        request.getRequestDispatcher("/views/appointment/make-appointment.jsp").forward(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            System.out.println("[DEBUG] PatientAddAppoinmentServlet.doPost() - Starting appointment creation");

            String fullName = request.getParameter("fullName");
            String phone = request.getParameter("phone");
            String email = request.getParameter("email");

            int patientId = Integer.parseInt(request.getParameter("patientId"));
            int doctorId = Integer.parseInt(request.getParameter("doctor"));
            int serviceId = Integer.parseInt(request.getParameter("service"));
            int shiftId = Integer.parseInt(request.getParameter("shift"));
            String dateStr = request.getParameter("appointmentDate"); // yyyy-MM-dd

            System.out.println("[DEBUG] Parameters received:");
            System.out.println("[DEBUG] - patientId: " + patientId);
            System.out.println("[DEBUG] - doctorId: " + doctorId);
            System.out.println("[DEBUG] - serviceId: " + serviceId);
            System.out.println("[DEBUG] - shiftId: " + shiftId);
            System.out.println("[DEBUG] - dateStr: " + dateStr);

            // Validate date string
            if (dateStr == null || dateStr.trim().isEmpty()) {
                System.out.println("[DEBUG] Date string is null or empty");
                request.setAttribute("errorMsg", "Vui lòng chọn ngày hẹn.");
                loadFormData(request, patientId, doctorId, serviceId, null, "");
                request.getRequestDispatcher("/views/appointment/make-appointment.jsp").forward(request, response);
                return;
            }

            // Parse date with proper error handling
            LocalDate date;
            try {
                date = LocalDate.parse(dateStr.trim());
                System.out.println("[DEBUG] Date parsed successfully: " + date);
            } catch (Exception e) {
                System.out.println("[DEBUG] Date parsing failed: " + e.getMessage());
                request.setAttribute("errorMsg", "Định dạng ngày không hợp lệ. Vui lòng chọn lại ngày.");
                loadFormData(request, patientId, doctorId, serviceId, null, "");
                request.getRequestDispatcher("/views/appointment/make-appointment.jsp").forward(request, response);
                return;
            }

            // Lấy giờ bắt đầu của ca làm việc
            Shift shift = new ShiftDAO().getShiftById(shiftId);
            LocalTime time = (shift != null) ? shift.getStartTime().toLocalTime() : LocalTime.of(0, 0);
            LocalDateTime appointmentDate = LocalDateTime.of(date, time);
            String note = request.getParameter("note") != null ? request.getParameter("note").trim() : "";

            System.out.println("[DEBUG] Appointment date created: " + appointmentDate);
            System.out.println("[DEBUG] Shift: " + (shift != null ? shift.getName() : "null"));

            // Validation
            System.out.println("[DEBUG] Starting validation...");
            String errorMsg = validateAppointment(patientId, doctorId, serviceId, appointmentDate, shiftId);
            if (errorMsg != null) {
                System.out.println("[DEBUG] Validation failed: " + errorMsg);
                request.setAttribute("errorMsg", errorMsg);
                // Reload data for form
                loadFormData(request, patientId, doctorId, serviceId, appointmentDate, note);
                request.getRequestDispatcher("/views/appointment/make-appointment.jsp").forward(request, response);
                return;
            }

            System.out.println("[DEBUG] Validation passed, creating appointment object...");

            Appointment appointment = new Appointment();
            Patient p = new Patient();
            p.setPatient_id(patientId);
            Doctor d = new Doctor();
            d.setDoctor_id(doctorId);
            Service s = new Service();
            s.setServiceId(serviceId);

            appointment.setPatient(p);
            appointment.setDoctor(d);
            appointment.setService(s);
            appointment.setAppointmentDateTime(appointmentDate);
            appointment.setNote(note);

            System.out.println("[DEBUG] Calling AppointmentDao.createAppointment()...");
            boolean isSuccess = AppointmentDao.createAppointment(appointment);
            System.out.println("[DEBUG] createAppointment result: " + isSuccess);

            if (isSuccess) {
                System.out.println("[DEBUG] Appointment created successfully!");
                request.setAttribute("successMsg", "Đặt lịch khám thành công!");
                request.setAttribute("note", "appointmentSuccess");
                request.getRequestDispatcher("/views/layouts/notification-page.jsp").forward(request, response);
            } else {
                System.out.println("[DEBUG] Appointment creation failed!");
                request.setAttribute("errorMsg", "Đặt lịch khám thất bại, vui lòng thử lại.");
                loadFormData(request, patientId, doctorId, serviceId, appointmentDate, note);
                request.getRequestDispatcher("/views/appointment/make-appointment.jsp").forward(request, response);
            }
        } catch (NumberFormatException e) {
            System.out.println("[DEBUG] NumberFormatException: " + e.getMessage());
            request.setAttribute("errorMsg", "Dữ liệu không hợp lệ. Vui lòng kiểm tra lại thông tin.");
            request.getRequestDispatcher("/views/appointment/make-appointment.jsp").forward(request, response);
        } catch (Exception e) {
            System.out.println("[DEBUG] General Exception: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("errorMsg", "Có lỗi xảy ra: " + e.getMessage());
            request.getRequestDispatcher("/views/appointment/make-appointment.jsp").forward(request, response);
        }
    }

    /**
     * Validate appointment data
     */
    private String validateAppointment(int patientId, int doctorId, int serviceId, LocalDateTime appointmentDate, int shiftId) {
        System.out.println("[DEBUG] validateAppointment - Starting validation");

        // Check if doctor can provide this service
        System.out.println("[DEBUG] Checking if doctor can provide service...");
        if (!AppointmentDao.canDoctorProvideService(doctorId, serviceId)) {
            System.out.println("[DEBUG] Doctor cannot provide this service");
            return "Bác sĩ này không cung cấp dịch vụ đã chọn.";
        }
        System.out.println("[DEBUG] Doctor can provide this service");

        // Chuyển appointmentDate sang week_day tiếng Việt
        String weekDayVN = getVietnameseWeekDay(appointmentDate.toLocalDate());
        System.out.println("[DEBUG] Week day in Vietnamese: " + weekDayVN);

        // Check if doctor is available at this week_day and shift
        System.out.println("[DEBUG] Checking if doctor is available by week day and shift...");
        if (!AppointmentDao.isDoctorAvailableByWeekDayAndShift(doctorId, weekDayVN, shiftId)) {
            System.out.println("[DEBUG] Doctor is not available by week day and shift");
            return "Bác sĩ không có lịch làm việc vào ca này.";
        }
        System.out.println("[DEBUG] Doctor is available by week day and shift");

        // Check if slot is available
        System.out.println("[DEBUG] Checking if slot is available...");
        if (!AppointmentDao.isSlotAvailable(doctorId, appointmentDate)) {
            System.out.println("[DEBUG] Slot is not available");
            return "Không còn slot trống cho bác sĩ vào thời gian này.";
        }
        System.out.println("[DEBUG] Slot is available");

        // Check if appointment date is in the future
        System.out.println("[DEBUG] Checking if appointment date is in the future...");
        if (appointmentDate.isBefore(LocalDateTime.now())) {
            System.out.println("[DEBUG] Appointment date is in the past");
            return "Không thể đặt lịch trong quá khứ.";
        }
        System.out.println("[DEBUG] Appointment date is in the future");

        System.out.println("[DEBUG] All validations passed");
        return null; // No errors
    }

    // Hàm chuyển LocalDate sang week_day tiếng Việt
    private String getVietnameseWeekDay(java.time.LocalDate date) {
        switch (date.getDayOfWeek()) {
            case MONDAY:
                return "Thứ 2";
            case TUESDAY:
                return "Thứ 3";
            case WEDNESDAY:
                return "Thứ 4";
            case THURSDAY:
                return "Thứ 5";
            case FRIDAY:
                return "Thứ 6";
            case SATURDAY:
                return "Thứ 7";
            case SUNDAY:
                return "Chủ nhật";
            default:
                return "";
        }
    }

    /**
     * Load form data for error cases
     */
    private void loadFormData(HttpServletRequest request, int patientId, int doctorId, int serviceId, LocalDateTime appointmentDate, String note) {
        try {
            Patient patient = PatientDao.getPatientById(patientId);
            List<Doctor> doctors = DoctorDao.getAllDoctors();
            List<Service> services = ServiceDAO.getTopServices(10);

            if (doctors == null) {
                doctors = new ArrayList<>();
            }
            if (services == null) {
                services = new ArrayList<>();
            }

            Collections.sort(doctors, new Comparator<Doctor>() {
                @Override
                public int compare(Doctor d1, Doctor d2) {
                    if (d1.getSpecialty() == null || d2.getSpecialty() == null) {
                        return 0;
                    }
                    int specialty_id1 = d1.getSpecialty().getSpecialtyId();
                    int specialty_id2 = d2.getSpecialty().getSpecialtyId();
                    if (specialty_id1 == specialty_id2) {
                        return d1.getDoctor_id() - d2.getDoctor_id();
                    } else {
                        return specialty_id1 - specialty_id2;
                    }
                }
            });

            request.setAttribute("patient", patient);
            request.setAttribute("doctors", doctors);
            request.setAttribute("services", services);
            request.setAttribute("selectedDoctorId", doctorId);
            request.setAttribute("selectedServiceId", serviceId);

            // Format appointmentDate thành string cho input datetime-local
            if (appointmentDate != null) {
                String formattedDate = appointmentDate.format(java.time.format.DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm"));
                request.setAttribute("appointmentDate", formattedDate);
            }

            request.setAttribute("note", note);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
