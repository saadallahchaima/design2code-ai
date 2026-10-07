package com.renodesign.repository;

import com.renodesign.entity.Material;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface MaterialRepository extends JpaRepository<Material, Long> {
    List<Material> findByActiveTrue();
    List<Material> findByCategoryIgnoreCaseAndActiveTrue(String category);
}
