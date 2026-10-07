package com.renodesign.service;

import com.renodesign.dto.transformation.TransformationRequest;
import com.renodesign.dto.transformation.TransformationResponse;
import com.renodesign.entity.Transformation;
import com.renodesign.entity.TransformationStatus;
import com.renodesign.entity.User;
import com.renodesign.exception.BadRequestException;
import com.renodesign.exception.ResourceNotFoundException;
import com.renodesign.repository.TransformationRepository;
import com.renodesign.service.ai.AITransformationRequest;
import com.renodesign.service.ai.AITransformationResult;
import com.renodesign.service.ai.AITransformationService;
import com.renodesign.service.storage.StorageService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

@Service
public class TransformationService {

    private static final Logger log = LoggerFactory.getLogger(TransformationService.class);

    private final TransformationRepository transformationRepository;
    private final StorageService storageService;
    private final AITransformationService aiTransformationService;

    public TransformationService(
            TransformationRepository transformationRepository,
            StorageService storageService,
            AITransformationService aiTransformationService
    ) {
        this.transformationRepository = transformationRepository;
        this.storageService = storageService;
        this.aiTransformationService = aiTransformationService;
    }

    @Transactional
    public TransformationResponse initiateTransformation(User user, MultipartFile file, TransformationRequest request) {
        if (file == null || file.isEmpty()) {
            throw new BadRequestException("Room image is required");
        }

        // 1. Upload original image
        String originalImageUrl = storageService.upload(file, "originals");

        // 2. Read bytes for AI processing
        byte[] imageBytes;
        try {
            imageBytes = file.getBytes();
        } catch (IOException e) {
            throw new RuntimeException("Could not read uploaded image bytes", e);
        }

        // 3. Persist Transformation entity with status PROCESSING
        Transformation entity = new Transformation();
        entity.setUser(user);
        entity.setOriginalImageUrl(originalImageUrl);
        entity.setRoomType(request.getRoomType());
        entity.setStyle(request.getStyle());
        entity.setWallMaterial(request.getWallMaterial());
        entity.setFloorMaterial(request.getFloorMaterial());
        entity.setLighting(request.getLighting());
        entity.setCustomPrompt(request.getCustomPrompt());
        entity.setStatus(TransformationStatus.PROCESSING);

        Transformation saved = transformationRepository.save(entity);

        // 4. Trigger AI transformation (asynchronously or synchronously)
        processTransformationAsync(saved.getId(), imageBytes, file.getOriginalFilename(), request);

        return TransformationResponse.fromEntity(saved);
    }

    @Async
    @Transactional
    public void processTransformationAsync(Long transformationId, byte[] imageBytes, String originalFilename, TransformationRequest request) {
        Transformation transformation = transformationRepository.findById(transformationId).orElse(null);
        if (transformation == null) {
            log.error("Transformation with ID {} not found for background AI processing", transformationId);
            return;
        }

        try {
            log.info("Starting AI transformation for id: {}, style: {}", transformationId, request.getStyle());

            AITransformationRequest aiRequest = new AITransformationRequest(
                    transformation.getOriginalImageUrl(),
                    imageBytes,
                    originalFilename,
                    request.getRoomType(),
                    request.getStyle(),
                    request.getWallMaterial(),
                    request.getFloorMaterial(),
                    request.getLighting(),
                    request.getCustomPrompt()
            );

            AITransformationResult result = aiTransformationService.transform(aiRequest);

            if (result.isSuccess()) {
                String generatedImageUrl;

                if (result.getImageBytes() != null && result.getImageBytes().length > 0) {
                    String ext = "image/png".equalsIgnoreCase(result.getMimeType()) ? ".png" : ".jpg";
                    String fileName = "gen_" + UUID.randomUUID() + ext;
                    generatedImageUrl = storageService.upload(result.getImageBytes(), fileName, result.getMimeType(), "generated");
                } else if (result.getImageUrl() != null && !result.getImageUrl().isBlank()) {
                    // Download remote URL and store locally for stability
                    try {
                        byte[] downloaded = downloadBytes(result.getImageUrl());
                        String fileName = "gen_" + UUID.randomUUID() + ".jpg";
                        generatedImageUrl = storageService.upload(downloaded, fileName, "image/jpeg", "generated");
                    } catch (Exception ex) {
                        generatedImageUrl = result.getImageUrl();
                    }
                } else {
                    transformation.setStatus(TransformationStatus.FAILED);
                    transformation.setErrorMessage("AI transformation returned no image data");
                    return;
                }

                transformation.setGeneratedImageUrl(generatedImageUrl);
                transformation.setStatus(TransformationStatus.COMPLETED);
                transformation.setErrorMessage(null);
                log.info("AI transformation completed successfully for id: {}", transformationId);

            } else {
                transformation.setStatus(TransformationStatus.FAILED);
                transformation.setErrorMessage(result.getErrorMessage() != null ? result.getErrorMessage() : "AI processing failed");
                log.warn("AI transformation failed for id: {}. Error: {}", transformationId, transformation.getErrorMessage());
            }

        } catch (Exception e) {
            log.error("Unexpected error during AI transformation execution: {}", e.getMessage(), e);
            transformation.setStatus(TransformationStatus.FAILED);
            transformation.setErrorMessage("Error during processing: " + e.getMessage());
        } finally {
            // Always persist the final status, even on unexpected exceptions
            transformationRepository.save(transformation);
        }
    }

    @Transactional
    public TransformationResponse regenerate(User user, Long existingTransformationId, TransformationRequest request) {
        Transformation existing = transformationRepository.findByIdAndUserId(existingTransformationId, user.getId())
                .orElseThrow(() -> new ResourceNotFoundException("Transformation not found with id: " + existingTransformationId));

        // Create new transformation reusing the exact original photo
        Transformation entity = new Transformation();
        entity.setUser(user);
        entity.setOriginalImageUrl(existing.getOriginalImageUrl());
        entity.setRoomType(request.getRoomType());
        entity.setStyle(request.getStyle());
        entity.setWallMaterial(request.getWallMaterial());
        entity.setFloorMaterial(request.getFloorMaterial());
        entity.setLighting(request.getLighting());
        entity.setCustomPrompt(request.getCustomPrompt());
        entity.setStatus(TransformationStatus.PROCESSING);

        Transformation saved = transformationRepository.save(entity);

        // Fetch original image bytes — fail fast if unavailable
        byte[] originalBytes;
        try {
            originalBytes = downloadBytes(existing.getOriginalImageUrl());
        } catch (Exception e) {
            log.error("Failed to download original image for regeneration id={}: {}", existingTransformationId, e.getMessage());
            throw new BadRequestException("Could not retrieve the original image for regeneration. Please try again.");
        }

        processTransformationAsync(saved.getId(), originalBytes, "regenerated_room.jpg", request);
        return TransformationResponse.fromEntity(saved);
    }

    @Transactional(readOnly = true)
    public List<TransformationResponse> getUserTransformations(User user) {
        return transformationRepository.findByUserIdOrderByCreatedAtDesc(user.getId()).stream()
                .map(TransformationResponse::fromEntity)
                .collect(Collectors.toList());
    }

    @Transactional(readOnly = true)
    public TransformationResponse getTransformationById(User user, Long id) {
        Transformation entity = transformationRepository.findByIdAndUserId(id, user.getId())
                .orElseThrow(() -> new ResourceNotFoundException("Transformation not found with id: " + id));
        return TransformationResponse.fromEntity(entity);
    }

    @Transactional
    public void deleteTransformation(User user, Long id) {
        Transformation entity = transformationRepository.findByIdAndUserId(id, user.getId())
                .orElseThrow(() -> new ResourceNotFoundException("Transformation not found with id: " + id));

        storageService.delete(entity.getOriginalImageUrl());
        if (entity.getGeneratedImageUrl() != null) {
            storageService.delete(entity.getGeneratedImageUrl());
        }

        transformationRepository.delete(entity);
    }

    private byte[] downloadBytes(String urlString) throws Exception {
        HttpClient client = HttpClient.newHttpClient();
        HttpRequest request = HttpRequest.newBuilder().uri(URI.create(urlString)).build();
        HttpResponse<byte[]> response = client.send(request, HttpResponse.BodyHandlers.ofByteArray());
        return response.body();
    }
}
