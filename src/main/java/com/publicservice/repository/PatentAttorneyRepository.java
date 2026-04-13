package com.publicservice.repository;

import com.publicservice.entity.PatentAttorney;
import java.util.Collection;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;

public interface PatentAttorneyRepository extends JpaRepository<PatentAttorney, Long> {

    Page<PatentAttorney> findAllByOrderByNameAsc(Pageable pageable);

    Page<PatentAttorney> findByFieldInOrderByNameAsc(Collection<String> fields, Pageable pageable);
}
