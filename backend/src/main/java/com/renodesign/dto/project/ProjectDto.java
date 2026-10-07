package com.renodesign.dto.project;

import com.renodesign.entity.Project;
import java.time.OffsetDateTime;

public class ProjectDto {
    private Long id;
    private String title;
    private String description;
    private String location;
    private String roomType;
    private String style;
    private String coverImage;
    private String beforeImage;
    private String afterImage;
    private OffsetDateTime createdAt;

    public ProjectDto() {}

    public static ProjectDto fromEntity(Project entity) {
        if (entity == null) return null;
        ProjectDto dto = new ProjectDto();
        dto.setId(entity.getId());
        dto.setTitle(entity.getTitle());
        dto.setDescription(entity.getDescription());
        dto.setLocation(entity.getLocation());
        dto.setRoomType(entity.getRoomType());
        dto.setStyle(entity.getStyle());
        dto.setCoverImage(entity.getCoverImage());
        dto.setBeforeImage(entity.getBeforeImage());
        dto.setAfterImage(entity.getAfterImage());
        dto.setCreatedAt(entity.getCreatedAt());
        return dto;
    }

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
