package models;

import lombok.*;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class Role {
    private int roleId;
    private String name;
    private String description;

    public int getRoleId() {
        return roleId;
    }

    public void setRoleId(int roleId) {
        this.roleId = roleId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }
    
    @Override
    public String toString() {
        return "Role{" +
                "roleId=" + roleId +
                ", name='" + (name != null ? name : "") + '\'' +
                ", description='" + (description != null ? description : "") + '\'' +
                '}';
    }
}
