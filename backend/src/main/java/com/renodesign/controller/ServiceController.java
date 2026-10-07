package com.renodesign.controller;

import com.renodesign.dto.common.ApiResponse;
import com.renodesign.dto.service.ServiceDto;
import com.renodesign.service.CompanyServiceService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/services")
@Tag(name = "Services", description = "Endpoints for RenoDesign company renovation services")
public class ServiceController {

    private final CompanyServiceService serviceService;

    public ServiceController(CompanyServiceService serviceService) {
        this.serviceService = serviceService;
    }

    @GetMapping
    @Operation(summary = "Get all active renovation services offered by RenoDesign")
    public ResponseEntity<ApiResponse<List<ServiceDto>>> getAllServices() {
        List<ServiceDto> list = serviceService.getAllActiveServices();
        return ResponseEntity.ok(ApiResponse.success(list));
    }

    @GetMapping("/{id}")
    @Operation(summary = "Get service details by ID")
    public ResponseEntity<ApiResponse<ServiceDto>> getServiceById(@PathVariable Long id) {
        ServiceDto dto = serviceService.getServiceById(id);
        return ResponseEntity.ok(ApiResponse.success(dto));
    }
}
