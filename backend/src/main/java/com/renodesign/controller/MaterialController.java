package com.renodesign.controller;

import com.renodesign.dto.common.ApiResponse;
import com.renodesign.dto.material.MaterialDto;
import com.renodesign.service.MaterialService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/materials")
@Tag(name = "Materials", description = "Endpoints for wall coverings and flooring materials")
public class MaterialController {

    private final MaterialService materialService;

    public MaterialController(MaterialService materialService) {
        this.materialService = materialService;
    }

    @GetMapping
    @Operation(summary = "Get materials with optional category filter (e.g. wall, floor)")
    public ResponseEntity<ApiResponse<List<MaterialDto>>> getMaterials(@RequestParam(required = false) String category) {
        List<MaterialDto> list = materialService.getMaterials(category);
        return ResponseEntity.ok(ApiResponse.success(list));
    }

    @GetMapping("/{id}")
    @Operation(summary = "Get material details by ID")
    public ResponseEntity<ApiResponse<MaterialDto>> getMaterialById(@PathVariable Long id) {
        MaterialDto dto = materialService.getMaterialById(id);
        return ResponseEntity.ok(ApiResponse.success(dto));
    }
}
