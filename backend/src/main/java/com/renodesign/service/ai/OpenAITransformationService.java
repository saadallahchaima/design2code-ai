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
public class OpenAITransformationService implements AITransformationService {

    private static final Logger log = LoggerFactory.getLogger(OpenAITransformationService.class);

    @Value("${app.ai.api-key:}")
    private String apiKey;

    @Value("${app.ai.api-url:https://api.openai.com/v1/images/edits}")
    private String apiUrl;

    private final PromptEngine promptEngine;
    private final RestTemplate restTemplate;
    private final ObjectMapper objectMapper;

    public OpenAITransformationService(PromptEngine promptEngine) {
        this.promptEngine = promptEngine;
        this.restTemplate = buildRestTemplate();
        this.objectMapper = new ObjectMapper();
    }

    private RestTemplate buildRestTemplate() {
        SimpleClientHttpRequestFactory factory = new SimpleClientHttpRequestFactory();
        factory.setConnectTimeout(30_000);
        factory.setReadTimeout(120_000);
        return new RestTemplate(factory);
    }

    @Override
    public String getProviderName() {
        return "openai";
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
            headers.setContentType(MediaType.MULTIPART_FORM_DATA);
            headers.set("Authorization", "Bearer " + apiKey);

            MultiValueMap<String, Object> body = new LinkedMultiValueMap<>();

            byte[] imageBytes = request.getOriginalImageBytes();
            if (imageBytes == null || imageBytes.length == 0) {
                return AITransformationResult.failure("Original image data is missing", getProviderName());
            }

            ByteArrayResource fileResource = new ByteArrayResource(imageBytes) {
                @Override
                public String getFilename() {
                    return "image.png";
                }
            };

            body.add("image", fileResource);
            body.add("prompt", prompt);
            body.add("n", 1);
            body.add("size", "1024x1024");
            body.add("response_format", "b64_json");

            HttpEntity<MultiValueMap<String, Object>> entity = new HttpEntity<>(body, headers);

            log.info("Dispatching real AI transformation request to OpenAI Images API: {}", apiUrl);
            ResponseEntity<String> response = restTemplate.postForEntity(apiUrl, entity, String.class);

            if (response.getStatusCode().is2xxSuccessful() && response.getBody() != null) {
                JsonNode root = objectMapper.readTree(response.getBody());
                JsonNode data = root.path("data");
                if (data.isArray() && !data.isEmpty()) {
                    JsonNode firstItem = data.get(0);
                    if (firstItem.has("b64_json")) {
                        byte[] decoded = Base64.getDecoder().decode(firstItem.get("b64_json").asText());
                        return AITransformationResult.successWithBytes(decoded, "image/png", getProviderName());
                    } else if (firstItem.has("url")) {
                        return AITransformationResult.successWithUrl(firstItem.get("url").asText(), getProviderName());
                    }
                }
            }

            return AITransformationResult.failure("OpenAI returned status: " + response.getStatusCode(), getProviderName());

        } catch (Exception ex) {
            log.error("OpenAI transformation failed: {}", ex.getMessage(), ex);
            return AITransformationResult.failure("OpenAI transformation error: " + ex.getMessage(), getProviderName());
        }
    }
}
