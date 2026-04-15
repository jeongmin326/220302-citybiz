package com.publicservice.repository;

import com.publicservice.entity.Accountant;
import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;

public interface AccountantRepository extends JpaRepository<Accountant, Long>,
        JpaSpecificationExecutor<Accountant> {

    long countByDistrict(String district);

    List<Accountant> findByDistrict(String district);
}
