package com.publicservice.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;
import java.time.LocalDateTime;

@Entity
@Table(name = "spaces")
@Getter
@Setter
public class Space {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long spaceId;

    @Column(name = "host_id")
    private Long hostId;

    private String name;

    private String region;

    private String district;

    private String address;

    @Column(name = "space_type")
    private String spaceType;

    @Column(name = "price_per_hour")
    private int pricePerHour;

    private int capacity;

    @Column(name = "main_image_url")
    private String mainImageUrl;

    private String description;

    @Column(name = "available_yn")
    private String availableYn;

    @Column(name = "created_at")
    private LocalDateTime createdAt;

    @Column(name = "updated_at")
    private LocalDateTime updatedAt;
}