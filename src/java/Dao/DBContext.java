package Model;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;

public class DBContext {
    public static Connection getConnection(){
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            String serverName = "mysql-a943150-tranquangminh050802-8c52.g.aivencloud.com";
            String port = "24719";
            String databaseName = "defaultdb";
            String username = "avnadmin";
            String password = "AVNS_aKeOgaBsPidcv6PHRUx";
            String url = "jdbc:mysql://" + serverName + ":" + port + "/" + databaseName + "?useSSL=true";
            return DriverManager.getConnection(url, username, password);
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
            return null;
        }
    }

    public static boolean executeUpdate(String sql, String[] fields) {// insert update delete
        Connection connection = getConnection();
        try {
            assert connection != null;
            PreparedStatement preparedStatement = connection.prepareStatement(sql);
            for (int i = 0; i < fields.length; i++) {
                preparedStatement.setString(i + 1, fields[i]);
            }
            int row = preparedStatement.executeUpdate();
            connection.close();
            return row > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}
