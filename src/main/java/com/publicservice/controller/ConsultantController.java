package com.publicservice.controller;

import com.publicservice.entity.PatentAttorney;
import com.publicservice.repository.PatentAttorneyRepository;
import jakarta.persistence.criteria.Predicate;
import java.math.BigDecimal;
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
@RequestMapping("/api/consultants")
public class ConsultantController {

    private final PatentAttorneyRepository patentAttorneyRepository;

    public ConsultantController(PatentAttorneyRepository patentAttorneyRepository) {
        this.patentAttorneyRepository = patentAttorneyRepository;
    }

    @GetMapping
    public Map<String, Object> getConsultants(
            @RequestParam(name = "fields", required = false) List<String> fields,
            @RequestParam(name = "minRating", required = false) BigDecimal minRating,
            @RequestParam(name = "consultTime", required = false) String consultTime,
            @RequestParam(name = "minExperienceYears", required = false) Integer minExperienceYears,
            @RequestParam(name = "maxPrice", required = false) Integer maxPrice,
            @RequestParam(name = "page", defaultValue = "0") int page,
            @RequestParam(name = "size", defaultValue = "12") int size) {
        Pageable pageable = PageRequest.of(
                Math.max(page, 0),
                Math.max(size, 1),
                Sort.by(Sort.Direction.ASC, "name"));

        Specification<PatentAttorney> specification = (root, query, criteriaBuilder) -> {
            List<Predicate> predicates = new ArrayList<>();

            if (fields != null && !fields.isEmpty()) {
                predicates.add(root.get("field").in(fields));
            }

            if (minRating != null) {
                predicates.add(criteriaBuilder.greaterThanOrEqualTo(root.get("rating"), minRating));
            }

            if (consultTime != null && !consultTime.isBlank()) {
                predicates.add(criteriaBuilder.equal(root.get("consultTime"), consultTime));
            }

            if (minExperienceYears != null) {
                predicates.add(criteriaBuilder.greaterThanOrEqualTo(root.get("experienceYears"), minExperienceYears));
            }

            if (maxPrice != null) {
                predicates.add(criteriaBuilder.lessThanOrEqualTo(root.get("price"), maxPrice));
            }

            return criteriaBuilder.and(predicates.toArray(new Predicate[0]));
        };

        Page<PatentAttorney> result = patentAttorneyRepository.findAll(specification, pageable);

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
