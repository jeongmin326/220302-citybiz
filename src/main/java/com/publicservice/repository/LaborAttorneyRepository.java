package com.publicservice.repository;

import com.publicservice.entity.LaborAttorney;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;

public interface LaborAttorneyRepository extends JpaRepository<LaborAttorney, Long>,
        JpaSpecificationExecutor<LaborAttorney> {
}
