package com.renodesign.controller;

import com.renodesign.dto.auth.UserDto;
import com.renodesign.dto.common.ApiResponse;
import com.renodesign.dto.material.MaterialDto;
import com.renodesign.dto.project.ProjectDto;
import com.renodesign.dto.quote.QuoteResponse;
import com.renodesign.dto.quote.UpdateQuoteStatusRequest;
import com.renodesign.dto.service.ServiceDto;
import com.renodesign.dto.style.StyleDto;
import com.renodesign.entity.*;
import com.renodesign.service.*;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/admin")
@PreAuthorize("hasRole('ADMIN')")
@Tag(name = "Admin", description = "Administration endpoints for projects, services, materials, styles, quotes, and users")
public class AdminController {

    private final ProjectService projectService;
    private final CompanyServiceService serviceService;
    private final MaterialService materialService;
    private final StyleService styleService;
    private final QuoteService quoteService;
    private final UserService userService;

    public AdminController(
            ProjectService projectService,
            CompanyServiceService serviceService,
            MaterialService materialService,
            StyleService styleService,
            QuoteService quoteService,
            UserService userService
    ) {
        this.projectService = projectService;
        this.serviceService = serviceService;
        this.materialService = materialService;
        this.styleService = styleService;
        this.quoteService = quoteService;
        this.userService = userService;
    }

    // Projects Management
    @PostMapping("/projects")
    @Operation(summary = "Admin: Create a new project")
    public ResponseEntity<ApiResponse<ProjectDto>> createProject(@RequestBody Project project) {
        return ResponseEntity.status(HttpStatus.CREATED).body(ApiResponse.success(projectService.createProject(project)));
    }

    @PutMapping("/projects/{id}")
    @Operation(summary = "Admin: Update a project")
    public ResponseEntity<ApiResponse<ProjectDto>> updateProject(@PathVariable Long id, @RequestBody Project project) {
        return ResponseEntity.ok(ApiResponse.success(projectService.updateProject(id, project)));
    }

    @DeleteMapping("/projects/{id}")
    @Operation(summary = "Admin: Delete a project")
    public ResponseEntity<ApiResponse<Void>> deleteProject(@PathVariable Long id) {
        projectService.deleteProject(id);
        return ResponseEntity.ok(ApiResponse.success("Project deleted successfully", null));
    }

    // Materials Management
    @PostMapping("/materials")
    @Operation(summary = "Admin: Create a new material")
    public ResponseEntity<ApiResponse<MaterialDto>> createMaterial(@RequestBody Material material) {
        return ResponseEntity.status(HttpStatus.CREATED).body(ApiResponse.success(materialService.createMaterial(material)));
    }

    @PutMapping("/materials/{id}")
    @Operation(summary = "Admin: Update a material")
    public ResponseEntity<ApiResponse<MaterialDto>> updateMaterial(@PathVariable Long id, @RequestBody Material material) {
        return ResponseEntity.ok(ApiResponse.success(materialService.updateMaterial(id, material)));
    }

    @DeleteMapping("/materials/{id}")
    @Operation(summary = "Admin: Delete a material")
    public ResponseEntity<ApiResponse<Void>> deleteMaterial(@PathVariable Long id) {
        materialService.deleteMaterial(id);
        return ResponseEntity.ok(ApiResponse.success("Material deleted successfully", null));
    }

    // Styles Management
    @PostMapping("/styles")
    @Operation(summary = "Admin: Create a new design style")
    public ResponseEntity<ApiResponse<StyleDto>> createStyle(@RequestBody StyleEntity style) {
        return ResponseEntity.status(HttpStatus.CREATED).body(ApiResponse.success(styleService.createStyle(style)));
    }

    @PutMapping("/styles/{id}")
    @Operation(summary = "Admin: Update a design style")
    public ResponseEntity<ApiResponse<StyleDto>> updateStyle(@PathVariable Long id, @RequestBody StyleEntity style) {
        return ResponseEntity.ok(ApiResponse.success(styleService.updateStyle(id, style)));
    }

    @DeleteMapping("/styles/{id}")
    @Operation(summary = "Admin: Delete a design style")
    public ResponseEntity<ApiResponse<Void>> deleteStyle(@PathVariable Long id) {
        styleService.deleteStyle(id);
        return ResponseEntity.ok(ApiResponse.success("Style deleted successfully", null));
    }

    // Services Management
    @PostMapping("/services")
    @Operation(summary = "Admin: Create a new company renovation service")
    public ResponseEntity<ApiResponse<ServiceDto>> createService(@RequestBody ServiceEntity serviceEntity) {
        return ResponseEntity.status(HttpStatus.CREATED).body(ApiResponse.success(serviceService.createService(serviceEntity)));
    }

    @PutMapping("/services/{id}")
    @Operation(summary = "Admin: Update a renovation service")
    public ResponseEntity<ApiResponse<ServiceDto>> updateService(@PathVariable Long id, @RequestBody ServiceEntity serviceEntity) {
        return ResponseEntity.ok(ApiResponse.success(serviceService.updateService(id, serviceEntity)));
    }

    @DeleteMapping("/services/{id}")
    @Operation(summary = "Admin: Delete a renovation service")
    public ResponseEntity<ApiResponse<Void>> deleteService(@PathVariable Long id) {
        serviceService.deleteService(id);
        return ResponseEntity.ok(ApiResponse.success("Service deleted successfully", null));
    }

    // Quotes Management
    @GetMapping("/quotes")
    @Operation(summary = "Admin: Get all quote requests with optional status filtering")
    public ResponseEntity<ApiResponse<List<QuoteResponse>>> getQuotes(@RequestParam(required = false) QuoteStatus status) {
        List<QuoteResponse> list = quoteService.getAllQuotesForAdmin(status);
        return ResponseEntity.ok(ApiResponse.success(list));
    }

    @PutMapping("/quotes/{id}/status")
    @Operation(summary = "Admin: Update quote request status")
    public ResponseEntity<ApiResponse<QuoteResponse>> updateQuoteStatus(
            @PathVariable Long id,
            @Valid @RequestBody UpdateQuoteStatusRequest request
    ) {
        QuoteResponse response = quoteService.updateQuoteStatus(id, request);
        return ResponseEntity.ok(ApiResponse.success("Quote status updated", response));
    }

    // Users Management
    @GetMapping("/users")
    @Operation(summary = "Admin: List all registered users")
    public ResponseEntity<ApiResponse<List<UserDto>>> getAllUsers() {
        List<UserDto> list = userService.getAllUsers();
        return ResponseEntity.ok(ApiResponse.success(list));
    }
}
