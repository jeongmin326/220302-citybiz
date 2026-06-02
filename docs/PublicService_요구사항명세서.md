# PublicService_Requirement_Spec_v1.0_260602

---

## 문서 정보

| 항목 | 내용 |
| :--- | :--- |
| **프로젝트명** | PublicService — 소상공인·창업자 통합 공공서비스 플랫폼 |
| **문서 유형** | Requirement Spec (요구사항 명세서) |
| **버전** | v1.0 |
| **작성일** | 2026-06-02 |

---

## 1. 기능 요구사항 (Functional Requirements)

### 1.1 회원 관리 (User Management)

| ID | 요구사항 | 구현 소스 | 우선순위 |
| :--- | :--- | :--- | :--- |
| FR-US-01 | 이메일/비밀번호 기반 회원가입 | `UserController`, `signup.jsp` | 필수 |
| FR-US-02 | 로그인 / 로그아웃 (세션 기반) | `Spring Security`, `login.jsp` | 필수 |
| FR-US-03 | 아이디 찾기 (이름+연락처 기반) | `findID.jsp` | 필수 |
| FR-US-04 | 비밀번호 찾기 및 재설정 | `findPWD.jsp` | 필수 |
| FR-US-05 | 회원 프로필 조회 및 수정 | `UserProfileRequest`, `userProfile.jsp` | 필수 |
| FR-US-06 | 마이페이지 — 상담·예약·스크랩 현황 조회 | `status.jsp` | 필수 |

### 1.2 정책자금 (Policy Fund)

| ID | 요구사항 | 구현 소스 | 우선순위 |
| :--- | :--- | :--- | :--- |
| FR-PF-01 | 정책자금 목록 조회 (필터·검색) | `PolicyFundController`, `policy.jsp` | 필수 |
| FR-PF-02 | 정책자금 상세 조회 | `PolicyFund` Entity | 필수 |
| FR-PF-03 | 정책자금 스크랩(북마크) 등록/해제 | `PolicyScrap`, `PolicyScrapRepository` | 높음 |
| FR-PF-04 | 스크랩한 정책자금 목록 조회 | `UserController` 연동 | 높음 |

### 1.3 전문가 서비스 (Expert Service)

| ID | 요구사항 | 구현 소스 | 우선순위 |
| :--- | :--- | :--- | :--- |
| FR-EX-01 | 지도 기반 전문가 탐색 (5개 직군) | `ExpertMapController`, `expertMap.jsp` | 필수 |
| FR-EX-02 | 주소→좌표 변환 (지오코딩 프록시) | `GeocodingProxyController` | 필수 |
| FR-EX-03 | 전문가 프로필 상세 조회 | `ExpertProfileController`, `prof.jsp` | 필수 |
| FR-EX-04 | 전문가 프로필 등록/수정/삭제 | `ExpertProfileRequest`, `expertProfile.jsp` | 필수 |
| FR-EX-05 | 전문가 관리 (본인 프로필 목록) | `expertManagement.jsp` | 높음 |

### 1.4 컨설팅 (Consulting)

| ID | 요구사항 | 구현 소스 | 우선순위 |
| :--- | :--- | :--- | :--- |
| FR-CO-01 | 상담 요청 등록 | `ConsultingController`, `ConsultingRequest` | 필수 |
| FR-CO-02 | 상담 메시지 송수신 (채팅) | `ConsultantController`, `ConsultingMessage` | 필수 |
| FR-CO-03 | 상담 목록 및 상태 조회 | `consulting.jsp` | 필수 |

### 1.5 공유공간 (Space)

| ID | 요구사항 | 구현 소스 | 우선순위 |
| :--- | :--- | :--- | :--- |
| FR-SP-01 | 공간 목록 조회 및 검색 | `SpaceController`, `space.jsp` | 필수 |
| FR-SP-02 | 공간 상세 조회 (이미지 포함) | `SpaceImageController`, `SpaceImage` | 필수 |
| FR-SP-03 | 공간 예약 신청 | `SpaceReservation` | 필수 |
| FR-SP-04 | 공간 등록 | `spaceRegi.jsp` | 필수 |
| FR-SP-05 | 공간 수정/삭제 | `spaceEdit.jsp`, `spaceManagement.jsp` | 필수 |
| FR-SP-06 | 공간 이미지 업로드/삭제 | `SpaceImageService` | 높음 |

### 1.6 화상 통화 (Video Call)

| ID | 요구사항 | 구현 소스 | 우선순위 |
| :--- | :--- | :--- | :--- |
| FR-VC-01 | WebRTC 기반 1:1 화상 통화 개시 | `VideoCallController`, `webrtc-client.js` | 필수 |
| FR-VC-02 | 화상통화 세션 등록 및 관리 | `VideoCallSessionRegistry` | 필수 |
| FR-VC-03 | WebSocket 핸드셰이크 인증 | `VideoCallHandshakeInterceptor` | 필수 |
| FR-VC-04 | 화상통화 화면 (참가자 뷰) | `videoCall.jsp`, `videoCall2.jsp` | 필수 |

### 1.7 멤버십·포인트 (Charge / Plan)

| ID | 요구사항 | 구현 소스 | 우선순위 |
| :--- | :--- | :--- | :--- |
| FR-CH-01 | 멤버십 플랜 조회 및 구독 | `ChargeController`, `plan.jsp` | 필수 |
| FR-CH-02 | 포인트 충전 | `recharge.jsp` | 필수 |
| FR-CH-03 | 포인트 사용 내역 조회 | `PointHistory`, `pointHistory.jsp` | 높음 |
| FR-CH-04 | 플랜 미가입 시 유료 기능 접근 차단 | `PlanCheckInterceptor` | 필수 |
| FR-CH-05 | 플랜 가입 이력 관리 | `PlanHistory`, `PlanService` | 높음 |

---

## 2. 비기능 요구사항 (Non-Functional Requirements)

### 2.1 성능 (Performance)

| ID | 요구사항 | 기준 |
| :--- | :--- | :--- |
| NFR-PF-01 | 일반 페이지 응답 시간 | 평균 2초 이내 |
| NFR-PF-02 | 정책자금·전문가 검색 응답 | 3초 이내 |
| NFR-PF-03 | 화상통화 연결 지연 | 5초 이내 (네트워크 환경 의존) |
| NFR-PF-04 | DB 커넥션 풀 | HikariCP 기본값 사용 (최대 10개) |

### 2.2 보안 (Security)

| ID | 요구사항 | 구현 방법 |
| :--- | :--- | :--- |
| NFR-SE-01 | 비밀번호 암호화 저장 | Spring Security BCrypt |
| NFR-SE-02 | 인증되지 않은 사용자 접근 제한 | Spring Security FilterChain |
| NFR-SE-03 | 유료 기능 플랜 권한 체크 | `PlanCheckInterceptor` |
| NFR-SE-04 | WebSocket 연결 인증 | `VideoCallHandshakeInterceptor` |
| NFR-SE-05 | CSRF 보호 | Spring Security 기본 설정 |

### 2.3 가용성 (Availability)

| ID | 요구사항 | 기준 |
| :--- | :--- | :--- |
| NFR-AV-01 | 서비스 가동률 | 99% 이상 (운영 환경 기준) |
| NFR-AV-02 | 장애 복구 시간 | WAR 재배포 기준 5분 이내 |

### 2.4 유지보수성 (Maintainability)

| ID | 요구사항 | 기준 |
| :--- | :--- | :--- |
| NFR-MA-01 | 레이어 분리 (Controller-Service-Repository) | 현재 구조 유지 |
| NFR-MA-02 | 설계 문서와 코드 일치 | 변경 시 docs/ 문서 동시 업데이트 |
| NFR-MA-03 | Git 버전 관리 | `.gitignore`, `.gitattributes` 설정 완료 |

### 2.5 확장성 (Scalability)

| ID | 요구사항 | 비고 |
| :--- | :--- | :--- |
| NFR-SC-01 | 전문가 직군 추가 가능 구조 | 엔티티 추가로 확장 가능 |
| NFR-SC-02 | 캐시 전략 고도화 가능 | 현재 인메모리 → Redis 전환 가능 |

---

## 3. 요구사항 추적 매트릭스 (Traceability Matrix)

| 요구사항 ID | 요구사항 명 | Controller | Service | Repository | Entity | View |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| FR-US-01~06 | 회원 관리 | UserController | UserService | UserRepository | User | user/*.jsp |
| FR-PF-01~04 | 정책자금 | PolicyFundController | — | PolicyFundRepository, PolicyScrapRepository | PolicyFund, PolicyScrap | policy.jsp |
| FR-EX-01~05 | 전문가 서비스 | ExpertMapController, ExpertProfileController, GeocodingProxyController | ExpertMapService | 5개 Expert Repository | 5개 Expert Entity | expertMap.jsp, prof.jsp |
| FR-CO-01~03 | 컨설팅 | ConsultingController, ConsultantController | — | ConsultingRequestRepository, ConsultingMessageRepository | ConsultingRequest, ConsultingMessage | consulting.jsp |
| FR-SP-01~06 | 공유공간 | SpaceController, SpaceImageController | SpaceImageService | SpaceRepository, SpaceImageRepository, SpaceReservationRepository | Space, SpaceImage, SpaceReservation | space.jsp, mypage/space*.jsp |
| FR-VC-01~04 | 화상통화 | VideoCallController | — | — | — | videoCall*.jsp |
| FR-CH-01~05 | 멤버십·포인트 | ChargeController | PlanService | PlanHistoryRepository, PointHistoryRepository | PlanHistory, PointHistory | charge/*.jsp |

---

*파일명 규칙: `{Project_Name}_{EN_Name}_vX.X_YYMMDD.md`*
*본 문서는 `PublicService_Requirement_Spec_v1.0_260602.md`로 저장한다.*
