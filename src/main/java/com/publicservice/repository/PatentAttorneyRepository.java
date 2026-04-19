package com.publicservice.repository;

import com.publicservice.entity.PatentAttorney;
import java.util.List;
import java.util.Optional;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;

public interface PatentAttorneyRepository extends JpaRepository<PatentAttorney, Long>, JpaSpecificationExecutor<PatentAttorney> {

    Optional<PatentAttorney> findByUserId(Long userId);

    long countByAddrContaining(String keyword);

    List<PatentAttorney> findByAddrContaining(String keyword);
}
