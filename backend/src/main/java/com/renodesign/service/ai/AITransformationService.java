package com.renodesign.service.ai;

public interface AITransformationService {

    AITransformationResult transform(AITransformationRequest request);

    String getProviderName();

    boolean isConfigured();
}
