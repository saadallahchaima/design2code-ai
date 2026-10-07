package com.renodesign.service;

import com.renodesign.dto.service.ServiceDto;
import com.renodesign.entity.ServiceEntity;
import com.renodesign.exception.ResourceNotFoundException;
import com.renodesign.repository.ServiceRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Service
@Transactional(readOnly = true)
public class CompanyServiceService {

    private final ServiceRepository serviceRepository;

    public CompanyServiceService(ServiceRepository serviceRepository) {
        this.serviceRepository = serviceRepository;
    }

    public List<ServiceDto> getAllActiveServices() {
        return serviceRepository.findByActiveTrue().stream()
                .map(ServiceDto::fromEntity)
                .collect(Collectors.toList());
    }

    public ServiceDto getServiceById(Long id) {
        ServiceEntity entity = serviceRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Service not found with id: " + id));
        return ServiceDto.fromEntity(entity);
    }

    @Transactional
    public ServiceDto createService(ServiceEntity entity) {
        return ServiceDto.fromEntity(serviceRepository.save(entity));
    }

    @Transactional
    public ServiceDto updateService(Long id, ServiceEntity details) {
        ServiceEntity existing = serviceRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Service not found with id: " + id));

        existing.setName(details.getName());
        existing.setDescription(details.getDescription());
        if (details.getImage() != null) existing.setImage(details.getImage());
        existing.setActive(details.isActive());

        return ServiceDto.fromEntity(serviceRepository.save(existing));
    }

    @Transactional
    public void deleteService(Long id) {
        if (!serviceRepository.existsById(id)) {
            throw new ResourceNotFoundException("Service not found with id: " + id);
        }
        serviceRepository.deleteById(id);
    }
}
