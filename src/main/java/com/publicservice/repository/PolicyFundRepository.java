package com.publicservice.repository;

import com.publicservice.entity.PolicyFund;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;

public interface PolicyFundRepository extends JpaRepository<PolicyFund, Long>,
        JpaSpecificationExecutor<PolicyFund> {
}
