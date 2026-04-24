package com.publicservice.controller;

import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/charge") // 공통 경로 설정으로 관리 용이성 증대
public class ChargeController {

    /**
     * 1. 요금제(구독) 안내 페이지
     */
    @GetMapping("/plan")
    public String showSubscriptionPlan(HttpSession session) {
        // [Backend] 사용자의 현재 구독 상태를 체크하여 이미 유료 회원이면 안내 문구를 띄우거나 리다이렉트
        return "charge/plan"; 
    }

    /**
     * 2. 포인트 충전 페이지 (MyPage 관련)
     */
    @GetMapping("/recharge")
    public String rechargePage() {
        // [Backend] 현재 보유 포인트 등을 조회하여 화면에 전달할 수 있음
        return "charge/recharge"; 
    }

    /**
     * 3. 포인트 이용 내역 조회
     */
    @GetMapping("/pointHistory")
    public String pointHistory(Model model, HttpSession session) {
        // [Backend 개발자 할 일]
        // 1. 세션에서 현재 로그인한 사용자 정보(Long userId)를 가져옵니다.
        // 2. Service/Repository를 통해 해당 사용자의 포인트 내역(충전/사용)을 DB에서 조회합니다.
        // 3. AI 분석 추가 제안: "사용자의 포인트 소비 패턴을 분석해 다음 달 예상 충전액을 계산하는 AI 로직"을 서비스 단에 호출 가능
        // 4. 모델에 데이터를 담아 JSP로 넘깁니다.
        // ex) model.addAttribute("historyList", pointHistoryService.getHistory(userId));
        // ex) model.addAttribute("currentPoint", userService.getUserPoint(userId));

        return "charge/pointHistory"; 
    }
}