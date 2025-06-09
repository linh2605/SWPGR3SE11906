package dal;

import models.ContactMessage;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ContactMessageDAO {
    
    public boolean createMessage(ContactMessage message) {
        try {
            Connection connection = DBContext.makeConnection();
            PreparedStatement stmt = connection.prepareStatement(
                "INSERT INTO contact_messages (name, email, phone, subject, message, status, priority) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?)"
            );
            stmt.setString(1, message.getName());
            stmt.setString(2, message.getEmail());
            stmt.setString(3, message.getPhone());
            stmt.setString(4, message.getSubject());
            stmt.setString(5, message.getMessage());
            stmt.setString(6, "pending");
            stmt.setString(7, "medium");
            
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public List<ContactMessage> getAllMessages() {
        List<ContactMessage> messages = new ArrayList<>();
        try {
            Connection connection = DBContext.makeConnection();
            PreparedStatement stmt = connection.prepareStatement(
                "SELECT * FROM contact_messages ORDER BY created_at DESC"
            );
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                ContactMessage message = new ContactMessage();
                message.setMessage_id(rs.getInt("message_id"));
                message.setName(rs.getString("name"));
                message.setEmail(rs.getString("email"));
                message.setPhone(rs.getString("phone"));
                message.setSubject(rs.getString("subject"));
                message.setMessage(rs.getString("message"));
                message.setStatus(rs.getString("status"));
                message.setPriority(rs.getString("priority"));
                message.setAssigned_to(rs.getInt("assigned_to"));
                message.setCreated_at(rs.getTimestamp("created_at"));
                message.setUpdated_at(rs.getTimestamp("updated_at"));
                messages.add(message);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return messages;
    }
    
    public boolean updateMessageStatus(int messageId, String status) {
        try {
            Connection connection = DBContext.makeConnection();
            PreparedStatement stmt = connection.prepareStatement(
                "UPDATE contact_messages SET status = ? WHERE message_id = ?"
            );
            stmt.setString(1, status);
            stmt.setInt(2, messageId);
            
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public boolean assignMessage(int messageId, int userId) {
        try {
            Connection connection = DBContext.makeConnection();
            PreparedStatement stmt = connection.prepareStatement(
                "UPDATE contact_messages SET assigned_to = ?, status = 'in_progress' WHERE message_id = ?"
            );
            stmt.setInt(1, userId);
            stmt.setInt(2, messageId);
            
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public boolean updateMessagePriority(int messageId, String priority) {
        try {
            Connection connection = DBContext.makeConnection();
            PreparedStatement stmt = connection.prepareStatement(
                "UPDATE contact_messages SET priority = ? WHERE message_id = ?"
            );
            stmt.setString(1, priority);
            stmt.setInt(2, messageId);
            
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public List<ContactMessage> getMessagesByStatus(String status) {
        List<ContactMessage> messages = new ArrayList<>();
        try {
            Connection connection = DBContext.makeConnection();
            PreparedStatement stmt = connection.prepareStatement(
                "SELECT * FROM contact_messages WHERE status = ? ORDER BY created_at DESC"
            );
            stmt.setString(1, status);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                ContactMessage message = new ContactMessage();
                message.setMessage_id(rs.getInt("message_id"));
                message.setName(rs.getString("name"));
                message.setEmail(rs.getString("email"));
                message.setPhone(rs.getString("phone"));
                message.setSubject(rs.getString("subject"));
                message.setMessage(rs.getString("message"));
                message.setStatus(rs.getString("status"));
                message.setPriority(rs.getString("priority"));
                message.setAssigned_to(rs.getInt("assigned_to"));
                message.setCreated_at(rs.getTimestamp("created_at"));
                message.setUpdated_at(rs.getTimestamp("updated_at"));
                messages.add(message);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return messages;
    }
    
    public boolean deleteMessage(int messageId) {
        try {
            Connection connection = DBContext.makeConnection();
            PreparedStatement stmt = connection.prepareStatement(
                "DELETE FROM contact_messages WHERE message_id = ?"
            );
            stmt.setInt(1, messageId);
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public ContactMessage getMessageById(int messageId) {
        try {
            Connection connection = DBContext.makeConnection();
            PreparedStatement stmt = connection.prepareStatement(
                "SELECT * FROM contact_messages WHERE message_id = ?"
            );
            stmt.setInt(1, messageId);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                ContactMessage message = new ContactMessage();
                message.setMessage_id(rs.getInt("message_id"));
                message.setName(rs.getString("name"));
                message.setEmail(rs.getString("email"));
                message.setPhone(rs.getString("phone"));
                message.setSubject(rs.getString("subject"));
                message.setMessage(rs.getString("message"));
                message.setStatus(rs.getString("status"));
                message.setPriority(rs.getString("priority"));
                message.setAssigned_to(rs.getInt("assigned_to"));
                message.setCreated_at(rs.getTimestamp("created_at"));
                message.setUpdated_at(rs.getTimestamp("updated_at"));
                return message;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
}