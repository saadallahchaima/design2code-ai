package com.renodesign.dto.service;

import com.renodesign.entity.ServiceEntity;

public class ServiceDto {
    private Long id;
    private String name;
    private String description;
    private String image;
    private boolean active;

    public ServiceDto() {}

    public static ServiceDto fromEntity(ServiceEntity entity) {
        if (entity == null) return null;
        ServiceDto dto = new ServiceDto();
        dto.setId(entity.getId());
        dto.setName(entity.getName());
        dto.setDescription(entity.getDescription());
        dto.setImage(entity.getImage());
        dto.setActive(entity.isActive());
        return dto;
    }

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getImage() { return image; }
    public void setImage(String image) { this.image = image; }

    public boolean isActive() { return active; }
    public void setActive(boolean active) { this.active = active; }
}
