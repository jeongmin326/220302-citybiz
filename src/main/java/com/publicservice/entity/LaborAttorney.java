package com.publicservice.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@Entity
@Table(name = "labor_attorneys")
@Getter
@Setter
public class LaborAttorney {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String name;

    private String office;

    private String city;

    private String district;

    @Column(name = "road_address")
    private String roadAddress;

    @Column(name = "addr", insertable = false, updatable = false)
    private String addr;

    private String phone;

    private BigDecimal rating;

    private String field;

    @Column(name = "consult_time")
    private String consultTime;

    @Column(name = "experience_years")
    private Integer experienceYears;

    private Integer price;

    private BigDecimal latitude;

    private BigDecimal longitude;

    @Column(name = "created_at")
    private LocalDateTime createdAt;

    @Column(name = "updated_at")
    private LocalDateTime updatedAt;
}
