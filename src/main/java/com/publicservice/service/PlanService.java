package com.publicservice.service;

import com.publicservice.entity.PlanHistory;
import com.publicservice.entity.User;
import com.publicservice.repository.PlanHistoryRepository;
import com.publicservice.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.Optional;

@Service
public class PlanService {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private PlanHistoryRepository planHistoryRepository;

    public boolean hasActivePlan(Long userId) {
        Optional<User> userOpt = userRepository.findById(userId);
        if (userOpt.isEmpty()) {
            return false;
        }
        User user = userOpt.get();
        return !"FREE".equals(user.getPlanType())
                && user.getPlanExpiresAt() != null
                && user.getPlanExpiresAt().isAfter(LocalDateTime.now());
    }

    @Transactional
    public void activatePlan(Long userId, String planType, String impUid, String merchantUid, Integer amount) {
        Optional<User> userOpt = userRepository.findById(userId);
        if (userOpt.isEmpty()) {
            throw new IllegalArgumentException("사용자를 찾을 수 없습니다.");
        }

        User user = userOpt.get();

        LocalDateTime startedAt = LocalDateTime.now();
        LocalDateTime expiresAt;

        // 기존 플랜이 동일한 타입이면 연장, 다른 타입이면 새로 시작
        boolean isSamePlanType = planType.equals(user.getPlanType());

        if ("MONTHLY".equals(planType)) {
            if (isSamePlanType && user.getPlanExpiresAt() != null && user.getPlanExpiresAt().isAfter(LocalDateTime.now())) {
                // 기존 월간 플랜 연장
                expiresAt = user.getPlanExpiresAt().plusDays(30);
            } else {
                // 새 월간 플랜 시작 또는 다른 플랜에서 전환
                expiresAt = startedAt.plusDays(30);
            }
        } else if ("YEARLY".equals(planType)) {
            if (isSamePlanType && user.getPlanExpiresAt() != null && user.getPlanExpiresAt().isAfter(LocalDateTime.now())) {
                // 기존 연간 플랜 연장
                expiresAt = user.getPlanExpiresAt().plusDays(365);
            } else {
                // 새 연간 플랜 시작 또는 다른 플랜에서 전환
                expiresAt = startedAt.plusDays(365);
            }
        } else {
            throw new IllegalArgumentException("올바르지 않은 플랜 타입입니다.");
        }

        user.setPlanType(planType);
        user.setPlanExpiresAt(expiresAt);
        userRepository.save(user);

        PlanHistory history = new PlanHistory();
        history.setUserId(userId);
        history.setPlanType(planType);
        history.setAmount(amount);
        history.setImpUid(impUid);
        history.setMerchantUid(merchantUid);
        history.setStartedAt(startedAt);
        history.setExpiresAt(expiresAt);
        planHistoryRepository.save(history);
    }
}
