package com.publicservice.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@Entity
@Table(name = "lawyers")
@Getter
@Setter
public class Lawyer {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "user_id")
    private Long userId;

    private String name;

    private String office;

    private String city;

    private String district;

    @Column(name = "road_address")
    private String roadAddress;

    @Column(name = "detail_address")
    private String detailAddress;

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

    @Column(precision = 10, scale = 7)
    private BigDecimal latitude;

    @Column(precision = 10, scale = 7)
    private BigDecimal longitude;

    @Column(name = "created_at", insertable = false, updatable = false)
    private LocalDateTime createdAt;

    @Column(name = "updated_at", insertable = false, updatable = false)
    private LocalDateTime updatedAt;
}
