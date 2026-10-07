package com.renodesign.dto.material;

import com.renodesign.entity.Material;

public class MaterialDto {
    private Long id;
    private String name;
    private String category;
    private String description;
    private String image;
    private String color;
    private String priceRange;
    private boolean active;

    public MaterialDto() {}

    public static MaterialDto fromEntity(Material entity) {
        if (entity == null) return null;
        MaterialDto dto = new MaterialDto();
        dto.setId(entity.getId());
        dto.setName(entity.getName());
        dto.setCategory(entity.getCategory());
        dto.setDescription(entity.getDescription());
        dto.setImage(entity.getImage());
        dto.setColor(entity.getColor());
        dto.setPriceRange(entity.getPriceRange());
        dto.setActive(entity.isActive());
        return dto;
    }

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getCategory() { return category; }
    public void setCategory(String category) { this.category = category; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getImage() { return image; }
    public void setImage(String image) { this.image = image; }

    public String getColor() { return color; }
    public void setColor(String color) { this.color = color; }

    public String getPriceRange() { return priceRange; }
    public void setPriceRange(String priceRange) { this.priceRange = priceRange; }

    public boolean isActive() { return active; }
    public void setActive(boolean active) { this.active = active; }
}
