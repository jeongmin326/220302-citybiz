package com.publicservice.controller;

import com.publicservice.dto.ExpertDto;
import com.publicservice.entity.Accountant;
import com.publicservice.entity.LaborAttorney;
import com.publicservice.entity.PatentAttorney;
import com.publicservice.entity.TaxAccountant;
import com.publicservice.repository.AccountantRepository;
import com.publicservice.repository.LaborAttorneyRepository;
import com.publicservice.repository.PatentAttorneyRepository;
import com.publicservice.repository.TaxAccountantRepository;
import jakarta.persistence.criteria.Predicate;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Collections;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;
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
    private final TaxAccountantRepository taxAccountantRepository;
    private final AccountantRepository accountantRepository;
    private final LaborAttorneyRepository laborAttorneyRepository;

    public ConsultantController(PatentAttorneyRepository patentAttorneyRepository,
                                TaxAccountantRepository taxAccountantRepository,
                                AccountantRepository accountantRepository,
                                LaborAttorneyRepository laborAttorneyRepository) {
        this.patentAttorneyRepository = patentAttorneyRepository;
        this.taxAccountantRepository = taxAccountantRepository;
        this.accountantRepository = accountantRepository;
        this.laborAttorneyRepository = laborAttorneyRepository;
    }

    @GetMapping
    public Map<String, Object> getConsultants(
            @RequestParam(name = "type", required = false, defaultValue = "ALL") String type,
            @RequestParam(name = "district", required = false) String district,
            @RequestParam(name = "keyword", required = false) String keyword,
            @RequestParam(name = "minRating", required = false) BigDecimal minRating,
            @RequestParam(name = "consultTime", required = false) String consultTime,
            @RequestParam(name = "minExperienceYears", required = false) Integer minExperienceYears,
            @RequestParam(name = "maxPrice", required = false) Integer maxPrice,
            @RequestParam(name = "page", defaultValue = "0") int page,
            @RequestParam(name = "size", defaultValue = "12") int size) {

        List<ExpertDto> items;
        long totalElements;
        boolean hasNext;

        String upperType = type.toUpperCase();

        if ("ALL".equals(upperType)) {
            List<ExpertDto> all = new ArrayList<>();
            all.addAll(fetchPatent(district, keyword, minRating, consultTime, minExperienceYears, maxPrice));
            all.addAll(fetchTax(district, keyword, minRating, consultTime, minExperienceYears, maxPrice));
            all.addAll(fetchAccount(district, keyword, minRating, consultTime, minExperienceYears, maxPrice));
            all.addAll(fetchLabor(district, keyword, minRating, consultTime, minExperienceYears, maxPrice));
            Collections.shuffle(all);

            totalElements = all.size();
            int start = page * size;
            int end = (int) Math.min((long) start + size, totalElements);
            items = start < totalElements ? new ArrayList<>(all.subList(start, end)) : new ArrayList<>();
            hasNext = end < totalElements;

        } else {
            Pageable pageable = PageRequest.of(Math.max(page, 0), Math.max(size, 1), Sort.by(Sort.Direction.ASC, "name"));

            switch (upperType) {
                case "PATENT" -> {
                    Page<PatentAttorney> result = patentAttorneyRepository.findAll(buildPatentSpec(district, keyword, minRating, consultTime, minExperienceYears, maxPrice), pageable);
                    items = result.getContent().stream().map(ExpertDto::from).collect(Collectors.toList());
                    Collections.shuffle(items);
                    totalElements = result.getTotalElements();
                    hasNext = result.hasNext();
                }
                case "TAX" -> {
                    Page<TaxAccountant> result = taxAccountantRepository.findAll(buildSpec(district, keyword, minRating, consultTime, minExperienceYears, maxPrice), pageable);
                    items = result.getContent().stream().map(ExpertDto::from).collect(Collectors.toList());
                    Collections.shuffle(items);
                    totalElements = result.getTotalElements();
                    hasNext = result.hasNext();
                }
                case "ACCOUNT" -> {
                    Page<Accountant> result = accountantRepository.findAll(buildSpec(district, keyword, minRating, consultTime, minExperienceYears, maxPrice), pageable);
                    items = result.getContent().stream().map(ExpertDto::from).collect(Collectors.toList());
                    Collections.shuffle(items);
                    totalElements = result.getTotalElements();
                    hasNext = result.hasNext();
                }
                case "LABOR" -> {
                    Page<LaborAttorney> result = laborAttorneyRepository.findAll(buildSpec(district, keyword, minRating, consultTime, minExperienceYears, maxPrice), pageable);
                    items = result.getContent().stream().map(ExpertDto::from).collect(Collectors.toList());
                    Collections.shuffle(items);
                    totalElements = result.getTotalElements();
                    hasNext = result.hasNext();
                }
                default -> {
                    items = new ArrayList<>();
                    totalElements = 0;
                    hasNext = false;
                }
            }
        }

        Map<String, Object> response = new LinkedHashMap<>();
        response.put("items", items);
        response.put("page", page);
        response.put("size", size);
        response.put("totalElements", totalElements);
        response.put("totalPages", totalElements == 0 ? 0 : (int) Math.ceil((double) totalElements / size));
        response.put("hasNext", hasNext);
        return response;
    }

    // patent_attorneys 전용 (district → address LIKE 검색)
    private Specification<PatentAttorney> buildPatentSpec(String district, String keyword, BigDecimal minRating,
                                                           String consultTime, Integer minExperienceYears, Integer maxPrice) {
        return (root, query, cb) -> {
            List<Predicate> predicates = new ArrayList<>();
            if (district != null && !district.isBlank()) predicates.add(cb.like(root.get("address"), "%" + district + "%"));
            if (keyword != null && !keyword.isBlank()) {
                String pattern = "%" + keyword + "%";
                predicates.add(cb.or(cb.like(root.get("name"), pattern), cb.like(root.get("office"), pattern)));
            }
            if (minRating != null) predicates.add(cb.greaterThanOrEqualTo(root.get("rating"), minRating));
            if (consultTime != null && !consultTime.isBlank()) predicates.add(cb.equal(root.get("consultTime"), consultTime));
            if (minExperienceYears != null) predicates.add(cb.greaterThanOrEqualTo(root.get("experienceYears"), minExperienceYears));
            if (maxPrice != null) predicates.add(cb.lessThanOrEqualTo(root.get("price"), maxPrice));
            return cb.and(predicates.toArray(new Predicate[0]));
        };
    }

    // tax_accountants, accountants, labor_attorneys 공통 Specification
    private <T> Specification<T> buildSpec(String district, String keyword, BigDecimal minRating,
                                           String consultTime, Integer minExperienceYears, Integer maxPrice) {
        return (root, query, cb) -> {
            List<Predicate> predicates = new ArrayList<>();
            if (district != null && !district.isBlank()) predicates.add(cb.equal(root.get("district"), district));
            if (keyword != null && !keyword.isBlank()) {
                String pattern = "%" + keyword + "%";
                predicates.add(cb.or(cb.like(root.get("name"), pattern), cb.like(root.get("office"), pattern)));
            }
            if (minRating != null) predicates.add(cb.greaterThanOrEqualTo(root.get("rating"), minRating));
            if (consultTime != null && !consultTime.isBlank()) predicates.add(cb.equal(root.get("consultTime"), consultTime));
            if (minExperienceYears != null) predicates.add(cb.greaterThanOrEqualTo(root.get("experienceYears"), minExperienceYears));
            if (maxPrice != null) predicates.add(cb.lessThanOrEqualTo(root.get("price"), maxPrice));
            return cb.and(predicates.toArray(new Predicate[0]));
        };
    }

    private List<ExpertDto> fetchPatent(String district, String keyword, BigDecimal minRating, String consultTime, Integer minExp, Integer maxPrice) {
        return patentAttorneyRepository.findAll(buildPatentSpec(district, keyword, minRating, consultTime, minExp, maxPrice))
                .stream().map(ExpertDto::from).collect(Collectors.toList());
    }

    private List<ExpertDto> fetchTax(String district, String keyword, BigDecimal minRating, String consultTime, Integer minExp, Integer maxPrice) {
        return taxAccountantRepository.findAll(buildSpec(district, keyword, minRating, consultTime, minExp, maxPrice))
                .stream().map(ExpertDto::from).collect(Collectors.toList());
    }

    private List<ExpertDto> fetchAccount(String district, String keyword, BigDecimal minRating, String consultTime, Integer minExp, Integer maxPrice) {
        return accountantRepository.findAll(buildSpec(district, keyword, minRating, consultTime, minExp, maxPrice))
                .stream().map(ExpertDto::from).collect(Collectors.toList());
    }

    private List<ExpertDto> fetchLabor(String district, String keyword, BigDecimal minRating, String consultTime, Integer minExp, Integer maxPrice) {
        return laborAttorneyRepository.findAll(buildSpec(district, keyword, minRating, consultTime, minExp, maxPrice))
                .stream().map(ExpertDto::from).collect(Collectors.toList());
    }
}
