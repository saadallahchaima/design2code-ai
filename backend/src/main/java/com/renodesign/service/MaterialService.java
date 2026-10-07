package com.renodesign.service;

import com.renodesign.dto.material.MaterialDto;
import com.renodesign.entity.Material;
import com.renodesign.exception.ResourceNotFoundException;
import com.renodesign.repository.MaterialRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Service
@Transactional(readOnly = true)
public class MaterialService {

    private final MaterialRepository materialRepository;

    public MaterialService(MaterialRepository materialRepository) {
        this.materialRepository = materialRepository;
    }

    public List<MaterialDto> getMaterials(String category) {
        List<Material> list;
        if (category != null && !category.isBlank()) {
            list = materialRepository.findByCategoryIgnoreCaseAndActiveTrue(category.trim());
        } else {
            list = materialRepository.findByActiveTrue();
        }
        return list.stream().map(MaterialDto::fromEntity).collect(Collectors.toList());
    }

    public MaterialDto getMaterialById(Long id) {
        Material material = materialRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Material not found with id: " + id));
        return MaterialDto.fromEntity(material);
    }

    @Transactional
    public MaterialDto createMaterial(Material material) {
        return MaterialDto.fromEntity(materialRepository.save(material));
    }

    @Transactional
    public MaterialDto updateMaterial(Long id, Material details) {
        Material existing = materialRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Material not found with id: " + id));

        existing.setName(details.getName());
        existing.setCategory(details.getCategory());
        existing.setDescription(details.getDescription());
        if (details.getImage() != null) existing.setImage(details.getImage());
        existing.setColor(details.getColor());
        existing.setPriceRange(details.getPriceRange());
        existing.setActive(details.isActive());

        return MaterialDto.fromEntity(materialRepository.save(existing));
    }

    @Transactional
    public void deleteMaterial(Long id) {
        if (!materialRepository.existsById(id)) {
            throw new ResourceNotFoundException("Material not found with id: " + id);
        }
        materialRepository.deleteById(id);
    }
}
