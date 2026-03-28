package com.publicservice.controller;

import com.publicservice.entity.User;
import com.publicservice.repository.UserRepository;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

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
    @GetMapping("/join")
    public String joinPage() {
        return "user/join";
    }

    //회원가입메핑추가
    @GetMapping("/findID")
    public String findID() {
        return "user/findID";
    }

    //아이디찾기추가
    @GetMapping("/findPWD")
    public String findPWD() {
        return "user/findPWD";
    }
    
    //비밀번호찾기추가
    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/login";
    }
}