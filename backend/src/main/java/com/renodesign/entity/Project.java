package com.renodesign.entity;

import jakarta.persistence.*;
import java.time.OffsetDateTime;

@Entity
@Table(name = "projects")
public class Project {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private String title;

    @Column(columnDefinition = "TEXT")
    private String description;

    private String location;

    @Column(name = "room_type", length = 100)
    private String roomType;

    @Column(length = 100)
    private String style;

    @Column(name = "cover_image", columnDefinition = "TEXT")
    private String coverImage;

    @Column(name = "before_image", columnDefinition = "TEXT")
    private String beforeImage;

    @Column(name = "after_image", columnDefinition = "TEXT")
    private String afterImage;

    @Column(name = "created_at", nullable = false, updatable = false)
    private OffsetDateTime createdAt;

    @PrePersist
    protected void onCreate() {
        this.createdAt = OffsetDateTime.now();
    }

    public Project() {}

    // Getters and Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getLocation() { return location; }
    public void setLocation(String location) { this.location = location; }

    public String getRoomType() { return roomType; }
    public void setRoomType(String roomType) { this.roomType = roomType; }

    public String getStyle() { return style; }
    public void setStyle(String style) { this.style = style; }

    public String getCoverImage() { return coverImage; }
    public void setCoverImage(String coverImage) { this.coverImage = coverImage; }

    public String getBeforeImage() { return beforeImage; }
    public void setBeforeImage(String beforeImage) { this.beforeImage = beforeImage; }

    public String getAfterImage() { return afterImage; }
    public void setAfterImage(String afterImage) { this.afterImage = afterImage; }

    public OffsetDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(OffsetDateTime createdAt) { this.createdAt = createdAt; }
}
