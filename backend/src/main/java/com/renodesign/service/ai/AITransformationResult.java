package com.renodesign.service.ai;

public class AITransformationResult {

    private boolean success;
    private byte[] imageBytes;
    private String imageUrl;
    private String mimeType;
    private String provider;
    private String errorMessage;

    public AITransformationResult() {}

    public static AITransformationResult successWithBytes(byte[] imageBytes, String mimeType, String provider) {
        AITransformationResult res = new AITransformationResult();
        res.setSuccess(true);
        res.setImageBytes(imageBytes);
        res.setMimeType(mimeType != null ? mimeType : "image/jpeg");
        res.setProvider(provider);
        return res;
    }

    public static AITransformationResult successWithUrl(String imageUrl, String provider) {
        AITransformationResult res = new AITransformationResult();
        res.setSuccess(true);
        res.setImageUrl(imageUrl);
        res.setProvider(provider);
        return res;
    }

    public static AITransformationResult failure(String errorMessage, String provider) {
        AITransformationResult res = new AITransformationResult();
        res.setSuccess(false);
        res.setErrorMessage(errorMessage);
        res.setProvider(provider);
        return res;
    }

    public boolean isSuccess() { return success; }
    public void setSuccess(boolean success) { this.success = success; }

    public byte[] getImageBytes() { return imageBytes; }
    public void setImageBytes(byte[] imageBytes) { this.imageBytes = imageBytes; }

    public String getImageUrl() { return imageUrl; }
    public void setImageUrl(String imageUrl) { this.imageUrl = imageUrl; }

    public String getMimeType() { return mimeType; }
    public void setMimeType(String mimeType) { this.mimeType = mimeType; }

    public String getProvider() { return provider; }
    public void setProvider(String provider) { this.provider = provider; }

    public String getErrorMessage() { return errorMessage; }
    public void setErrorMessage(String errorMessage) { this.errorMessage = errorMessage; }
}
