package dal;

import models.Specialty;
import models.User;
import models.Gender;
import models.Role;
import models.Status;
import models.Doctor;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
public class DoctorDao {
    public static List<Doctor> getAllDoctors() {
        try {
            Connection connection = DBContext.makeConnection();
            PreparedStatement preparedStatement = connection.prepareStatement("select * from doctors inner join users on doctors.user_id = users.user_id inner join specialties on doctors.specialty_id = specialties.specialty_id");
            ResultSet resultSet = preparedStatement.executeQuery();
            List<Doctor> doctors = new ArrayList<>();
            while (resultSet.next()) {
                Doctor doctor = mappingDoctor(resultSet);
                doctors.add(doctor);
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
        doctor.setGender(Gender.valueOf(resultSet.getString("gender")));
        doctor.setDob(resultSet.getDate("dob"));
        doctor.setImage_url(resultSet.getString("image_url"));
        doctor.setDegree(resultSet.getString("degree"));
        doctor.setExperience(resultSet.getString("experience"));
        doctor.setStatus(Status.valueOf(resultSet.getString("status")));
        doctor.setCreated_at(resultSet.getTimestamp("doctors.created_at"));
        User user = new User();
        user.setUser_id(resultSet.getInt("users.user_id"));
        user.setUsername(resultSet.getString("username"));
        user.setPassword(resultSet.getString("password"));
        user.setFullname(resultSet.getString("full_name"));
        user.setEmail(resultSet.getString("email"));
        user.setPhone(resultSet.getString("phone"));
        Role role = new Role();
        role.setName("doctor");
        user.setRole(role);
        user.setCreated_at(resultSet.getTimestamp("users.created_at"));
        doctor.setUser(user);
        Specialty specialty = new Specialty();
        specialty.setSpecialty_id(resultSet.getInt("specialties.specialty_id"));
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

        try (Connection connection = DBContext.makeConnection();
             PreparedStatement doctorStmt = connection.prepareStatement(insertDoctorSQL)) {

            doctorStmt.setInt(1, doctor.getUser().getUser_id());
            doctorStmt.setString(2, doctor.getGender().toString());
            doctorStmt.setDate(3, doctor.getDob());
            doctorStmt.setString(4, doctor.getImage_url());
            doctorStmt.setInt(5, doctor.getSpecialty().getSpecialty_id());
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

        try (Connection connection = DBContext.makeConnection();
             PreparedStatement doctorStmt = connection.prepareStatement(updateDoctorSQL)) {

            doctorStmt.setString(1, doctor.getGender().toString());
            doctorStmt.setDate(2, doctor.getDob());
            doctorStmt.setString(3, doctor.getImage_url());
            doctorStmt.setInt(4, doctor.getSpecialty().getSpecialty_id());
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
    public static void main(String[] args) {
        System.out.println(getAllDoctors().size());
    }
}
