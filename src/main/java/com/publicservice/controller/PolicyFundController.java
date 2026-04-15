package com.publicservice.controller;

import com.publicservice.entity.PolicyFund;
import com.publicservice.repository.PolicyFundRepository;
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
@RequestMapping("/api/policies")
public class PolicyFundController {

    private final PolicyFundRepository policyFundRepository;

    public PolicyFundController(PolicyFundRepository policyFundRepository) {
        this.policyFundRepository = policyFundRepository;
    }

    @GetMapping
    public Map<String, Object> getPolicies(
            @RequestParam(name = "category", required = false) String category,
            @RequestParam(name = "institution", required = false) String institution,
            @RequestParam(name = "applicationAvailableYn", required = false) String applicationAvailableYn,
            @RequestParam(name = "keyword", required = false) String keyword,
            @RequestParam(name = "page", defaultValue = "0") int page,
            @RequestParam(name = "size", defaultValue = "12") int size) {

        Pageable pageable = PageRequest.of(
                Math.max(page, 0),
                Math.max(size, 1),
                Sort.by(Sort.Direction.DESC, "registeredDate"));

        Specification<PolicyFund> specification = (root, query, criteriaBuilder) -> {
            List<Predicate> predicates = new ArrayList<>();

            if (category != null && !category.isBlank()) {
                predicates.add(criteriaBuilder.equal(root.get("category"), category));
            }

            if (institution != null && !institution.isBlank()) {
                predicates.add(criteriaBuilder.like(root.get("institution"),
                        "%" + institution + "%"));
            }

            if (applicationAvailableYn != null && !applicationAvailableYn.isBlank()) {
                predicates.add(criteriaBuilder.equal(root.get("applicationAvailableYn"),
                        applicationAvailableYn));
            }

            if (keyword != null && !keyword.isBlank()) {
                String pattern = "%" + keyword + "%";
                predicates.add(criteriaBuilder.or(
                        criteriaBuilder.like(root.get("fundName"), pattern),
                        criteriaBuilder.like(root.get("supportTarget"), pattern),
                        criteriaBuilder.like(root.get("businessDescription"), pattern),
                        criteriaBuilder.like(root.get("hashtags"), pattern),
                        criteriaBuilder.like(root.get("institution"), pattern)
                ));
            }

            return criteriaBuilder.and(predicates.toArray(new Predicate[0]));
        };

        Page<PolicyFund> result = policyFundRepository.findAll(specification, pageable);

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
