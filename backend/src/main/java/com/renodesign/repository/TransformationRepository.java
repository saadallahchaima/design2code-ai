package com.renodesign.repository;

import com.renodesign.entity.Transformation;
import com.renodesign.entity.TransformationStatus;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface TransformationRepository extends JpaRepository<Transformation, Long> {
    List<Transformation> findByUserIdOrderByCreatedAtDesc(Long userId);
    Optional<Transformation> findByIdAndUserId(Long id, Long userId);
    List<Transformation> findByStatus(TransformationStatus status);
}
