package dal;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import models.News;
import models.User;

public class NewsDAO {

    public static List<News> getAllNews() {
        List<News> newsList = new ArrayList<>();
        String sql = "SELECT id\n"
                + "	 , title\n"
                + "      , image_preview\n"
                + "      , short_description\n"
                + "	 , description\n"
                + "	 , n.created_at\n"
                + "	 , updated_at\n"
                + "	 , created_by\n"
                + "	 , u.full_name\n"
                + "  FROM news n\n"
                + "	       JOIN users u\n"
                + "	       ON n.created_by = u.user_id\n"
                + "ORDER BY n.created_at DESC;";

        try (Connection conn = DBContext.makeConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                News news = new News();
                news.setNewsID(rs.getInt("id"));
                news.setTitle(rs.getString("title"));
                news.setImagePreview(rs.getString("image_preview"));
                news.setShortDescription(rs.getString("short_description"));
                news.setDescription(rs.getString("description"));
                news.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
                news.setUpdatedAt(rs.getTimestamp("updated_at").toLocalDateTime());
                System.out.println(news.getFormattedCreatedAt());
                User u = new User();
                u.setUserId(rs.getInt("created_by"));
                u.setFullName(rs.getString("full_name"));
                news.setCreatedBy(u);

                newsList.add(news);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return newsList;
    }

    public static List<News> getLastestNewsLimit(int limit) {
        List<News> newsList = new ArrayList<>();
        String sql = "SELECT id\n"
                + "	 , title\n"
                + "      , image_preview\n"
                + "      , short_description\n"
                + "	 , description\n"
                + "	 , n.created_at\n"
                + "	 , updated_at\n"
                + "	 , created_by\n"
                + "	 , u.full_name\n"
                + "  FROM news n\n"
                + "	       JOIN users u\n"
                + "	       ON n.created_by = u.user_id\n"
                + " ORDER BY n.created_at DESC\n"
                + " LIMIT ?;";

        try {
            Connection conn = DBContext.makeConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, limit);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                News news = new News();
                news.setNewsID(rs.getInt("id"));
                news.setTitle(rs.getString("title"));
                news.setImagePreview(rs.getString("image_preview"));
                news.setShortDescription(rs.getString("short_description"));
                news.setDescription(rs.getString("description"));
                news.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
                news.setUpdatedAt(rs.getTimestamp("updated_at").toLocalDateTime());
                System.out.println(news.getFormattedCreatedAt());
                User u = new User();
                u.setUserId(rs.getInt("created_by"));
                u.setFullName(rs.getString("full_name"));
                news.setCreatedBy(u);

                newsList.add(news);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return newsList;
    }

    public static News getNewsById(int newsID) {
        try {
            String sql = "SELECT id\n"
                    + "	 , title\n"
                    + "      , image_preview\n"
                    + "      , short_description\n"
                    + "	 , description\n"
                    + "	 , n.created_at\n"
                    + "	 , updated_at\n"
                    + "	 , created_by\n"
                    + "	 , u.full_name\n"
                    + "  FROM news n\n"
                    + "	       JOIN users u\n"
                    + "	       ON n.created_by = u.user_id\n"
                    + " WHERE n.id = ?;";
            Connection connection = DBContext.makeConnection();
            PreparedStatement preparedStatement = connection.prepareStatement(sql);
            preparedStatement.setInt(1, newsID);
            ResultSet rs = preparedStatement.executeQuery();
            if (rs.next()) {
                News news = new News();
                news.setNewsID(rs.getInt("id"));
                news.setTitle(rs.getString("title"));
                news.setImagePreview(rs.getString("image_preview"));
                news.setShortDescription(rs.getString("short_description"));
                news.setDescription(rs.getString("description"));
                news.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
                news.setUpdatedAt(rs.getTimestamp("updated_at").toLocalDateTime());
                System.out.println(news.getFormattedCreatedAt());
                User u = new User();
                u.setUserId(rs.getInt("created_by"));
                u.setFullName(rs.getString("full_name"));
                news.setCreatedBy(u);
                return news;
            } else {
                return new News();
            }
        } catch (Exception e) {
            e.printStackTrace();
            return new News();
        }
    }
}
