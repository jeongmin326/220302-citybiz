package com.publicservice.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;
import java.time.LocalDateTime;

@Entity
@Table(name = "consulting_requests")
@Getter
@Setter
public class ConsultingRequest {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long requestId;

    /** 자문을 받는 전문가 엔티티 ID (각 전문가 테이블의 PK) */
    @Column(name = "expert_id", nullable = false)
    private Long expertId;

    /** 전문가 유형: PATENT / TAX / ACCOUNT / LABOR / LAWYER */
    @Column(name = "expert_type", nullable = false, length = 20)
    private String expertType;

    /** 전문가의 users.user_id (빠른 조회용) */
    @Column(name = "expert_user_id")
    private Long expertUserId;

    /** 요청을 보낸 사용자 ID */
    @Column(name = "user_id", nullable = false)
    private Long userId;

    /** 자문 제목 */
    @Column(nullable = false, length = 200)
    private String title;

    /** 자문 상세 내용 */
    @Column(columnDefinition = "TEXT")
    private String content;

    /** PENDING / ACCEPTED / REJECTED / CANCELLED */
    @Column(nullable = false, length = 20)
    private String status;

    /** VIDEO / PHONE / CHAT / OFFLINE */
    @Column(name = "consultation_type", nullable = false, length = 20)
    private String consultationType = "CHAT";

    /** 상담 시간(초): 45 / 600(10분) / 1200(20분) */
    @Column(name = "duration_seconds", nullable = false)
    private Integer durationSeconds = 600;

    /** 세션 가격(원) */
    @Column(name = "session_price", nullable = false)
    private Integer sessionPrice = 0;

    /** 통화 시작 시각 */
    @Column(name = "call_started_at")
    private LocalDateTime callStartedAt;

    /** 통화 종료 시각 */
    @Column(name = "call_ended_at")
    private LocalDateTime callEndedAt;

    /** 연장 결제 누적액(원) */
    @Column(name = "extra_paid", nullable = false)
    private Integer extraPaid = 0;

    @Column(name = "created_at", nullable = false)
    private LocalDateTime createdAt;

    @Column(name = "updated_at", nullable = false)
    private LocalDateTime updatedAt;

    @PrePersist
    protected void onCreate() {
        this.createdAt = LocalDateTime.now();
        this.updatedAt = LocalDateTime.now();
        if (this.status == null) {
            this.status = "PENDING";
        }
    }

    @PreUpdate
    protected void onUpdate() {
        this.updatedAt = LocalDateTime.now();
    }
}
