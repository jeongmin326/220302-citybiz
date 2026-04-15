package com.publicservice.repository;

import com.publicservice.entity.Accountant;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;

public interface AccountantRepository extends JpaRepository<Accountant, Long>,
        JpaSpecificationExecutor<Accountant> {
}
