package com.publicservice.controller;

import com.publicservice.entity.Space;
import com.publicservice.entity.SpaceReservation;
import com.publicservice.entity.User;
import com.publicservice.repository.SpaceRepository;
import com.publicservice.repository.SpaceReservationRepository;
import com.publicservice.repository.UserRepository;
import jakarta.persistence.criteria.Predicate;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.time.Duration;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.UUID;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

@RestController
@RequestMapping("/api/spaces")
public class SpaceController {

    private final SpaceRepository spaceRepository;
    private final SpaceReservationRepository reservationRepository;
    private final UserRepository userRepository;

    @Value("${upload.spaces.path}")
    private String uploadPath;

    public SpaceController(SpaceRepository spaceRepository,
                           SpaceReservationRepository reservationRepository,
                           UserRepository userRepository) {
        this.spaceRepository = spaceRepository;
        this.reservationRepository = reservationRepository;
        this.userRepository = userRepository;
    }

    // ---------------------------------------------------------------
    // GET /api/spaces — 공간 검색 (기존)
    // ---------------------------------------------------------------
    @GetMapping
    public Map<String, Object> getSpaces(
            @RequestParam(name = "region",     required = false) String region,
            @RequestParam(name = "district",   required = false) String district,
            @RequestParam(name = "spaceTypes", required = false) List<String> spaceTypes,
            @RequestParam(name = "minPrice",   required = false) Integer minPrice,
            @RequestParam(name = "maxPrice",   required = false) Integer maxPrice,
            @RequestParam(name = "capacity",   required = false) Integer capacity,
            @RequestParam(name = "page",  defaultValue = "0")  int page,
            @RequestParam(name = "size",  defaultValue = "12") int size) {

        Pageable pageable = PageRequest.of(
                Math.max(page, 0),
                Math.max(size, 1),
                Sort.by(Sort.Direction.ASC, "spaceId"));

        Specification<Space> spec = (root, query, cb) -> {
            List<Predicate> predicates = new ArrayList<>();
            if (region     != null && !region.isBlank())
                predicates.add(cb.equal(root.get("region"), region));
            if (district   != null && !district.isBlank())
                predicates.add(cb.equal(root.get("district"), district));
            if (spaceTypes != null && !spaceTypes.isEmpty())
                predicates.add(root.get("spaceType").in(spaceTypes));
            if (minPrice   != null)
                predicates.add(cb.greaterThanOrEqualTo(root.get("pricePerHour"), minPrice));
            if (maxPrice   != null)
                predicates.add(cb.lessThanOrEqualTo(root.get("pricePerHour"), maxPrice));
            if (capacity   != null)
                predicates.add(cb.greaterThanOrEqualTo(root.get("capacity"), capacity));
            return cb.and(predicates.toArray(new Predicate[0]));
        };

        Page<Space> result = spaceRepository.findAll(spec, pageable);

        Map<String, Object> response = new LinkedHashMap<>();
        response.put("items",         result.getContent());
        response.put("page",          result.getNumber());
        response.put("size",          result.getSize());
        response.put("totalElements", result.getTotalElements());
        response.put("totalPages",    result.getTotalPages());
        response.put("hasNext",       result.hasNext());
        return response;
    }

    // ---------------------------------------------------------------
    // GET /api/spaces/{id}/availability?date=YYYY-MM-DD — 타임라인용 예약 현황
    // ---------------------------------------------------------------
    @GetMapping("/{spaceId}/availability")
    public Map<String, Object> getAvailability(
            @PathVariable("spaceId") Long spaceId,
            @RequestParam("date") String date) {

        Map<String, Object> result = new LinkedHashMap<>();

        Optional<Space> spaceOpt = spaceRepository.findById(spaceId);
        if (spaceOpt.isEmpty()) {
            result.put("error", "공간을 찾을 수 없습니다.");
            return result;
        }

        List<SpaceReservation> booked =
                reservationRepository.findBookedSlots(spaceId, LocalDate.parse(date));

        List<Map<String, String>> slots = new ArrayList<>();
        for (SpaceReservation r : booked) {
            Map<String, String> slot = new LinkedHashMap<>();
            slot.put("startTime", r.getStartTime().toString());
            slot.put("endTime",   r.getEndTime().toString());
            slots.add(slot);
        }

        result.put("bookedSlots",  slots);
        result.put("pricePerHour", spaceOpt.get().getPricePerHour());
        return result;
    }

    // ---------------------------------------------------------------
    // POST /api/spaces — 공간 등록 (호스트 전용)
    // ---------------------------------------------------------------
    @PostMapping(consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    public ResponseEntity<Map<String, Object>> createSpace(
            @RequestParam("name")                              String name,
            @RequestParam("spaceType")                         String spaceType,
            @RequestParam("description")                       String description,
            @RequestParam("region")                            String region,
            @RequestParam("district")                          String district,
            @RequestParam("address")                           String address,
            @RequestParam(value = "detailAddress", defaultValue = "") String detailAddress,
            @RequestParam("maxCapacity")                       int capacity,
            @RequestParam("pricePerHour")                      int pricePerHour,
            @RequestParam(value = "mainImage", required = false) MultipartFile mainImage,
            HttpSession session) {

        Map<String, Object> result = new LinkedHashMap<>();

        Long hostId = (Long) session.getAttribute("loginUserId");
        if (hostId == null) {
            result.put("error", "로그인이 필요합니다.");
            return ResponseEntity.status(401).body(result);
        }

        // 이미지 저장
        String imageUrl = null;
        if (mainImage != null && !mainImage.isEmpty()) {
            try {
                String ext      = Optional.ofNullable(mainImage.getOriginalFilename())
                                          .filter(f -> f.contains("."))
                                          .map(f -> f.substring(f.lastIndexOf('.')))
                                          .orElse(".jpg");
                String fileName = UUID.randomUUID().toString() + ext;

                Path uploadDir = Paths.get(uploadPath).isAbsolute()
                        ? Paths.get(uploadPath)
                        : Paths.get(System.getProperty("user.dir"), uploadPath);
                Files.createDirectories(uploadDir);
                Files.copy(mainImage.getInputStream(),
                           uploadDir.resolve(fileName),
                           StandardCopyOption.REPLACE_EXISTING);
                imageUrl = "/images/spaces/" + fileName;
            } catch (IOException e) {
                result.put("error", "이미지 저장 실패: " + e.getMessage());
                return ResponseEntity.status(500).body(result);
            }
        }

        String fullAddress = detailAddress.isBlank() ? address : address + " " + detailAddress;

        Space space = new Space();
        space.setHostId(hostId);
        space.setName(name);
        space.setSpaceType(spaceType);
        space.setDescription(description);
        space.setRegion(region);
        space.setDistrict(district);
        space.setAddress(fullAddress);
        space.setCapacity(capacity);
        space.setPricePerHour(pricePerHour);
        space.setMainImageUrl(imageUrl);
        space.setAvailableYn("Y");
        space.setCreatedAt(LocalDateTime.now());
        space.setUpdatedAt(LocalDateTime.now());
        spaceRepository.save(space);

        result.put("success", true);
        result.put("spaceId", space.getSpaceId());
        return ResponseEntity.ok(result);
    }

    // ---------------------------------------------------------------
    // POST /api/spaces/{id}/reserve — 예약 신청 (사용자)
    // ---------------------------------------------------------------
    @PostMapping("/{spaceId}/reserve")
    public Map<String, Object> makeReservation(
            @PathVariable("spaceId")                           Long spaceId,
            @RequestParam("useDate")                           String useDate,
            @RequestParam("startTime")                         String startTime,
            @RequestParam("endTime")                           String endTime,
            @RequestParam(value = "userMemo", defaultValue = "") String userMemo,
            HttpSession session) {

        Map<String, Object> result = new LinkedHashMap<>();

        Long userId = (Long) session.getAttribute("loginUserId");
        if (userId == null) {
            result.put("error", "로그인이 필요합니다.");
            return result;
        }

        Optional<Space> spaceOpt = spaceRepository.findById(spaceId);
        if (spaceOpt.isEmpty()) {
            result.put("error", "존재하지 않는 공간입니다.");
            return result;
        }
        Space space = spaceOpt.get();

        LocalTime start = LocalTime.parse(startTime);
        LocalTime end   = LocalTime.parse(endTime);
        long hours = Duration.between(start, end).toHours();
        if (hours <= 0) {
            result.put("error", "종료 시간은 시작 시간보다 늦어야 합니다.");
            return result;
        }

        // 시간 중복 체크 (PENDING·APPROVED 예약과 겹치면 거부)
        LocalDate date = LocalDate.parse(useDate);
        long overlap = reservationRepository.countOverlapping(spaceId, date, start, end);
        if (overlap > 0) {
            result.put("error", "해당 시간대에 이미 예약이 있습니다. 다른 시간을 선택해 주세요.");
            return result;
        }

        SpaceReservation reservation = new SpaceReservation();
        reservation.setSpaceId(spaceId);
        reservation.setUserId(userId);
        reservation.setUseDate(date);
        reservation.setStartTime(start);
        reservation.setEndTime(end);
        reservation.setTotalPrice((int) hours * space.getPricePerHour());
        reservation.setStatus("PENDING");
        reservation.setUserMemo(userMemo.isBlank() ? null : userMemo);
        reservationRepository.save(reservation);

        result.put("success",       true);
        result.put("reservationId", reservation.getReservationId());
        result.put("totalPrice",    reservation.getTotalPrice());
        return result;
    }

    // ---------------------------------------------------------------
    // GET /api/spaces/my/reservations — 내 예약 목록 (사용자)
    // ---------------------------------------------------------------
    @GetMapping("/my/reservations")
    public Map<String, Object> getMyReservations(HttpSession session) {
        Map<String, Object> result = new LinkedHashMap<>();

        Long userId = (Long) session.getAttribute("loginUserId");
        if (userId == null) {
            result.put("items",         List.of());
            result.put("upcomingCount", 0);
            return result;
        }

        List<SpaceReservation> reservations =
                reservationRepository.findByUserIdOrderByCreatedAtDesc(userId);

        Map<Long, Space> spaceCache = new HashMap<>();
        List<Map<String, Object>> items = new ArrayList<>();
        LocalDate today = LocalDate.now();

        for (SpaceReservation r : reservations) {
            Space sp = spaceCache.computeIfAbsent(r.getSpaceId(),
                    id -> spaceRepository.findById(id).orElse(null));

            Map<String, Object> item = new LinkedHashMap<>();
            item.put("reservationId", r.getReservationId());
            item.put("spaceName",     sp != null ? sp.getName()         : "알 수 없음");
            item.put("spaceAddress",  sp != null ? sp.getAddress()      : "");
            item.put("mainImageUrl",  sp != null ? sp.getMainImageUrl() : null);
            item.put("useDate",       r.getUseDate().toString());
            item.put("startTime",     r.getStartTime().toString());
            item.put("endTime",       r.getEndTime().toString());
            item.put("totalPrice",    r.getTotalPrice());
            item.put("status",        r.getStatus());
            items.add(item);
        }

        long upcomingCount = reservations.stream()
                .filter(r -> ("PENDING".equals(r.getStatus()) || "APPROVED".equals(r.getStatus()))
                          && !r.getUseDate().isBefore(today))
                .count();

        result.put("items",         items);
        result.put("upcomingCount", upcomingCount);
        return result;
    }

    // ---------------------------------------------------------------
    // GET /api/spaces/host/reservations — 호스트 예약 목록
    // ---------------------------------------------------------------
    @GetMapping("/host/reservations")
    public Map<String, Object> getHostReservations(HttpSession session) {
        Map<String, Object> result = new LinkedHashMap<>();

        Long hostId = (Long) session.getAttribute("loginUserId");
        if (hostId == null) {
            result.put("error", "로그인이 필요합니다.");
            return result;
        }

        List<SpaceReservation> reservations =
                reservationRepository.findByHostIdOrderByCreatedAtDesc(hostId);

        Map<Long, Space> spaceCache = new HashMap<>();
        Map<Long, User>  userCache  = new HashMap<>();
        List<Map<String, Object>> items = new ArrayList<>();

        LocalDate today = LocalDate.now();

        for (SpaceReservation r : reservations) {
            Space sp = spaceCache.computeIfAbsent(r.getSpaceId(),
                    id -> spaceRepository.findById(id).orElse(null));
            User  u  = userCache.computeIfAbsent(r.getUserId(),
                    id -> userRepository.findById(id).orElse(null));

            Map<String, Object> item = new LinkedHashMap<>();
            item.put("reservationId", r.getReservationId());
            item.put("spaceName",     sp != null ? sp.getName() : "알 수 없음");
            item.put("userName",      u  != null ? u.getName()  : "알 수 없음");
            item.put("userPhone",     u  != null ? u.getPhone() : "-");
            item.put("useDate",       r.getUseDate().toString());
            item.put("startTime",     r.getStartTime().toString());
            item.put("endTime",       r.getEndTime().toString());
            item.put("totalPrice",    r.getTotalPrice());
            item.put("status",        r.getStatus());
            item.put("userMemo",      r.getUserMemo());
            items.add(item);
        }

        long pendingCount  = reservationRepository.countByHostIdAndStatus(hostId, "PENDING");
        long approvedCount = reservations.stream()
                .filter(r -> "APPROVED".equals(r.getStatus())
                          && r.getUseDate().getYear()       == today.getYear()
                          && r.getUseDate().getMonthValue() == today.getMonthValue())
                .count();
        int monthRevenue = reservations.stream()
                .filter(r -> "APPROVED".equals(r.getStatus())
                          && r.getUseDate().getYear()       == today.getYear()
                          && r.getUseDate().getMonthValue() == today.getMonthValue())
                .mapToInt(SpaceReservation::getTotalPrice)
                .sum();

        result.put("items",         items);
        result.put("pendingCount",  pendingCount);
        result.put("approvedCount", approvedCount);
        result.put("monthRevenue",  monthRevenue);
        return result;
    }

    // ---------------------------------------------------------------
    // PATCH /api/spaces/reservations/{id}/status — 승인 / 거절 (호스트)
    // ---------------------------------------------------------------
    @PatchMapping("/reservations/{id}/status")
    public Map<String, Object> updateReservationStatus(
            @PathVariable("id")         Long reservationId,
            @RequestParam("status")     String newStatus,
            HttpSession session) {

        Map<String, Object> result = new LinkedHashMap<>();

        Long hostId = (Long) session.getAttribute("loginUserId");
        if (hostId == null) {
            result.put("error", "로그인이 필요합니다.");
            return result;
        }

        Optional<SpaceReservation> opt = reservationRepository.findById(reservationId);
        if (opt.isEmpty()) {
            result.put("error", "예약을 찾을 수 없습니다.");
            return result;
        }
        SpaceReservation reservation = opt.get();

        // 이 공간이 해당 호스트 소유인지 검증
        Space space = spaceRepository.findById(reservation.getSpaceId()).orElse(null);
        if (space == null || !hostId.equals(space.getHostId())) {
            result.put("error", "권한이 없습니다.");
            return result;
        }

        if (!"APPROVED".equals(newStatus) && !"REJECTED".equals(newStatus)) {
            result.put("error", "유효하지 않은 상태값입니다.");
            return result;
        }

        reservation.setStatus(newStatus);
        reservationRepository.save(reservation);

        result.put("success", true);
        result.put("status",  newStatus);
        return result;
    }

    // ---------------------------------------------------------------
    // POST /api/spaces/reservations/{id}/cancel — 예약 취소 (사용자 본인)
    // ---------------------------------------------------------------
    @PostMapping("/reservations/{id}/cancel")
    public Map<String, Object> cancelReservation(
            @PathVariable("id") Long reservationId,
            HttpSession session) {

        Map<String, Object> result = new LinkedHashMap<>();

        Long userId = (Long) session.getAttribute("loginUserId");
        if (userId == null) {
            result.put("error", "로그인이 필요합니다.");
            return result;
        }

        Optional<SpaceReservation> opt = reservationRepository.findById(reservationId);
        if (opt.isEmpty()) {
            result.put("error", "예약을 찾을 수 없습니다.");
            return result;
        }
        SpaceReservation reservation = opt.get();

        if (!userId.equals(reservation.getUserId())) {
            result.put("error", "본인의 예약만 취소할 수 있습니다.");
            return result;
        }

        if (!"PENDING".equals(reservation.getStatus()) && !"APPROVED".equals(reservation.getStatus())) {
            result.put("error", "대기 중이거나 확정된 예약만 취소할 수 있습니다.");
            return result;
        }

        reservation.setStatus("CANCELLED");
        reservationRepository.save(reservation);

        result.put("success", true);
        result.put("status",  "CANCELLED");
        return result;
    }
}
