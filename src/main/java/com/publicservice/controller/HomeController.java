package com.publicservice.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class HomeController {

    @GetMapping("/")
    public String mainPage() {
        return "home/main";
    }

    // 공간 대여 페이지 매핑
    @GetMapping("/space")
    public String spacePage() {
        return "home/space"; 
    }
}