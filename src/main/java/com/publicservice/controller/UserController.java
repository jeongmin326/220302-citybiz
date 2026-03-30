package com.publicservice.controller;

import com.publicservice.entity.User;
import com.publicservice.repository.UserRepository;
import com.publicservice.dao.UserDAO;

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

import java.util.HashMap;
import java.util.Map;

import java.util.Optional;

@Controller
public class UserController {

    @Autowired
    private UserRepository userRepository;

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

            if (user.getPasswordHash().equals(password)) {
                session.setAttribute("loginUser", user.getEmail());
                session.setAttribute("loginName", user.getName());
                session.setAttribute("loginRole", user.getRole());

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

        try {
            boolean exists = userDAO.existsByEmail(email);
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

    //비밀번호찾기추가
    @GetMapping("/findPWD")
    public String findPWD() {
        return "user/findPWD";
    }
    
    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/login";
    }
}