package com.publicservice.controller;

import jakarta.servlet.http.HttpServletRequest;
import org.springframework.boot.web.servlet.error.ErrorController;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class ErrorPageController implements ErrorController {

    @RequestMapping("/error")
    public String handleError(HttpServletRequest request, Model model) {
        Object statusAttr = request.getAttribute("jakarta.servlet.error.status_code");

        int statusCode = (statusAttr != null) ? Integer.parseInt(statusAttr.toString()) : 0;

        String errorMessage = switch (statusCode) {
            case 400 -> "잘못된 요청입니다.";
            case 401 -> "로그인이 필요합니다.";
            case 403 -> "접근 권한이 없습니다.";
            case 404 -> "페이지를 찾을 수 없습니다.";
            case 500 -> "서버 내부 오류가 발생했습니다.";
            default  -> "알 수 없는 오류가 발생했습니다.";
        };

        model.addAttribute("statusCode", statusCode != 0 ? statusCode : "");
        model.addAttribute("errorMessage", errorMessage);

        return "error/error";
    }
}
