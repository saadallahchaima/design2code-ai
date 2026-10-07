package com.renodesign.dto.transformation;

import com.renodesign.entity.Transformation;
import com.renodesign.entity.TransformationStatus;
import java.time.OffsetDateTime;

public class TransformationResponse {
    private Long id;
    private Long userId;
    private String originalImageUrl;
    private String generatedImageUrl;
    private String roomType;
    private String style;
    private String wallMaterial;
    private String floorMaterial;
    private String lighting;
    private String customPrompt;
    private TransformationStatus status;
    private String errorMessage;
    private OffsetDateTime createdAt;
    private OffsetDateTime updatedAt;

    public TransformationResponse() {}

    public static TransformationResponse fromEntity(Transformation entity) {
        if (entity == null) return null;
        TransformationResponse res = new TransformationResponse();
        res.setId(entity.getId());
        res.setUserId(entity.getUser() != null ? entity.getUser().getId() : null);
        res.setOriginalImageUrl(entity.getOriginalImageUrl());
        res.setGeneratedImageUrl(entity.getGeneratedImageUrl());
        res.setRoomType(entity.getRoomType());
        res.setStyle(entity.getStyle());
        res.setWallMaterial(entity.getWallMaterial());
        res.setFloorMaterial(entity.getFloorMaterial());
        res.setLighting(entity.getLighting());
        res.setCustomPrompt(entity.getCustomPrompt());
        res.setStatus(entity.getStatus());
        res.setErrorMessage(entity.getErrorMessage());
        res.setCreatedAt(entity.getCreatedAt());
        res.setUpdatedAt(entity.getUpdatedAt());
        return res;
    }

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public Long getUserId() { return userId; }
    public void setUserId(Long userId) { this.userId = userId; }

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
