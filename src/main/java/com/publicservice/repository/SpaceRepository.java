package com.publicservice.repository;

import com.publicservice.entity.Space;
import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;

public interface SpaceRepository extends JpaRepository<Space, Long>,
        JpaSpecificationExecutor<Space> {

    List<Space> findByDistrict(String district);

    List<Space> findByHostId(Long hostId);
}