package com.publicservice.repository;

import com.publicservice.entity.TaxAccountant;
import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;

public interface TaxAccountantRepository extends JpaRepository<TaxAccountant, Long>,
        JpaSpecificationExecutor<TaxAccountant> {

    long countByDistrict(String district);

    List<TaxAccountant> findByDistrict(String district);
}
