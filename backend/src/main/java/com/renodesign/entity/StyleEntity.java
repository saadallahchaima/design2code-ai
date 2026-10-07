package com.renodesign.entity;

import jakarta.persistence.*;

@Entity
@Table(name = "styles")
public class StyleEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, unique = true, length = 100)
    private String name;

    @Column(columnDefinition = "TEXT")
    private String description;

    @Column(columnDefinition = "TEXT")
    private String image;

    @Column(name = "prompt_instructions", columnDefinition = "TEXT")
    private String promptInstructions;

    @Column(nullable = false)
    private boolean active = true;

    public StyleEntity() {}

    public StyleEntity(String name, String description, String image, String promptInstructions, boolean active) {
        this.name = name;
        this.description = description;
        this.image = image;
        this.promptInstructions = promptInstructions;
        this.active = active;
    }

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getImage() { return image; }
    public void setImage(String image) { this.image = image; }

    public String getPromptInstructions() { return promptInstructions; }
    public void setPromptInstructions(String promptInstructions) { this.promptInstructions = promptInstructions; }

    public boolean isActive() { return active; }
    public void setActive(boolean active) { this.active = active; }
}
