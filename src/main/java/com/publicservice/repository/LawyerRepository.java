package com.publicservice.repository;

import com.publicservice.entity.Lawyer;
import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;

public interface LawyerRepository extends JpaRepository<Lawyer, Long>,
        JpaSpecificationExecutor<Lawyer> {

    long countByDistrict(String district);

    List<Lawyer> findByDistrict(String district);
}
