package com.publicservice.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;
import java.time.LocalDate;
import java.time.LocalDateTime;

@Entity
@Table(name = "policy_funds")
@Getter
@Setter
public class PolicyFund {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String category;

    @Column(name = "fund_name")
    private String fundName;

    @Column(name = "support_target")
    private String supportTarget;

    @Column(name = "business_description", columnDefinition = "TEXT")
    private String businessDescription;

    private String institution;

    private String hashtags;

    @Column(name = "registered_date")
    private LocalDate registeredDate;

    @Column(name = "application_available_yn")
    private String applicationAvailableYn;

    @Column(name = "created_at")
    private LocalDateTime createdAt;

    @Column(name = "updated_at")
    private LocalDateTime updatedAt;
}
