package com.renodesign.service;

import com.renodesign.dto.project.ProjectDto;
import com.renodesign.entity.Favorite;
import com.renodesign.entity.Project;
import com.renodesign.entity.User;
import com.renodesign.exception.ResourceNotFoundException;
import com.renodesign.repository.FavoriteRepository;
import com.renodesign.repository.ProjectRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Service
public class FavoriteService {

    private final FavoriteRepository favoriteRepository;
    private final ProjectRepository projectRepository;

    public FavoriteService(FavoriteRepository favoriteRepository, ProjectRepository projectRepository) {
        this.favoriteRepository = favoriteRepository;
        this.projectRepository = projectRepository;
    }

    @Transactional
    public void addFavorite(User user, Long projectId) {
        Project project = projectRepository.findById(projectId)
                .orElseThrow(() -> new ResourceNotFoundException("Project not found with id: " + projectId));

        if (!favoriteRepository.existsByUserIdAndProjectId(user.getId(), projectId)) {
            favoriteRepository.save(new Favorite(user, project));
        }
    }

    @Transactional
    public void removeFavorite(User user, Long projectId) {
        favoriteRepository.deleteByUserIdAndProjectId(user.getId(), projectId);
    }

    @Transactional(readOnly = true)
    public List<ProjectDto> getUserFavorites(User user) {
        return favoriteRepository.findByUserIdOrderByCreatedAtDesc(user.getId()).stream()
                .map(Favorite::getProject)
                .map(ProjectDto::fromEntity)
                .collect(Collectors.toList());
    }

    @Transactional(readOnly = true)
    public boolean isFavorite(User user, Long projectId) {
        return favoriteRepository.existsByUserIdAndProjectId(user.getId(), projectId);
    }
}
