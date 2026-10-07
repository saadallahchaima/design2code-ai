package com.renodesign.service;

import com.renodesign.dto.quote.QuoteCreateRequest;
import com.renodesign.dto.quote.QuoteResponse;
import com.renodesign.dto.quote.UpdateQuoteStatusRequest;
import com.renodesign.entity.QuoteRequest;
import com.renodesign.entity.QuoteStatus;
import com.renodesign.entity.Transformation;
import com.renodesign.entity.User;
import com.renodesign.exception.ResourceNotFoundException;
import com.renodesign.repository.QuoteRequestRepository;
import com.renodesign.repository.TransformationRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Service
public class QuoteService {

    private final QuoteRequestRepository quoteRequestRepository;
    private final TransformationRepository transformationRepository;

    public QuoteService(QuoteRequestRepository quoteRequestRepository, TransformationRepository transformationRepository) {
        this.quoteRequestRepository = quoteRequestRepository;
        this.transformationRepository = transformationRepository;
    }

    @Transactional
    public QuoteResponse createQuote(User user, QuoteCreateRequest request) {
        QuoteRequest quote = new QuoteRequest();
        quote.setUser(user);

        if (request.getTransformationId() != null) {
            Transformation transformation = transformationRepository.findById(request.getTransformationId())
                    .orElse(null);
            quote.setTransformation(transformation);
        }

        quote.setFullName(request.getFullName().trim());
        quote.setPhone(request.getPhone().trim());
        quote.setEmail(request.getEmail().trim());
        quote.setCity(request.getCity().trim());
        quote.setRoomType(request.getRoomType().trim());
        quote.setSurfaceArea(request.getSurfaceArea());
        quote.setMessage(request.getMessage() != null ? request.getMessage().trim() : null);
        quote.setStatus(QuoteStatus.PENDING);

        QuoteRequest saved = quoteRequestRepository.save(quote);
        return QuoteResponse.fromEntity(saved);
    }

    @Transactional(readOnly = true)
    public List<QuoteResponse> getUserQuotes(User user) {
        return quoteRequestRepository.findByUserIdOrderByCreatedAtDesc(user.getId()).stream()
                .map(QuoteResponse::fromEntity)
                .collect(Collectors.toList());
    }

    @Transactional(readOnly = true)
    public QuoteResponse getQuoteById(User user, Long id) {
        QuoteRequest quote = quoteRequestRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Quote request not found with id: " + id));

        // Check ownership unless admin
        if (!quote.getUser().getId().equals(user.getId()) && !user.getRole().name().equals("ADMIN")) {
            throw new ResourceNotFoundException("Quote request not found with id: " + id);
        }

        return QuoteResponse.fromEntity(quote);
    }

    @Transactional(readOnly = true)
    public List<QuoteResponse> getAllQuotesForAdmin(QuoteStatus status) {
        List<QuoteRequest> list;
        if (status != null) {
            list = quoteRequestRepository.findByStatusOrderByCreatedAtDesc(status);
        } else {
            list = quoteRequestRepository.findAll();
        }
        return list.stream().map(QuoteResponse::fromEntity).collect(Collectors.toList());
    }

    @Transactional
    public QuoteResponse updateQuoteStatus(Long id, UpdateQuoteStatusRequest request) {
        QuoteRequest quote = quoteRequestRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Quote request not found with id: " + id));

        quote.setStatus(request.getStatus());
        QuoteRequest updated = quoteRequestRepository.save(quote);
        return QuoteResponse.fromEntity(updated);
    }
}
