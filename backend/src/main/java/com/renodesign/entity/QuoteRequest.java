package com.renodesign.entity;

import jakarta.persistence.*;
import java.time.OffsetDateTime;

@Entity
@Table(name = "quote_requests")
public class QuoteRequest {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "transformation_id")
    private Transformation transformation;

    @Column(name = "full_name", nullable = false)
    private String fullName;

    @Column(nullable = false, length = 50)
    private String phone;

    @Column(nullable = false)
    private String email;

    @Column(nullable = false, length = 100)
    private String city;

    @Column(name = "room_type", nullable = false, length = 100)
    private String roomType;

    @Column(name = "surface_area")
    private Double surfaceArea;

    @Column(columnDefinition = "TEXT")
    private String message;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 50)
    private QuoteStatus status = QuoteStatus.PENDING;

    @Column(name = "created_at", nullable = false, updatable = false)
    private OffsetDateTime createdAt;

    @PrePersist
    protected void onCreate() {
        this.createdAt = OffsetDateTime.now();
        if (this.status == null) {
            this.status = QuoteStatus.PENDING;
        }
    }

    public QuoteRequest() {}

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public User getUser() { return user; }
    public void setUser(User user) { this.user = user; }

    public Transformation getTransformation() { return transformation; }
    public void setTransformation(Transformation transformation) { this.transformation = transformation; }

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
}
