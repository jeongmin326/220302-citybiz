package com.publicservice.repository;

import com.publicservice.entity.PolicyFund;
import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

public interface PolicyFundRepository extends JpaRepository<PolicyFund, Long>,
        JpaSpecificationExecutor<PolicyFund> {

    @Query("SELECT p FROM PolicyFund p WHERE " +
           "p.fundName LIKE %:kw% OR " +
           "p.supportTarget LIKE %:kw% OR " +
           "p.businessDescription LIKE %:kw% OR " +
           "p.hashtags LIKE %:kw% OR " +
           "p.institution LIKE %:kw%")
    List<PolicyFund> searchByKeyword(@Param("kw") String kw);
}
