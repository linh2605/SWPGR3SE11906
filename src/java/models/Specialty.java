package models;

public class Specialty {
    private int specialty_id;
    private String name;
    private String description;

    public Specialty() {}
    public Specialty(int specialty_id, String name, String description) {
        this.specialty_id = specialty_id;
        this.name = name;
        this.description = description;
    }
    public int getSpecialtyId() { return specialty_id; }
    public void setSpecialtyId(int specialty_id) { this.specialty_id = specialty_id; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
}
