package dal;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import models.Doctor;
import models.Service;
import models.ServiceType;

import javax.print.Doc;

public class ServiceDAO {

    public static Service getServiceById(int serviceId) {
        String sql = "SELECT service_id, name, detail, price, type, image FROM services WHERE service_id = ?";
        try (Connection conn = DBContext.makeConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, serviceId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Service s = new Service();
                    s.setServiceId(rs.getInt("service_id"));
                    s.setName(rs.getString("name"));
                    s.setDetail(rs.getString("detail"));
                    s.setPrice(rs.getLong("price"));
                    String typeStr = rs.getString("type");
                    s.setImage(rs.getString("image"));
                    if (typeStr != null && !typeStr.trim().isEmpty()) {
                        try {
                            s.setType(ServiceType.valueOf(typeStr));
                        } catch (IllegalArgumentException e) {
                            System.err.println("Invalid service type value in database: " + typeStr);
                            s.setType(ServiceType.SPECIALIST);
                        }
                    } else {
                        s.setType(ServiceType.SPECIALIST);
                    }
                    List<DoctorService> doctorServices = ServiceDAO.getDoctorService();
                    List<Doctor> doctors = DoctorDao.getAllDeletedDoctors();
                    List<Doctor> temp = new ArrayList<>();
                    for (int i = 0; i < doctorServices.size(); i++) {
                        if (doctorServices.get(i).service_id == serviceId) {
                            temp.add(ServiceDAO.searchDoctor(doctors, doctorServices.get(i).doctor_id));
                        }
                    }
                    s.setDoctors(temp);
                    return s;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public static List<Service> getTopServices(int limit) {
        List<Service> list = new ArrayList<>();
        String sql = "SELECT service_id, name, detail, price, type, image FROM services LIMIT ?";
        try (Connection conn = DBContext.makeConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Service s = new Service();
                    s.setServiceId(rs.getInt("service_id"));
                    s.setName(rs.getString("name"));
                    s.setDetail(rs.getString("detail"));
                    s.setPrice(rs.getLong("price"));
                    String typeStr = rs.getString("type");
                    s.setImage(rs.getString("image"));
                    if (typeStr != null && !typeStr.trim().isEmpty()) {
                        try {
                            s.setType(ServiceType.valueOf(typeStr));
                        } catch (IllegalArgumentException e) {
                            System.err.println("Invalid service type value in database: " + typeStr);
                            s.setType(ServiceType.SPECIALIST);
                        }
                    } else {
                        s.setType(ServiceType.SPECIALIST);
                    }
                    list.add(s);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public static List<Service> getServicesByDoctorId(int doctorId) {
        List<Service> list = new ArrayList<>();
        String sql = "SELECT s.service_id, name, detail, price, type, image\n"
                + "  FROM services s\n"
                + "	JOIN doctor_services ds ON s.service_id = ds.service_id\n"
                + " WHERE ds.doctor_id = ?";
        try (Connection conn = DBContext.makeConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, doctorId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Service s = new Service();
                    s.setServiceId(rs.getInt("service_id"));
                    s.setName(rs.getString("name"));
                    s.setDetail(rs.getString("detail"));
                    s.setPrice(rs.getLong("price"));
                    String typeStr = rs.getString("type");
                    s.setImage(rs.getString("image"));
                    if (typeStr != null && !typeStr.trim().isEmpty()) {
                        try {
                            s.setType(ServiceType.valueOf(typeStr));
                        } catch (IllegalArgumentException e) {
                            System.err.println("Invalid service type value in database: " + typeStr);
                            s.setType(ServiceType.SPECIALIST);
                        }
                    } else {
                        s.setType(ServiceType.SPECIALIST);
                    }
                    list.add(s);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
    
    public static List<Service> getTopPopularServices(int limit) {
        List<Service> list = new ArrayList<>();
        String sql = "SELECT s.service_id, s.name, s.detail, s.price, s.image, s.type, COUNT(a.appointment_id) as count " +
                "FROM services s LEFT JOIN appointments a ON s.service_id = a.service_id " +
                "GROUP BY s.service_id, s.name, s.detail, s.price, s.type, s.image " +
                "ORDER BY count DESC LIMIT ?";
        try (Connection conn = DBContext.makeConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Service s = new Service();
                    s.setServiceId(rs.getInt("service_id"));
                    s.setName(rs.getString("name"));
                    s.setDetail(rs.getString("detail"));
                    s.setPrice(rs.getLong("price"));
                    String typeStr = rs.getString("type");
                    s.setImage(rs.getString("image"));
                    if (typeStr != null && !typeStr.trim().isEmpty()) {
                        try {
                            s.setType(ServiceType.valueOf(typeStr));
                        } catch (IllegalArgumentException e) {
                            System.err.println("Invalid service type value in database: " + typeStr);
                            s.setType(ServiceType.SPECIALIST);
                        }
                    } else {
                        s.setType(ServiceType.SPECIALIST);
                    }
                    list.add(s);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public static class DoctorService{
        int doctor_id;
        int service_id;

        public DoctorService(int doctor_id, int service_id) {
            this.doctor_id = doctor_id;
            this.service_id = service_id;
        }
    }

    public static List<Service> getAll(){
        List<Service> list = new ArrayList<>();
        try {
            String sql = "select * from services";
            Connection connection = DBContext.makeConnection();
            PreparedStatement ps = connection.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            List<Doctor> doctors = DoctorDao.getAllDeletedDoctors();
            List<DoctorService> doctorServices = getDoctorService();
            while (rs.next()) {
                Service s = new Service();
                s.setServiceId(rs.getInt("service_id"));
                s.setName(rs.getString("name"));
                s.setDetail(rs.getString("detail"));
                s.setPrice(rs.getLong("price"));
                s.setType(ServiceType.valueOf(rs.getString("type")));
                s.setImage(rs.getString("image"));
                List<Doctor> temp = new ArrayList<>();
                for (int i = 0; i < doctorServices.size(); i++) {
                    if (doctorServices.get(i).service_id == s.getService_id()){
                        temp.add(searchDoctor(doctors, doctorServices.get(i).doctor_id));
                    }
                }
                s.setDoctors(temp);
                list.add(s);
            }
        } catch (Exception e){
            e.printStackTrace();
        }
        return list;
    }

    public static Doctor searchDoctor(List<Doctor> doctors, int doctor_id){
        for (Doctor doctor : doctors) {
            if (doctor.getDoctor_id() == doctor_id) {
                return doctor;
            }
        }
        return null;
    }

    public static List<DoctorService> getDoctorService(){
        List<DoctorService> doctors = new ArrayList<>();
        try {
            Connection connection = DBContext.makeConnection();
            PreparedStatement preparedStatement = connection.prepareStatement("select * from doctor_services");
            ResultSet resultSet = preparedStatement.executeQuery();
            while (resultSet.next()) {
                DoctorService s = new DoctorService(resultSet.getInt("doctor_id"), resultSet.getInt("service_id"));
                doctors.add(s);
            }
        } catch (Exception e){
            e.printStackTrace();
        }
        return doctors;
    }

    public static void create(Service service) {
        String insertServiceSQL = "INSERT INTO services (name, detail, price, image, type) VALUES (?, ?, ?, ?, ?)";
        String insertDoctorServiceSQL = "INSERT INTO doctor_services (doctor_id, service_id) VALUES (?, ?)";

        Connection conn = null;
        PreparedStatement serviceStmt = null;
        PreparedStatement doctorStmt = null;
        ResultSet generatedKeys = null;

        try {
            conn = DBContext.makeConnection();
            assert conn != null;
            conn.setAutoCommit(false);

            serviceStmt = conn.prepareStatement(insertServiceSQL, Statement.RETURN_GENERATED_KEYS);
            serviceStmt.setString(1, service.getName());
            serviceStmt.setString(2, service.getDetail());
            serviceStmt.setLong(3, service.getPrice());
            serviceStmt.setString(4, service.getImage());
            serviceStmt.setString(5, service.getType().name());

            serviceStmt.executeUpdate();

            generatedKeys = serviceStmt.getGeneratedKeys();
            if (generatedKeys.next()) {
                int serviceId = generatedKeys.getInt(1);

                doctorStmt = conn.prepareStatement(insertDoctorServiceSQL);
                for (Doctor doctor : service.getDoctors()) {
                    doctorStmt.setInt(1, doctor.getDoctor_id());
                    doctorStmt.setInt(2, serviceId);
                    doctorStmt.addBatch();
                }
                doctorStmt.executeBatch();
            }

            conn.commit();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    public static void update(Service service) {
        String updateServiceSQL = "UPDATE services SET name=?, detail=?, price=?, image=?, type=? WHERE service_id=?";
        String deleteOldDoctorsSQL = "DELETE FROM doctor_services WHERE service_id=?";
        String insertDoctorServiceSQL = "INSERT INTO doctor_services (doctor_id, service_id) VALUES (?, ?)";

        Connection conn = null;
        PreparedStatement updateStmt = null;
        PreparedStatement deleteStmt = null;
        PreparedStatement insertStmt = null;

        try {
            conn = DBContext.makeConnection();
            conn.setAutoCommit(false);

            // Cập nhật thông tin service
            updateStmt = conn.prepareStatement(updateServiceSQL);
            updateStmt.setString(1, service.getName());
            updateStmt.setString(2, service.getDetail());
            updateStmt.setLong(3, service.getPrice());
            updateStmt.setString(4, service.getImage());
            updateStmt.setString(5, service.getType().name());
            updateStmt.setInt(6, service.getService_id());
            updateStmt.executeUpdate();

            // Xóa liên kết cũ
            deleteStmt = conn.prepareStatement(deleteOldDoctorsSQL);
            deleteStmt.setInt(1, service.getService_id());
            deleteStmt.executeUpdate();

            // Thêm liên kết mới
            insertStmt = conn.prepareStatement(insertDoctorServiceSQL);
            for (Doctor doctor : service.getDoctors()) {
                insertStmt.setInt(1, doctor.getDoctor_id());
                insertStmt.setInt(2, service.getService_id());
                insertStmt.addBatch();
            }
            insertStmt.executeBatch();

            conn.commit();
        } catch (Exception e) {
            e.printStackTrace();

        }
    }
    public static void delete(int serviceId) {
        String deleteDoctorServicesSQL = "DELETE FROM doctor_services WHERE service_id=?";
        String deleteServiceSQL = "DELETE FROM services WHERE service_id=?";

        Connection conn = null;
        PreparedStatement deleteDoctorsStmt = null;
        PreparedStatement deleteServiceStmt = null;

        try {
            conn = DBContext.makeConnection();
            conn.setAutoCommit(false);

            deleteDoctorsStmt = conn.prepareStatement(deleteDoctorServicesSQL);
            deleteDoctorsStmt.setInt(1, serviceId);
            deleteDoctorsStmt.executeUpdate();

            deleteServiceStmt = conn.prepareStatement(deleteServiceSQL);
            deleteServiceStmt.setInt(1, serviceId);
            deleteServiceStmt.executeUpdate();

            conn.commit();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

}
