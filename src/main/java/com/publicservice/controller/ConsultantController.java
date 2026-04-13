package com.publicservice.controller;

import com.publicservice.entity.PatentAttorney;
import com.publicservice.repository.PatentAttorneyRepository;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
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
            @RequestParam(name = "page", defaultValue = "0") int page,
            @RequestParam(name = "size", defaultValue = "12") int size) {
        Pageable pageable = PageRequest.of(Math.max(page, 0), Math.max(size, 1));
        Page<PatentAttorney> result;

        if (fields == null || fields.isEmpty()) {
            result = patentAttorneyRepository.findAllByOrderByNameAsc(pageable);
        } else {
            result = patentAttorneyRepository.findByFieldInOrderByNameAsc(fields, pageable);
        }

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
