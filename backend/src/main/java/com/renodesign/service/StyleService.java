package com.renodesign.service;

import com.renodesign.dto.style.StyleDto;
import com.renodesign.entity.StyleEntity;
import com.renodesign.exception.ResourceNotFoundException;
import com.renodesign.repository.StyleRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Service
@Transactional(readOnly = true)
public class StyleService {

    private final StyleRepository styleRepository;

    public StyleService(StyleRepository styleRepository) {
        this.styleRepository = styleRepository;
    }

    public List<StyleDto> getAllActiveStyles() {
        return styleRepository.findByActiveTrue().stream()
                .map(StyleDto::fromEntity)
                .collect(Collectors.toList());
    }

    public StyleDto getStyleById(Long id) {
        StyleEntity entity = styleRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Style not found with id: " + id));
        return StyleDto.fromEntity(entity);
    }

    @Transactional
    public StyleDto createStyle(StyleEntity entity) {
        return StyleDto.fromEntity(styleRepository.save(entity));
    }

    @Transactional
    public StyleDto updateStyle(Long id, StyleEntity details) {
        StyleEntity existing = styleRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Style not found with id: " + id));

        existing.setName(details.getName());
        existing.setDescription(details.getDescription());
        if (details.getImage() != null) existing.setImage(details.getImage());
        existing.setPromptInstructions(details.getPromptInstructions());
        existing.setActive(details.isActive());

        return StyleDto.fromEntity(styleRepository.save(existing));
    }

    @Transactional
    public void deleteStyle(Long id) {
        if (!styleRepository.existsById(id)) {
            throw new ResourceNotFoundException("Style not found with id: " + id);
        }
        styleRepository.deleteById(id);
    }
}
