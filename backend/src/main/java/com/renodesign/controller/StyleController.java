package com.renodesign.controller;

import com.renodesign.dto.common.ApiResponse;
import com.renodesign.dto.style.StyleDto;
import com.renodesign.service.StyleService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/styles")
@Tag(name = "Styles", description = "Endpoints for interior design renovation styles")
public class StyleController {

    private final StyleService styleService;

    public StyleController(StyleService styleService) {
        this.styleService = styleService;
    }

    @GetMapping
    @Operation(summary = "Get all active interior design styles")
    public ResponseEntity<ApiResponse<List<StyleDto>>> getAllStyles() {
        List<StyleDto> list = styleService.getAllActiveStyles();
        return ResponseEntity.ok(ApiResponse.success(list));
    }

    @GetMapping("/{id}")
    @Operation(summary = "Get style details by ID")
    public ResponseEntity<ApiResponse<StyleDto>> getStyleById(@PathVariable Long id) {
        StyleDto dto = styleService.getStyleById(id);
        return ResponseEntity.ok(ApiResponse.success(dto));
    }
}
