package com.renodesign.repository;

import com.renodesign.entity.StyleEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface StyleRepository extends JpaRepository<StyleEntity, Long> {
    List<StyleEntity> findByActiveTrue();
    Optional<StyleEntity> findByNameIgnoreCase(String name);
}
