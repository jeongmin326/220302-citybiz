package com.publicservice.controller;

import com.publicservice.dto.ExpertProfileRequest;
import com.publicservice.entity.Accountant;
import com.publicservice.entity.LaborAttorney;
import com.publicservice.entity.Lawyer;
import com.publicservice.entity.PatentAttorney;
import com.publicservice.entity.TaxAccountant;
import com.publicservice.repository.AccountantRepository;
import com.publicservice.repository.LaborAttorneyRepository;
import com.publicservice.repository.LawyerRepository;
import com.publicservice.repository.PatentAttorneyRepository;
import com.publicservice.repository.TaxAccountantRepository;
import jakarta.servlet.http.HttpSession;
import java.math.BigDecimal;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/expert")
public class ExpertProfileController {

    private final TaxAccountantRepository taxAccountantRepository;
    private final AccountantRepository accountantRepository;
    private final LaborAttorneyRepository laborAttorneyRepository;
    private final LawyerRepository lawyerRepository;
    private final PatentAttorneyRepository patentAttorneyRepository;

    public ExpertProfileController(TaxAccountantRepository taxAccountantRepository,
                                   AccountantRepository accountantRepository,
                                   LaborAttorneyRepository laborAttorneyRepository,
                                   LawyerRepository lawyerRepository,
                                   PatentAttorneyRepository patentAttorneyRepository) {
        this.taxAccountantRepository = taxAccountantRepository;
        this.accountantRepository = accountantRepository;
        this.laborAttorneyRepository = laborAttorneyRepository;
        this.lawyerRepository = lawyerRepository;
        this.patentAttorneyRepository = patentAttorneyRepository;
    }

    @PostMapping("/profile")
    public ResponseEntity<String> saveProfile(ExpertProfileRequest req, HttpSession session) {
        Long userId = (Long) session.getAttribute("loginUserId");
        if (userId == null) {
            return ResponseEntity.status(401).body("로그인이 필요합니다.");
        }

        switch (req.getExpertType()) {
            case "세무사" -> {
                TaxAccountant e = taxAccountantRepository.findByUserId(userId)
                        .orElse(new TaxAccountant());
                e.setUserId(userId);
                fillCommon(e, req);
                taxAccountantRepository.save(e);
            }
            case "회계사" -> {
                Accountant e = accountantRepository.findByUserId(userId)
                        .orElse(new Accountant());
                e.setUserId(userId);
                fillCommon(e, req);
                accountantRepository.save(e);
            }
            case "노무사" -> {
                LaborAttorney e = laborAttorneyRepository.findByUserId(userId)
                        .orElse(new LaborAttorney());
                e.setUserId(userId);
                fillCommon(e, req);
                laborAttorneyRepository.save(e);
            }
            case "변호사" -> {
                Lawyer e = lawyerRepository.findByUserId(userId)
                        .orElse(new Lawyer());
                e.setUserId(userId);
                fillCommon(e, req);
                lawyerRepository.save(e);
            }
            case "변리사" -> {
                PatentAttorney e = patentAttorneyRepository.findByUserId(userId)
                        .orElse(new PatentAttorney());
                e.setUserId(userId);
                fillCommon(e, req);
                patentAttorneyRepository.save(e);
            }
            default -> {
                return ResponseEntity.badRequest().body("올바르지 않은 전문가 유형입니다.");
            }
        }
        return ResponseEntity.ok("프로필이 저장되었습니다.");
    }

    private void fillCommon(TaxAccountant e, ExpertProfileRequest req) {
        e.setName(req.getName());
        e.setOffice(req.getOffice());
        e.setPhone(req.getPhone());
        e.setCity(req.getCity());
        e.setDistrict(req.getDistrict());
        e.setRoadAddress(req.getRoadAddress());
        if (req.getDetailAddress() != null) e.setDetailAddress(req.getDetailAddress());
        e.setField(req.getField());
        e.setConsultTime(req.getConsultTime());
        e.setExperienceYears(req.getExperienceYears());
        e.setPrice(req.getPrice());
        if (e.getRating() == null) e.setRating(BigDecimal.ZERO);
        if (req.getLatitude()  != null) e.setLatitude(BigDecimal.valueOf(req.getLatitude()));
        if (req.getLongitude() != null) e.setLongitude(BigDecimal.valueOf(req.getLongitude()));
    }

    private void fillCommon(Accountant e, ExpertProfileRequest req) {
        e.setName(req.getName());
        e.setOffice(req.getOffice());
        e.setPhone(req.getPhone());
        e.setCity(req.getCity());
        e.setDistrict(req.getDistrict());
        e.setRoadAddress(req.getRoadAddress());
        if (req.getDetailAddress() != null) e.setDetailAddress(req.getDetailAddress());
        e.setField(req.getField());
        e.setConsultTime(req.getConsultTime());
        e.setExperienceYears(req.getExperienceYears());
        e.setPrice(req.getPrice());
        if (e.getRating() == null) e.setRating(BigDecimal.ZERO);
        if (req.getLatitude()  != null) e.setLatitude(BigDecimal.valueOf(req.getLatitude()));
        if (req.getLongitude() != null) e.setLongitude(BigDecimal.valueOf(req.getLongitude()));
    }

    private void fillCommon(LaborAttorney e, ExpertProfileRequest req) {
        e.setName(req.getName());
        e.setOffice(req.getOffice());
        e.setPhone(req.getPhone());
        e.setCity(req.getCity());
        e.setDistrict(req.getDistrict());
        e.setRoadAddress(req.getRoadAddress());
        if (req.getDetailAddress() != null) e.setDetailAddress(req.getDetailAddress());
        e.setField(req.getField());
        e.setConsultTime(req.getConsultTime());
        e.setExperienceYears(req.getExperienceYears());
        e.setPrice(req.getPrice());
        if (e.getRating() == null) e.setRating(BigDecimal.ZERO);
        if (req.getLatitude()  != null) e.setLatitude(BigDecimal.valueOf(req.getLatitude()));
        if (req.getLongitude() != null) e.setLongitude(BigDecimal.valueOf(req.getLongitude()));
    }

    private void fillCommon(Lawyer e, ExpertProfileRequest req) {
        e.setName(req.getName());
        e.setOffice(req.getOffice());
        e.setPhone(req.getPhone());
        e.setCity(req.getCity());
        e.setDistrict(req.getDistrict());
        e.setRoadAddress(req.getRoadAddress());
        if (req.getDetailAddress() != null) e.setDetailAddress(req.getDetailAddress());
        e.setField(req.getField());
        e.setConsultTime(req.getConsultTime());
        e.setExperienceYears(req.getExperienceYears());
        e.setPrice(req.getPrice());
        if (e.getRating() == null) e.setRating(BigDecimal.ZERO);
        if (req.getLatitude()  != null) e.setLatitude(BigDecimal.valueOf(req.getLatitude()));
        if (req.getLongitude() != null) e.setLongitude(BigDecimal.valueOf(req.getLongitude()));
    }

    private void fillCommon(PatentAttorney e, ExpertProfileRequest req) {
        e.setName(req.getName());
        e.setOffice(req.getOffice());
        e.setPhone(req.getPhone());
        e.setCity(req.getCity());
        e.setDistrict(req.getDistrict());
        e.setRoadAddress(req.getRoadAddress());
        if (req.getDetailAddress() != null) e.setDetailAddress(req.getDetailAddress());
        e.setField(req.getField());
        e.setConsultTime(req.getConsultTime());
        e.setExperienceYears(req.getExperienceYears());
        e.setPrice(req.getPrice());
        if (e.getRating() == null) e.setRating(BigDecimal.ZERO);
        if (req.getLatitude()  != null) e.setLatitude(BigDecimal.valueOf(req.getLatitude()));
        if (req.getLongitude() != null) e.setLongitude(BigDecimal.valueOf(req.getLongitude()));
    }
}
