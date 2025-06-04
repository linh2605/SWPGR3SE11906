/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package DAO;

import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;
import java.sql.Connection;
import java.sql.SQLException;

/**
 *
 * @author HoangAnh
 */
public class DBContext {
    // Cấu hình cho MySQL
    private final static String host = "localhost"; // Máy local
    private final static String dbName = "swp_db";  // Database 
    private final static String portNumber = "3306"; // Cổng mặc định của MySQL
    private final static String userID = "root";    // Tài khoản MySQL
    private final static String password = "1234";  // Mật khẩu 
    
    private static HikariDataSource dataSource;
    
    static {
        HikariConfig config = new HikariConfig();
        config.setJdbcUrl("jdbc:mysql://" + host + ":" + portNumber + "/" + dbName);
        config.setUsername(userID);
        config.setPassword(password);
        config.setDriverClassName("com.mysql.cj.jdbc.Driver");
        
        // Cấu hình connection pool
        config.setMaximumPoolSize(10);
        config.setMinimumIdle(5);
        config.setIdleTimeout(300000);
        config.setConnectionTimeout(20000);
        config.addDataSourceProperty("cachePrepStmts", "true");
        config.addDataSourceProperty("prepStmtCacheSize", "250");
        config.addDataSourceProperty("prepStmtCacheSqlLimit", "2048");
        
        dataSource = new HikariDataSource(config);
    }
    
    public static Connection makeConnection() {
        try {
            return dataSource.getConnection();
        } catch (SQLException ex) {
            System.out.println("Connection error! " + ex.getMessage());
            return null;
        }
    }

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