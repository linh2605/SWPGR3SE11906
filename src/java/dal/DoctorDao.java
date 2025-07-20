package dal;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import models.Doctor;
import models.Gender;
import models.Role;
import models.Specialty;
import models.Status;
import models.User;

public class DoctorDao {

    public static void deleteDoctor(int userId) {
        try {
            String sql = "update doctors set status = 'inactive' where user_id = ?";
            Connection conn = DBContext.makeConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public static List<Doctor> getAllDoctors() {

        try {
            Connection connection = DBContext.makeConnection();
            PreparedStatement preparedStatement = connection.prepareStatement("select * from doctors inner join users on doctors.user_id = users.user_id inner join specialties on doctors.specialty_id = specialties.specialty_id where doctors.status = 'active'");
            ResultSet resultSet = preparedStatement.executeQuery();
            List<Doctor> doctors = new ArrayList<>();
            while (resultSet.next()) {
                Doctor doctor = mappingDoctor(resultSet);
                doctors.add(doctor);
            }
            System.out.println("DoctorDao.getAllDoctors() - Retrieved " + doctors.size() + " active doctors");
            return doctors;
        } catch (Exception e) {
            e.printStackTrace();
            System.err.println("Error in DoctorDao.getAllDoctors(): " + e.getMessage());
            return new ArrayList<>();
        }
    }

    public static List<Doctor> getAllDeletedDoctors() {
        try {
            Connection connection = DBContext.makeConnection();
            PreparedStatement preparedStatement = connection.prepareStatement("select * from doctors inner join users on doctors.user_id = users.user_id inner join specialties on doctors.specialty_id = specialties.specialty_id");
            ResultSet resultSet = preparedStatement.executeQuery();
            List<Doctor> doctors = new ArrayList<>();
            while (resultSet.next()) {
                Doctor doctor = mappingDoctor(resultSet);
                doctors.add(doctor);
            }
            System.out.println("DoctorDao.getAllDoctors() - Retrieved " + doctors.size() + " doctors");
            return doctors;
        } catch (Exception e) {
            e.printStackTrace();
            System.err.println("Error in DoctorDao.getAllDoctors(): " + e.getMessage());
            return new ArrayList<>();
        }
    }

    // sort theo số appoinment đang pending hiện tại của bác sĩ tăng dần
    public static List<Doctor> getDoctorsBySpecialityId(int specialityId) {
        List<Doctor> doctors = new ArrayList<>();
        String sql = "  WITH booked_doctors\n"
                + "	       AS (SELECT doctor_id\n"
                + "	                , COUNT(doctor_id) AS appointment_count\n"
                + "	             FROM (SELECT doctor_id\n"
                + "	                     FROM appointments\n"
                + "	                    WHERE appointment_date >= NOW()\n"
                + "	                      AND status = 'pending'\n"
                + "	                  ) AS pending_appointments\n"
                + "	            GROUP BY doctor_id\n"
                + "	  )\n"
                + "SELECT d.doctor_id\n"
                + "	 , d.user_id\n"
                + "	 , u.full_name\n"
                + "	 , specialty_id\n"
                + "	 , degree\n"
                + "	 , experience\n"
                + "  FROM doctors d\n"
                + "	       JOIN users u\n"
                + "	       ON d.user_id = u.user_id\n"
                + "	       LEFT JOIN booked_doctors bd\n"
                + "	       ON d.doctor_id = bd.doctor_id\n"
                + " WHERE d.status = 'active'\n"
                + "   AND specialty_id = ?\n"
                + "  ORDER BY appointment_count ASC;";
        try {
            Connection connection = DBContext.makeConnection();
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, specialityId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Doctor d = new Doctor();
                d.setDoctor_id(rs.getInt("doctor_id"));
                User u = new User();
                u.setUserId(rs.getInt("user_id"));
                u.setFullName(rs.getString("full_name"));
                d.setUser(u);
                d.setFullName(rs.getString("full_name"));
                Specialty s = new Specialty();
                s.setSpecialtyId(rs.getInt("specialty_id"));
                d.setSpecialty(s);
                d.setDegree(rs.getString("degree"));
                d.setExperience(rs.getString("experience"));
                doctors.add(d);
            }
            return doctors;
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }

    private static Doctor mappingDoctor(ResultSet resultSet) throws SQLException {
        Doctor doctor = new Doctor();
        doctor.setDoctor_id(resultSet.getInt("doctor_id"));
        String genderStr = resultSet.getString("gender");
        if (genderStr != null && !genderStr.trim().isEmpty()) {
            try {
                doctor.setGender(Gender.valueOf(genderStr.toUpperCase()));
            } catch (IllegalArgumentException e) {
                // Log error and set default
                System.err.println("Invalid gender value in database: " + genderStr);
                doctor.setGender(Gender.OTHER);
            }
        } else {
            doctor.setGender(Gender.OTHER);
        }
        doctor.setDob(resultSet.getDate("dob"));
        doctor.setImage_url(resultSet.getString("image_url"));
        doctor.setDegree(resultSet.getString("degree"));
        doctor.setExperience(resultSet.getString("experience"));

        String statusStr = resultSet.getString("status");
        if (statusStr != null && !statusStr.trim().isEmpty()) {
            try {
                doctor.setStatus(Status.valueOf(statusStr));
            } catch (IllegalArgumentException e) {
                System.err.println("Invalid status value in database: " + statusStr);
                doctor.setStatus(Status.active);
            }
        } else {
            doctor.setStatus(Status.active);
        }

        doctor.setCreated_at(resultSet.getTimestamp("doctors.created_at"));
        User user = new User();
        user.setUserId(resultSet.getInt("users.user_id"));
        user.setUsername(resultSet.getString("username"));
        user.setPassword(resultSet.getString("password"));
        user.setFullName(resultSet.getString("full_name"));
        user.setEmail(resultSet.getString("email"));
        user.setPhone(resultSet.getString("phone"));
        user.setCreatedAt(resultSet.getTimestamp("users.created_at"));
        Role role = new Role();
        role.setName("doctor");
        user.setRole(role);
        doctor.setUser(user);
        Specialty specialty = new Specialty();
        specialty.setSpecialtyId(resultSet.getInt("specialties.specialty_id"));
        specialty.setName(resultSet.getString("name"));
        specialty.setDescription(resultSet.getString("description"));
        doctor.setSpecialty(specialty);
        return doctor;
    }

    public static Doctor getDoctorById(int doctor_id) {
        try {
            Connection connection = DBContext.makeConnection();
            PreparedStatement preparedStatement = connection.prepareStatement("select * from doctors inner join users on doctors.user_id = users.user_id inner join specialties on doctors.specialty_id = specialties.specialty_id where doctor_id = ?");
            preparedStatement.setInt(1, doctor_id);
            ResultSet resultSet = preparedStatement.executeQuery();
            if (resultSet.next()) {
                return mappingDoctor(resultSet);
            } else {
                return new Doctor();
            }
        } catch (Exception e) {
            e.printStackTrace();
            return new Doctor();
        }
    }

    public static boolean insertDoctor(Doctor doctor) {
        String insertDoctorSQL = "INSERT INTO doctors (user_id, gender, dob, image_url, specialty_id, degree, experience, status) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection connection = DBContext.makeConnection(); PreparedStatement doctorStmt = connection.prepareStatement(insertDoctorSQL)) {

            doctorStmt.setInt(1, doctor.getUser().getUserId());
            doctorStmt.setString(2, doctor.getGender().toString());
            doctorStmt.setDate(3, doctor.getDob());
            doctorStmt.setString(4, doctor.getImage_url());
            doctorStmt.setInt(5, doctor.getSpecialty().getSpecialtyId());
            doctorStmt.setString(6, doctor.getDegree());
            doctorStmt.setString(7, doctor.getExperience());
            doctorStmt.setString(8, doctor.getStatus().toString());

            int rowsAffected = doctorStmt.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public static boolean updateDoctor(Doctor doctor) {
        String updateDoctorSQL = "UPDATE doctors SET gender = ?, dob = ?, image_url = ?, specialty_id = ?, degree = ?, experience = ?, status = ? WHERE doctor_id = ?";

        try (Connection connection = DBContext.makeConnection(); PreparedStatement doctorStmt = connection.prepareStatement(updateDoctorSQL)) {

            doctorStmt.setString(1, doctor.getGender().toString());
            doctorStmt.setDate(2, doctor.getDob());
            doctorStmt.setString(3, doctor.getImage_url());
            doctorStmt.setInt(4, doctor.getSpecialty().getSpecialtyId());
            doctorStmt.setString(5, doctor.getDegree());
            doctorStmt.setString(6, doctor.getExperience());
            doctorStmt.setString(7, doctor.getStatus().toString());
            doctorStmt.setInt(8, doctor.getDoctor_id());

            return doctorStmt.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public int countAllDoctors() {
        String sql = "SELECT COUNT(*) FROM doctors";
        try (Connection conn = DBContext.makeConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    // Đếm số bác sĩ có sẵn (active, có lịch làm việc hôm nay, không bị ngoại lệ/nghỉ)
    public int countAvailableDoctors() {
        String sql = "SELECT COUNT(DISTINCT d.doctor_id) "
                + "FROM doctors d "
                + "JOIN working_schedules ws ON d.doctor_id = ws.doctor_id AND ws.is_active = 1 "
                + "JOIN shifts s ON ws.shift_id = s.shift_id "
                + "WHERE d.status = 'active' "
                + "AND ws.week_day = DAYNAME(NOW()) "
                + "AND TIME(NOW()) BETWEEN s.start_time AND s.end_time "
                + "AND d.doctor_id NOT IN (SELECT doctor_id FROM schedule_exceptions WHERE exception_date = CURDATE())";
        try (Connection conn = DBContext.makeConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    /**
     * Lấy danh sách doctors có thể cung cấp service cụ thể
     */
    public static List<Doctor> getDoctorsByServiceId(int serviceId) {
        List<Doctor> doctors = new ArrayList<>();
        String sql = "SELECT DISTINCT d.doctor_id\n"
                + "              , d.user_id\n"
                + "              , u.full_name\n"
                + "              , d.specialty_id\n"
                + "              , s.name AS specialty_name\n"
                + "              , d.degree\n"
                + "              , d.experience\n"
                + "  FROM doctors d\n"
                + "	       JOIN users u\n"
                + "	       ON d.user_id = u.user_id\n"
                + "	       JOIN doctor_services ds\n"
                + "	       ON d.doctor_id = ds.doctor_id\n"
                + "	       JOIN specialties s\n"
                + "	       ON d.specialty_id = s.specialty_id\n"
                + " WHERE ds.service_id = ?\n"
                + "   AND d.status = 'active'\n"
                + " ORDER BY u.full_name";
        try (Connection conn = DBContext.makeConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, serviceId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Doctor d = new Doctor();
                    d.setDoctor_id(rs.getInt("doctor_id"));
                    User u = new User();
                    u.setUserId(rs.getInt("user_id"));
                    u.setFullName(rs.getString("full_name"));
                    d.setUser(u);
                    d.setFullName(rs.getString("full_name"));
                    Specialty s = new Specialty();
                    s.setSpecialtyId(rs.getInt("specialty_id"));
                    s.setName(rs.getString("specialty_name"));
                    d.setSpecialty(s);
                    d.setDegree(rs.getString("degree"));
                    d.setExperience(rs.getString("experience"));
                    doctors.add(d);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return doctors;
    }

    public static void main(String[] args) {
        System.out.println(getAllDoctors().size());
    }
}
