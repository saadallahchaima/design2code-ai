package com.renodesign.repository;

import com.renodesign.entity.QuoteRequest;
import com.renodesign.entity.QuoteStatus;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface QuoteRequestRepository extends JpaRepository<QuoteRequest, Long> {
    List<QuoteRequest> findByUserIdOrderByCreatedAtDesc(Long userId);
    List<QuoteRequest> findByStatusOrderByCreatedAtDesc(QuoteStatus status);
}
