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

public class ServiceDAO {

    public static Service getServiceById(int serviceId) {
        String sql = "SELECT package_id, name, description, price, duration FROM examination_packages WHERE package_id = ?";
        try (Connection conn = DBContext.makeConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, serviceId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Service s = new Service();
                    s.setServiceId(rs.getInt("package_id"));
                    s.setName(rs.getString("name"));
                    s.setDetail(rs.getString("description"));
                    s.setPrice(rs.getLong("price"));
                    s.setType(ServiceType.SPECIALIST);
                    s.setImage("");
                    List<DoctorService> doctorServices = ServiceDAO.getDoctorService();
                    List<Doctor> doctors = DoctorDao.getAllDeletedDoctors();
                    List<Doctor> temp = new ArrayList<>();
                    for (int i = 0; i < doctorServices.size(); i++) {
                        if (doctorServices.get(i).package_id == serviceId) {
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
        String sql = "SELECT package_id, name, description, price, duration FROM examination_packages LIMIT ?";
        try (Connection conn = DBContext.makeConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Service s = new Service();
                    s.setServiceId(rs.getInt("package_id"));
                    s.setName(rs.getString("name"));
                    s.setDetail(rs.getString("description"));
                    s.setPrice(rs.getLong("price"));
                    s.setType(ServiceType.SPECIALIST);
                    s.setImage("");
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
        String sql = "SELECT ep.package_id, ep.name, ep.description, ep.price, ep.duration\n"
                + "  FROM examination_packages ep\n"
                + "	JOIN doctor_services ds ON ep.package_id = ds.package_id\n"
                + " WHERE ds.doctor_id = ?";
        try (Connection conn = DBContext.makeConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, doctorId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Service s = new Service();
                    s.setServiceId(rs.getInt("package_id")); // Sử dụng package_id thay cho service_id
                    s.setName(rs.getString("name"));
                    s.setDetail(rs.getString("description")); // Sử dụng description thay cho detail
                    s.setPrice(rs.getLong("price"));
                    s.setType(ServiceType.SPECIALIST); // Mặc định là SPECIALIST
                    s.setImage(""); // Không có image trong examination_packages
                    list.add(s);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
    
    // Đã xóa hàm getTopPopularServices vì không còn sử dụng

    public static class DoctorService{
        int doctor_id;
        int package_id;

        public DoctorService(int doctor_id, int package_id) {
            this.doctor_id = doctor_id;
            this.package_id = package_id;
        }
    }

    public static List<Service> getAll(){
        List<Service> list = new ArrayList<>();
        try {
            String sql = "select * from examination_packages";
            Connection connection = DBContext.makeConnection();
            PreparedStatement ps = connection.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            List<Doctor> doctors = DoctorDao.getAllDeletedDoctors();
            List<DoctorService> doctorServices = getDoctorService();
            while (rs.next()) {
                Service s = new Service();
                s.setServiceId(rs.getInt("package_id"));
                s.setName(rs.getString("name"));
                s.setDetail(rs.getString("description"));
                s.setPrice(rs.getLong("price"));
                s.setType(ServiceType.SPECIALIST);
                s.setImage("");
                List<Doctor> temp = new ArrayList<>();
                for (int i = 0; i < doctorServices.size(); i++) {
                                            if (doctorServices.get(i).package_id == s.getServiceId()){
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
                DoctorService s = new DoctorService(resultSet.getInt("doctor_id"), resultSet.getInt("package_id"));
                doctors.add(s);
            }
        } catch (Exception e){
            e.printStackTrace();
        }
        return doctors;
    }

    public static int create(Service service) {
        String insertPackageSQL = "INSERT INTO examination_packages (name, description, price, duration) VALUES (?, ?, ?, ?)";
        String insertDoctorServiceSQL = "INSERT INTO doctor_services (doctor_id, package_id) VALUES (?, ?)";

        Connection conn = null;
        PreparedStatement packageStmt = null;
        PreparedStatement doctorStmt = null;
        ResultSet generatedKeys = null;
        int packageId = -1;

        try {
            conn = DBContext.makeConnection();
            assert conn != null;
            conn.setAutoCommit(false);

            packageStmt = conn.prepareStatement(insertPackageSQL, Statement.RETURN_GENERATED_KEYS);
            packageStmt.setString(1, service.getName());
            packageStmt.setString(2, service.getDetail());
            packageStmt.setLong(3, service.getPrice());
            packageStmt.setInt(4, 60); // duration mặc định 60 phút

            packageStmt.executeUpdate();

            generatedKeys = packageStmt.getGeneratedKeys();
            if (generatedKeys.next()) {
                packageId = generatedKeys.getInt(1);

                doctorStmt = conn.prepareStatement(insertDoctorServiceSQL);
                for (Doctor doctor : service.getDoctors()) {
                    doctorStmt.setInt(1, doctor.getDoctor_id());
                    doctorStmt.setInt(2, packageId);
                    doctorStmt.addBatch();
                }
                doctorStmt.executeBatch();
            }

            conn.commit();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return packageId;
    }
    public static void update(Service service) {
        String updatePackageSQL = "UPDATE examination_packages SET name=?, description=?, price=?, duration=? WHERE package_id=?";
        String deleteOldDoctorsSQL = "DELETE FROM doctor_services WHERE package_id=?";
        String insertDoctorServiceSQL = "INSERT INTO doctor_services (doctor_id, package_id) VALUES (?, ?)";

        Connection conn = null;
        PreparedStatement updateStmt = null;
        PreparedStatement deleteStmt = null;
        PreparedStatement insertStmt = null;

        try {
            conn = DBContext.makeConnection();
            conn.setAutoCommit(false);

            // Cập nhật thông tin package
            updateStmt = conn.prepareStatement(updatePackageSQL);
            updateStmt.setString(1, service.getName());
            updateStmt.setString(2, service.getDetail());
            updateStmt.setLong(3, service.getPrice());
            updateStmt.setInt(4, 60); // duration mặc định
            updateStmt.setInt(5, service.getServiceId());
            updateStmt.executeUpdate();

            // Xóa liên kết cũ
            deleteStmt = conn.prepareStatement(deleteOldDoctorsSQL);
            deleteStmt.setInt(1, service.getServiceId());
            deleteStmt.executeUpdate();

            // Thêm liên kết mới
            insertStmt = conn.prepareStatement(insertDoctorServiceSQL);
            for (Doctor doctor : service.getDoctors()) {
                insertStmt.setInt(1, doctor.getDoctor_id());
                insertStmt.setInt(2, service.getServiceId());
                insertStmt.addBatch();
            }
            insertStmt.executeBatch();

            conn.commit();
        } catch (Exception e) {
            e.printStackTrace();

        }
    }
    public static void delete(int serviceId) {
        String deleteDoctorServicesSQL = "DELETE FROM doctor_services WHERE package_id=?";
        String deletePackageSQL = "DELETE FROM examination_packages WHERE package_id=?";

        Connection conn = null;
        PreparedStatement deleteDoctorsStmt = null;
        PreparedStatement deleteServiceStmt = null;

        try {
            conn = DBContext.makeConnection();
            conn.setAutoCommit(false);

            deleteDoctorsStmt = conn.prepareStatement(deleteDoctorServicesSQL);
            deleteDoctorsStmt.setInt(1, serviceId);
            deleteDoctorsStmt.executeUpdate();

            deleteServiceStmt = conn.prepareStatement(deletePackageSQL);
            deleteServiceStmt.setInt(1, serviceId);
            deleteServiceStmt.executeUpdate();

            conn.commit();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

}
