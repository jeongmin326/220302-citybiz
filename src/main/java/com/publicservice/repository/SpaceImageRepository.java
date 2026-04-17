package com.publicservice.repository;

import com.publicservice.entity.SpaceImage;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface SpaceImageRepository extends JpaRepository<SpaceImage, Long> {

    List<SpaceImage> findBySpaceIdOrderBySortOrderAsc(Long spaceId);

    Optional<SpaceImage> findBySpaceIdAndIsMain(Long spaceId, String isMain);
}
