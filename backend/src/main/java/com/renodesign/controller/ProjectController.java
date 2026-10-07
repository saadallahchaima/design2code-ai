package com.renodesign.controller;

import com.renodesign.dto.common.ApiResponse;
import com.renodesign.dto.project.ProjectDto;
import com.renodesign.service.ProjectService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/projects")
@Tag(name = "Projects", description = "Endpoints for exploring renovation showcase projects")
public class ProjectController {

    private final ProjectService projectService;

    public ProjectController(ProjectService projectService) {
        this.projectService = projectService;
    }

    @GetMapping
    @Operation(summary = "Get showcase projects with optional filtering by style or room type")
    public ResponseEntity<ApiResponse<List<ProjectDto>>> getAllProjects(
            @RequestParam(required = false) String style,
            @RequestParam(required = false) String roomType
    ) {
        List<ProjectDto> list = projectService.getAllProjects(style, roomType);
        return ResponseEntity.ok(ApiResponse.success(list));
    }

    @GetMapping("/{id}")
    @Operation(summary = "Get project details by ID")
    public ResponseEntity<ApiResponse<ProjectDto>> getProjectById(@PathVariable Long id) {
        ProjectDto dto = projectService.getProjectById(id);
        return ResponseEntity.ok(ApiResponse.success(dto));
    }
}
