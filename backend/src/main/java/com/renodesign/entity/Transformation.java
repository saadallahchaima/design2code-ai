package com.renodesign.entity;

import jakarta.persistence.*;
import java.time.OffsetDateTime;

@Entity
@Table(name = "transformations")
public class Transformation {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @Column(name = "original_image_url", nullable = false, columnDefinition = "TEXT")
    private String originalImageUrl;

    @Column(name = "generated_image_url", columnDefinition = "TEXT")
    private String generatedImageUrl;

    @Column(name = "room_type", nullable = false, length = 100)
    private String roomType;

    @Column(nullable = false, length = 100)
    private String style;

    @Column(name = "wall_material", length = 100)
    private String wallMaterial;

    @Column(name = "floor_material", length = 100)
    private String floorMaterial;

    @Column(length = 100)
    private String lighting;

    @Column(name = "custom_prompt", columnDefinition = "TEXT")
    private String customPrompt;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 50)
    private TransformationStatus status = TransformationStatus.PENDING;

    @Column(name = "error_message", columnDefinition = "TEXT")
    private String errorMessage;

    @Column(name = "created_at", nullable = false, updatable = false)
    private OffsetDateTime createdAt;

    @Column(name = "updated_at", nullable = false)
    private OffsetDateTime updatedAt;

    @PrePersist
    protected void onCreate() {
        this.createdAt = OffsetDateTime.now();
        this.updatedAt = OffsetDateTime.now();
        if (this.status == null) {
            this.status = TransformationStatus.PENDING;
        }
    }

    @PreUpdate
    protected void onUpdate() {
        this.updatedAt = OffsetDateTime.now();
    }

    public Transformation() {}

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public User getUser() { return user; }
    public void setUser(User user) { this.user = user; }

    public String getOriginalImageUrl() { return originalImageUrl; }
    public void setOriginalImageUrl(String originalImageUrl) { this.originalImageUrl = originalImageUrl; }

    public String getGeneratedImageUrl() { return generatedImageUrl; }
    public void setGeneratedImageUrl(String generatedImageUrl) { this.generatedImageUrl = generatedImageUrl; }

    public String getRoomType() { return roomType; }
    public void setRoomType(String roomType) { this.roomType = roomType; }

    public String getStyle() { return style; }
    public void setStyle(String style) { this.style = style; }

    public String getWallMaterial() { return wallMaterial; }
    public void setWallMaterial(String wallMaterial) { this.wallMaterial = wallMaterial; }

    public String getFloorMaterial() { return floorMaterial; }
    public void setFloorMaterial(String floorMaterial) { this.floorMaterial = floorMaterial; }

    public String getLighting() { return lighting; }
    public void setLighting(String lighting) { this.lighting = lighting; }

    public String getCustomPrompt() { return customPrompt; }
    public void setCustomPrompt(String customPrompt) { this.customPrompt = customPrompt; }

    public TransformationStatus getStatus() { return status; }
    public void setStatus(TransformationStatus status) { this.status = status; }

    public String getErrorMessage() { return errorMessage; }
    public void setErrorMessage(String errorMessage) { this.errorMessage = errorMessage; }

    public OffsetDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(OffsetDateTime createdAt) { this.createdAt = createdAt; }

    public OffsetDateTime getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(OffsetDateTime updatedAt) { this.updatedAt = updatedAt; }
}
