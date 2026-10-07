package com.renodesign.service;

import com.renodesign.dto.project.ProjectDto;
import com.renodesign.entity.Project;
import com.renodesign.exception.ResourceNotFoundException;
import com.renodesign.repository.ProjectRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Service
@Transactional(readOnly = true)
public class ProjectService {

    private final ProjectRepository projectRepository;

    public ProjectService(ProjectRepository projectRepository) {
        this.projectRepository = projectRepository;
    }

    public List<ProjectDto> getAllProjects(String style, String roomType) {
        List<Project> list;
        if (style != null && !style.isBlank()) {
            list = projectRepository.findByStyleIgnoreCase(style);
        } else if (roomType != null && !roomType.isBlank()) {
            list = projectRepository.findByRoomTypeIgnoreCase(roomType);
        } else {
            list = projectRepository.findAll();
        }
        return list.stream().map(ProjectDto::fromEntity).collect(Collectors.toList());
    }

    public ProjectDto getProjectById(Long id) {
        Project project = projectRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Project not found with id: " + id));
        return ProjectDto.fromEntity(project);
    }

    @Transactional
    public ProjectDto createProject(Project project) {
        Project saved = projectRepository.save(project);
        return ProjectDto.fromEntity(saved);
    }

    @Transactional
    public ProjectDto updateProject(Long id, Project details) {
        Project existing = projectRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Project not found with id: " + id));

        existing.setTitle(details.getTitle());
        existing.setDescription(details.getDescription());
        existing.setLocation(details.getLocation());
        existing.setRoomType(details.getRoomType());
        existing.setStyle(details.getStyle());
        if (details.getCoverImage() != null) existing.setCoverImage(details.getCoverImage());
        if (details.getBeforeImage() != null) existing.setBeforeImage(details.getBeforeImage());
        if (details.getAfterImage() != null) existing.setAfterImage(details.getAfterImage());

        return ProjectDto.fromEntity(projectRepository.save(existing));
    }

    @Transactional
    public void deleteProject(Long id) {
        if (!projectRepository.existsById(id)) {
            throw new ResourceNotFoundException("Project not found with id: " + id);
        }
        projectRepository.deleteById(id);
    }
}
