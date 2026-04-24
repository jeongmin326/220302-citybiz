package com.publicservice.controller;

import com.publicservice.entity.PointHistory;
import com.publicservice.entity.User;
import com.publicservice.repository.PointHistoryRepository;
import com.publicservice.repository.PlanHistoryRepository;
import com.publicservice.repository.UserRepository;
import com.publicservice.service.PlanService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.client.RestTemplate;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;

import java.text.DecimalFormat;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/charge")
public class ChargeController {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private PointHistoryRepository pointHistoryRepository;

    @Autowired
    private PlanHistoryRepository planHistoryRepository;

    @Autowired
    private PlanService planService;

    @Value("${portone.imp_key}")
    private String impKey;

    @Value("${portone.api_key}")
    private String impKeyBackend;

    @Value("${portone.api_secret}")
    private String impSecret;

    @Value("${portone.channel.card}")
    private String cardChannelKey;

    @Value("${portone.channel.kakao}")
    private String kakaoChannelKey;

    @Value("${portone.channel.toss}")
    private String tossChannelKey;

    private final RestTemplate restTemplate = new RestTemplate();
    private final ObjectMapper objectMapper = new ObjectMapper();

    @GetMapping("/plan")
    public String showSubscriptionPlan(Model model, HttpSession session) {
        Long userId = (Long) session.getAttribute("loginUserId");
        if (userId != null) {
            User user = userRepository.findById(userId).orElse(null);
            if (user != null) {
                model.addAttribute("currentPlan", user.getPlanType());
                model.addAttribute("planExpiresAt", user.getPlanExpiresAt());
            }
        }
        model.addAttribute("impKey", impKey);
        model.addAttribute("cardChannelKey", cardChannelKey);
        model.addAttribute("kakaoChannelKey", kakaoChannelKey);
        model.addAttribute("tossChannelKey", tossChannelKey);
        return "charge/plan";
    }

    @GetMapping("/recharge")
    public String rechargePage(Model model, HttpSession session) {
        Long userId = (Long) session.getAttribute("loginUserId");
        if (userId != null) {
            User user = userRepository.findById(userId).orElse(null);
            if (user != null) {
                model.addAttribute("currentPoint", user.getPoint());
            }
        }
        model.addAttribute("impKey", impKey);
        model.addAttribute("cardChannelKey", cardChannelKey);
        model.addAttribute("kakaoChannelKey", kakaoChannelKey);
        model.addAttribute("tossChannelKey", tossChannelKey);
        return "charge/recharge";
    }

    @GetMapping("/pointHistory")
    public String pointHistory(Model model, HttpSession session) {
        Long userId = (Long) session.getAttribute("loginUserId");
        if (userId != null) {
            User user = userRepository.findById(userId).orElse(null);
            if (user != null) {
                model.addAttribute("currentPoint", user.getPoint());
                List<PointHistory> historyList = pointHistoryRepository.findByUserIdOrderByCreatedAtDesc(userId);
                model.addAttribute("historyList", historyList);
            }
        }
        return "charge/pointHistory";
    }

    @PostMapping("/verify")
    @ResponseBody
    public Map<String, Object> verifyPayment(
            @RequestBody Map<String, Object> request,
            HttpSession session) {
        Map<String, Object> response = new HashMap<>();

        try {
            Long userId = (Long) session.getAttribute("loginUserId");
            if (userId == null) {
                response.put("success", false);
                response.put("message", "로그인이 필요합니다.");
                return response;
            }

            String impUid = (String) request.get("imp_uid");
            String merchantUid = (String) request.get("merchant_uid");
            Integer amount = ((Number) request.get("amount")).intValue();

            // 포트원 토큰 발급
            String accessToken = getPortoneAccessToken();
            if (accessToken == null) {
                response.put("success", false);
                response.put("message", "결제 검증 중 오류가 발생했습니다.");
                return response;
            }

            // 포트원에서 결제 정보 조회 (imp_uid로 먼저 시도)
            Map<String, Object> paymentInfo = getPaymentInfo(accessToken, impUid);

            // imp_uid로 조회 실패 시, merchant_uid로 재시도
            if (paymentInfo == null && merchantUid != null) {
                System.out.println("❌ imp_uid로 조회 실패, merchant_uid로 재시도: " + merchantUid);
                paymentInfo = getPaymentInfoByMerchantUid(accessToken, merchantUid);
            }

            if (paymentInfo == null) {
                response.put("success", false);
                response.put("message", "결제 정보를 조회할 수 없습니다.");
                return response;
            }

            // 결제 검증
            Integer paidAmount = (Integer) paymentInfo.get("paid_amount");
            String status = (String) paymentInfo.get("status");

            if (!status.equals("paid") || !paidAmount.equals(amount)) {
                response.put("success", false);
                response.put("message", "결제 금액 또는 상태가 일치하지 않습니다.");
                return response;
            }

            // 보너스 계산
            int bonusPercent = 0;
            if (amount == 10000) {
                bonusPercent = 2;
            } else if (amount == 30000) {
                bonusPercent = 3;
            } else if (amount == 50000) {
                bonusPercent = 5;
            }

            int bonusAmount = (amount * bonusPercent) / 100;
            int totalAmount = amount + bonusAmount;

            // 포인트 충전
            User user = userRepository.findById(userId).orElse(null);
            if (user == null) {
                response.put("success", false);
                response.put("message", "사용자를 찾을 수 없습니다.");
                return response;
            }

            user.setPoint(user.getPoint() + totalAmount);
            userRepository.save(user);

            // 포인트 내역 저장
            PointHistory history = new PointHistory();
            history.setUserId(userId);
            history.setAmount(totalAmount);
            history.setType("CHARGE");
            DecimalFormat df = new DecimalFormat("#,###");
            if (bonusAmount > 0) {
                history.setDescription(df.format(amount) + "원 충전 (+" + df.format(bonusAmount) + "원 보너스)");
            } else {
                history.setDescription(df.format(amount) + "원 충전");
            }
            history.setImpUid(impUid);
            pointHistoryRepository.save(history);

            response.put("success", true);
            response.put("message", "포인트 충전이 완료되었습니다.");
            response.put("currentPoint", user.getPoint());

        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "오류 발생: " + e.getMessage());
        }

        return response;
    }

    @PostMapping("/verifyPlan")
    @ResponseBody
    public Map<String, Object> verifyPlanPayment(
            @RequestBody Map<String, Object> request,
            HttpSession session) {
        Map<String, Object> response = new HashMap<>();

        try {
            Long userId = (Long) session.getAttribute("loginUserId");
            if (userId == null) {
                response.put("success", false);
                response.put("message", "로그인이 필요합니다.");
                return response;
            }

            String impUid = (String) request.get("imp_uid");
            String merchantUid = (String) request.get("merchant_uid");
            Integer amount = ((Number) request.get("amount")).intValue();
            String planType = (String) request.get("planType");

            // 중복 결제 방지
            if (planHistoryRepository.findByImpUid(impUid).isPresent()) {
                response.put("success", false);
                response.put("message", "이미 처리된 결제입니다.");
                return response;
            }

            // 포트원 토큰 발급
            String accessToken = getPortoneAccessToken();
            if (accessToken == null) {
                response.put("success", false);
                response.put("message", "결제 검증 중 오류가 발생했습니다.");
                return response;
            }

            // 포트원에서 결제 정보 조회
            Map<String, Object> paymentInfo = getPaymentInfo(accessToken, impUid);

            // imp_uid로 조회 실패 시, merchant_uid로 재시도
            if (paymentInfo == null && merchantUid != null) {
                paymentInfo = getPaymentInfoByMerchantUid(accessToken, merchantUid);
            }

            if (paymentInfo == null) {
                response.put("success", false);
                response.put("message", "결제 정보를 조회할 수 없습니다.");
                return response;
            }

            // 결제 검증
            Integer paidAmount = (Integer) paymentInfo.get("paid_amount");
            String status = (String) paymentInfo.get("status");

            // 플랜 금액 검증
            int expectedAmount = "MONTHLY".equals(planType) ? 100000 : 1000000;
            if (!status.equals("paid") || !paidAmount.equals(expectedAmount)) {
                response.put("success", false);
                response.put("message", "결제 금액 또는 상태가 일치하지 않습니다.");
                return response;
            }

            // 플랜 활성화
            planService.activatePlan(userId, planType, impUid, merchantUid, amount);

            // 업데이트된 사용자 정보 조회
            User user = userRepository.findById(userId).orElse(null);
            if (user == null) {
                response.put("success", false);
                response.put("message", "사용자를 찾을 수 없습니다.");
                return response;
            }

            response.put("success", true);
            response.put("message", "플랜 가입이 완료되었습니다.");
            response.put("planType", user.getPlanType());
            response.put("planExpiresAt", user.getPlanExpiresAt());

        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "오류 발생: " + e.getMessage());
        }

        return response;
    }

    private String getPortoneAccessToken() {
        try {
            String url = "https://api.iamport.kr/users/getToken";
            Map<String, String> body = new HashMap<>();
            body.put("imp_key", impKeyBackend);
            body.put("imp_secret", impSecret);

            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.APPLICATION_JSON);

            HttpEntity<Map<String, String>> entity = new HttpEntity<>(body, headers);
            System.out.println("🔵 포트원 토큰 요청: " + url);
            ResponseEntity<String> result = restTemplate.postForEntity(url, entity, String.class);
            System.out.println("🟢 포트원 토큰 응답: " + result.getBody());

            JsonNode jsonNode = objectMapper.readTree(result.getBody());
            int code = jsonNode.get("code").asInt();
            System.out.println("🟡 포트원 응답 코드: " + code);

            if (code == 0) {
                String token = jsonNode.get("response").get("access_token").asText();
                System.out.println("✅ 토큰 발급 성공");
                return token;
            } else {
                System.out.println("❌ 토큰 발급 실패: " + jsonNode.get("message").asText());
            }
        } catch (Exception e) {
            System.out.println("❌ 토큰 발급 예외: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    private Map<String, Object> getPaymentInfo(String accessToken, String impUid) {
        try {
            String url = "https://api.iamport.kr/payments/" + impUid;

            HttpHeaders headers = new HttpHeaders();
            headers.set("Authorization", "Bearer " + accessToken);

            HttpEntity<String> entity = new HttpEntity<>(headers);
            System.out.println("🔵 포트원 결제 조회 요청: " + url);
            System.out.println("🔵 Authorization 헤더: Bearer " + accessToken.substring(0, 10) + "...");
            ResponseEntity<String> result = restTemplate.exchange(url, org.springframework.http.HttpMethod.GET, entity, String.class);
            System.out.println("🟢 포트원 결제 조회 응답: " + result.getBody());

            JsonNode jsonNode = objectMapper.readTree(result.getBody());
            int code = jsonNode.get("code").asInt();
            System.out.println("🟡 포트원 결제 조회 코드: " + code);

            if (code == 0) {
                JsonNode responseNode = jsonNode.get("response");
                Map<String, Object> paymentInfo = new HashMap<>();
                paymentInfo.put("imp_uid", responseNode.get("imp_uid").asText());
                paymentInfo.put("amount", responseNode.get("amount").asInt());
                paymentInfo.put("paid_amount", responseNode.get("paid_amount").asInt());
                paymentInfo.put("status", responseNode.get("status").asText());
                System.out.println("✅ 결제 정보 조회 성공");
                return paymentInfo;
            } else {
                System.out.println("❌ 결제 정보 조회 실패: " + jsonNode.get("message").asText());
            }
        } catch (Exception e) {
            System.out.println("❌ 결제 정보 조회 예외: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    private Map<String, Object> getPaymentInfoByMerchantUid(String accessToken, String merchantUid) {
        try {
            String url = "https://api.iamport.kr/payments/find/" + merchantUid + "/paid";

            HttpHeaders headers = new HttpHeaders();
            headers.set("Authorization", "Bearer " + accessToken);

            HttpEntity<String> entity = new HttpEntity<>(headers);
            System.out.println("🔵 포트원 merchant_uid로 결제 조회 요청: " + url);
            ResponseEntity<String> result = restTemplate.exchange(url, org.springframework.http.HttpMethod.GET, entity, String.class);
            System.out.println("🟢 포트원 merchant_uid 조회 응답: " + result.getBody());

            JsonNode jsonNode = objectMapper.readTree(result.getBody());
            int code = jsonNode.get("code").asInt();
            System.out.println("🟡 포트원 merchant_uid 조회 코드: " + code);

            if (code == 0 && jsonNode.has("response")) {
                JsonNode responseNode = jsonNode.get("response");

                // response가 배열이면 첫 번째 요소 선택, 아니면 그대로 사용
                if (responseNode.isArray()) {
                    if (responseNode.size() > 0) {
                        responseNode = responseNode.get(0);
                    } else {
                        return null;
                    }
                }

                Map<String, Object> paymentInfo = new HashMap<>();
                paymentInfo.put("imp_uid", responseNode.get("imp_uid").asText());
                int amount = responseNode.get("amount").asInt();
                paymentInfo.put("amount", amount);
                // paid_amount가 없으면 amount 사용
                int paidAmount = responseNode.has("paid_amount") && !responseNode.get("paid_amount").isNull() ?
                    responseNode.get("paid_amount").asInt() : amount;
                paymentInfo.put("paid_amount", paidAmount);
                paymentInfo.put("status", responseNode.get("status").asText());
                System.out.println("✅ merchant_uid로 결제 정보 조회 성공");
                return paymentInfo;
            }
            System.out.println("❌ merchant_uid로 결제 조회 실패");
        } catch (Exception e) {
            System.out.println("❌ merchant_uid 결제 조회 예외: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }
}