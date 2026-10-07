package com.renodesign.dto.style;

import com.renodesign.entity.StyleEntity;

public class StyleDto {
    private Long id;
    private String name;
    private String description;
    private String image;
    private String promptInstructions;
    private boolean active;

    public StyleDto() {}

    public static StyleDto fromEntity(StyleEntity entity) {
        if (entity == null) return null;
        StyleDto dto = new StyleDto();
        dto.setId(entity.getId());
        dto.setName(entity.getName());
        dto.setDescription(entity.getDescription());
        dto.setImage(entity.getImage());
        dto.setPromptInstructions(entity.getPromptInstructions());
        dto.setActive(entity.isActive());
        return dto;
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
