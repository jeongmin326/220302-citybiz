package com.publicservice.repository;

import com.publicservice.entity.SpaceImage;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface SpaceImageRepository extends JpaRepository<SpaceImage, Long> {

    @org.springframework.data.jpa.repository.Query(
        "SELECT i FROM SpaceImage i WHERE i.spaceId = :spaceId AND i.isMain != 'D' ORDER BY i.sortOrder ASC")
    List<SpaceImage> findBySpaceIdOrderBySortOrderAsc(@org.springframework.data.repository.query.Param("spaceId") Long spaceId);

    Optional<SpaceImage> findBySpaceIdAndIsMain(Long spaceId, String isMain);

    Optional<SpaceImage> findFirstByIsMain(String isMain);
}
