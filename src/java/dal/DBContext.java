/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package dal;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 *
 * @author HoangAnh
 */
public class DBContext{
    
    public static Connection makeConnection() {
        try {
            // URL cho MySQL: jdbc:mysql://<host>:<port>/<databaseName>
            String url = "jdbc:mysql://" + host + ":" + portNumber + "/" + dbName;
            Class.forName("com.mysql.cj.jdbc.Driver");
            return DriverManager.getConnection(url, userID, password);
        } catch (SQLException ex) {
            System.out.println("Connection error! " + ex.getMessage());
        } catch (ClassNotFoundException ex) {
            System.out.println("MySQL JDBC Driver not found! " + ex.getMessage());
        }
        return null;
    }
    
    // Cấu hình cho MySQL
    private final static String host = "localhost"; // Máy local
    private final static String dbName = "swp_db";  // Database 
    private final static String portNumber = "3306"; // Cổng mặc định của MySQL
    private final static String userID = "root";    // Tài khoản MySQL
    private final static String password = "1234";  // Mật khẩu 

    public static void main(String[] args) {
        Connection connection = DBContext.makeConnection();

        if (connection != null) {
            System.out.println("Kết nối thành công đến cơ sở dữ liệu!");
            try {
                // Đóng kết nối sau khi sử dụng
                connection.close();
                System.out.println("Đã đóng kết nối.");
            } catch (SQLException ex) {
                System.out.println("Đóng kết nối không thành công: " + ex.getMessage());
            }
        } else {
            System.out.println("Kết nối không thành công.");
        }
    }
}