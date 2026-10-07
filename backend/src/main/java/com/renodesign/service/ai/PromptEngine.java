package com.renodesign.service.ai;

import org.springframework.stereotype.Component;

@Component
public class PromptEngine {

    public String buildPrompt(AITransformationRequest request) {
        StringBuilder sb = new StringBuilder();

        sb.append("Transform this interior photograph into a photorealistic, high-end renovated interior. ");
        sb.append("Preserve the original room architecture, perspective, windows, doors, walls, ceilings, and proportions. ");
        sb.append("Do not modify the structural layout, dimensions or geometry of the room. ");
        sb.append("Do not create unrealistic objects or distort doors or windows. Maintain realistic materials, shadows, reflections, and lighting.\n\n");

        sb.append("Apply the following renovation design specifications:\n");

        if (request.getRoomType() != null && !request.getRoomType().isBlank()) {
            sb.append("- Room: ").append(request.getRoomType()).append("\n");
        }

        if (request.getStyle() != null && !request.getStyle().isBlank()) {
            sb.append("- Interior Design Style: ").append(request.getStyle()).append("\n");
        }

        if (request.getWallMaterial() != null && !request.getWallMaterial().isBlank()) {
            sb.append("- Wall treatment: ").append(request.getWallMaterial()).append("\n");
        }

        if (request.getFloorMaterial() != null && !request.getFloorMaterial().isBlank()) {
            sb.append("- Flooring: ").append(request.getFloorMaterial()).append("\n");
        }

        if (request.getLighting() != null && !request.getLighting().isBlank()) {
            sb.append("- Lighting & Ambience: ").append(request.getLighting()).append("\n");
        }

        if (request.getCustomPrompt() != null && !request.getCustomPrompt().isBlank()) {
            sb.append("- Specific requirements: ").append(request.getCustomPrompt().trim()).append("\n");
        }

        sb.append("\nThe final result must look like an award-winning architectural and interior photograph captured with a full-frame camera with natural ambient daylight, 8k resolution, ultra-detailed architectural finishes, immaculate craftsmanship.");

        return sb.toString();
    }

    public String buildNegativePrompt() {
        return "blurry, low quality, distorted architecture, crooked walls, deformed windows, unnatural perspective, CGI artifacts, floating furniture, oversaturated, unrealistic geometry, bad proportions";
    }
}
