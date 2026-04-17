package com.publicservice.controller;

import com.publicservice.entity.ConsultingMessage;
import com.publicservice.entity.ConsultingRequest;
import com.publicservice.entity.User;
import com.publicservice.repository.AccountantRepository;
import com.publicservice.repository.ConsultingMessageRepository;
import com.publicservice.repository.ConsultingRequestRepository;
import com.publicservice.repository.LaborAttorneyRepository;
import com.publicservice.repository.LawyerRepository;
import com.publicservice.repository.PatentAttorneyRepository;
import com.publicservice.repository.TaxAccountantRepository;
import com.publicservice.repository.UserRepository;
import jakarta.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@SuppressWarnings("null")
@RestController
@RequestMapping("/api/consulting")
public class ConsultingController {

    private final ConsultingRequestRepository requestRepository;
    private final ConsultingMessageRepository messageRepository;
    private final UserRepository userRepository;
    private final PatentAttorneyRepository patentRepo;
    private final TaxAccountantRepository taxRepo;
    private final AccountantRepository accountRepo;
    private final LaborAttorneyRepository laborRepo;
    private final LawyerRepository lawyerRepo;

    public ConsultingController(ConsultingRequestRepository requestRepository,
                                ConsultingMessageRepository messageRepository,
                                UserRepository userRepository,
                                PatentAttorneyRepository patentRepo,
                                TaxAccountantRepository taxRepo,
                                AccountantRepository accountRepo,
                                LaborAttorneyRepository laborRepo,
                                LawyerRepository lawyerRepo) {
        this.requestRepository = requestRepository;
        this.messageRepository = messageRepository;
        this.userRepository = userRepository;
        this.patentRepo = patentRepo;
        this.taxRepo = taxRepo;
        this.accountRepo = accountRepo;
        this.laborRepo = laborRepo;
        this.lawyerRepo = lawyerRepo;
    }

    // -------------------------------------------------------------------
    // POST /api/consulting/requests — 자문요청 남기기 (사용자)
    // -------------------------------------------------------------------
    @PostMapping("/requests")
    public Map<String, Object> submitRequest(
            @RequestParam("expertId")   Long expertId,
            @RequestParam("expertType") String expertType,
            @RequestParam("title")      String title,
            @RequestParam(value = "content", defaultValue = "") String content,
            HttpSession session) {

        Map<String, Object> result = new LinkedHashMap<>();
        Long userId = (Long) session.getAttribute("loginUserId");
        if (userId == null) {
            result.put("error", "로그인이 필요합니다.");
            return result;
        }

        // 중복 신청 방지
        if (requestRepository.existsByUserIdAndExpertIdAndExpertTypeAndStatus(
                userId, expertId, expertType, "PENDING")) {
            result.put("error", "이미 해당 전문가에게 대기 중인 자문요청이 있습니다.");
            return result;
        }

        // 전문가 userId 조회
        Long expertUserId = resolveExpertUserId(expertType, expertId);

        ConsultingRequest req = new ConsultingRequest();
        req.setExpertId(expertId);
        req.setExpertType(expertType);
        req.setExpertUserId(expertUserId);
        req.setUserId(userId);
        req.setTitle(title.trim());
        req.setContent(content.isBlank() ? null : content.trim());
        req.setStatus("PENDING");
        requestRepository.save(req);

        result.put("success",   true);
        result.put("requestId", req.getRequestId());
        return result;
    }

    // -------------------------------------------------------------------
    // GET /api/consulting/my/requests — 내가 보낸 자문요청 목록 (사용자)
    // -------------------------------------------------------------------
    @GetMapping("/my/requests")
    public Map<String, Object> getMyRequests(HttpSession session) {
        Map<String, Object> result = new LinkedHashMap<>();
        Long userId = (Long) session.getAttribute("loginUserId");
        if (userId == null) {
            result.put("items", List.of());
            return result;
        }

        List<ConsultingRequest> requests =
                requestRepository.findByUserIdOrderByCreatedAtDesc(userId);
        List<Map<String, Object>> items = new ArrayList<>();

        for (ConsultingRequest r : requests) {
            String expertName   = resolveExpertName(r.getExpertType(), r.getExpertId());
            String expertOffice = resolveExpertOffice(r.getExpertType(), r.getExpertId());

            Map<String, Object> item = new LinkedHashMap<>();
            item.put("requestId",   r.getRequestId());
            item.put("expertName",  expertName);
            item.put("expertOffice", expertOffice);
            item.put("expertType",  r.getExpertType());
            item.put("title",       r.getTitle());
            item.put("status",      r.getStatus());
            item.put("createdAt",   r.getCreatedAt().toLocalDate().toString());
            items.add(item);
        }

        result.put("items", items);
        return result;
    }

    // -------------------------------------------------------------------
    // GET /api/consulting/expert/requests — 전문가가 받은 자문요청 목록
    // -------------------------------------------------------------------
    @GetMapping("/expert/requests")
    public Map<String, Object> getExpertRequests(HttpSession session) {
        Map<String, Object> result = new LinkedHashMap<>();
        Long expertUserId = (Long) session.getAttribute("loginUserId");
        if (expertUserId == null) {
            result.put("error", "로그인이 필요합니다.");
            return result;
        }

        List<ConsultingRequest> requests =
                requestRepository.findByExpertUserIdOrderByCreatedAtDesc(expertUserId);
        List<Map<String, Object>> items = new ArrayList<>();

        for (ConsultingRequest r : requests) {
            User user = userRepository.findById(r.getUserId()).orElse(null);

            Map<String, Object> item = new LinkedHashMap<>();
            item.put("requestId",    r.getRequestId());
            item.put("userName",     user != null ? user.getName()        : "알 수 없음");
            item.put("companyName",  user != null ? user.getCompanyName() : "-");
            item.put("title",        r.getTitle());
            item.put("content",      r.getContent());
            item.put("status",       r.getStatus());
            item.put("createdAt",    r.getCreatedAt().toLocalDate().toString());
            items.add(item);
        }

        long pendingCount  = requestRepository.countByExpertUserIdAndStatus(expertUserId, "PENDING");
        long acceptedCount = requestRepository.countByExpertUserIdAndStatus(expertUserId, "ACCEPTED");
        long totalCount    = requests.size();

        result.put("items",         items);
        result.put("pendingCount",  pendingCount);
        result.put("acceptedCount", acceptedCount);
        result.put("totalCount",    totalCount);
        return result;
    }

    // -------------------------------------------------------------------
    // PATCH /api/consulting/requests/{id}/status — 수락 / 거절 (전문가)
    // -------------------------------------------------------------------
    @PatchMapping("/requests/{id}/status")
    public Map<String, Object> updateStatus(
            @PathVariable("id")     Long requestId,
            @RequestParam("status") String newStatus,
            HttpSession session) {

        Map<String, Object> result = new LinkedHashMap<>();
        Long expertUserId = (Long) session.getAttribute("loginUserId");
        if (expertUserId == null) {
            result.put("error", "로그인이 필요합니다.");
            return result;
        }

        Optional<ConsultingRequest> opt = requestRepository.findById(requestId);
        if (opt.isEmpty()) {
            result.put("error", "요청을 찾을 수 없습니다.");
            return result;
        }
        ConsultingRequest req = opt.get();

        if (!expertUserId.equals(req.getExpertUserId())) {
            result.put("error", "권한이 없습니다.");
            return result;
        }
        if (!"ACCEPTED".equals(newStatus) && !"REJECTED".equals(newStatus)) {
            result.put("error", "유효하지 않은 상태값입니다.");
            return result;
        }

        req.setStatus(newStatus);
        requestRepository.save(req);

        result.put("success", true);
        result.put("status",  newStatus);
        return result;
    }

    // -------------------------------------------------------------------
    // POST /api/consulting/requests/{id}/cancel — 취소 (사용자 본인)
    // -------------------------------------------------------------------
    @PostMapping("/requests/{id}/cancel")
    public Map<String, Object> cancelRequest(
            @PathVariable("id") Long requestId,
            HttpSession session) {

        Map<String, Object> result = new LinkedHashMap<>();
        Long userId = (Long) session.getAttribute("loginUserId");
        if (userId == null) {
            result.put("error", "로그인이 필요합니다.");
            return result;
        }

        Optional<ConsultingRequest> opt = requestRepository.findById(requestId);
        if (opt.isEmpty()) {
            result.put("error", "요청을 찾을 수 없습니다.");
            return result;
        }
        ConsultingRequest req = opt.get();

        if (!userId.equals(req.getUserId())) {
            result.put("error", "본인의 요청만 취소할 수 있습니다.");
            return result;
        }
        if (!"PENDING".equals(req.getStatus())) {
            result.put("error", "대기 중인 요청만 취소할 수 있습니다.");
            return result;
        }

        req.setStatus("CANCELLED");
        requestRepository.save(req);

        result.put("success", true);
        return result;
    }

    // -------------------------------------------------------------------
    // 내부 헬퍼: 전문가 유형 + 엔티티 ID로 users.userId 조회
    // -------------------------------------------------------------------
    // -------------------------------------------------------------------
    // GET /api/consulting/requests/{id}/messages — 채팅 메시지 목록
    // -------------------------------------------------------------------
    @GetMapping("/requests/{id}/messages")
    public Map<String, Object> getMessages(
            @PathVariable("id") Long requestId,
            HttpSession session) {

        Map<String, Object> result = new LinkedHashMap<>();
        Long loginUserId = (Long) session.getAttribute("loginUserId");
        if (loginUserId == null) {
            result.put("error", "로그인이 필요합니다.");
            return result;
        }

        Optional<ConsultingRequest> opt = requestRepository.findById(requestId);
        if (opt.isEmpty()) {
            result.put("error", "요청을 찾을 수 없습니다.");
            return result;
        }
        ConsultingRequest req = opt.get();

        boolean isUser   = loginUserId.equals(req.getUserId());
        boolean isExpert = loginUserId.equals(req.getExpertUserId());
        if (!isUser && !isExpert) {
            result.put("error", "권한이 없습니다.");
            return result;
        }

        List<ConsultingMessage> messages =
                messageRepository.findByRequestIdOrderByCreatedAtAsc(requestId);
        List<Map<String, Object>> items = new ArrayList<>();
        for (ConsultingMessage m : messages) {
            Map<String, Object> item = new LinkedHashMap<>();
            item.put("messageId",   m.getMessageId());
            item.put("senderRole",  m.getSenderRole());
            item.put("content",     m.getContent());
            item.put("createdAt",   m.getCreatedAt().toString().substring(0, 16).replace("T", " "));
            item.put("isMine",      loginUserId.equals(m.getSenderId()));
            items.add(item);
        }

        result.put("items",      items);
        result.put("myRole",     isExpert ? "EXPERT" : "USER");
        result.put("requestTitle", req.getTitle());
        return result;
    }

    // -------------------------------------------------------------------
    // POST /api/consulting/requests/{id}/messages — 메시지 전송
    // -------------------------------------------------------------------
    @PostMapping("/requests/{id}/messages")
    public Map<String, Object> sendMessage(
            @PathVariable("id") Long requestId,
            @RequestParam("content") String content,
            HttpSession session) {

        Map<String, Object> result = new LinkedHashMap<>();
        Long loginUserId = (Long) session.getAttribute("loginUserId");
        if (loginUserId == null) {
            result.put("error", "로그인이 필요합니다.");
            return result;
        }

        Optional<ConsultingRequest> opt = requestRepository.findById(requestId);
        if (opt.isEmpty()) {
            result.put("error", "요청을 찾을 수 없습니다.");
            return result;
        }
        ConsultingRequest req = opt.get();

        boolean isUser   = loginUserId.equals(req.getUserId());
        boolean isExpert = loginUserId.equals(req.getExpertUserId());
        if (!isUser && !isExpert) {
            result.put("error", "권한이 없습니다.");
            return result;
        }
        if (!"ACCEPTED".equals(req.getStatus())) {
            result.put("error", "수락된 자문요청에서만 채팅이 가능합니다.");
            return result;
        }
        if (content == null || content.isBlank()) {
            result.put("error", "메시지 내용을 입력해 주세요.");
            return result;
        }

        ConsultingMessage msg = new ConsultingMessage();
        msg.setRequestId(requestId);
        msg.setSenderId(loginUserId);
        msg.setSenderRole(isExpert ? "EXPERT" : "USER");
        msg.setContent(content.trim());
        messageRepository.save(msg);

        result.put("success",   true);
        result.put("messageId", msg.getMessageId());
        return result;
    }

    // expertType은 한국어 레이블("변리사","세무사","회계사","노무사","변호사") 사용
    private Long resolveExpertUserId(String expertType, Long expertId) {
        return switch (expertType) {
            case "변리사" -> patentRepo.findById(expertId).map(e -> e.getUserId()).orElse(null);
            case "세무사" -> taxRepo.findById(expertId).map(e -> e.getUserId()).orElse(null);
            case "회계사" -> accountRepo.findById(expertId).map(e -> e.getUserId()).orElse(null);
            case "노무사" -> laborRepo.findById(expertId).map(e -> e.getUserId()).orElse(null);
            case "변호사" -> lawyerRepo.findById(expertId).map(e -> e.getUserId()).orElse(null);
            default      -> null;
        };
    }

    private String resolveExpertName(String expertType, Long expertId) {
        return switch (expertType) {
            case "변리사" -> patentRepo.findById(expertId).map(e -> e.getName()).orElse("알 수 없음");
            case "세무사" -> taxRepo.findById(expertId).map(e -> e.getName()).orElse("알 수 없음");
            case "회계사" -> accountRepo.findById(expertId).map(e -> e.getName()).orElse("알 수 없음");
            case "노무사" -> laborRepo.findById(expertId).map(e -> e.getName()).orElse("알 수 없음");
            case "변호사" -> lawyerRepo.findById(expertId).map(e -> e.getName()).orElse("알 수 없음");
            default      -> "알 수 없음";
        };
    }

    private String resolveExpertOffice(String expertType, Long expertId) {
        return switch (expertType) {
            case "변리사" -> patentRepo.findById(expertId).map(e -> e.getOffice()).orElse("-");
            case "세무사" -> taxRepo.findById(expertId).map(e -> e.getOffice()).orElse("-");
            case "회계사" -> accountRepo.findById(expertId).map(e -> e.getOffice()).orElse("-");
            case "노무사" -> laborRepo.findById(expertId).map(e -> e.getOffice()).orElse("-");
            case "변호사" -> lawyerRepo.findById(expertId).map(e -> e.getOffice()).orElse("-");
            default      -> "-";
        };
    }
}
