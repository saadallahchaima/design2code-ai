package com.renodesign;

import com.renodesign.dto.project.ProjectDto;
import com.renodesign.entity.Project;
import com.renodesign.service.ProjectService;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

import static org.junit.jupiter.api.Assertions.*;

@SpringBootTest
@ActiveProfiles("test")
@Transactional
class ProjectServiceTest {

    @Autowired
    private ProjectService projectService;

    @Test
    void testCreateAndRetrieveProject() {
        Project project = new Project();
        project.setTitle("Modern Parisian Penthouse");
        project.setDescription("Full renovation with herringbone parquet.");
        project.setLocation("Paris 16th");
        project.setRoomType("Living Room");
        project.setStyle("Modern Luxury");
        project.setCoverImage("https://example.com/cover.jpg");
        project.setBeforeImage("https://example.com/before.jpg");
        project.setAfterImage("https://example.com/after.jpg");

        ProjectDto created = projectService.createProject(project);
        assertNotNull(created.getId());
        assertEquals("Modern Parisian Penthouse", created.getTitle());

        List<ProjectDto> filtered = projectService.getAllProjects("Modern Luxury", null);
        assertFalse(filtered.isEmpty());
        assertEquals("Modern Luxury", filtered.get(0).getStyle());

        ProjectDto fetched = projectService.getProjectById(created.getId());
        assertEquals(created.getId(), fetched.getId());
    }
}
