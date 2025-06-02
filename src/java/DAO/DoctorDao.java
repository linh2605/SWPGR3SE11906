package DAO;

import Model.*;

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
}
