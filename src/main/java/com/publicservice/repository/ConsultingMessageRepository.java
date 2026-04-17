package com.publicservice.repository;

import com.publicservice.entity.ConsultingMessage;
import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;

public interface ConsultingMessageRepository extends JpaRepository<ConsultingMessage, Long> {

    /** 특정 자문요청의 메시지 전체 (시간순) */
    List<ConsultingMessage> findByRequestIdOrderByCreatedAtAsc(Long requestId);
}
