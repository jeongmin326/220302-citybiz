package com.publicservice.webrtc;

import com.publicservice.entity.ConsultingRequest;
import com.publicservice.repository.ConsultingRequestRepository;
import com.publicservice.entity.User;
import com.publicservice.repository.UserRepository;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.handler.annotation.DestinationVariable;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.SendTo;
import org.springframework.messaging.simp.SimpMessageHeaderAccessor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import java.time.LocalDateTime;
import java.time.temporal.ChronoUnit;
import java.util.HashMap;
import java.util.Map;

@Controller
public class VideoCallController {

    @Autowired
    private ConsultingRequestRepository consultingRequestRepository;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private VideoCallSessionRegistry sessionRegistry;

    @GetMapping("/video/call")
    public String videoCallPage(
            @RequestParam("requestId") Long requestId,
            HttpSession session,
            Model model) {
        Long userId = (Long) session.getAttribute("loginUserId");
        if (userId == null) {
            return "redirect:/login";
        }

        ConsultingRequest req = consultingRequestRepository.findById(requestId).orElse(null);
        if (req == null || !"ACCEPTED".equals(req.getStatus())) {
            return "error/notfound";
        }

        if (!userId.equals(req.getUserId()) && !userId.equals(req.getExpertUserId())) {
            return "error/notfound";
        }

        boolean isExpert = userId.equals(req.getExpertUserId());
        Long otherUserId = isExpert ? req.getUserId() : req.getExpertUserId();

        String otherUserInfo = "";
        if (isExpert) {
            // 전문가는 신청자의 회사명 표시
            User applicantUser = userRepository.findById(req.getUserId()).orElse(null);
            otherUserInfo = applicantUser != null ? applicantUser.getCompanyName() : "";
        } else {
            // 신청자는 전문가의 회사명, 이름, 직종 표시
            String expertName = "";
            String expertCompany = "";
            String expertType = req.getExpertType() != null ? req.getExpertType() : "";

            User expertUser = userRepository.findById(req.getExpertUserId()).orElse(null);
            if (expertUser != null) {
                expertName = expertUser.getName() != null ? expertUser.getName() : "";
                expertCompany = expertUser.getCompanyName() != null ? expertUser.getCompanyName() : "";
            }

            otherUserInfo = expertCompany + " " + expertName + " " + expertType;
        }

        model.addAttribute("requestId", requestId);
        model.addAttribute("requestTitle", req.getTitle());
        model.addAttribute("myUserId", userId);
        model.addAttribute("otherUserId", otherUserId);
        model.addAttribute("isExpert", isExpert);
        model.addAttribute("otherUserInfo", otherUserInfo);
        model.addAttribute("durationSeconds", req.getDurationSeconds());
        model.addAttribute("sessionPrice", req.getSessionPrice());
        model.addAttribute("callInitiated", req.getCallInitiated() != null && req.getCallInitiated());

        return "video/videoCall";
    }

    @MessageMapping("/video/{requestId}/signal")
    @SendTo("/topic/video/{requestId}")
    public Map<String, Object> handleSignal(
            @DestinationVariable Long requestId,
            Map<String, Object> message,
            SimpMessageHeaderAccessor headerAccessor) {

        Long senderId = (Long) headerAccessor.getSessionAttributes().get("userId");
        message.put("senderId", senderId);

        String type = (String) message.get("type");
        if ("CALL_REQUEST".equals(type)) {
            Long targetId = ((Number) message.get("targetId")).longValue();
            // 통화 요청 상태 저장
            consultingRequestRepository.findById(requestId).ifPresent(req -> {
                req.setCallInitiated(true);
                consultingRequestRepository.save(req);
            });
            sessionRegistry.tryInitiateCall(requestId, senderId, targetId);
        } else if ("CALL_ACCEPTED".equals(type)) {
            sessionRegistry.acceptCall(requestId);
        } else if ("HANGUP".equals(type) || "CALL_REJECTED".equals(type)) {
            // 통화 요청 상태 초기화
            consultingRequestRepository.findById(requestId).ifPresent(req -> {
                req.setCallInitiated(false);
                consultingRequestRepository.save(req);
            });
            sessionRegistry.endCall(requestId);
        }

        return message;
    }
}
