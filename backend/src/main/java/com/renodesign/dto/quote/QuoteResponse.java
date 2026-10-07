package com.renodesign.dto.quote;

import com.renodesign.entity.QuoteRequest;
import com.renodesign.entity.QuoteStatus;
import java.time.OffsetDateTime;

public class QuoteResponse {
    private Long id;
    private Long userId;
    private Long transformationId;
    private String fullName;
    private String phone;
    private String email;
    private String city;
    private String roomType;
    private Double surfaceArea;
    private String message;
    private QuoteStatus status;
    private OffsetDateTime createdAt;

    // Attached transformation preview
    private String originalImageUrl;
    private String generatedImageUrl;
    private String style;

    public QuoteResponse() {}

    public static QuoteResponse fromEntity(QuoteRequest entity) {
        if (entity == null) return null;
        QuoteResponse res = new QuoteResponse();
        res.setId(entity.getId());
        res.setUserId(entity.getUser() != null ? entity.getUser().getId() : null);
        if (entity.getTransformation() != null) {
            res.setTransformationId(entity.getTransformation().getId());
            res.setOriginalImageUrl(entity.getTransformation().getOriginalImageUrl());
            res.setGeneratedImageUrl(entity.getTransformation().getGeneratedImageUrl());
            res.setStyle(entity.getTransformation().getStyle());
        }
        res.setFullName(entity.getFullName());
        res.setPhone(entity.getPhone());
        res.setEmail(entity.getEmail());
        res.setCity(entity.getCity());
        res.setRoomType(entity.getRoomType());
        res.setSurfaceArea(entity.getSurfaceArea());
        res.setMessage(entity.getMessage());
        res.setStatus(entity.getStatus());
        res.setCreatedAt(entity.getCreatedAt());
        return res;
    }

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public Long getUserId() { return userId; }
    public void setUserId(Long userId) { this.userId = userId; }

    public Long getTransformationId() { return transformationId; }
    public void setTransformationId(Long transformationId) { this.transformationId = transformationId; }

    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }

    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getCity() { return city; }
    public void setCity(String city) { this.city = city; }

    public String getRoomType() { return roomType; }
    public void setRoomType(String roomType) { this.roomType = roomType; }

    public Double getSurfaceArea() { return surfaceArea; }
    public void setSurfaceArea(Double surfaceArea) { this.surfaceArea = surfaceArea; }

    public String getMessage() { return message; }
    public void setMessage(String message) { this.message = message; }

    public QuoteStatus getStatus() { return status; }
    public void setStatus(QuoteStatus status) { this.status = status; }

    public OffsetDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(OffsetDateTime createdAt) { this.createdAt = createdAt; }

    public String getOriginalImageUrl() { return originalImageUrl; }
    public void setOriginalImageUrl(String originalImageUrl) { this.originalImageUrl = originalImageUrl; }

    public String getGeneratedImageUrl() { return generatedImageUrl; }
    public void setGeneratedImageUrl(String generatedImageUrl) { this.generatedImageUrl = generatedImageUrl; }

    public String getStyle() { return style; }
    public void setStyle(String style) { this.style = style; }
}
