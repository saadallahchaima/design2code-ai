package com.renodesign;

import com.renodesign.service.ai.AITransformationRequest;
import com.renodesign.service.ai.AITransformationResult;
import com.renodesign.service.ai.PromptEngine;
import com.renodesign.service.ai.RealAITransformationService;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.ActiveProfiles;

import static org.junit.jupiter.api.Assertions.*;

@SpringBootTest
@ActiveProfiles("test")
class AITransformationServiceTest {

    @Autowired
    private PromptEngine promptEngine;

    @Autowired
    private RealAITransformationService realAITransformationService;

    @Test
    void testPromptEngineBuildsArchitecturalPrompt() {
        AITransformationRequest request = new AITransformationRequest();
        request.setRoomType("Living Room");
        request.setStyle("Scandinavian Nordic");
        request.setWallMaterial("Lime Wash Velvet Plaster");
        request.setFloorMaterial("Chevron Oak Parquet");
        request.setLighting("Concealed LED cove lights");
        request.setCustomPrompt("Add warm linen drapery and acoustic wooden slatted panels.");

        String prompt = promptEngine.buildPrompt(request);

        assertNotNull(prompt);
        assertTrue(prompt.contains("Scandinavian Nordic"));
        assertTrue(prompt.contains("Lime Wash Velvet Plaster"));
        assertTrue(prompt.contains("Chevron Oak Parquet"));
        assertTrue(prompt.contains("Concealed LED cove lights"));
        assertTrue(prompt.contains("Add warm linen drapery"));
        assertTrue(prompt.contains("Preserve the original room architecture"));
    }

    @Test
    void testUnconfiguredOrMockKeyReturnsDescriptiveFailure() {
        AITransformationRequest request = new AITransformationRequest();
        request.setRoomType("Kitchen");
        request.setStyle("Modern Luxury");
        request.setOriginalImageBytes(new byte[]{1, 2, 3});

        AITransformationResult result = realAITransformationService.transform(request);
        assertNotNull(result);
        assertFalse(result.isSuccess());
        assertTrue(result.getErrorMessage().contains("AI service is not configured")
                || result.getErrorMessage().contains("API key")
                || result.getErrorMessage().contains("failed"));
    }
}
