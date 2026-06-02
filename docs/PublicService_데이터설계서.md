# PublicService — Data Design

| 항목 | 내용 |
| :--- | :--- |
| 산출물 | Data Design (데이터 설계서) |
| 버전 | v1.0 |
| 작성일 | 2026-05-20 |
| 대상 DBMS | MariaDB (스키마: `citybizdb`) |
| 근거 | `checkDB.txt`, `src/main/java/com/publicservice/entity/*` |

---

## 1. 논리 데이터 모델 (ERD 요약)

```
users ─┬──< spaces (host_id)              ─< space_images
       │                                  ─< space_reservations
       ├──< tax_accountants    ─┐
       ├──< accountants        ─┤
       ├──< labor_attorneys    ─┼─< consulting_requests ─< consulting_messages
       ├──< lawyers            ─┤
       ├──< patent_attorneys   ─┘
       ├──< policy_scraps >──── policy_funds
       ├──< point_history
       └──< plan_history

district_centers (독립 마스터, 시/구 좌표)
```

> `consulting_requests`는 5개 전문가 테이블 중 하나를 `expert_type` + `expert_id`로 가리킨다(다형성). DB-level FK는 부여되지 않으며 애플리케이션 레벨에서 보장.

## 2. 도메인 그룹

| 그룹 | 테이블 |
| :--- | :--- |
| 계정 | `users` |
| 공간 | `spaces`, `space_images`, `space_reservations` |
| 전문가 마스터 | `tax_accountants`, `accountants`, `labor_attorneys`, `lawyers`, `patent_attorneys` |
| 상담 | `consulting_requests`, `consulting_messages` |
| 정책 | `policy_funds`, `policy_scraps` |
| 결제/플랜 | `point_history`, `plan_history` |
| 마스터 | `district_centers` |

---

## 3. 물리 스키마 명세

### 3.1 `users` — 사용자 계정

| 컬럼 | 타입 | NULL | 기본 | 설명 |
| :--- | :--- | :---: | :--- | :--- |
| `user_id` | BIGINT (PK, AI) | N | — | 사용자 고유 ID |
| `email` | VARCHAR(255) UNIQUE | N | — | 로그인 이메일 |
| `password_hash` | VARCHAR(255) | N | — | BCrypt 해시 |
| `name`, `phone` UNIQUE, `role` | VARCHAR(255) | Y | — | 이름, 전화, 역할(USER/PROVIDER/EXPERT) |
| `business_stage`, `status` | VARCHAR(255) | Y | — | 사업 단계 / 상태 |
| `company_name`, `biz_no`, `industry` | VARCHAR(255) | Y | — | 사업자 정보 |
| `city`, `district`, `road_address`, `detail_address` | VARCHAR(255) | Y | — | 주소 (엔티티에서 사용; DB 스크립트엔 부분 누락—마이그레이션 시 확인) |
| `point` | BIGINT | Y | 0 | 보유 포인트 (엔티티 기준) |
| `plan_type`, `plan_expires_at` | VARCHAR/DATETIME | Y | — | 구독 플랜 |
| `created_at`, `updated_at` | DATETIME | N | CURRENT_TIMESTAMP | 감사 컬럼 |

**제약**: UNIQUE(`email`), UNIQUE(`phone`).

### 3.2 `spaces` — 공간

| 컬럼 | 타입 | 비고 |
| :--- | :--- | :--- |
| `space_id` | BIGINT PK AI | |
| `host_id` | BIGINT | FK → `users.user_id` (ON DELETE SET NULL) |
| `name`, `space_type`, `description`, `main_image_url`, `available_yn` | VARCHAR(255) | |
| `price_per_hour`, `capacity` | INT NOT NULL | |
| `latitude`, `longitude` | DECIMAL(10,7) | |
| `city`, `district`, `road_address` | VARCHAR(255) | |
| `detail_address` | VARCHAR(100) | |
| `addr` | VARCHAR(255) **GENERATED ALWAYS AS** | `city+district+road+detail` 결합 (STORED) |
| `created_at`, `updated_at` | DATETIME | |

**인덱스**: `idx_spaces_host_id(host_id)`.

### 3.3 `space_images` — 공간 이미지

| 컬럼 | 타입 | 비고 |
| :--- | :--- | :--- |
| `image_id` | BIGINT PK AI | |
| `space_id` | BIGINT NOT NULL | FK → `spaces` (ON DELETE CASCADE) |
| `file_name`, `content_type` | VARCHAR(255) | |
| `image_data` | LONGBLOB NOT NULL | 이미지 바이너리(서버 캐싱 대상) |
| `is_main` | VARCHAR(1) NOT NULL | Y/N |
| `sort_order` | INT NOT NULL DEFAULT 0 | |
| `created_at` | DATETIME | |

> 디스크 저장소(`F:\publicservice\img_space\`)와 BLOB이 병행 운영됨 — `Decision Records` ADR-004 참조.

### 3.4 `space_reservations` — 공간 예약

| 컬럼 | 타입 | 비고 |
| :--- | :--- | :--- |
| `reservation_id` | BIGINT PK AI | |
| `space_id`, `user_id` | BIGINT NOT NULL | 각각 FK → spaces, users (CASCADE) |
| `use_date` | DATE NOT NULL | |
| `start_time`, `end_time` | TIME NOT NULL | |
| `total_price` | INT NOT NULL | hours × `spaces.price_per_hour` |
| `status` | VARCHAR(255) NOT NULL | PENDING/APPROVED/REJECTED/CANCELLED |
| `user_memo` | VARCHAR(255) | |
| `created_at`, `updated_at` | DATETIME | |

**인덱스**: `idx_res_space`, `idx_res_user`.

### 3.5 전문가 마스터 5종 (`tax_accountants`, `accountants`, `labor_attorneys`, `lawyers`, `patent_attorneys`)

5개 테이블이 **동일 컬럼 구조**를 갖는다(이름·필드만 다름).

| 컬럼 | 타입 | 비고 |
| :--- | :--- | :--- |
| `id` | BIGINT PK AI | |
| `user_id` | BIGINT | users.user_id (FK 미부여, 애플리케이션 보장) |
| `name`, `office`, `phone`, `field`, `consult_time` | VARCHAR(255) | |
| `rating` | DECIMAL(38,2) | |
| `experience_years` | INT NOT NULL DEFAULT 0 | |
| `price` | INT NOT NULL DEFAULT 0 | 상담 가격(만원) ※엔티티 단계에서는 통화 방식별 가격 필드(`price_call`/`price_video`/`price_chat`)가 추가 운영 |
| `city`, `district`, `road_address`, `detail_address` | VARCHAR | |
| `addr` | VARCHAR(255) GENERATED | spaces와 동일 패턴 |
| `latitude`, `longitude` | DECIMAL(10,7) | |
| `created_at`, `updated_at` | DATETIME | |

> 통합 조회는 `ExpertDto.from()` 컨버터가 5개 결과를 동형(homogeneous) DTO로 변환한다.

### 3.6 `consulting_requests` — 자문요청

| 컬럼 | 타입 | 비고 |
| :--- | :--- | :--- |
| `request_id` | BIGINT PK AI | |
| `user_id` | BIGINT NOT NULL | 신청자 |
| `expert_id` | BIGINT NOT NULL | 전문가 마스터 PK |
| `expert_type` | VARCHAR(20) NOT NULL | TAX/ACCOUNT/LABOR/LAWYER/PATENT |
| `expert_user_id` | BIGINT | 전문가의 `users.user_id` (선택) |
| `title` | VARCHAR(200) NOT NULL | |
| `content` | TEXT | |
| `status` | VARCHAR(20) NOT NULL | PENDING/ACCEPTED/REJECTED/CANCELLED/COMPLETED |
| `consultation_type`* | VARCHAR | VIDEO/PHONE/CHAT/OFFLINE (엔티티 기준) |
| `duration_seconds`, `session_price`* | INT/BIGINT | 상담 길이/가격 |
| `call_started_at`, `call_ended_at`* | DATETIME | 통화 타임스탬프 |
| `extra_paid`, `remaining_seconds`* | INT | 연장 결제 / 잔여 |
| `call_initiated`* | BOOL | 통화 진행 중 플래그 |
| `created_at`, `updated_at` | DATETIME(6) NOT NULL | |

\* `checkDB.txt` 시점 이후 엔티티 코드에서 추가됨 → 마이그레이션 산출물(`Deployment Spec`)에 반영 필요.

### 3.7 `consulting_messages` — 채팅 메시지

| 컬럼 | 타입 | 비고 |
| :--- | :--- | :--- |
| `message_id` | BIGINT PK AI | |
| `request_id` | BIGINT NOT NULL | consulting_requests FK (애플리케이션 보장) |
| `sender_id` | BIGINT NOT NULL | users.user_id |
| `sender_role` | VARCHAR(10) NOT NULL | USER / EXPERT |
| `content` | TEXT NOT NULL | |
| `created_at` | DATETIME(6) NOT NULL | |

### 3.8 `policy_funds` — 정책자금

| 컬럼 | 타입 | 비고 |
| :--- | :--- | :--- |
| `id` | INT PK AI | |
| `category` | VARCHAR(20) NOT NULL | 융자/보증/보험 |
| `fund_name` | VARCHAR(100) NOT NULL | |
| `support_target` | VARCHAR(500) NOT NULL | |
| `business_description` | TEXT NOT NULL | |
| `institution` | VARCHAR(100) NOT NULL | |
| `hashtags` | VARCHAR(255) | |
| `registered_date` | DATE NOT NULL | |
| `application_available_yn` | CHAR(1) NOT NULL DEFAULT 'Y' | Y/N |
| `detail_url`* | VARCHAR | (엔티티 기준 추가) |
| `created_at`, `updated_at` | DATETIME | |

### 3.9 `policy_scraps`

| 컬럼 | 타입 | 비고 |
| :--- | :--- | :--- |
| `id` | BIGINT PK AI | |
| `user_id` | BIGINT NOT NULL | FK users (CASCADE) |
| `policy_fund_id` | INT NOT NULL | FK policy_funds (CASCADE) |
| `created_at` | DATETIME NOT NULL | |

**제약**: UNIQUE(`user_id`,`policy_fund_id`).

### 3.10 `point_history`

| 컬럼 | 타입 | 비고 |
| :--- | :--- | :--- |
| `id` | BIGINT PK AI | |
| `user_id` | BIGINT NOT NULL | |
| `amount` | BIGINT NOT NULL | 양수: 충전, 음수: 사용 |
| `type` | VARCHAR | CHARGE / USE |
| `description` | VARCHAR | 거래 메모 |
| `imp_uid` | VARCHAR | 포트원 결제 ID(충전 시) |
| `created_at` | DATETIME | |

### 3.11 `plan_history`

| 컬럼 | 타입 | 비고 |
| :--- | :--- | :--- |
| `id` | BIGINT PK AI | |
| `user_id` | BIGINT NOT NULL | |
| `plan_type` | VARCHAR | MONTHLY / YEARLY |
| `amount` | INT | 결제 금액 |
| `imp_uid`, `merchant_uid` | VARCHAR | 포트원 키 |
| `starts_at`, `expires_at` | DATETIME | |
| `created_at` | DATETIME | |

### 3.12 `district_centers` — 구별 기준 좌표

| 컬럼 | 타입 | 비고 |
| :--- | :--- | :--- |
| `id` | INT PK AI | |
| `city`, `district` | VARCHAR(30) NOT NULL | UNIQUE(city, district) |
| `center_name`, `center_address` | VARCHAR | |
| `center_latitude`, `center_longitude` | DECIMAL(10,7) NOT NULL | |
| `created_at`, `updated_at` | DATETIME | |

---

## 4. 데이터 정책 및 제약

| 정책 | 내용 |
| :--- | :--- |
| **인코딩** | `utf8mb4` 기본 |
| **시간 컬럼** | 모든 도메인 테이블에 `created_at`/`updated_at` 표준 부여(ON UPDATE CURRENT_TIMESTAMP) |
| **삭제 정책** | 사용자 ↔ 공간: `ON DELETE SET NULL` (호스트 탈퇴 시 공간 유지); 공간 ↔ 이미지/예약: `CASCADE`; 정책 스크랩: `CASCADE` |
| **다형성(전문가 ↔ 상담)** | DB FK 미부여; `expert_type + expert_id`로 애플리케이션 결합 |
| **금액 단위** | 포인트는 원(₩), 전문가 price는 만원(만 단위) — 컨버전 시 주의 |
| **좌표 정밀도** | `DECIMAL(10,7)` (위경도 cm 단위) |
| **GENERATED 컬럼** | `spaces.addr` 및 모든 전문가 테이블의 `addr` (STORED) — 갱신은 trigger 없이 컬럼 변경 시 자동 |
| **인덱스 권장 추가** | `consulting_requests(user_id)`, `consulting_requests(expert_user_id, status)`, `point_history(user_id, created_at DESC)` |

## 5. 데이터 보존 / 개인정보

| 항목 | 정책 |
| :--- | :--- |
| 비밀번호 | BCrypt 단방향 해시만 저장 |
| 전화번호 | UNIQUE 제약(`uq_users_phone`); 향후 본인인증 모듈 도입 시 분리 저장 권고 |
| 결제 식별자(`imp_uid`) | 포트원 영수 기간 한도 내 보존; 회원 탈퇴 시 의무 보존 데이터는 별도 anonymized 테이블로 분리 권고 |
| 이미지(BLOB) | DB 보관 + 디스크(`F:\publicservice\img_space\`) 병행 — 일관성 정책 ADR-004 참조 |

## 6. 변경 이력

| 버전 | 일자 | 변경 |
| :--- | :--- | :--- |
| v1.0 | 2026-05-20 | 현 스키마 + 엔티티 코드 기준 초기 작성. `consulting_requests`의 통화 운영 컬럼(`consultation_type`, `duration_seconds`, `call_*`)이 엔티티엔 존재하나 `checkDB.txt`엔 없어 별도 마이그레이션 확인 필요(★). |
