package com.renodesign.service.ai;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.context.annotation.Primary;
import org.springframework.stereotype.Service;

@Service
@Primary
public class RealAITransformationService implements AITransformationService {

    private static final Logger log = LoggerFactory.getLogger(RealAITransformationService.class);

    private final AITransformationServiceFactory serviceFactory;

    public RealAITransformationService(AITransformationServiceFactory serviceFactory) {
        this.serviceFactory = serviceFactory;
    }

    @Override
    public AITransformationResult transform(AITransformationRequest request) {
        AITransformationService activeService = serviceFactory.getService();
        if (activeService == null) {
            log.warn("No active AI transformation service found in factory");
            return AITransformationResult.failure(
                    "AI service is not configured. Please configure the AI provider credentials (AI_API_KEY).",
                    "none"
            );
        }

        log.info("Executing real transformation via provider: {}", activeService.getProviderName());
        return activeService.transform(request);
    }

    @Override
    public String getProviderName() {
        AITransformationService activeService = serviceFactory.getService();
        return activeService != null ? activeService.getProviderName() : "real-ai-service";
    }

    @Override
    public boolean isConfigured() {
        AITransformationService activeService = serviceFactory.getService();
        return activeService != null && activeService.isConfigured();
    }
}
