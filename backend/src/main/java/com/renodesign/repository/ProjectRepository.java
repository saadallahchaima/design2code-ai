package com.renodesign.repository;

import com.renodesign.entity.Project;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ProjectRepository extends JpaRepository<Project, Long> {
    List<Project> findByStyleIgnoreCase(String style);
    List<Project> findByRoomTypeIgnoreCase(String roomType);
}
