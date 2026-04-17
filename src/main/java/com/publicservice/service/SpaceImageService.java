package com.publicservice.service;

import com.publicservice.entity.SpaceImage;
import com.publicservice.repository.SpaceImageRepository;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Objects;
import java.util.Optional;

@Service
public class SpaceImageService {

    private final SpaceImageRepository spaceImageRepository;

    public SpaceImageService(SpaceImageRepository spaceImageRepository) {
        this.spaceImageRepository = spaceImageRepository;
    }

    /**
     * 대표 이미지 저장.
     * 기존 대표 이미지(is_main=Y)가 있으면 N으로 변경 후 새로 저장.
     */
    public SpaceImage saveMainImage(Long spaceId, MultipartFile file) throws IOException {
        Objects.requireNonNull(spaceId, "spaceId must not be null");
        spaceImageRepository.findBySpaceIdAndIsMain(spaceId, "Y").ifPresent(existing -> {
            existing.setIsMain("N");
            spaceImageRepository.save(existing);
        });

        SpaceImage image = new SpaceImage();
        image.setSpaceId(spaceId);
        image.setFileName(file.getOriginalFilename());
        image.setContentType(file.getContentType());
        image.setImageData(file.getBytes());
        image.setIsMain("Y");
        image.setSortOrder(0);
        image.setCreatedAt(LocalDateTime.now());

        return spaceImageRepository.save(image);
    }

    public Optional<SpaceImage> findById(Long imageId) {
        return spaceImageRepository.findById(imageId);
    }

    public Optional<SpaceImage> findMainImage(Long spaceId) {
        return spaceImageRepository.findBySpaceIdAndIsMain(spaceId, "Y");
    }

    public List<SpaceImage> findAllBySpaceId(Long spaceId) {
        return spaceImageRepository.findBySpaceIdOrderBySortOrderAsc(spaceId);
    }
}
