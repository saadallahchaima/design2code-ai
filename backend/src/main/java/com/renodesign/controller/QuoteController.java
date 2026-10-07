package com.renodesign.controller;

import com.renodesign.dto.common.ApiResponse;
import com.renodesign.dto.quote.QuoteCreateRequest;
import com.renodesign.dto.quote.QuoteResponse;
import com.renodesign.entity.User;
import com.renodesign.service.QuoteService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/quotes")
@Tag(name = "Quotes", description = "Endpoints for requesting and tracking renovation quotes")
public class QuoteController {

    private final QuoteService quoteService;

    public QuoteController(QuoteService quoteService) {
        this.quoteService = quoteService;
    }

    @PostMapping
    @Operation(summary = "Submit a renovation quote request")
    public ResponseEntity<ApiResponse<QuoteResponse>> createQuote(
            @AuthenticationPrincipal User user,
            @Valid @RequestBody QuoteCreateRequest request
    ) {
        QuoteResponse response = quoteService.createQuote(user, request);
        return ResponseEntity.status(HttpStatus.CREATED).body(ApiResponse.success("Quote request submitted successfully", response));
    }

    @GetMapping
    @Operation(summary = "Get all quote requests submitted by the authenticated user")
    public ResponseEntity<ApiResponse<List<QuoteResponse>>> getUserQuotes(@AuthenticationPrincipal User user) {
        List<QuoteResponse> list = quoteService.getUserQuotes(user);
        return ResponseEntity.ok(ApiResponse.success(list));
    }

    @GetMapping("/{id}")
    @Operation(summary = "Get quote request details by ID")
    public ResponseEntity<ApiResponse<QuoteResponse>> getQuoteById(
            @AuthenticationPrincipal User user,
            @PathVariable Long id
    ) {
        QuoteResponse response = quoteService.getQuoteById(user, id);
        return ResponseEntity.ok(ApiResponse.success(response));
    }
}
