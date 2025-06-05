package dal;

import model.Status;
import model.User;
import model.Role;
import model.Gender;
import model.Specialty;
import model.Doctor;

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
        String insertUserSQL = "INSERT INTO users (username, password, full_name, email, phone, role_id) VALUES (?, ?, ?, ?, ?, ?)";
        String insertDoctorSQL = "INSERT INTO doctors (user_id, gender, dob, image_url, specialty_id, degree, experience, status) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection connection = DBContext.makeConnection()) {
            connection.setAutoCommit(false);

            // Insert user
            try (PreparedStatement userStmt = connection.prepareStatement(insertUserSQL, PreparedStatement.RETURN_GENERATED_KEYS)) {
                User user = doctor.getUser();
                userStmt.setString(1, user.getUsername());
                userStmt.setString(2, user.getPassword());
                userStmt.setString(3, user.getFullname());
                userStmt.setString(4, user.getEmail());
                userStmt.setString(5, user.getPhone());
                userStmt.setInt(6, 2); // role_id for doctor, adjust if needed

                userStmt.executeUpdate();
                ResultSet rs = userStmt.getGeneratedKeys();
                if (rs.next()) {
                    int userId = rs.getInt(1);

                    // Insert doctor
                    try (PreparedStatement doctorStmt = connection.prepareStatement(insertDoctorSQL)) {
                        doctorStmt.setInt(1, userId);
                        doctorStmt.setString(2, doctor.getGender().toString());
                        doctorStmt.setDate(3, doctor.getDob());
                        doctorStmt.setString(4, doctor.getImage_url());
                        doctorStmt.setInt(5, doctor.getSpecialty().getSpecialty_id());
                        doctorStmt.setString(6, doctor.getDegree());
                        doctorStmt.setString(7, doctor.getExperience());
                        doctorStmt.setString(8, doctor.getStatus().toString());

                        doctorStmt.executeUpdate();
                    }
                }

                connection.commit();
                return true;
            } catch (SQLException e) {
                connection.rollback();
                e.printStackTrace();
                return false;
            }
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    public static boolean updateDoctor(Doctor doctor) {
        String updateUserSQL = "UPDATE users SET full_name = ?, email = ?, phone = ? WHERE user_id = ?";
        String updateDoctorSQL = "UPDATE doctors SET gender = ?, dob = ?, image_url = ?, specialty_id = ?, degree = ?, experience = ?, status = ? WHERE doctor_id = ?";

        try (Connection connection = DBContext.makeConnection()) {
            connection.setAutoCommit(false);

            // Update user
            try (PreparedStatement userStmt = connection.prepareStatement(updateUserSQL)) {
                User user = doctor.getUser();
                userStmt.setString(1, user.getFullname());
                userStmt.setString(2, user.getEmail());
                userStmt.setString(3, user.getPhone());
                userStmt.setInt(4, user.getUser_id());
                userStmt.executeUpdate();
            }

            // Update doctor
            try (PreparedStatement doctorStmt = connection.prepareStatement(updateDoctorSQL)) {
                doctorStmt.setString(1, doctor.getGender().toString());
                doctorStmt.setDate(2, doctor.getDob());
                doctorStmt.setString(3, doctor.getImage_url());
                doctorStmt.setInt(4, doctor.getSpecialty().getSpecialty_id());
                doctorStmt.setString(5, doctor.getDegree());
                doctorStmt.setString(6, doctor.getExperience());
                doctorStmt.setString(7, doctor.getStatus().toString());
                doctorStmt.setInt(8, doctor.getDoctor_id());
                doctorStmt.executeUpdate();
            }
            connection.commit();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}
