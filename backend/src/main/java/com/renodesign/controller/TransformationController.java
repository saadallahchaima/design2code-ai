package com.renodesign.controller;

import com.renodesign.dto.common.ApiResponse;
import com.renodesign.dto.transformation.TransformationRequest;
import com.renodesign.dto.transformation.TransformationResponse;
import com.renodesign.entity.User;
import com.renodesign.service.TransformationService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;

@RestController
@RequestMapping("/api/transformations")
@Tag(name = "Transformations", description = "Endpoints for AI interior room transformations")
public class TransformationController {

    private final TransformationService transformationService;

    public TransformationController(TransformationService transformationService) {
        this.transformationService = transformationService;
    }

    @PostMapping(consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    @Operation(summary = "Submit a room photo and parameters for AI transformation")
    public ResponseEntity<ApiResponse<TransformationResponse>> createTransformation(
            @AuthenticationPrincipal User user,
            @RequestParam("file") MultipartFile file,
            @RequestParam("roomType") String roomType,
            @RequestParam("style") String style,
            @RequestParam(value = "wallMaterial", required = false) String wallMaterial,
            @RequestParam(value = "floorMaterial", required = false) String floorMaterial,
            @RequestParam(value = "lighting", required = false) String lighting,
            @RequestParam(value = "customPrompt", required = false) String customPrompt
    ) {
        TransformationRequest request = new TransformationRequest();
        request.setRoomType(roomType);
        request.setStyle(style);
        request.setWallMaterial(wallMaterial);
        request.setFloorMaterial(floorMaterial);
        request.setLighting(lighting);
        request.setCustomPrompt(customPrompt);

        TransformationResponse response = transformationService.initiateTransformation(user, file, request);
        return ResponseEntity.status(HttpStatus.ACCEPTED).body(ApiResponse.success("Transformation initiated", response));
    }

    @GetMapping
    @Operation(summary = "List all transformations created by the authenticated user")
    public ResponseEntity<ApiResponse<List<TransformationResponse>>> getUserTransformations(@AuthenticationPrincipal User user) {
        List<TransformationResponse> list = transformationService.getUserTransformations(user);
        return ResponseEntity.ok(ApiResponse.success(list));
    }

    @GetMapping("/{id}")
    @Operation(summary = "Get transformation details and status by ID")
    public ResponseEntity<ApiResponse<TransformationResponse>> getTransformationById(
            @AuthenticationPrincipal User user,
            @PathVariable Long id
    ) {
        TransformationResponse response = transformationService.getTransformationById(user, id);
        return ResponseEntity.ok(ApiResponse.success(response));
    }

    @PostMapping("/{id}/regenerate")
    @Operation(summary = "Regenerate transformation with new style or materials reusing the original photo")
    public ResponseEntity<ApiResponse<TransformationResponse>> regenerate(
            @AuthenticationPrincipal User user,
            @PathVariable Long id,
            @RequestBody TransformationRequest request
    ) {
        TransformationResponse response = transformationService.regenerate(user, id, request);
        return ResponseEntity.status(HttpStatus.ACCEPTED).body(ApiResponse.success("Regeneration initiated", response));
    }

    @DeleteMapping("/{id}")
    @Operation(summary = "Delete transformation by ID")
    public ResponseEntity<ApiResponse<Void>> deleteTransformation(
            @AuthenticationPrincipal User user,
            @PathVariable Long id
    ) {
        transformationService.deleteTransformation(user, id);
        return ResponseEntity.ok(ApiResponse.success("Transformation deleted successfully", null));
    }
}
