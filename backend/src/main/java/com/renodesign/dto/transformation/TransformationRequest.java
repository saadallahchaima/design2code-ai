package com.renodesign.dto.transformation;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;

public class TransformationRequest {

    @NotBlank(message = "Room type is required")
    private String roomType;

    @NotBlank(message = "Style is required")
    private String style;

    private String wallMaterial;
    private String floorMaterial;
    private String lighting;

    @Size(max = 1000, message = "Custom prompt must not exceed 1000 characters")
    private String customPrompt;

    public TransformationRequest() {}

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
}
