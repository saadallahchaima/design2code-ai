package com.renodesign.service.storage;

import org.springframework.web.multipart.MultipartFile;

public interface StorageService {
    String upload(MultipartFile file, String folder);
    String upload(byte[] content, String fileName, String contentType, String folder);
    void delete(String fileUrl);
    String getUrl(String fileName);
}
