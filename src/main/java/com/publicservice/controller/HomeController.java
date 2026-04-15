package com.publicservice.controller;

import com.publicservice.dto.ExpertDto;
import com.publicservice.entity.PolicyFund;
import com.publicservice.entity.Space;
import com.publicservice.repository.AccountantRepository;
import com.publicservice.repository.LaborAttorneyRepository;
import com.publicservice.repository.PatentAttorneyRepository;
import com.publicservice.repository.PolicyFundRepository;
import com.publicservice.repository.SpaceRepository;
import com.publicservice.repository.TaxAccountantRepository;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
public class HomeController {

    private final PolicyFundRepository policyFundRepository;
    private final SpaceRepository spaceRepository;
    private final PatentAttorneyRepository patentAttorneyRepository;
    private final TaxAccountantRepository taxAccountantRepository;
    private final AccountantRepository accountantRepository;
    private final LaborAttorneyRepository laborAttorneyRepository;

    public HomeController(PolicyFundRepository policyFundRepository,
                          SpaceRepository spaceRepository,
                          PatentAttorneyRepository patentAttorneyRepository,
                          TaxAccountantRepository taxAccountantRepository,
                          AccountantRepository accountantRepository,
                          LaborAttorneyRepository laborAttorneyRepository) {
        this.policyFundRepository = policyFundRepository;
        this.spaceRepository = spaceRepository;
        this.patentAttorneyRepository = patentAttorneyRepository;
        this.taxAccountantRepository = taxAccountantRepository;
        this.accountantRepository = accountantRepository;
        this.laborAttorneyRepository = laborAttorneyRepository;
    }
    // 03/29 07:20 /main이 없어져서 다시 추가했어용
    @GetMapping("/main")
    public String mainPage() {
        return "home/main";
    }

    // 교수님이 말하는 사이트 구조
    @GetMapping("/prof")
    public String profPage() {
        return "home/prof";
    }

    // 공간 대여 페이지 매핑
    @GetMapping("/space")
    public String spacePage() {
        return "home/space"; 
    }

    // 정책 페이지 매핑
    @GetMapping("/policy")
    public String policyPage() {
        return "home/policy"; 
    }

    // 컨설팅 페이지 매핑
    @GetMapping("/consulting")
    public String consultingPage() {
        return "home/consulting"; 
    }
    // 마이페이지(User) 매핑
    @GetMapping("/mypage/status")
    public String statusPage() {
        // views/mypage 폴더 안의 status.jsp를 화면에 띄우라는 뜻입니다.
        return "mypage/status"; 
    }

    // 공급자(Host) 공간 등록 페이지 매핑
    @GetMapping("/mypage/spaceRegi") // 웹 브라우저에 입력할 주소 (예: localhost:8080/mypage/spaceRegi)
    public String spaceRegisterPage() {
        // views/mypage 폴더 안의 spaceRegi.jsp를 화면에 띄우라는 뜻입니다.
        return "mypage/spaceRegi"; 
    }

    // 공급자(Host) 예약 관리(대시보드) 페이지 매핑
    @GetMapping("/mypage/spaceManagement")
    public String spaceManagementPage() {
        return "mypage/spaceManagement"; 
    }

    // 전문가(Expert) 프로필 수정 페이지 매핑
    @GetMapping("/mypage/expertProfile")
    public String expertProfilePage() {
        return "mypage/expertProfile"; 
    }

    // 전문가(Expert) 컨설팅 신청 관리 페이지 매핑
    @GetMapping("/mypage/expertManagement")
    public String expertManagementPage() {
        return "mypage/expertManagement"; 
    }

    @GetMapping("/search")
    public String searchPage(@RequestParam(name = "keyword", required = false) String keyword,
                             @RequestParam(name = "region", required = false) String region,
                             Model model) {
        // 정책자금 검색
        if (keyword != null && !keyword.isBlank()) {
            List<PolicyFund> policyResults = policyFundRepository.searchByKeyword(keyword.trim());
            model.addAttribute("policyResults", policyResults);
            model.addAttribute("policyCount", policyResults.size());
        } else {
            model.addAttribute("policyResults", List.of());
            model.addAttribute("policyCount", 0);
        }

        // 공간 + 컨설팅 검색 (region = "서울특별시 강남구" 형태 → district = "강남구" 추출)
        if (region != null && !region.isBlank()) {
            String district = region.contains(" ") ? region.substring(region.lastIndexOf(" ") + 1) : region;

            List<Space> spaceResults = spaceRepository.findByDistrict(district);
            model.addAttribute("spaceResults", spaceResults);
            model.addAttribute("spaceCount", spaceResults.size());

            long consultingCount = taxAccountantRepository.countByDistrict(district)
                    + accountantRepository.countByDistrict(district)
                    + laborAttorneyRepository.countByDistrict(district)
                    + patentAttorneyRepository.countByAddressContaining(district);
            model.addAttribute("consultingCount", consultingCount);

            // 컨설팅 추천 2개: 타입별로 랜덤 1명씩 후보 모아서 2개 선택
            List<ExpertDto> consultingCandidates = new ArrayList<>();
            List<com.publicservice.entity.TaxAccountant> taxList = taxAccountantRepository.findByDistrict(district);
            if (!taxList.isEmpty()) {
                Collections.shuffle(taxList);
                consultingCandidates.add(ExpertDto.from(taxList.get(0)));
            }
            List<com.publicservice.entity.Accountant> accountList = accountantRepository.findByDistrict(district);
            if (!accountList.isEmpty()) {
                Collections.shuffle(accountList);
                consultingCandidates.add(ExpertDto.from(accountList.get(0)));
            }
            List<com.publicservice.entity.LaborAttorney> laborList = laborAttorneyRepository.findByDistrict(district);
            if (!laborList.isEmpty()) {
                Collections.shuffle(laborList);
                consultingCandidates.add(ExpertDto.from(laborList.get(0)));
            }
            List<com.publicservice.entity.PatentAttorney> patentList = patentAttorneyRepository.findByAddressContaining(district);
            if (!patentList.isEmpty()) {
                Collections.shuffle(patentList);
                consultingCandidates.add(ExpertDto.from(patentList.get(0)));
            }
            Collections.shuffle(consultingCandidates);
            model.addAttribute("consultingResults",
                    consultingCandidates.size() > 2 ? consultingCandidates.subList(0, 2) : consultingCandidates);
        } else {
            model.addAttribute("spaceResults", List.of());
            model.addAttribute("spaceCount", 0);
            model.addAttribute("consultingCount", 0);
        }

        return "home/search";
    }

    @GetMapping("/about")
    public String aboutPage() {
        return "home/about";
    }
}