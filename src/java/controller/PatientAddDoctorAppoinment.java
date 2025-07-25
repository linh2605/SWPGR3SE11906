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
import dal.WorkingScheduleDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;
import models.Appointment;
import models.Doctor;
import models.Patient;
import models.Service;
import models.Shift;
import java.util.ArrayList;
import models.WorkingSchedule;

/**
 *
 * @author New_user
 */
@WebServlet(name = "PatientAddAppoinmentDoctor", urlPatterns = {"/appointment-doctor"})
public class PatientAddDoctorAppoinment extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Use AuthHelper for unified authentication
            if (!utils.AuthHelper.hasRole(request, 1)) { // 1 = patient
                request.setAttribute("errorMsg", "Chỉ bệnh nhân mới được đặt lịch");
                request.getRequestDispatcher("/views/error/access-denied.jsp").forward(request, response);
                return;
            }

            Integer userId = utils.AuthHelper.getCurrentUserId(request);
            if (userId == null) {
                request.setAttribute("errorMsg", "Vui lòng đăng nhập để thực hiện thao tác này");
                request.getRequestDispatcher("/views/home/login.jsp").forward(request, response);
                return;
            }
            Patient patient = PatientDao.getPatientByUserId(userId);
            if (patient == null || patient.getUser() == null) {
                request.setAttribute("errorMsg", "Không tìm thấy thông tin bệnh nhân.");
                request.getRequestDispatcher("/views/home/login.jsp").forward(request, response);
                return;
            }

            
            if (request.getParameter("id") != null 
                && request.getParameter("id").length() > 0) {
                int doctor_id = Integer.parseInt(request.getParameter("id"));
                Doctor doctor = DoctorDao.getDoctorById(doctor_id);
                if (doctor.getDoctor_id() != 0) {
                    request.setAttribute("d", doctor);
                    List<Service> services = ServiceDAO.getServicesByDoctorId(doctor_id);
                    List<WorkingSchedule> schedules = new WorkingScheduleDAO().getSchedulesByDoctorId(doctor_id);
                    List<Shift> shifts = new ShiftDAO().getAllShifts();

                    if (services == null) {
                        services = new ArrayList<>();
                    }
                    if (shifts == null) {
                        shifts = new ArrayList<>();
                    }

                    request.setAttribute("doctor", doctor);
                    request.setAttribute("patient", patient);
                    request.setAttribute("services", services);
                    request.setAttribute("schedules", schedules);
                    request.setAttribute("shifts", shifts);
                } else {
                    request.setAttribute("errorMsg", "Không tìm thấy bác sĩ cần đặt");
                    request.getRequestDispatcher("/views/layouts/notification-page.jsp").forward(request, response);
                }
            } else {
                request.setAttribute("errorMsg", "Không tìm thấy bác sĩ cần đặt");
                request.getRequestDispatcher("/views/layouts/notification-page.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMsg", "Có lỗi xảy ra khi tải trang đặt lịch: " + e.getMessage());
        }

        request.getRequestDispatcher("/views/appointment/make-doctor-appointment.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            System.out.println("[DEBUG] PatientAddAppoinmentDoctor.doPost() - Starting appointment creation");

            int patientId = Integer.parseInt(request.getParameter("patientId"));
            int doctorId = Integer.parseInt(request.getParameter("doctor"));
            int packageId = Integer.parseInt(request.getParameter("service")); // service parameter vẫn giữ nguyên tên để không ảnh hưởng frontend
            int shiftId = Integer.parseInt(request.getParameter("shift"));
            String dateStr = request.getParameter("appointmentDate"); // yyyy-MM-dd

            System.out.println("[DEBUG] Parameters received:");
            System.out.println("[DEBUG] - patientId: " + patientId);
            System.out.println("[DEBUG] - doctorId: " + doctorId);
            System.out.println("[DEBUG] - packageId: " + packageId);
            System.out.println("[DEBUG] - shiftId: " + shiftId);
            System.out.println("[DEBUG] - dateStr: " + dateStr);

            // Validate date string
            if (dateStr == null || dateStr.trim().isEmpty()) {
                System.out.println("[DEBUG] Date string is null or empty");
                request.setAttribute("errorMsg", "Vui lòng chọn ngày hẹn.");
                loadFormData(request, patientId, doctorId, packageId, null, "");
                request.getRequestDispatcher("/views/appointment/make-doctor-appointment.jsp").forward(request, response);
                return;
            }

            // Parse date with proper error handling
            LocalDate date;
            try {
                date = LocalDate.parse(dateStr.trim(),DateTimeFormatter.ofPattern("dd/MM/yyyy"));
                System.out.println("[DEBUG] Date parsed successfully: " + date);
            } catch (Exception e) {
                System.out.println("[DEBUG] Date parsing failed: " + e.getMessage());
                request.setAttribute("errorMsg", "Định dạng ngày không hợp lệ. Vui lòng chọn lại ngày.");
                loadFormData(request, patientId, doctorId, packageId, null, "");
                request.getRequestDispatcher("/views/appointment/make-doctor-appointment.jsp").forward(request, response);
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
            String errorMsg = validateAppointment(patientId, doctorId, packageId, appointmentDate, shiftId);
            if (errorMsg != null) {
                System.out.println("[DEBUG] Validation failed: " + errorMsg);
                request.setAttribute("errorMsg", errorMsg);
                // Reload data for form
                loadFormData(request, patientId, doctorId, packageId, appointmentDate, note);
                request.getRequestDispatcher("/views/appointment/make-doctor-appointment.jsp").forward(request, response);
                return;
            }

            System.out.println("[DEBUG] Validation passed, creating appointment object...");

            Appointment appointment = new Appointment();
            Patient p = new Patient();
            p.setPatient_id(patientId);
            Doctor d = new Doctor();
            d.setDoctor_id(doctorId);
            Service s = new Service();
            s.setServiceId(packageId); // packageId được map thành serviceId trong ServiceDAO

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
                loadFormData(request, patientId, doctorId, packageId, appointmentDate, note);
                request.getRequestDispatcher("/views/appointment/make-doctor-appointment.jsp").forward(request, response);
            }
        } catch (NumberFormatException e) {
            System.out.println("[DEBUG] NumberFormatException: " + e.getMessage());
            request.setAttribute("errorMsg", "Dữ liệu không hợp lệ. Vui lòng kiểm tra lại thông tin.");
            request.getRequestDispatcher("/views/appointment/make-doctor-appointment.jsp").forward(request, response);
        } catch (Exception e) {
            System.out.println("[DEBUG] General Exception: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("errorMsg", "Có lỗi xảy ra: " + e.getMessage());
            request.getRequestDispatcher("/views/appointment/make-doctor-appointment.jsp").forward(request, response);
        }
    }

    /**
     * Validate appointment data
     */
    private String validateAppointment(int patientId, int doctorId, int packageId, LocalDateTime appointmentDate, int shiftId) {
        System.out.println("[DEBUG] validateAppointment - Starting validation");

        // Check if doctor can provide this service
        System.out.println("[DEBUG] Checking if doctor can provide service...");
        if (!AppointmentDao.canDoctorProvideService(doctorId, packageId)) {
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
    private void loadFormData(HttpServletRequest request, int patientId, int doctorId, int packageId, LocalDateTime appointmentDate, String note) {
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
            request.setAttribute("selectedServiceId", packageId);

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
