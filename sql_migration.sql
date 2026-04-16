-- =====================================================
-- 예약 시스템 DB 마이그레이션
-- MySQL에서 순서대로 실행하세요
-- =====================================================

-- 1. spaces 테이블에 host_id 컬럼 추가 (기존 88개 공간이 있으므로 nullable)
ALTER TABLE spaces
    ADD COLUMN host_id bigint NULL COMMENT '공간 등록자(호스트) user_id' AFTER space_id,
    ADD KEY idx_spaces_host_id (host_id),
    ADD CONSTRAINT fk_spaces_host FOREIGN KEY (host_id) REFERENCES users(user_id) ON DELETE SET NULL;

-- 2. 공간 예약 테이블 생성
CREATE TABLE space_reservations (
    reservation_id  bigint       NOT NULL AUTO_INCREMENT COMMENT '예약 고유 ID',
    space_id        bigint       NOT NULL                COMMENT '예약된 공간 ID',
    user_id         bigint       NOT NULL                COMMENT '예약자(사용자) ID',
    use_date        date         NOT NULL                COMMENT '사용 날짜',
    start_time      time         NOT NULL                COMMENT '시작 시간',
    end_time        time         NOT NULL                COMMENT '종료 시간',
    total_price     int          NOT NULL                COMMENT '총 결제 금액',
    status          varchar(20)  NOT NULL DEFAULT 'PENDING' COMMENT '상태: PENDING / APPROVED / REJECTED / CANCELLED',
    user_memo       varchar(500) DEFAULT NULL            COMMENT '사용자 요청 메모',
    created_at      datetime     NOT NULL DEFAULT CURRENT_TIMESTAMP            COMMENT '예약 신청일시',
    updated_at      datetime     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '수정일시',
    PRIMARY KEY (reservation_id),
    KEY idx_res_space (space_id),
    KEY idx_res_user  (user_id),
    CONSTRAINT fk_res_space FOREIGN KEY (space_id) REFERENCES spaces(space_id) ON DELETE CASCADE,
    CONSTRAINT fk_res_user  FOREIGN KEY (user_id)  REFERENCES users(user_id)  ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='공간 예약 테이블';
