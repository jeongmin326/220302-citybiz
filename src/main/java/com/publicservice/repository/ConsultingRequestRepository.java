package com.publicservice.repository;

import com.publicservice.entity.ConsultingRequest;
import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;

public interface ConsultingRequestRepository extends JpaRepository<ConsultingRequest, Long> {

    /** 사용자가 보낸 자문요청 목록 (최신순) */
    List<ConsultingRequest> findByUserIdOrderByCreatedAtDesc(Long userId);

    /** 전문가가 받은 자문요청 목록 (최신순) */
    List<ConsultingRequest> findByExpertUserIdOrderByCreatedAtDesc(Long expertUserId);

    /** 전문가의 PENDING 건수 */
    long countByExpertUserIdAndStatus(Long expertUserId, String status);

    /** 중복 신청 방지 (같은 전문가에게 PENDING 상태 요청이 이미 있는지) */
    boolean existsByUserIdAndExpertIdAndExpertTypeAndStatus(
            Long userId, Long expertId, String expertType, String status);
}
