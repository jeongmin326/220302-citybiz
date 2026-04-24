package com.publicservice.repository;

import com.publicservice.entity.PlanHistory;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface PlanHistoryRepository extends JpaRepository<PlanHistory, Long> {
    List<PlanHistory> findByUserIdOrderByCreatedAtDesc(Long userId);
    Optional<PlanHistory> findByImpUid(String impUid);
}
