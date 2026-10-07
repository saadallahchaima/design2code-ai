package com.renodesign.dto.quote;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;

public class QuoteCreateRequest {

    private Long transformationId;

    @NotBlank(message = "Full name is required")
    private String fullName;

    @NotBlank(message = "Phone number is required")
    private String phone;

    @NotBlank(message = "Email is required")
    @Email(message = "Invalid email format")
    private String email;

    @NotBlank(message = "City is required")
    private String city;

    @NotBlank(message = "Room type is required")
    private String roomType;

    private Double surfaceArea;

    private String message;

    public QuoteCreateRequest() {}

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
}
