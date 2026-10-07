package com.renodesign.entity;

import jakarta.persistence.*;

@Entity
@Table(name = "materials")
public class Material {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private String name;

    @Column(nullable = false, length = 50)
    private String category; // 'wall', 'floor', etc.

    @Column(columnDefinition = "TEXT")
    private String description;

    @Column(columnDefinition = "TEXT")
    private String image;

    @Column(length = 100)
    private String color;

    @Column(name = "price_range", length = 50)
    private String priceRange;

    @Column(nullable = false)
    private boolean active = true;

    public Material() {}

    public Material(String name, String category, String description, String image, String color, String priceRange, boolean active) {
        this.name = name;
        this.category = category;
        this.description = description;
        this.image = image;
        this.color = color;
        this.priceRange = priceRange;
        this.active = active;
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
