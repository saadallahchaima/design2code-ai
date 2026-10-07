package com.renodesign.service.storage;

import com.renodesign.exception.BadRequestException;
import jakarta.annotation.PostConstruct;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.Arrays;
import java.util.List;
import java.util.UUID;

@Service
@ConditionalOnProperty(name = "app.storage.provider", havingValue = "local", matchIfMissing = true)
public class LocalStorageService implements StorageService {

    @Value("${app.storage.upload-dir:uploads}")
    private String uploadDir;

    @Value("${app.storage.base-url:http://localhost:8080/uploads}")
    private String baseUrl;

    private static final List<String> ALLOWED_CONTENT_TYPES = Arrays.asList(
            "image/jpeg", "image/png", "image/webp", "image/jpg"
    );

    @PostConstruct
    public void init() {
        try {
            Files.createDirectories(Paths.get(uploadDir));
            Files.createDirectories(Paths.get(uploadDir, "originals"));
            Files.createDirectories(Paths.get(uploadDir, "generated"));
            Files.createDirectories(Paths.get(uploadDir, "materials"));
            Files.createDirectories(Paths.get(uploadDir, "projects"));
        } catch (IOException e) {
            throw new RuntimeException("Could not initialize local storage folder", e);
        }
    }

    @Override
    public String upload(MultipartFile file, String folder) {
        if (file.isEmpty()) {
            throw new BadRequestException("Failed to store empty file");
        }

        String contentType = file.getContentType();
        if (contentType == null || !ALLOWED_CONTENT_TYPES.contains(contentType.toLowerCase())) {
            throw new BadRequestException("Invalid image format: " + contentType + ". Allowed formats: JPEG, PNG, WEBP");
        }

        String originalFilename = file.getOriginalFilename();
        String extension = "";
        if (originalFilename != null && originalFilename.contains(".")) {
            extension = originalFilename.substring(originalFilename.lastIndexOf("."));
        } else {
            extension = ".jpg";
        }

        String fileName = UUID.randomUUID() + extension;
        Path targetFolder = Paths.get(uploadDir, folder);

        try {
            Files.createDirectories(targetFolder);
            Path destination = targetFolder.resolve(fileName);
            Files.copy(file.getInputStream(), destination, StandardCopyOption.REPLACE_EXISTING);
            return baseUrl + "/" + folder + "/" + fileName;
        } catch (IOException e) {
            throw new RuntimeException("Failed to store file " + fileName, e);
        }
    }

    @Override
    public String upload(byte[] content, String fileName, String contentType, String folder) {
        if (content == null || content.length == 0) {
            throw new BadRequestException("Content is empty");
        }

        Path targetFolder = Paths.get(uploadDir, folder);
        try {
            Files.createDirectories(targetFolder);
            Path destination = targetFolder.resolve(fileName);
            Files.write(destination, content);
            return baseUrl + "/" + folder + "/" + fileName;
        } catch (IOException e) {
            throw new RuntimeException("Failed to store file bytes " + fileName, e);
        }
    }

    @Override
    public void delete(String fileUrl) {
        if (fileUrl == null || !fileUrl.contains(baseUrl)) {
            return;
        }
        String relativePath = fileUrl.replace(baseUrl + "/", "");
        Path targetFile = Paths.get(uploadDir, relativePath);
        try {
            Files.deleteIfExists(targetFile);
        } catch (IOException ignored) {}
    }

    @Override
    public String getUrl(String fileName) {
        return baseUrl + "/" + fileName;
    }
}
