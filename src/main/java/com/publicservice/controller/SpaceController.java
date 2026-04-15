package com.publicservice.controller;

import com.publicservice.entity.Space;
import com.publicservice.repository.SpaceRepository;
import jakarta.persistence.criteria.Predicate;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/spaces")
public class SpaceController {

    private final SpaceRepository spaceRepository;

    public SpaceController(SpaceRepository spaceRepository) {
        this.spaceRepository = spaceRepository;
    }

    @GetMapping
    public Map<String, Object> getSpaces(
            @RequestParam(name = "region", required = false) String region,
            @RequestParam(name = "district", required = false) String district,
            @RequestParam(name = "spaceTypes", required = false) List<String> spaceTypes,
            @RequestParam(name = "minPrice", required = false) Integer minPrice,
            @RequestParam(name = "maxPrice", required = false) Integer maxPrice,
            @RequestParam(name = "capacity", required = false) Integer capacity,
            @RequestParam(name = "page", defaultValue = "0") int page,
            @RequestParam(name = "size", defaultValue = "12") int size) {

        Pageable pageable = PageRequest.of(
                Math.max(page, 0),
                Math.max(size, 1),
                Sort.by(Sort.Direction.ASC, "spaceId"));

        Specification<Space> specification = (root, query, criteriaBuilder) -> {
            List<Predicate> predicates = new ArrayList<>();

            if (region != null && !region.isBlank()) {
                predicates.add(criteriaBuilder.equal(root.get("region"), region));
            }

            if (district != null && !district.isBlank()) {
                predicates.add(criteriaBuilder.equal(root.get("district"), district));
            }

            if (spaceTypes != null && !spaceTypes.isEmpty()) {
                predicates.add(root.get("spaceType").in(spaceTypes));
            }

            if (minPrice != null) {
                predicates.add(criteriaBuilder.greaterThanOrEqualTo(root.get("pricePerHour"), minPrice));
            }

            if (maxPrice != null) {
                predicates.add(criteriaBuilder.lessThanOrEqualTo(root.get("pricePerHour"), maxPrice));
            }

            if (capacity != null) {
                predicates.add(criteriaBuilder.greaterThanOrEqualTo(root.get("capacity"), capacity));
            }

            return criteriaBuilder.and(predicates.toArray(new Predicate[0]));
        };

        Page<Space> result = spaceRepository.findAll(specification, pageable);

        Map<String, Object> response = new LinkedHashMap<>();
        response.put("items", result.getContent());
        response.put("page", result.getNumber());
        response.put("size", result.getSize());
        response.put("totalElements", result.getTotalElements());
        response.put("totalPages", result.getTotalPages());
        response.put("hasNext", result.hasNext());
        return response;
    }
}
