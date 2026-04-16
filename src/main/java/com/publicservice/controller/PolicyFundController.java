package com.publicservice.controller;

import com.publicservice.entity.PolicyFund;
import com.publicservice.entity.PolicyScrap;
import com.publicservice.repository.PolicyFundRepository;
import com.publicservice.repository.PolicyScrapRepository;
import jakarta.persistence.criteria.Predicate;
import jakarta.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.Collections;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.stream.Collectors;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/policies")
public class PolicyFundController {

    private final PolicyFundRepository policyFundRepository;
    private final PolicyScrapRepository policyScrapRepository;

    public PolicyFundController(PolicyFundRepository policyFundRepository,
                                PolicyScrapRepository policyScrapRepository) {
        this.policyFundRepository = policyFundRepository;
        this.policyScrapRepository = policyScrapRepository;
    }

    @GetMapping
    public Map<String, Object> getPolicies(
            @RequestParam(name = "category", required = false) String category,
            @RequestParam(name = "institution", required = false) String institution,
            @RequestParam(name = "applicationAvailableYn", required = false) String applicationAvailableYn,
            @RequestParam(name = "keyword", required = false) String keyword,
            @RequestParam(name = "page", defaultValue = "0") int page,
            @RequestParam(name = "size", defaultValue = "12") int size,
            HttpSession session) {

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

        List<PolicyFund> items = new ArrayList<>(result.getContent());
        Collections.shuffle(items);

        Map<String, Object> response = new LinkedHashMap<>();
        response.put("items", items);
        response.put("page", result.getNumber());
        response.put("size", result.getSize());
        response.put("totalElements", result.getTotalElements());
        response.put("totalPages", result.getTotalPages());
        response.put("hasNext", result.hasNext());

        Long userId = (Long) session.getAttribute("loginUserId");
        if (userId != null) {
            response.put("scrappedPolicyIds", policyScrapRepository.findPolicyFundIdsByUserId(userId));
        } else {
            response.put("scrappedPolicyIds", List.of());
        }

        return response;
    }

    // 스크랩 토글 (로그인 필요)
    @PostMapping("/{id}/scrap")
    public Map<String, Object> toggleScrap(@PathVariable("id") Long policyFundId, HttpSession session) {
        Map<String, Object> result = new LinkedHashMap<>();

        Long userId = (Long) session.getAttribute("loginUserId");
        if (userId == null) {
            result.put("error", "로그인이 필요합니다.");
            result.put("scrapped", false);
            return result;
        }

        Optional<PolicyScrap> existing = policyScrapRepository.findByUserIdAndPolicyFundId(userId, policyFundId);
        if (existing.isPresent()) {
            policyScrapRepository.delete(existing.get());
            result.put("scrapped", false);
        } else {
            PolicyScrap scrap = new PolicyScrap();
            scrap.setUserId(userId);
            scrap.setPolicyFundId(policyFundId);
            policyScrapRepository.save(scrap);
            result.put("scrapped", true);
        }
        result.put("count", policyScrapRepository.countByUserId(userId));
        return result;
    }

    // 내 스크랩 목록 조회
    @GetMapping("/my-scraps")
    public Map<String, Object> getMyScraps(HttpSession session) {
        Map<String, Object> result = new LinkedHashMap<>();

        Long userId = (Long) session.getAttribute("loginUserId");
        if (userId == null) {
            result.put("items", List.of());
            result.put("count", 0);
            return result;
        }

        List<PolicyScrap> scraps = policyScrapRepository.findByUserIdOrderByCreatedAtDesc(userId);
        List<Long> policyIds = scraps.stream()
                .map(PolicyScrap::getPolicyFundId)
                .collect(Collectors.toList());

        Map<Long, PolicyFund> policyMap = policyFundRepository.findAllById(policyIds).stream()
                .collect(Collectors.toMap(PolicyFund::getId, p -> p));

        List<PolicyFund> orderedPolicies = policyIds.stream()
                .filter(policyMap::containsKey)
                .map(policyMap::get)
                .collect(Collectors.toList());

        result.put("items", orderedPolicies);
        result.put("count", scraps.size());
        return result;
    }
}
