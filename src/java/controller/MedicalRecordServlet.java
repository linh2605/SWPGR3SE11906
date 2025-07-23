package controller;

import dal.MedicalRecordDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import models.MedicalRecord;

import java.io.IOException;
import java.util.List;

@WebServlet("/medicalRecord")
public class MedicalRecordServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        try {
            if ("view".equals(action)) {
                int recordId = Integer.parseInt(request.getParameter("recordId"));
                MedicalRecord record = MedicalRecordDAO.getMedicalRecord(recordId);

                if (record != null) {
                    String patientFullName = MedicalRecordDAO.getPatientFullName(record.getPatientId());
                    String doctorFullName = MedicalRecordDAO.getDoctorFullName(record.getDoctorId());
                    record.setPatientFullName(patientFullName);
                    record.setDoctorFullName(doctorFullName);

                    request.setAttribute("medicalRecord", record);
                    request.getRequestDispatcher("views/patient/viewMedicalRecord.jsp").forward(request, response);
                } else {
                    request.setAttribute("error", "Hồ sơ bệnh án không tồn tại!");
                    request.getRequestDispatcher("views/patient/listMedicalRecords.jsp").forward(request, response);
                }

            } else if ("list".equals(action)) {
    Integer roleId = (Integer) request.getSession().getAttribute("roleId");
    Integer patientId = null;

    if (roleId != null && roleId == 1) {
        // ✅ Nếu là bệnh nhân, lấy patientId từ session
        patientId = (Integer) request.getSession().getAttribute("patientId");
        System.out.println("DEBUG (patient): patientId = " + patientId);
    } else if (roleId != null && roleId == 2) {
        // ✅ Nếu là bác sĩ, lấy patientId từ URL parameter
        patientId = Integer.parseInt(request.getParameter("patientId"));
        System.out.println("DEBUG (doctor): patientId = " + patientId);
    }

    if (patientId == null || patientId == -1) {
        request.setAttribute("error", "Không tìm thấy hồ sơ bệnh án vì thiếu PatientId.");
        request.getRequestDispatcher("/views/home/login.jsp").forward(request, response);
        return;
    }

    // Lấy danh sách hồ sơ bệnh án
    List<MedicalRecord> records = MedicalRecordDAO.getMedicalRecordsByPatientId(patientId);

    for (MedicalRecord r : records) {
        String doctorFullName = MedicalRecordDAO.getDoctorFullName(r.getDoctorId());
        r.setDoctorFullName(doctorFullName);
    }

    request.setAttribute("records", records);
    request.getRequestDispatcher("views/patient/listMedicalRecords.jsp").forward(request, response);


            } else if ("addForm".equals(action)) {
                int patientId = Integer.parseInt(request.getParameter("patientId"));
                request.setAttribute("patientId", patientId);
                request.getRequestDispatcher("views/patient/addMedicalRecord.jsp").forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Đã xảy ra lỗi trong quá trình xử lý!");
            request.getRequestDispatcher("views/patient/listMedicalRecords.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        if ("add".equals(action)) {
            addMedicalRecord(request, response);
        } else if ("update".equals(action)) {
            updateMedicalRecord(request, response);
        }
    }

    private void addMedicalRecord(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int patientId = Integer.parseInt(request.getParameter("patientId"));
            int doctorId = (int) request.getSession().getAttribute("doctorId"); // lấy từ session bác sĩ
            String diagnosis = request.getParameter("diagnosis");
            String treatment = request.getParameter("treatment");
            String prescription = request.getParameter("prescription");

            MedicalRecord record = new MedicalRecord(0, patientId, doctorId, diagnosis, treatment, prescription, null, null);
            MedicalRecordDAO.addMedicalRecord(record);

            request.setAttribute("success", "Thêm hồ sơ bệnh án thành công!");
            List<MedicalRecord> records = MedicalRecordDAO.getMedicalRecordsByPatientId(patientId);
            request.setAttribute("records", records);
            request.getRequestDispatcher("views/patient/listMedicalRecords.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Thêm hồ sơ bệnh án thất bại!");
            request.getRequestDispatcher("views/patient/addMedicalRecord.jsp").forward(request, response);
        }
    }

    private void updateMedicalRecord(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int recordId = Integer.parseInt(request.getParameter("recordId"));
            String diagnosis = request.getParameter("diagnosis");
            String treatment = request.getParameter("treatment");
            String prescription = request.getParameter("prescription");

            MedicalRecord record = new MedicalRecord(recordId, 0, 0, diagnosis, treatment, prescription, null, null);
            MedicalRecordDAO.updateMedicalRecord(record);

            request.setAttribute("success", "Cập nhật hồ sơ bệnh án thành công!");
            request.setAttribute("medicalRecord", record);
            request.getRequestDispatcher("views/patient/viewMedicalRecord.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Cập nhật hồ sơ bệnh án thất bại!");
            request.getRequestDispatcher("views/patient/viewMedicalRecord.jsp").forward(request, response);
        }
    }
}
