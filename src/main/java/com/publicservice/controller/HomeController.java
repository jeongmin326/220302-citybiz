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

    // 공간 대여 페이지 매핑
    @GetMapping("/space")
    public String spacePage() {
        return "home/space"; 
    }
}