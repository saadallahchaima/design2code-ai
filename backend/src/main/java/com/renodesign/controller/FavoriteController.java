package com.renodesign.controller;

import com.renodesign.dto.common.ApiResponse;
import com.renodesign.dto.project.ProjectDto;
import com.renodesign.entity.User;
import com.renodesign.service.FavoriteService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/favorites")
@Tag(name = "Favorites", description = "Endpoints for managing user favorite renovation projects")
public class FavoriteController {

    private final FavoriteService favoriteService;

    public FavoriteController(FavoriteService favoriteService) {
        this.favoriteService = favoriteService;
    }

    @PostMapping("/{projectId}")
    @Operation(summary = "Add a project to favorites")
    public ResponseEntity<ApiResponse<Void>> addFavorite(
            @AuthenticationPrincipal User user,
            @PathVariable Long projectId
    ) {
        favoriteService.addFavorite(user, projectId);
        return ResponseEntity.ok(ApiResponse.success("Project added to favorites", null));
    }

    @DeleteMapping("/{projectId}")
    @Operation(summary = "Remove a project from favorites")
    public ResponseEntity<ApiResponse<Void>> removeFavorite(
            @AuthenticationPrincipal User user,
            @PathVariable Long projectId
    ) {
        favoriteService.removeFavorite(user, projectId);
        return ResponseEntity.ok(ApiResponse.success("Project removed from favorites", null));
    }

    @GetMapping
    @Operation(summary = "Get all favorite projects for the current user")
    public ResponseEntity<ApiResponse<List<ProjectDto>>> getUserFavorites(@AuthenticationPrincipal User user) {
        List<ProjectDto> list = favoriteService.getUserFavorites(user);
        return ResponseEntity.ok(ApiResponse.success(list));
    }

    @GetMapping("/check/{projectId}")
    @Operation(summary = "Check if a project is in favorites")
    public ResponseEntity<ApiResponse<Boolean>> isFavorite(
            @AuthenticationPrincipal User user,
            @PathVariable Long projectId
    ) {
        boolean fav = favoriteService.isFavorite(user, projectId);
        return ResponseEntity.ok(ApiResponse.success(fav));
    }
}
