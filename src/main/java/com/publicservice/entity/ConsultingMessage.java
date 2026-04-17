package com.publicservice.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;
import java.time.LocalDateTime;

@Entity
@Table(name = "consulting_messages")
@Getter
@Setter
public class ConsultingMessage {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long messageId;

    /** 어떤 자문요청의 채팅인지 */
    @Column(name = "request_id", nullable = false)
    private Long requestId;

    /** 보낸 사람의 userId */
    @Column(name = "sender_id", nullable = false)
    private Long senderId;

    /** "USER" 또는 "EXPERT" */
    @Column(name = "sender_role", nullable = false, length = 10)
    private String senderRole;

    @Column(nullable = false, columnDefinition = "TEXT")
    private String content;

    @Column(name = "created_at", nullable = false)
    private LocalDateTime createdAt;

    @PrePersist
    protected void onCreate() {
        this.createdAt = LocalDateTime.now();
    }
}
