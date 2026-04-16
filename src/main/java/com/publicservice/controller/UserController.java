package com.publicservice.controller;

import com.publicservice.entity.Space;
import com.publicservice.entity.User;
import com.publicservice.repository.SpaceRepository;
import com.publicservice.repository.UserRepository;
import com.publicservice.service.UserService;
import com.publicservice.dao.UserDAO;
import java.time.LocalDateTime;

import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.HashMap;
import java.util.Map;

import java.util.Optional;

@Controller
public class UserController {

    @Autowired
    private UserRepository userRepository;
    @Autowired
    private UserService userService;
    @Autowired
    private SpaceRepository spaceRepository;

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

            // PROVIDER 가입 시: 시설명으로 draft 공간 자동 생성
            if ("PROVIDER".equals(role) && companyName != null && !companyName.trim().isEmpty()) {
                Optional<User> newUser = userRepository.findByEmail(email);
                if (newUser.isPresent()) {
                    Space draft = new Space();
                    draft.setHostId(newUser.get().getUserId());
                    draft.setName(companyName.trim());
                    draft.setRegion("미설정");
                    draft.setDistrict("미설정");
                    draft.setAddress("미설정");
                    draft.setSpaceType("office");
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

}