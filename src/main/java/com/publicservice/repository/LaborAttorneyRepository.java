package com.publicservice.repository;

import com.publicservice.entity.LaborAttorney;
import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;

public interface LaborAttorneyRepository extends JpaRepository<LaborAttorney, Long>,
        JpaSpecificationExecutor<LaborAttorney> {

    long countByDistrict(String district);

    List<LaborAttorney> findByDistrict(String district);
}
