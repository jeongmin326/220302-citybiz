package com.publicservice.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;
import java.time.LocalDateTime;

@Entity
@Table(name = "patent_attorneys")
@Getter
@Setter
public class PatentAttorney {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private Long patentAttorneyId;

    @Column(nullable = false)
    private String name;

    private Integer status;

    private String office;

    @Column(name = "addr")
    private String address;

    private String phone;

    @Column(nullable = false)
    private String field;

    @Column(name = "created_at")
    private LocalDateTime createdAt;

    @Column(name = "updated_at")
    private LocalDateTime updatedAt;
}
