package com.publicservice.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class HomeController {
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
}