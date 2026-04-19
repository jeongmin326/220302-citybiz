package com.publicservice.controller;

import com.publicservice.dto.ExpertDto;
import com.publicservice.entity.PolicyFund;
import com.publicservice.entity.Space;
import com.publicservice.entity.User;
import com.publicservice.repository.AccountantRepository;
import com.publicservice.repository.LaborAttorneyRepository;
import com.publicservice.repository.LawyerRepository;
import com.publicservice.repository.PatentAttorneyRepository;
import com.publicservice.repository.PolicyFundRepository;
import com.publicservice.repository.SpaceRepository;
import com.publicservice.repository.TaxAccountantRepository;
import com.publicservice.repository.UserRepository;
import jakarta.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Optional;
import org.springframework.beans.factory.annotation.Value;
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
    private final LawyerRepository lawyerRepository;
    private final UserRepository userRepository;

    @Value("${naver.maps.client.id:}")
    private String naverClientId;

    public HomeController(PolicyFundRepository policyFundRepository,
                          SpaceRepository spaceRepository,
                          PatentAttorneyRepository patentAttorneyRepository,
                          TaxAccountantRepository taxAccountantRepository,
                          AccountantRepository accountantRepository,
                          LaborAttorneyRepository laborAttorneyRepository,
                          LawyerRepository lawyerRepository,
                          UserRepository userRepository) {
        this.policyFundRepository = policyFundRepository;
        this.spaceRepository = spaceRepository;
        this.patentAttorneyRepository = patentAttorneyRepository;
        this.taxAccountantRepository = taxAccountantRepository;
        this.accountantRepository = accountantRepository;
        this.laborAttorneyRepository = laborAttorneyRepository;
        this.lawyerRepository = lawyerRepository;
        this.userRepository = userRepository;
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
    public String spacePage(Model model) {
        model.addAttribute("naverClientId", naverClientId);
        return "home/space";
    }

    // 정책 페이지 매핑
    @GetMapping("/policy")
    public String policyPage() {
        return "home/policy"; 
    }

    // 컨설팅 페이지 매핑
    @GetMapping("/consulting")
    public String consultingPage(org.springframework.ui.Model model) {
        model.addAttribute("naverClientId", naverClientId);
        return "home/consulting";
    }
    // 마이페이지(User) 매핑
    @GetMapping("/mypage/status")
    public String statusPage() {
        // views/mypage 폴더 안의 status.jsp를 화면에 띄우라는 뜻입니다.
        return "mypage/status"; 
    }

    // 공급자(Host) 공간 등록 페이지 매핑
    @GetMapping("/mypage/spaceRegi")
    public String spaceRegisterPage(
            @RequestParam(value = "mode", required = false) String mode,
            HttpSession session, Model model) {
        Long userId = (Long) session.getAttribute("loginUserId");
        if (userId != null) {
            // 가입 시 입력한 시설명(company_name) 전달
            Optional<User> userOpt = userRepository.findById(userId);
            userOpt.ifPresent(u -> model.addAttribute("facilityName", u.getCompanyName()));

            // mode=new 이면 항상 빈 폼 (추가 공간 등록)
            // 그 외엔 draft 공간이 있을 경우 완성 모드로 전환
            if (!"new".equals(mode)) {
                List<Space> hostSpaces = spaceRepository.findByHostId(userId);
                hostSpaces.stream()
                        .filter(s -> "N".equals(s.getAvailableYn())
                                  && "미설정".equals(s.getCity()))
                        .findFirst()
                        .ifPresent(draft -> model.addAttribute("draftSpace", draft));
            }
        }
        return "mypage/spaceRegi";
    }

    // 공급자(Host) 공간 수정 페이지 매핑
    @GetMapping("/mypage/spaceEdit")
    public String spaceEditPage(@RequestParam("spaceId") Long spaceId,
                                HttpSession session, Model model) {
        Long userId = (Long) session.getAttribute("loginUserId");
        if (userId == null) return "redirect:/login";

        Optional<Space> spaceOpt = spaceRepository.findById(spaceId);
        if (spaceOpt.isEmpty() || !userId.equals(spaceOpt.get().getHostId())) {
            return "redirect:/mypage/spaceManagement";
        }
        model.addAttribute("space", spaceOpt.get());
        userRepository.findById(userId).ifPresent(u -> {
            model.addAttribute("userName", u.getName());
            model.addAttribute("userPhone", u.getPhone());
        });
        return "mypage/spaceEdit";
    }

    // 공급자(Host) 예약 관리(대시보드) 페이지 매핑
    @GetMapping("/mypage/spaceManagement")
    public String spaceManagementPage() {
        return "mypage/spaceManagement";
    }

    // 전문가(Expert) 프로필 수정 페이지 매핑
    @GetMapping("/mypage/expertProfile")
    public String expertProfilePage(jakarta.servlet.http.HttpSession session,
                                    org.springframework.ui.Model model) {
        Long userId = (Long) session.getAttribute("loginUserId");
        if (userId != null) {
            com.publicservice.dto.ExpertProfileRequest profile = new com.publicservice.dto.ExpertProfileRequest();
            boolean found = false;

            java.util.Optional<com.publicservice.entity.TaxAccountant> tax = taxAccountantRepository.findByUserId(userId);
            if (tax.isPresent()) {
                com.publicservice.entity.TaxAccountant e = tax.get();
                profile.setExpertType("세무사");
                profile.setName(e.getName()); profile.setOffice(e.getOffice()); profile.setPhone(e.getPhone());
                profile.setCity(e.getCity()); profile.setDistrict(e.getDistrict()); profile.setRoadAddress(e.getRoadAddress());
                profile.setDetailAddress(e.getDetailAddress());
                profile.setField(e.getField()); profile.setConsultTime(e.getConsultTime());
                profile.setExperienceYears(e.getExperienceYears()); profile.setPrice(e.getPrice());
                found = true;
            }
            if (!found) {
                java.util.Optional<com.publicservice.entity.Accountant> acc = accountantRepository.findByUserId(userId);
                if (acc.isPresent()) {
                    com.publicservice.entity.Accountant e = acc.get();
                    profile.setExpertType("회계사");
                    profile.setName(e.getName()); profile.setOffice(e.getOffice()); profile.setPhone(e.getPhone());
                    profile.setCity(e.getCity()); profile.setDistrict(e.getDistrict()); profile.setRoadAddress(e.getRoadAddress());
                    profile.setDetailAddress(e.getDetailAddress());
                    profile.setField(e.getField()); profile.setConsultTime(e.getConsultTime());
                    profile.setExperienceYears(e.getExperienceYears()); profile.setPrice(e.getPrice());
                    found = true;
                }
            }
            if (!found) {
                java.util.Optional<com.publicservice.entity.LaborAttorney> labor = laborAttorneyRepository.findByUserId(userId);
                if (labor.isPresent()) {
                    com.publicservice.entity.LaborAttorney e = labor.get();
                    profile.setExpertType("노무사");
                    profile.setName(e.getName()); profile.setOffice(e.getOffice()); profile.setPhone(e.getPhone());
                    profile.setCity(e.getCity()); profile.setDistrict(e.getDistrict()); profile.setRoadAddress(e.getRoadAddress());
                    profile.setDetailAddress(e.getDetailAddress());
                    profile.setField(e.getField()); profile.setConsultTime(e.getConsultTime());
                    profile.setExperienceYears(e.getExperienceYears()); profile.setPrice(e.getPrice());
                    found = true;
                }
            }
            if (!found) {
                java.util.Optional<com.publicservice.entity.Lawyer> lawyer = lawyerRepository.findByUserId(userId);
                if (lawyer.isPresent()) {
                    com.publicservice.entity.Lawyer e = lawyer.get();
                    profile.setExpertType("변호사");
                    profile.setName(e.getName()); profile.setOffice(e.getOffice()); profile.setPhone(e.getPhone());
                    profile.setCity(e.getCity()); profile.setDistrict(e.getDistrict()); profile.setRoadAddress(e.getRoadAddress());
                    profile.setDetailAddress(e.getDetailAddress());
                    profile.setField(e.getField()); profile.setConsultTime(e.getConsultTime());
                    profile.setExperienceYears(e.getExperienceYears()); profile.setPrice(e.getPrice());
                    found = true;
                }
            }
            if (!found) {
                java.util.Optional<com.publicservice.entity.PatentAttorney> patent = patentAttorneyRepository.findByUserId(userId);
                if (patent.isPresent()) {
                    com.publicservice.entity.PatentAttorney e = patent.get();
                    profile.setExpertType("변리사");
                    profile.setName(e.getName()); profile.setOffice(e.getOffice()); profile.setPhone(e.getPhone());
                    profile.setCity(e.getCity()); profile.setDistrict(e.getDistrict()); profile.setRoadAddress(e.getRoadAddress());
                    profile.setDetailAddress(e.getDetailAddress());
                    profile.setField(e.getField()); profile.setConsultTime(e.getConsultTime());
                    profile.setExperienceYears(e.getExperienceYears()); profile.setPrice(e.getPrice());
                    found = true;
                }
            }
            if (found) model.addAttribute("profile", profile);
        }
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
        model.addAttribute("naverClientId", naverClientId);
        // 정책자금 검색
        if (keyword != null && !keyword.isBlank()) {
            List<PolicyFund> policyResults = policyFundRepository.searchByKeyword(keyword.trim());
            Collections.shuffle(policyResults);
            model.addAttribute("policyResults", policyResults);
            model.addAttribute("policyCount", policyResults.size());
            List<String> institutionList = policyResults.stream()
                    .map(PolicyFund::getInstitution)
                    .filter(i -> i != null && !i.isBlank())
                    .distinct()
                    .sorted()
                    .collect(java.util.stream.Collectors.toList());
            model.addAttribute("institutionList", institutionList);
            model.addAttribute("institutionCount", institutionList.size());
        } else {
            model.addAttribute("policyResults", List.of());
            model.addAttribute("policyCount", 0);
            model.addAttribute("institutionList", List.of());
            model.addAttribute("institutionCount", 0);
        }

        // 공간 + 컨설팅 검색 (region = "서울특별시 강남구" 형태 → district = "강남구" 추출)
        if (region != null && !region.isBlank()) {
            String district = region.contains(" ") ? region.substring(region.lastIndexOf(" ") + 1) : region;

            List<Space> spaceResults = spaceRepository.findByDistrict(district);
            Collections.shuffle(spaceResults);
            model.addAttribute("spaceResults", spaceResults);
            model.addAttribute("spaceCount", spaceResults.size());

            long consultingCount = taxAccountantRepository.countByDistrict(district)
                    + accountantRepository.countByDistrict(district)
                    + laborAttorneyRepository.countByDistrict(district)
                    + patentAttorneyRepository.countByAddrContaining(district)
                    + lawyerRepository.countByDistrict(district);
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
            List<com.publicservice.entity.PatentAttorney> patentList = patentAttorneyRepository.findByAddrContaining(district);
            if (!patentList.isEmpty()) {
                Collections.shuffle(patentList);
                consultingCandidates.add(ExpertDto.from(patentList.get(0)));
            }
            List<com.publicservice.entity.Lawyer> lawyerList = lawyerRepository.findByDistrict(district);
            if (!lawyerList.isEmpty()) {
                Collections.shuffle(lawyerList);
                consultingCandidates.add(ExpertDto.from(lawyerList.get(0)));
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