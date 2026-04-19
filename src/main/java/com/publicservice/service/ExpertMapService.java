package com.publicservice.service;

import com.publicservice.dto.ExpertMapDto;
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
import java.util.Optional;
import org.springframework.stereotype.Service;

@Service
public class ExpertMapService {

    private final TaxAccountantRepository taxRepo;
    private final AccountantRepository accountRepo;
    private final LaborAttorneyRepository laborRepo;
    private final LawyerRepository lawyerRepo;
    private final PatentAttorneyRepository patentRepo;

    public ExpertMapService(TaxAccountantRepository taxRepo,
                            AccountantRepository accountRepo,
                            LaborAttorneyRepository laborRepo,
                            LawyerRepository lawyerRepo,
                            PatentAttorneyRepository patentRepo) {
        this.taxRepo = taxRepo;
        this.accountRepo = accountRepo;
        this.laborRepo = laborRepo;
        this.lawyerRepo = lawyerRepo;
        this.patentRepo = patentRepo;
    }

    public Optional<ExpertMapDto> findByTypeAndId(String type, Long id) {
        if (id == null) return Optional.empty();
        return switch (type.toLowerCase()) {
            case "tax"        -> taxRepo.findById(id).map(this::fromTax);
            case "accountant" -> accountRepo.findById(id).map(this::fromAccountant);
            case "labor"      -> laborRepo.findById(id).map(this::fromLabor);
            case "lawyer"     -> lawyerRepo.findById(id).map(this::fromLawyer);
            case "patent"     -> patentRepo.findById(id).map(this::fromPatent);
            default           -> Optional.empty();
        };
    }

    private ExpertMapDto fromTax(TaxAccountant e) {
        ExpertMapDto dto = new ExpertMapDto();
        dto.setId(e.getId());
        dto.setName(e.getName());
        dto.setOffice(e.getOffice());
        dto.setPhone(e.getPhone());
        dto.setAddress(e.getAddr());
        dto.setExpertType("세무사");
        dto.setLatitude(e.getLatitude());
        dto.setLongitude(e.getLongitude());
        return dto;
    }

    private ExpertMapDto fromAccountant(Accountant e) {
        ExpertMapDto dto = new ExpertMapDto();
        dto.setId(e.getId());
        dto.setName(e.getName());
        dto.setOffice(e.getOffice());
        dto.setPhone(e.getPhone());
        dto.setAddress(e.getAddr());
        dto.setExpertType("회계사");
        dto.setLatitude(e.getLatitude());
        dto.setLongitude(e.getLongitude());
        return dto;
    }

    private ExpertMapDto fromLabor(LaborAttorney e) {
        ExpertMapDto dto = new ExpertMapDto();
        dto.setId(e.getId());
        dto.setName(e.getName());
        dto.setOffice(e.getOffice());
        dto.setPhone(e.getPhone());
        dto.setAddress(e.getAddr());
        dto.setExpertType("노무사");
        dto.setLatitude(e.getLatitude());
        dto.setLongitude(e.getLongitude());
        return dto;
    }

    private ExpertMapDto fromLawyer(Lawyer e) {
        ExpertMapDto dto = new ExpertMapDto();
        dto.setId(e.getId());
        dto.setName(e.getName());
        dto.setOffice(e.getOffice());
        dto.setPhone(e.getPhone());
        dto.setAddress(e.getAddr());
        dto.setExpertType("변호사");
        dto.setLatitude(e.getLatitude());
        dto.setLongitude(e.getLongitude());
        return dto;
    }

    private ExpertMapDto fromPatent(PatentAttorney e) {
        ExpertMapDto dto = new ExpertMapDto();
        dto.setId(e.getId());
        dto.setName(e.getName());
        dto.setOffice(e.getOffice());
        dto.setPhone(e.getPhone());
        dto.setAddress(e.getAddr());
        dto.setExpertType("변리사");
        dto.setLatitude(e.getLatitude());
        dto.setLongitude(e.getLongitude());
        return dto;
    }
}
