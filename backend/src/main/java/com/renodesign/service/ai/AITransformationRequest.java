package com.renodesign.service.ai;

public class AITransformationRequest {

    private String originalImageUrl;
    private byte[] originalImageBytes;
    private String originalImageFilename;
    private String roomType;
    private String style;
    private String wallMaterial;
    private String floorMaterial;
    private String lighting;
    private String customPrompt;

    public AITransformationRequest() {}

    public AITransformationRequest(String originalImageUrl, byte[] originalImageBytes, String originalImageFilename,
                                   String roomType, String style, String wallMaterial, String floorMaterial,
                                   String lighting, String customPrompt) {
        this.originalImageUrl = originalImageUrl;
        this.originalImageBytes = originalImageBytes;
        this.originalImageFilename = originalImageFilename;
        this.roomType = roomType;
        this.style = style;
        this.wallMaterial = wallMaterial;
        this.floorMaterial = floorMaterial;
        this.lighting = lighting;
        this.customPrompt = customPrompt;
    }

    public String getOriginalImageUrl() { return originalImageUrl; }
    public void setOriginalImageUrl(String originalImageUrl) { this.originalImageUrl = originalImageUrl; }

    public byte[] getOriginalImageBytes() { return originalImageBytes; }
    public void setOriginalImageBytes(byte[] originalImageBytes) { this.originalImageBytes = originalImageBytes; }

    public String getOriginalImageFilename() { return originalImageFilename; }
    public void setOriginalImageFilename(String originalImageFilename) { this.originalImageFilename = originalImageFilename; }

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
