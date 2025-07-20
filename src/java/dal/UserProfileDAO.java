/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import models.UserProfile;

/**
 *
 * @author auiri
 */
public class UserProfileDAO {
    private final Connection conn;

    public UserProfileDAO(Connection conn) {
        this.conn = conn;
    }

    public UserProfile getUserProfile(int userId, int roleId) throws SQLException {
        System.out.println("=== GET USER PROFILE ===");
        System.out.println("UserId: " + userId);
        System.out.println("RoleId: " + roleId);
        
        UserProfile profile = new UserProfile();

        // Lấy dữ liệu từ bảng users
        String userSql = "SELECT * FROM users WHERE user_id = ?";
        try (PreparedStatement pst = conn.prepareStatement(userSql)) {
            pst.setInt(1, userId);
            try (ResultSet rs = pst.executeQuery()) {
                if (rs.next()) {
                    profile.setUserId(userId);
                    profile.setFullName(rs.getString("full_name"));
                    profile.setEmail(rs.getString("email"));
                    profile.setPhone(rs.getString("phone"));
                    profile.setRoleId(rs.getInt("role_id"));
                }
            }
        }

        // Lấy thông tin phụ thuộc vai trò
        String detailSql = null;
        switch (roleId) {
            case 1:
                detailSql = "SELECT * FROM patients WHERE user_id = ?";
                break;
            case 2:
                detailSql = "SELECT * FROM doctors WHERE user_id = ?";
                break;
            case 3:
                detailSql = "SELECT * FROM receptionists WHERE user_id = ?";
                break;
            case 5:
                detailSql = "SELECT * FROM technicians WHERE user_id = ?";
                break;
            default:
                detailSql = null;
        }

        if (detailSql == null) return profile;

        try (PreparedStatement pst = conn.prepareStatement(detailSql)) {
            pst.setInt(1, userId);
            try (ResultSet rs = pst.executeQuery()) {
                if (rs.next()) {
                    String gender = rs.getString("gender");
                    // Normalize gender to uppercase for consistency
                    if (gender != null) {
                        gender = gender.toUpperCase();
                    }
                    profile.setGender(gender);
                    profile.setDob(rs.getString(roleId == 1 ? "date_of_birth" : "dob"));
                    profile.setImageUrl(rs.getString("image_url"));
                    
                    System.out.println("Database Gender: " + gender);
                    
                    if (roleId == 1) {
                        profile.setAddress(rs.getString("address"));
                    } else if (roleId == 2) {
                        profile.setSpecialtyId(rs.getString("specialty_id"));
                        profile.setDegree(rs.getString("degree"));
                        profile.setExperience(rs.getString("experience"));
                        profile.setStatus(rs.getString("status"));
                    } else if (roleId == 3) {
                        profile.setShift(rs.getString("shift"));
                        profile.setStatus(rs.getString("status"));
                    } else if (roleId == 5) {
                        profile.setDepartment(rs.getString("department"));
                        profile.setShift(rs.getString("shift"));
                        profile.setStatus(rs.getString("status"));
                    }
                } else {
                    System.out.println("No data found for userId: " + userId + ", roleId: " + roleId);
                }
            }
        }

        return profile;
    }

    public void updateUserProfile(UserProfile profile) throws SQLException {
        // Debug logging
        System.out.println("=== UPDATE USER PROFILE ===");
        System.out.println("RoleId: " + profile.getRoleId());
        System.out.println("UserId: " + profile.getUserId());
        System.out.println("Gender: " + profile.getGender());
        
        // Cập nhật bảng users
        String updateUser = "UPDATE users SET full_name = ?, email = ?, phone = ? WHERE user_id = ?";
        try (PreparedStatement pst = conn.prepareStatement(updateUser)) {
            pst.setString(1, profile.getFullName());
            pst.setString(2, profile.getEmail());
            pst.setString(3, profile.getPhone());
            pst.setInt(4, profile.getUserId());
            int userRows = pst.executeUpdate();
            System.out.println("Users table updated rows: " + userRows);
        }

        // Cập nhật bảng theo role
        switch (profile.getRoleId()) {
            case 1: {
                String updatePatient = "UPDATE patients SET gender = ?, date_of_birth = ?, address = ?, image_url = ? WHERE user_id = ?";
                try (PreparedStatement pst = conn.prepareStatement(updatePatient)) {
                    pst.setString(1, profile.getGender());
                    pst.setString(2, profile.getDob());
                    pst.setString(3, profile.getAddress());
                    pst.setString(4, profile.getImageUrl());
                    pst.setInt(5, profile.getUserId());
                    int patientRows = pst.executeUpdate();
                    System.out.println("Patients table updated rows: " + patientRows);
                }
                break;
            }
            case 2: {
                String updateDoctor = "UPDATE doctors SET gender = ?, dob = ?, image_url = ?, specialty_id = ?, degree = ?, experience = ?, status = ? WHERE user_id = ?";
                try (PreparedStatement pst = conn.prepareStatement(updateDoctor)) {
                    pst.setString(1, profile.getGender());
                    pst.setString(2, profile.getDob());
                    pst.setString(3, profile.getImageUrl());
                    pst.setString(4, profile.getSpecialtyId());
                    pst.setString(5, profile.getDegree());
                    pst.setString(6, profile.getExperience());
                    pst.setString(7, profile.getStatus());
                    pst.setInt(8, profile.getUserId());
                    int doctorRows = pst.executeUpdate();
                    System.out.println("Doctors table updated rows: " + doctorRows);
                }
                break;
            }
            case 3: {
                String updateRecep = "UPDATE receptionists SET gender = ?, dob = ?, image_url = ?, shift = ?, status = ? WHERE user_id = ?";
                try (PreparedStatement pst = conn.prepareStatement(updateRecep)) {
                    pst.setString(1, profile.getGender());
                    pst.setString(2, profile.getDob());
                    pst.setString(3, profile.getImageUrl());
                    pst.setString(4, profile.getShift());
                    pst.setString(5, profile.getStatus());
                    pst.setInt(6, profile.getUserId());
                    int recepRows = pst.executeUpdate();
                    System.out.println("Receptionists table updated rows: " + recepRows);
                }
                break;
            }
            case 5: {
                String updateTech = "UPDATE technicians SET gender = ?, dob = ?, image_url = ?, department = ?, shift = ?, status = ? WHERE user_id = ?";
                try (PreparedStatement pst = conn.prepareStatement(updateTech)) {
                    pst.setString(1, profile.getGender());
                    pst.setString(2, profile.getDob());
                    pst.setString(3, profile.getImageUrl());
                    pst.setString(4, profile.getDepartment());
                    pst.setString(5, profile.getShift());
                    pst.setString(6, profile.getStatus());
                    pst.setInt(7, profile.getUserId());
                    int techRows = pst.executeUpdate();
                    System.out.println("Technicians table updated rows: " + techRows);
                }
                break;
            }
        }
    }
}