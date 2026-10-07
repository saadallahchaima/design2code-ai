package com.renodesign.repository;

import com.renodesign.entity.Favorite;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface FavoriteRepository extends JpaRepository<Favorite, Long> {
    List<Favorite> findByUserIdOrderByCreatedAtDesc(Long userId);
    Optional<Favorite> findByUserIdAndProjectId(Long userId, Long projectId);
    boolean existsByUserIdAndProjectId(Long userId, Long projectId);
    void deleteByUserIdAndProjectId(Long userId, Long projectId);
}
