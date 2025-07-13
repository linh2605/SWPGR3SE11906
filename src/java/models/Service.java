package models;

import java.util.List;

public class Service {
    private int service_id;
    private String name;
    private String detail;
    private Long price;
    private ServiceType type;
    private String image;
    private List<Doctor> doctors;

    // Constructors
    public Service() {}
    
    public Service(int service_id, String name, String detail, Long price, ServiceType type) {
        this.service_id = service_id;
        this.name = name;
        this.detail = detail;
        this.price = price;
        this.type = type;
    }

    public Service(String name, String detail, Long price, ServiceType type, String image, List<Doctor> doctors) {
        this.name = name;
        this.detail = detail;
        this.price = price;
        this.type = type;
        this.image = image;
        this.doctors = doctors;
    }

    // Getters and Setters
    public int getServiceId() {
        return service_id;
    }
    
    public void setServiceId(int service_id) {
        this.service_id = service_id;
    }
    
    public String getName() {
        return name;
    }
    
    public void setName(String name) {
        this.name = name;
    }
    
    public String getDetail() {
        return detail;
    }
    
    public void setDetail(String detail) {
        this.detail = detail;
    }
    
    public Long getPrice() {
        return price;
    }
    
    public void setPrice(Long price) {
        this.price = price;
    }
    
    public ServiceType getType() {
        return type;
    }
    
    public void setType(ServiceType type) {
        this.type = type;
    }
    
    public List<Doctor> getDoctors() {
        return doctors;
    }
    
    public void setDoctors(List<Doctor> doctors) {
        this.doctors = doctors;
    }

    public int getService_id() {
        return service_id;
    }

    public void setService_id(int service_id) {
        this.service_id = service_id;
    }

    public String getImage() {
        return image;
    }

    public void setImage(String image) {
        this.image = image;
    }

    @Override
    public String toString() {
        return "Service{" + "service_id=" + service_id + ", name=" + name + ", detail=" + detail + ", price=" + price + ", type=" + type + '}';
    }
}
