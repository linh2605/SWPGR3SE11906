
package dal;

import models.Role;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class RoleDao {
    public static Role getRoleWithName(String name){
        try {
            Role role = new Role();
            Connection connection = DBContext.makeConnection();
            String sql = "select * from roles where name = ?";
            PreparedStatement preparedStatement = connection.prepareStatement(sql);
            preparedStatement.setString(1, name);
            ResultSet resultSet = preparedStatement.executeQuery();
            if(resultSet.next()){
                role.setName(resultSet.getString("name"));
                role.setDescription(resultSet.getString("description"));
                role.setRole_id(resultSet.getInt("role_id"));
                return role;
            }
            return null;
        } catch (Exception e){
            e.printStackTrace();
            return null;
        }
    }
}
