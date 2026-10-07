package com.renodesign.service.ai;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.ApplicationContext;
import org.springframework.stereotype.Component;

import java.util.Arrays;
import java.util.LinkedHashMap;
import java.util.Map;

/**
 * Factory that selects the correct AI provider implementation based on configuration.
 * Uses ApplicationContext lazy lookup to avoid circular dependency with RealAITransformationService.
 */
@Component
public class AITransformationServiceFactory {

    private final ApplicationContext applicationContext;
    private final String configuredProvider;

    public AITransformationServiceFactory(
            ApplicationContext applicationContext,
            @Value("${app.ai.provider:stability}") String configuredProvider
    ) {
        this.applicationContext = applicationContext;
        this.configuredProvider = configuredProvider;
    }

    public AITransformationService getService() {
        return getService(configuredProvider);
    }

    public AITransformationService getService(String provider) {
        Map<String, AITransformationService> candidates = new LinkedHashMap<>();
        Map<String, AITransformationService> allBeans = applicationContext.getBeansOfType(AITransformationService.class);
        for (Map.Entry<String, AITransformationService> entry : allBeans.entrySet()) {
            AITransformationService svc = entry.getValue();
            // Skip the facade to avoid circular resolution
            if (svc instanceof RealAITransformationService) continue;
            candidates.put(svc.getProviderName().toLowerCase(), svc);
        }

        String target = provider != null ? provider.toLowerCase() : "stability";
        AITransformationService service = candidates.get(target);
        if (service == null) {
            service = candidates.get("stability");
        }
        if (service == null && !candidates.isEmpty()) {
            service = candidates.values().iterator().next();
        }
        return service;
    }
}
