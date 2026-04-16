package com.publicservice.repository;

import com.publicservice.entity.PolicyScrap;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;
import java.util.Optional;

public interface PolicyScrapRepository extends JpaRepository<PolicyScrap, Long> {

    Optional<PolicyScrap> findByUserIdAndPolicyFundId(Long userId, Long policyFundId);

    List<PolicyScrap> findByUserIdOrderByCreatedAtDesc(Long userId);

    long countByUserId(Long userId);

    @Query("SELECT s.policyFundId FROM PolicyScrap s WHERE s.userId = :userId")
    List<Long> findPolicyFundIdsByUserId(@Param("userId") Long userId);
}
