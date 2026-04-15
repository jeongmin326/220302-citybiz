package com.publicservice.repository;

import com.publicservice.entity.PatentAttorney;
import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;

public interface PatentAttorneyRepository extends JpaRepository<PatentAttorney, Long>, JpaSpecificationExecutor<PatentAttorney> {

    long countByAddressContaining(String keyword);

    List<PatentAttorney> findByAddressContaining(String keyword);
}
