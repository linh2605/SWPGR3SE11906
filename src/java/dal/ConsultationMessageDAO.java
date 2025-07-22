package dal;

import models.ConsultationMessage;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ConsultationMessageDAO {

    // Thêm tin nhắn mới
    public static int addMessage(ConsultationMessage message) throws SQLException {
        String sql = "INSERT INTO consultation_messages (session_id, message_content, message_type, sender_type, sender_id, is_read, created_at) VALUES (?, ?, ?, ?, ?, ?, NOW())";
        try (Connection conn = DBContext.makeConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            stmt.setInt(1, message.getSession_id());
            stmt.setString(2, message.getMessage_content());
            stmt.setString(3, message.getMessage_type());
            stmt.setString(4, message.getSender_type());
            stmt.setInt(5, message.getSender_id());
            stmt.setBoolean(6, message.isIs_read());
            
            int affectedRows = stmt.executeUpdate();
            
            if (affectedRows > 0) {
                try (ResultSet rs = stmt.getGeneratedKeys()) {
                    if (rs.next()) {
                        return rs.getInt(1);
                    }
                }
            }
        } catch (SQLException e) {
            System.err.println("Error adding consultation message: " + e.getMessage());
            e.printStackTrace();
            throw e;
        }
        return -1;
    }

    // Lấy tất cả tin nhắn của một phiên tư vấn
    public static List<ConsultationMessage> getMessagesBySession(int sessionId) throws SQLException {
        List<ConsultationMessage> messages = new ArrayList<>();
        String sql = "SELECT * FROM consultation_messages WHERE session_id = ? ORDER BY created_at ASC";
        
        try (Connection conn = DBContext.makeConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, sessionId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    messages.add(extractFromResultSet(rs));
                }
            }
        }
        return messages;
    }

    // Đánh dấu tất cả tin nhắn đã đọc
    public static boolean markAllAsRead(int sessionId, String senderType, int senderId) throws SQLException {
        String sql = "UPDATE consultation_messages SET is_read = true WHERE session_id = ? AND sender_type != ? AND sender_id != ?";
        try (Connection conn = DBContext.makeConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, sessionId);
            stmt.setString(2, senderType);
            stmt.setInt(3, senderId);
            
            return stmt.executeUpdate() > 0;
        }
    }

    // Đếm số tin nhắn chưa đọc
    public static int countUnreadMessages(int sessionId, String senderType, int senderId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM consultation_messages WHERE session_id = ? AND sender_type != ? AND sender_id != ? AND is_read = false";
        try (Connection conn = DBContext.makeConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, sessionId);
            stmt.setString(2, senderType);
            stmt.setInt(3, senderId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }
        return 0;
    }

    private static ConsultationMessage extractFromResultSet(ResultSet rs) throws SQLException {
        ConsultationMessage message = new ConsultationMessage();
        message.setMessage_id(rs.getInt("message_id"));
        message.setSession_id(rs.getInt("session_id"));
        message.setMessage_content(rs.getString("message_content"));
        message.setMessage_type(rs.getString("message_type"));
        message.setSender_type(rs.getString("sender_type"));
        message.setSender_id(rs.getInt("sender_id"));
        message.setIs_read(rs.getBoolean("is_read"));
        message.setCreated_at(rs.getTimestamp("created_at"));
        // updated_at column doesn't exist in database
        return message;
    }
} 