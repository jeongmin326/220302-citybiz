package com.publicservice.repository;

import com.publicservice.entity.TaxAccountant;
import java.util.List;
import java.util.Optional;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;

public interface TaxAccountantRepository extends JpaRepository<TaxAccountant, Long>,
        JpaSpecificationExecutor<TaxAccountant> {

    Optional<TaxAccountant> findByUserId(Long userId);

    long countByDistrict(String district);

    List<TaxAccountant> findByDistrict(String district);
}
