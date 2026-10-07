package com.renodesign.service.ai;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.ByteArrayResource;
import org.springframework.http.*;
import org.springframework.http.client.SimpleClientHttpRequestFactory;
import org.springframework.stereotype.Service;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.client.RestTemplate;

import java.util.Base64;

@Service
public class StabilityAITransformationService implements AITransformationService {

    private static final Logger log = LoggerFactory.getLogger(StabilityAITransformationService.class);

    @Value("${app.ai.api-key:}")
    private String apiKey;

    @Value("${app.ai.api-url:https://api.stability.ai/v1/generation/stable-diffusion-xl-1024-v1-0/image-to-image}")
    private String apiUrl;

    private final PromptEngine promptEngine;
    private final RestTemplate restTemplate;
    private final ObjectMapper objectMapper;

    public StabilityAITransformationService(PromptEngine promptEngine) {
        this.promptEngine = promptEngine;
        this.restTemplate = buildRestTemplate();
        this.objectMapper = new ObjectMapper();
    }

    private RestTemplate buildRestTemplate() {
        SimpleClientHttpRequestFactory factory = new SimpleClientHttpRequestFactory();
        factory.setConnectTimeout(30_000);   // 30s connect timeout
        factory.setReadTimeout(120_000);     // 120s read timeout for AI generation
        return new RestTemplate(factory);
    }

    @Override
    public String getProviderName() {
        return "stability";
    }

    @Override
    public boolean isConfigured() {
        return apiKey != null && !apiKey.isBlank() && !apiKey.equalsIgnoreCase("test-mock-key");
    }

    @Override
    public AITransformationResult transform(AITransformationRequest request) {
        if (!isConfigured()) {
            return AITransformationResult.failure(
                    "AI service is not configured. Please configure the AI provider credentials (AI_API_KEY).",
                    getProviderName()
            );
        }

        try {
            String prompt = promptEngine.buildPrompt(request);
            String negativePrompt = promptEngine.buildNegativePrompt();

            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.MULTIPART_FORM_DATA);
            headers.set("Authorization", "Bearer " + apiKey);
            headers.set("Accept", "application/json");

            MultiValueMap<String, Object> body = new LinkedMultiValueMap<>();

            // Attach photo bytes as multipart resource
            byte[] imageBytes = request.getOriginalImageBytes();
            if (imageBytes == null || imageBytes.length == 0) {
                return AITransformationResult.failure("Original image data is missing", getProviderName());
            }

            String filename = request.getOriginalImageFilename() != null ? request.getOriginalImageFilename() : "room.jpg";
            ByteArrayResource fileResource = new ByteArrayResource(imageBytes) {
                @Override
                public String getFilename() {
                    return filename;
                }
            };
            body.add("init_image", fileResource);

            // Architectural transformation parameters
            body.add("init_image_mode", "IMAGE_STRENGTH");
            body.add("image_strength", 0.35); // 0.35 retains exact wall/window geometry while renovating surfaces
            body.add("text_prompts[0][text]", prompt);
            body.add("text_prompts[0][weight]", 1.0);
            body.add("text_prompts[1][text]", negativePrompt);
            body.add("text_prompts[1][weight]", -1.0);
            body.add("cfg_scale", 7.5);
            body.add("samples", 1);
            body.add("steps", 30);

            HttpEntity<MultiValueMap<String, Object>> entity = new HttpEntity<>(body, headers);

            log.info("Dispatching real AI transformation request to Stability AI endpoint: {}", apiUrl);
            ResponseEntity<String> response = restTemplate.postForEntity(apiUrl, entity, String.class);

            if (response.getStatusCode().is2xxSuccessful() && response.getBody() != null) {
                JsonNode root = objectMapper.readTree(response.getBody());
                JsonNode artifacts = root.path("artifacts");
                if (artifacts.isArray() && !artifacts.isEmpty()) {
                    String base64Image = artifacts.get(0).path("base64").asText();
                    byte[] generatedBytes = Base64.getDecoder().decode(base64Image);
                    return AITransformationResult.successWithBytes(generatedBytes, "image/png", getProviderName());
                }
            }

            return AITransformationResult.failure(
                    "Stability AI API returned unexpected response: " + response.getStatusCode(),
                    getProviderName()
            );

        } catch (Exception ex) {
            log.error("Stability AI transformation failed: {}", ex.getMessage(), ex);
            return AITransformationResult.failure(
                    "Stability AI transformation failed: " + ex.getMessage(),
                    getProviderName()
            );
        }
    }
}
