package com.publicservice.repository;

import com.publicservice.entity.Accountant;
import java.util.List;
import java.util.Optional;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;

public interface AccountantRepository extends JpaRepository<Accountant, Long>,
        JpaSpecificationExecutor<Accountant> {

    Optional<Accountant> findByUserId(Long userId);

    long countByDistrict(String district);

    List<Accountant> findByDistrict(String district);
}
