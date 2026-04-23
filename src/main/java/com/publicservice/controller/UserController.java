package com.publicservice.controller;

import com.publicservice.dao.UserDAO;
import com.publicservice.dto.UserProfileRequest;
import com.publicservice.entity.Accountant;
import com.publicservice.entity.LaborAttorney;
import com.publicservice.entity.Lawyer;
import com.publicservice.entity.Space;
import com.publicservice.entity.TaxAccountant;
import com.publicservice.entity.User;
import com.publicservice.repository.AccountantRepository;
import com.publicservice.repository.LaborAttorneyRepository;
import com.publicservice.repository.LawyerRepository;
import com.publicservice.repository.SpaceRepository;
import com.publicservice.repository.TaxAccountantRepository;
import com.publicservice.repository.UserRepository;
import com.publicservice.service.UserService;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.Map;
import java.util.Optional;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
public class UserController {

    @Autowired
    private UserRepository userRepository;
    @Autowired
    private UserService userService;
    @Autowired
    private SpaceRepository spaceRepository;
    @Autowired
    private TaxAccountantRepository taxAccountantRepository;
    @Autowired
    private AccountantRepository accountantRepository;
    @Autowired
    private LaborAttorneyRepository laborAttorneyRepository;
    @Autowired
    private LawyerRepository lawyerRepository;

    @GetMapping("/login")
    public String loginPage() {
        return "user/login";
    }

   @PostMapping("/login")
    public String loginProcess(@RequestParam("email") String email,
                            @RequestParam("password") String password,
                            @RequestParam(value = "rememberId", required = false) String rememberId,
                            HttpSession session,
                            HttpServletResponse response) {

        Optional<User> userOpt = userRepository.findByEmail(email);

        if (userOpt.isPresent()) {
            User user = userOpt.get();

            BCryptPasswordEncoder encoder = new BCryptPasswordEncoder();

            if (encoder.matches(password, user.getPasswordHash())) {
                session.setAttribute("loginUser", user.getEmail());
                session.setAttribute("loginName", user.getName());
                session.setAttribute("loginRole", user.getRole());
                session.setAttribute("loginUserId", user.getUserId());

                if (rememberId != null) {
                    Cookie rememberCookie = new Cookie("rememberEmail", user.getEmail());
                    rememberCookie.setMaxAge(60 * 60 * 24 * 7); // 7일
                    rememberCookie.setPath("/");
                    response.addCookie(rememberCookie);
                } else {
                    Cookie rememberCookie = new Cookie("rememberEmail", null);
                    rememberCookie.setMaxAge(0);
                    rememberCookie.setPath("/");
                    response.addCookie(rememberCookie);
                }

                return "redirect:/main";
            }
        }

        return "redirect:/login?error=true";
    }

    //회원가입메핑추가
    @GetMapping("/signup")
    public String joinPage() {
        return "user/signup";
    }

    //회원가입
    @Autowired
    private UserDAO userDAO;

    @PostMapping("/signup")
    public String signup(HttpServletRequest request) {
        try {
            
            String email = request.getParameter("email");
            String password = request.getParameter("password");
            String name = request.getParameter("name");
            String phone = request.getParameter("phone");
            String role = request.getParameter("role");
            String companyName = request.getParameter("company_name");
            String bizNo = request.getParameter("biz_no");
            String businessStage = request.getParameter("business_stage");
            String industry = request.getParameter("industry");
            String status = request.getParameter("status");

            if (status == null || status.trim().isEmpty()) {
                status = "ACTIVE";
            }

            if (userDAO.existsByEmail(email)) {
                return "redirect:/signup?error=duplicate";
            }

            if (userDAO.existsByPhone(phone)) {
                return "redirect:/signup?error=duplicatePhone";
            }

            userDAO.insertUser(
                    email,
                    password,
                    name,
                    phone,
                    role,
                    companyName,
                    bizNo,
                    businessStage,
                    industry,
                    status
            );

            // EXPERT 가입 시: 전문가 테이블 자동 삽입
            if ("EXPERT".equals(role)) {
                String expertType       = request.getParameter("expert_type");
                String expertOffice     = request.getParameter("expert_office");
                String expertCity       = request.getParameter("expert_city");
                String expertDistrict   = request.getParameter("expert_district");
                String expertRoadAddr   = request.getParameter("expert_road_address");
                String expertField      = request.getParameter("expert_field");
                String expertConsultTime= request.getParameter("expert_consult_time");
                String expYrsStr        = request.getParameter("expert_experience_years");
                String priceStr         = request.getParameter("expert_price");

                int expYrs  = (expYrsStr  != null && !expYrsStr.isEmpty())  ? Integer.parseInt(expYrsStr)  : 0;
                int expPrice= (priceStr   != null && !priceStr.isEmpty())   ? Integer.parseInt(priceStr)   : 0;

                if (expertType != null && !expertType.trim().isEmpty()) {
                    Optional<User> newUser = userRepository.findByEmail(email);
                    if (newUser.isPresent()) {
                        Long newUserId = newUser.get().getUserId();
                        String safeName   = name   != null ? name   : "";
                        String safePhone  = phone  != null ? phone  : "";
                        String safeOffice = expertOffice   != null ? expertOffice   : "";
                        String safeCity   = expertCity     != null ? expertCity     : "";
                        String safeDist   = expertDistrict != null ? expertDistrict : "";
                        String safeRoad   = expertRoadAddr != null ? expertRoadAddr : "";
                        String safeField  = expertField    != null ? expertField    : "";
                        String safeCT     = expertConsultTime != null ? expertConsultTime : "평일";

                        switch (expertType) {
                            case "세무사" -> {
                                TaxAccountant e = new TaxAccountant();
                                e.setUserId(newUserId); e.setName(safeName); e.setOffice(safeOffice);
                                e.setPhone(safePhone);  e.setCity(safeCity);  e.setDistrict(safeDist);
                                e.setRoadAddress(safeRoad); e.setField(safeField);
                                e.setConsultTime(safeCT); e.setExperienceYears(expYrs); e.setPrice(expPrice);
                                e.setRating(BigDecimal.ZERO);
                                taxAccountantRepository.save(e);
                            }
                            case "회계사" -> {
                                Accountant e = new Accountant();
                                e.setUserId(newUserId); e.setName(safeName); e.setOffice(safeOffice);
                                e.setPhone(safePhone);  e.setCity(safeCity);  e.setDistrict(safeDist);
                                e.setRoadAddress(safeRoad); e.setField(safeField);
                                e.setConsultTime(safeCT); e.setExperienceYears(expYrs); e.setPrice(expPrice);
                                e.setRating(BigDecimal.ZERO);
                                accountantRepository.save(e);
                            }
                            case "노무사" -> {
                                LaborAttorney e = new LaborAttorney();
                                e.setUserId(newUserId); e.setName(safeName); e.setOffice(safeOffice);
                                e.setPhone(safePhone);  e.setCity(safeCity);  e.setDistrict(safeDist);
                                e.setRoadAddress(safeRoad); e.setField(safeField);
                                e.setConsultTime(safeCT); e.setExperienceYears(expYrs); e.setPrice(expPrice);
                                e.setRating(BigDecimal.ZERO);
                                laborAttorneyRepository.save(e);
                            }
                            case "변호사" -> {
                                Lawyer e = new Lawyer();
                                e.setUserId(newUserId); e.setName(safeName); e.setOffice(safeOffice);
                                e.setPhone(safePhone);  e.setCity(safeCity);  e.setDistrict(safeDist);
                                e.setRoadAddress(safeRoad); e.setField(safeField);
                                e.setConsultTime(safeCT); e.setExperienceYears(expYrs); e.setPrice(expPrice);
                                e.setRating(BigDecimal.ZERO);
                                lawyerRepository.save(e);
                            }
                        }
                    }
                }
            }

            // PROVIDER 가입 시: 시설명으로 draft 공간 자동 생성
            if ("PROVIDER".equals(role) && companyName != null && !companyName.trim().isEmpty()) {
                String spaceType        = request.getParameter("space_type");
                String spaceDescription = request.getParameter("space_description");
                Optional<User> newUser = userRepository.findByEmail(email);
                if (newUser.isPresent()) {
                    Space draft = new Space();
                    draft.setHostId(newUser.get().getUserId());
                    draft.setName(companyName.trim());
                    draft.setCity("미설정");
                    draft.setDistrict("미설정");
                    draft.setRoadAddress("미설정");
                    draft.setAddr("미설정");
                    draft.setSpaceType(spaceType != null && !spaceType.trim().isEmpty() ? spaceType.trim() : "사무실");
                    draft.setDescription(spaceDescription != null ? spaceDescription.trim() : "");
                    draft.setPricePerHour(0);
                    draft.setCapacity(1);
                    draft.setAvailableYn("N");
                    draft.setCreatedAt(LocalDateTime.now());
                    draft.setUpdatedAt(LocalDateTime.now());
                    spaceRepository.save(draft);
                }
            }

            return "redirect:/login?signup=success";
        } catch (Exception e) {
            e.printStackTrace();
            return "redirect:/signup?signup=fail";
        }
    }

    // 이메일 중복 체크
    @GetMapping("/check-email")
    @ResponseBody
    public Map<String, Object> checkEmail(@RequestParam("email") String email) {
        Map<String, Object> result = new HashMap<>();

        if (!email.matches("^[^\\s@]+@[^\\s@]+\\.[^\\s@]+$")) {
            result.put("valid", false);
            result.put("exists", false);
            return result;
        }

        try {
            boolean exists = userDAO.existsByEmail(email);
            result.put("valid", true);
            result.put("exists", exists);
        } catch (Exception e) {
            e.printStackTrace();
            result.put("valid", false);
            result.put("exists", false);
            result.put("error", true);
        }

        return result;
    }

    // 전화번호 중복 체크
    @GetMapping("/check-phone")
    @ResponseBody
    public Map<String, Object> checkPhone(@RequestParam("phone") String phone) {
        Map<String, Object> result = new HashMap<>();

        try {
            boolean exists = userDAO.existsByPhone(phone);
            result.put("exists", exists);
        } catch (Exception e) {
            e.printStackTrace();
            result.put("exists", false);
            result.put("error", true);
        }

        return result;
    }
    

    //아이디찾기추가
    @GetMapping("/findID")
    public String findID() {
        return "user/findID";
    }

    @PostMapping("/findID")
    public String findID(
            @RequestParam String name,
            @RequestParam String phone,
            RedirectAttributes redirectAttributes
    ) {
        phone = phone.replaceAll("[^0-9]", "");

        String email = userService.findEmailByNameAndPhone(name, phone);

        if (email != null) {
            redirectAttributes.addFlashAttribute("msg", "아이디는 " + email + " 입니다.");
        } else {
            redirectAttributes.addFlashAttribute("msg", "일치하는 회원 정보를 찾을 수 없습니다.");
        }

        return "redirect:/findID";
    }

    //비밀번호찾기추가
    @GetMapping("/findPWD")
    public String findPWD() {
        return "user/findPWD";
    }

    @PostMapping("/findPWD")
    public String findPWD(
            @RequestParam String email,
            @RequestParam String name,
            @RequestParam String phone,
            RedirectAttributes redirectAttributes
    ) {
        phone = phone.replaceAll("[^0-9]", "");

        boolean success = userService.resetPassword(email, name, phone);

        if (success) {
            redirectAttributes.addFlashAttribute("msg", "비밀번호는 1234로 초기화되었습니다.");
        } else {
            redirectAttributes.addFlashAttribute("msg", "일치하는 회원 정보를 찾을 수 없습니다.");
        }

        return "redirect:/findPWD";
    }
    
    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/login";
    }

    // ---------------------------------------------------------------
    // GET /api/user/profile — 로그인 사용자 프로필 조회
    // ---------------------------------------------------------------
    @GetMapping("/api/user/profile")
    @ResponseBody
    public Map<String, Object> getUserProfile(HttpSession session) {
        Map<String, Object> result = new HashMap<>();
        Long userId = (Long) session.getAttribute("loginUserId");
        if (userId == null) {
            result.put("error", "로그인이 필요합니다.");
            return result;
        }
        Optional<User> opt = userRepository.findById(userId);
        if (opt.isEmpty()) {
            result.put("error", "사용자를 찾을 수 없습니다.");
            return result;
        }
        User user = opt.get();
        result.put("name",          user.getName());
        result.put("email",         user.getEmail());
        result.put("companyName",   user.getCompanyName());
        result.put("businessStage", user.getBusinessStage());
        result.put("industry",      user.getIndustry());
        result.put("role",          user.getRole());
        result.put("phone",         user.getPhone());
        result.put("bizNo",         user.getBizNo());
        result.put("city",          user.getCity());
        result.put("district",      user.getDistrict());
        result.put("roadAddress",   user.getRoadAddress());
        result.put("detailAddress", user.getDetailAddress());
        return result;
    }

    // ---------------------------------------------------------------
    // POST /api/user/profile — 로그인 사용자 프로필 수정
    // ---------------------------------------------------------------
    @PostMapping("/api/user/profile")
    @ResponseBody
    public Map<String, Object> updateUserProfile(
            UserProfileRequest req,
            HttpSession session) {
        Map<String, Object> result = new HashMap<>();
        Long userId = (Long) session.getAttribute("loginUserId");
        if (userId == null) {
            result.put("error", "로그인이 필요합니다.");
            return result;
        }
        Optional<User> opt = userRepository.findById(userId);
        if (opt.isEmpty()) {
            result.put("error", "사용자를 찾을 수 없습니다.");
            return result;
        }

        String phone = req.getPhone() != null ? req.getPhone().trim() : "";
        if (phone.isBlank() || !phone.matches("^01[0-9]{9}$")) {
            result.put("error", "올바른 휴대폰 번호를 입력해 주세요.");
            return result;
        }

        Optional<User> phoneOwner = userRepository.findByPhone(phone);
        if (phoneOwner.isPresent() && !phoneOwner.get().getUserId().equals(userId)) {
            result.put("error", "이미 사용 중인 휴대폰 번호입니다.");
            return result;
        }

        if (req.getCity() == null || req.getCity().isBlank()
                || req.getRoadAddress() == null || req.getRoadAddress().isBlank()) {
            result.put("error", "주소를 검색하여 선택해 주세요.");
            return result;
        }

        User user = opt.get();
        user.setPhone(phone);
        user.setCity(req.getCity().trim());
        user.setDistrict(req.getDistrict() != null ? req.getDistrict().trim() : "");
        user.setRoadAddress(req.getRoadAddress().trim());
        user.setDetailAddress(req.getDetailAddress() != null ? req.getDetailAddress().trim() : "");
        if (req.getBusinessStage() != null) user.setBusinessStage(req.getBusinessStage());
        if (req.getIndustry() != null) user.setIndustry(req.getIndustry().trim());
        userRepository.save(user);
        result.put("success", true);
        return result;
    }

    // MyPage 관련 컨트롤러

    @GetMapping("/mypage/recharge")
    public String rechargePage() {
        
        return "mypage/recharge"; 
    }

}
