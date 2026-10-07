package com.renodesign.service.ai;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.*;
import org.springframework.http.client.SimpleClientHttpRequestFactory;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import java.util.Base64;
import java.util.HashMap;
import java.util.Map;

@Service
public class ReplicateAITransformationService implements AITransformationService {

    private static final Logger log = LoggerFactory.getLogger(ReplicateAITransformationService.class);

    @Value("${app.ai.api-key:}")
    private String apiKey;

    @Value("${app.ai.api-url:https://api.replicate.com/v1/predictions}")
    private String apiUrl;

    @Value("${app.ai.model:adirik/interior-design:76604baddc2f76fe7714fa4dd082960435fa2f96e42f0d0f7ac91adc373979be}")
    private String modelVersion;

    private final PromptEngine promptEngine;
    private final RestTemplate restTemplate;
    private final ObjectMapper objectMapper;

    public ReplicateAITransformationService(PromptEngine promptEngine) {
        this.promptEngine = promptEngine;
        this.restTemplate = buildRestTemplate();
        this.objectMapper = new ObjectMapper();
    }

    private RestTemplate buildRestTemplate() {
        SimpleClientHttpRequestFactory factory = new SimpleClientHttpRequestFactory();
        factory.setConnectTimeout(30_000);
        // Note: Replicate polls asynchronously, individual HTTP calls should be fast
        factory.setReadTimeout(30_000);
        return new RestTemplate(factory);
    }

    @Override
    public String getProviderName() {
        return "replicate";
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

            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.APPLICATION_JSON);
            headers.set("Authorization", "Bearer " + apiKey);

            byte[] imageBytes = request.getOriginalImageBytes();
            if (imageBytes == null || imageBytes.length == 0) {
                return AITransformationResult.failure("Original image data is missing", getProviderName());
            }

            String base64Image = "data:image/jpeg;base64," + Base64.getEncoder().encodeToString(imageBytes);

            Map<String, Object> input = new HashMap<>();
            input.put("image", base64Image);
            input.put("prompt", prompt);
            input.put("negative_prompt", promptEngine.buildNegativePrompt());
            input.put("guidance_scale", 8.0);

            Map<String, Object> body = new HashMap<>();
            String version = modelVersion.contains(":") ? modelVersion.split(":")[1] : modelVersion;
            body.put("version", version);
            body.put("input", input);

            HttpEntity<Map<String, Object>> entity = new HttpEntity<>(body, headers);
            log.info("Sending transformation request to Replicate API: {}", apiUrl);

            ResponseEntity<String> response = restTemplate.postForEntity(apiUrl, entity, String.class);
            if (response.getStatusCode().is2xxSuccessful() && response.getBody() != null) {
                JsonNode root = objectMapper.readTree(response.getBody());
                String getUrl = root.path("urls").path("get").asText();

                // Poll Replicate prediction until status is succeeded
                long startTime = System.currentTimeMillis();
                while (System.currentTimeMillis() - startTime < 120_000) {
                    Thread.sleep(3000);
                    HttpHeaders pollHeaders = new HttpHeaders();
                    pollHeaders.set("Authorization", "Bearer " + apiKey);
                    HttpEntity<Void> pollEntity = new HttpEntity<>(pollHeaders);

                    ResponseEntity<String> pollRes = restTemplate.exchange(getUrl, HttpMethod.GET, pollEntity, String.class);
                    if (pollRes.getBody() != null) {
                        JsonNode pollNode = objectMapper.readTree(pollRes.getBody());
                        String status = pollNode.path("status").asText();

                        if ("succeeded".equalsIgnoreCase(status)) {
                            JsonNode output = pollNode.path("output");
                            if (output.isArray() && !output.isEmpty()) {
                                return AITransformationResult.successWithUrl(output.get(0).asText(), getProviderName());
                            } else if (output.isTextual()) {
                                return AITransformationResult.successWithUrl(output.asText(), getProviderName());
                            }
                        } else if ("failed".equalsIgnoreCase(status) || "canceled".equalsIgnoreCase(status)) {
                            String err = pollNode.path("error").asText("Replicate processing failed");
                            return AITransformationResult.failure(err, getProviderName());
                        }
                    }
                }
            }

            return AITransformationResult.failure("Replicate transformation request timed out", getProviderName());

        } catch (Exception ex) {
            log.error("Replicate transformation error: {}", ex.getMessage(), ex);
            return AITransformationResult.failure("Replicate transformation error: " + ex.getMessage(), getProviderName());
        }
    }
}
