package com.publicservice.controller;

import com.publicservice.entity.ConsultingMessage;
import com.publicservice.entity.ConsultingRequest;
import com.publicservice.entity.PointHistory;
import com.publicservice.entity.User;
import com.publicservice.repository.AccountantRepository;
import com.publicservice.repository.ConsultingMessageRepository;
import com.publicservice.repository.ConsultingRequestRepository;
import com.publicservice.repository.LaborAttorneyRepository;
import com.publicservice.repository.LawyerRepository;
import com.publicservice.repository.PatentAttorneyRepository;
import com.publicservice.repository.PointHistoryRepository;
import com.publicservice.repository.TaxAccountantRepository;
import com.publicservice.repository.UserRepository;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.ZoneId;
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
import org.springframework.web.bind.annotation.RequestBody;
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
    private final PointHistoryRepository pointHistoryRepository;
    private final PatentAttorneyRepository patentRepo;
    private final TaxAccountantRepository taxRepo;
    private final AccountantRepository accountRepo;
    private final LaborAttorneyRepository laborRepo;
    private final LawyerRepository lawyerRepo;

    public ConsultingController(ConsultingRequestRepository requestRepository,
                                ConsultingMessageRepository messageRepository,
                                UserRepository userRepository,
                                PointHistoryRepository pointHistoryRepository,
                                PatentAttorneyRepository patentRepo,
                                TaxAccountantRepository taxRepo,
                                AccountantRepository accountRepo,
                                LaborAttorneyRepository laborRepo,
                                LawyerRepository lawyerRepo) {
        this.requestRepository = requestRepository;
        this.messageRepository = messageRepository;
        this.userRepository = userRepository;
        this.pointHistoryRepository = pointHistoryRepository;
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
            @RequestParam("expertId")        Long expertId,
            @RequestParam("expertType")      String expertType,
            @RequestParam("title")           String title,
            @RequestParam(value = "content", defaultValue = "") String content,
            @RequestParam("consultationType") String consultationType,
            @RequestParam("durationSeconds") Integer durationSeconds,
            HttpSession session) {

        Map<String, Object> result = new LinkedHashMap<>();
        Long userId = (Long) session.getAttribute("loginUserId");
        if (userId == null) {
            result.put("error", "로그인이 필요합니다.");
            return result;
        }

        User user = userRepository.findById(userId).orElse(null);
        if (user == null) {
            result.put("error", "사용자를 찾을 수 없습니다.");
            return result;
        }

        // 서버에서 가격 계산 (10분 기준 가격에서 실제 시간에 따라 비례 계산)
        Integer basePrice = resolveExpertPrice(expertType, expertId, consultationType);
        if (basePrice == null || basePrice < 0) {
            result.put("error", "전문가 정보를 찾을 수 없습니다.");
            return result;
        }
        Integer sessionPrice = Math.round(basePrice * durationSeconds / 600.0f);

        if (user.getPoint() < sessionPrice) {
            result.put("error", "포인트가 부족합니다.");
            result.put("currentPoint", user.getPoint());
            result.put("requiredPoint", sessionPrice);
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

        // 포인트 차감
        user.setPoint(user.getPoint() - sessionPrice);
        userRepository.save(user);

        // 포인트 내역 기록
        PointHistory history = new PointHistory();
        history.setUserId(userId);
        history.setAmount(sessionPrice);
        history.setType("USE");
        history.setDescription(consultationType + " 상담 결제");
        pointHistoryRepository.save(history);

        // 자문 요청 생성
        ConsultingRequest req = new ConsultingRequest();
        req.setExpertId(expertId);
        req.setExpertType(expertType);
        req.setExpertUserId(expertUserId);
        req.setUserId(userId);
        req.setTitle(title.trim());
        req.setContent(content.isBlank() ? null : content.trim());
        req.setConsultationType(consultationType);
        req.setDurationSeconds(durationSeconds);
        req.setSessionPrice(sessionPrice);
        req.setStatus("PENDING");
        requestRepository.save(req);

        result.put("success",       true);
        result.put("requestId",     req.getRequestId());
        result.put("remainingPoint", user.getPoint());
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
            String expertName  = resolveExpertName(r.getExpertType(), r.getExpertId());
            String expertOffice = resolveExpertOffice(r.getExpertType(), r.getExpertId());
            String expertPhone  = resolveExpertPhone(r.getExpertType(), r.getExpertId());
            String expertAddr   = resolveExpertAddress(r.getExpertType(), r.getExpertId());

            Map<String, Object> item = new LinkedHashMap<>();
            item.put("requestId",         r.getRequestId());
            item.put("expertId",          r.getExpertId());
            item.put("expertName",        expertName);
            item.put("expertOffice",      expertOffice);
            item.put("expertPhone",       expertPhone);
            item.put("expertAddr",        expertAddr);
            item.put("expertType",        r.getExpertType());
            item.put("title",             r.getTitle());
            item.put("status",            r.getStatus());
            item.put("consultationType",  r.getConsultationType());
            item.put("durationSeconds",   r.getDurationSeconds());
            item.put("sessionPrice",      r.getSessionPrice());
            item.put("callStartedAt",     r.getCallStartedAt());
            item.put("callEndedAt",       r.getCallEndedAt());
            item.put("extraPaid",         r.getExtraPaid());
            item.put("createdAt",         r.getCreatedAt().toLocalDate().toString());
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
            item.put("requestId",       r.getRequestId());
            item.put("userName",        user != null ? user.getName()        : "알 수 없음");
            item.put("companyName",     user != null ? user.getCompanyName() : "-");
            item.put("userPhone",       user != null ? user.getPhone()       : "-");
            item.put("title",           r.getTitle());
            item.put("content",         r.getContent());
            item.put("status",          r.getStatus());
            item.put("consultationType",r.getConsultationType());
            item.put("durationSeconds", r.getDurationSeconds());
            item.put("createdAt",       r.getCreatedAt().toLocalDate().toString());
            items.add(item);
        }

        long pendingCount  = requestRepository.countByExpertUserIdAndStatus(expertUserId, "PENDING");
        long acceptedCount = requestRepository.countByExpertUserIdAndStatus(expertUserId, "ACCEPTED");
        long totalCount    = requests.size();

        LocalDate today = LocalDate.now();
        int monthRevenue = requests.stream()
                .filter(r -> "COMPLETED".equals(r.getStatus())
                          && r.getCreatedAt().getYear()       == today.getYear()
                          && r.getCreatedAt().getMonthValue() == today.getMonthValue())
                .mapToInt(r -> r.getSessionPrice() + (r.getExtraPaid() != null ? r.getExtraPaid() : 0))
                .sum();

        result.put("items",         items);
        result.put("pendingCount",  pendingCount);
        result.put("acceptedCount", acceptedCount);
        result.put("totalCount",    totalCount);
        result.put("monthRevenue",  monthRevenue);
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
        if (!"ACCEPTED".equals(newStatus) && !"REJECTED".equals(newStatus) && !"COMPLETED".equals(newStatus)) {
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

        result.put("items",             items);
        result.put("myRole",            isExpert ? "EXPERT" : "USER");
        result.put("requestTitle",      req.getTitle());
        result.put("consultationType",  req.getConsultationType());
        result.put("durationSeconds",   req.getDurationSeconds());
        result.put("sessionPrice",      req.getSessionPrice());
        result.put("callStartedAt",     req.getCallStartedAt());
        result.put("callEndedAt",       req.getCallEndedAt());
        result.put("extraPaid",         req.getExtraPaid());
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

    // -------------------------------------------------------------------
    // POST /api/consulting/{id}/start-call — 통화 시작 (시간 기록)
    // -------------------------------------------------------------------
    @PostMapping("/requests/{id}/start-call")
    public Map<String, Object> startCall(
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

        if (!userId.equals(req.getUserId()) && !userId.equals(req.getExpertUserId())) {
            result.put("error", "권한이 없습니다.");
            return result;
        }

        // 통화 세션 시작 - callStartedAt을 현재 시간으로 설정
        req.setCallStartedAt(LocalDateTime.now());
        requestRepository.save(req);

        long callStartedAtMs = req.getCallStartedAt()
            .atZone(ZoneId.systemDefault()).toInstant().toEpochMilli();
        result.put("success", true);
        result.put("callStartedAtMs", callStartedAtMs);
        result.put("durationSeconds", req.getDurationSeconds());
        return result;
    }

    // -------------------------------------------------------------------
    // POST /api/consulting/{id}/end-call — 상담 종료
    // -------------------------------------------------------------------
    @PostMapping("/requests/{id}/end-call")
    public Map<String, Object> endCall(
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

        if (!userId.equals(req.getUserId()) && !userId.equals(req.getExpertUserId())) {
            result.put("error", "권한이 없습니다.");
            return result;
        }

        // 상담 종료 처리
        req.setCallEndedAt(LocalDateTime.now());
        req.setStatus("COMPLETED");
        requestRepository.save(req);

        result.put("success", true);
        return result;
    }

    // -------------------------------------------------------------------
    // POST /api/consulting/{id}/extend — 통화 연장 (포인트 또는 카드)
    // -------------------------------------------------------------------
    @PostMapping("/requests/{id}/extend")
    public Map<String, Object> extendCall(
            @PathVariable("id") Long requestId,
            @RequestParam("payType") String payType,
            @RequestParam("addSeconds") Integer addSeconds,
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

        if (!userId.equals(req.getUserId()) && !userId.equals(req.getExpertUserId())) {
            result.put("error", "권한이 없습니다.");
            return result;
        }

        if ("POINT".equals(payType)) {
            // 10분 기준 가격으로 추가 시간 계산
            Integer basePrice = resolveExpertPrice(req.getExpertType(), req.getExpertId(), req.getConsultationType());
            if (basePrice == null || basePrice < 0) {
                result.put("error", "전문가 정보를 찾을 수 없습니다.");
                return result;
            }
            Integer extensionCost = Math.round(basePrice * addSeconds / 600.0f);

            User user = userRepository.findById(userId).orElse(null);
            if (user == null) {
                result.put("error", "사용자를 찾을 수 없습니다.");
                return result;
            }

            if (user.getPoint() < extensionCost) {
                result.put("error", "포인트가 부족합니다.");
                result.put("required", extensionCost);
                result.put("current", user.getPoint());
                return result;
            }

            // 포인트 차감
            user.setPoint(user.getPoint() - extensionCost);
            userRepository.save(user);

            // 포인트 내역 기록
            PointHistory history = new PointHistory();
            history.setUserId(userId);
            history.setAmount(extensionCost);
            history.setType("USE");
            history.setDescription("통화 연장");
            pointHistoryRepository.save(history);

            // 시간 연장
            req.setDurationSeconds(req.getDurationSeconds() + addSeconds);
            req.setExtraPaid(req.getExtraPaid() + extensionCost);
            requestRepository.save(req);

            result.put("success", true);
            result.put("newDuration", req.getDurationSeconds());
            result.put("remainingPoint", user.getPoint());
        } else if ("CARD".equals(payType)) {
            result.put("error", "카드 결제는 아직 구현되지 않았습니다.");
        } else {
            result.put("error", "유효하지 않은 결제 방식입니다.");
        }

        return result;
    }

    // -------------------------------------------------------------------
    // POST /api/consulting/{id}/complete-call — 상담 완료 (전문가용)
    // -------------------------------------------------------------------
    @PostMapping("/requests/{id}/complete-call")
    public Map<String, Object> completeCall(
            @PathVariable("id") Long requestId,
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

        req.setRemainingSeconds(0);
        req.setStatus("COMPLETED");
        requestRepository.save(req);

        result.put("success", true);
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

    private String resolveExpertPhone(String expertType, Long expertId) {
        return switch (expertType) {
            case "변리사" -> patentRepo.findById(expertId).map(e -> e.getPhone()).orElse("-");
            case "세무사" -> taxRepo.findById(expertId).map(e -> e.getPhone()).orElse("-");
            case "회계사" -> accountRepo.findById(expertId).map(e -> e.getPhone()).orElse("-");
            case "노무사" -> laborRepo.findById(expertId).map(e -> e.getPhone()).orElse("-");
            case "변호사" -> lawyerRepo.findById(expertId).map(e -> e.getPhone()).orElse("-");
            default      -> "-";
        };
    }

    private String resolveExpertAddress(String expertType, Long expertId) {
        return switch (expertType) {
            case "변리사" -> patentRepo.findById(expertId).map(e -> e.getAddr()).orElse("-");
            case "세무사" -> taxRepo.findById(expertId).map(e -> e.getAddr()).orElse("-");
            case "회계사" -> accountRepo.findById(expertId).map(e -> e.getAddr()).orElse("-");
            case "노무사" -> laborRepo.findById(expertId).map(e -> e.getAddr()).orElse("-");
            case "변호사" -> lawyerRepo.findById(expertId).map(e -> e.getAddr()).orElse("-");
            default      -> "-";
        };
    }

    // 10분 기준 가격 조회 (상담 타입에 따라 VIDEO/CHAT/CALL 가격)
    private Integer resolveExpertPrice(String expertType, Long expertId, String consultationType) {
        return switch (expertType) {
            case "변리사" -> patentRepo.findById(expertId).map(e ->
                "VIDEO".equals(consultationType) ? e.getPriceVideo() :
                "CHAT".equals(consultationType) ? e.getPriceChat() :
                "PHONE".equals(consultationType) ? e.getPriceCall() : 0
            ).orElse(0);
            case "세무사" -> taxRepo.findById(expertId).map(e ->
                "VIDEO".equals(consultationType) ? e.getPriceVideo() :
                "CHAT".equals(consultationType) ? e.getPriceChat() :
                "PHONE".equals(consultationType) ? e.getPriceCall() : 0
            ).orElse(0);
            case "회계사" -> accountRepo.findById(expertId).map(e ->
                "VIDEO".equals(consultationType) ? e.getPriceVideo() :
                "CHAT".equals(consultationType) ? e.getPriceChat() :
                "PHONE".equals(consultationType) ? e.getPriceCall() : 0
            ).orElse(0);
            case "노무사" -> laborRepo.findById(expertId).map(e ->
                "VIDEO".equals(consultationType) ? e.getPriceVideo() :
                "CHAT".equals(consultationType) ? e.getPriceChat() :
                "PHONE".equals(consultationType) ? e.getPriceCall() : 0
            ).orElse(0);
            case "변호사" -> lawyerRepo.findById(expertId).map(e ->
                "VIDEO".equals(consultationType) ? e.getPriceVideo() :
                "CHAT".equals(consultationType) ? e.getPriceChat() :
                "PHONE".equals(consultationType) ? e.getPriceCall() : 0
            ).orElse(0);
            default      -> 0;
        };
    }
}
