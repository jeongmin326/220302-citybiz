# PublicService — Function Map

| 항목 | 내용 |
| :--- | :--- |
| 산출물 | Function Map (기능 분해도) |
| 버전 | v1.0 |
| 작성일 | 2026-05-20 |

본 문서는 PublicService 시스템의 기능을 4단계(L1 도메인 → L2 기능군 → L3 단위 기능 → L4 원자 동작)로 분해한다. 각 원자 동작은 Controller/Service의 실제 메서드 또는 핸들러에 추적된다.

---

## 0. L1 도메인 개관

| ID | 도메인 | 핵심 책임 |
| :--- | :--- | :--- |
| **F1** | 회원/인증(Account) | 가입·로그인·아이디/비밀번호 찾기·세션 |
| **F2** | 마이페이지/프로필(Profile) | 일반/호스트/전문가 프로필 관리 |
| **F3** | 공간 공유(Space) | 등록·검색·예약·관리 |
| **F4** | 전문가 상담(Consulting) | 검색·자문요청·채팅·통화 |
| **F5** | 정책자금(Policy) | 검색·필터·스크랩 |
| **F6** | 결제/포인트(Charge) | 충전·플랜 구독·내역 |
| **F7** | 지도/위치(Map) | 전문가 지도, 지오코딩 |
| **F8** | 실시간/WebRTC(Realtime) | 시그널링·세션 관리 |
| **F9** | 공통/시스템(System) | 홈·검색·에러·정적 자원·캐시 |

---

## 1. F1 — 회원/인증

| ID | L2 | L3 단위 기능 | L4 원자 동작 (Endpoint / Handler) | 근거 |
| :--- | :--- | :--- | :--- | :--- |
| F1.1 | 회원가입 | 가입 폼 표시 | `GET /signup` → `user/signup` | `UserController` |
| F1.2 | 회원가입 | 가입 처리 | `POST /signup` (USER/PROVIDER/EXPERT) | `UserController#signup` |
| F1.3 | 회원가입 | 이메일 중복 검증 | `GET /check-email` → `{valid, exists}` | `UserController` |
| F1.4 | 회원가입 | 전화 중복 검증 | `GET /check-phone` → `{exists}` | `UserController` |
| F1.5 | 회원가입 | EXPERT 보조 레코드 생성 | EXPERT 선택 시 5개 전문가 테이블 중 1건 자동 생성 | `UserController#signup` |
| F1.6 | 회원가입 | PROVIDER 보조 레코드 생성 | PROVIDER 선택 시 draft `spaces` 1건 자동 생성 | `UserController#signup` |
| F1.7 | 로그인 | 로그인 폼 | `GET /login` | `UserController` |
| F1.8 | 로그인 | 로그인 처리 | `POST /login` (BCrypt 검증, 세션 적재, Remember-Me 쿠키) | `UserController#login` |
| F1.9 | 로그인 | 로그아웃 | `GET /logout` (세션 무효화) | `UserController` |
| F1.10 | 계정 찾기 | 아이디 찾기 폼 | `GET /findID` | `UserController` |
| F1.11 | 계정 찾기 | 아이디 조회 | `POST /findID` (name + phone) | `UserService#findEmailByNameAndPhone` |
| F1.12 | 계정 찾기 | 비밀번호 찾기 폼 | `GET /findPWD` | `UserController` |
| F1.13 | 계정 찾기 | 비밀번호 초기화 | `POST /findPWD` (email+name+phone → 기본값 `1234`) | `UserService#resetPassword` |

## 2. F2 — 마이페이지/프로필

| ID | L2 | L3 단위 기능 | L4 원자 동작 | 근거 |
| :--- | :--- | :--- | :--- | :--- |
| F2.1 | 마이페이지 | 사용자 메인 | `GET /mypage/status` (포인트·상태 카드) | `HomeController` |
| F2.2 | 사용자 프로필 | 프로필 페이지 | `GET /mypage/profile` | `HomeController` |
| F2.3 | 사용자 프로필 | 프로필 JSON 조회 | `GET /api/user/profile` | `UserController` |
| F2.4 | 사용자 프로필 | 프로필 수정 | `POST /api/user/profile` (주소·전화·업종 등) | `UserController` |
| F2.5 | 사용자 프로필 | 보유 포인트 조회 | `GET /api/user/my-info` → `{point}` | `UserController` |
| F2.6 | 호스트 관리 | 공간 등록 페이지 | `GET /mypage/spaceRegi` *(플랜 게이트)* | `HomeController` + `PlanCheckInterceptor` |
| F2.7 | 호스트 관리 | 공간 수정 페이지 | `GET /mypage/spaceEdit` *(플랜 게이트)* | 동상 |
| F2.8 | 호스트 관리 | 호스트 예약 관리 | `GET /mypage/spaceManagement` (월 매출 집계) | `HomeController` |
| F2.9 | 전문가 관리 | 전문가 프로필 페이지 | `GET /mypage/expertProfile` *(플랜 게이트)* | `HomeController` |
| F2.10 | 전문가 관리 | 전문가 프로필 저장 | `ExpertProfileController` (5개 타입 분기) | `ExpertProfileRequest` |
| F2.11 | 전문가 관리 | 자문요청 관리 | `GET /mypage/expertManagement` (월 매출 집계) | `HomeController` |

## 3. F3 — 공간 공유

| ID | L2 | L3 단위 기능 | L4 원자 동작 | 근거 |
| :--- | :--- | :--- | :--- | :--- |
| F3.1 | 공간 검색 | 공간 홈 | `GET /space` (Naver Maps clientId 전달) | `HomeController` |
| F3.2 | 공간 검색 | 공간 목록 조회 | `GET /api/spaces` (city/district/keyword/spaceTypes/priceRange/capacity) | `SpaceController` |
| F3.3 | 공간 검색 | 가용 시간 조회 | `GET /api/spaces/{id}/availability?date=YYYY-MM-DD` | `SpaceController` |
| F3.4 | 공간 등록 | 공간 신규 등록 | `POST /api/spaces` (호스트+플랜 필수, 이미지 첨부) | `SpaceController` |
| F3.5 | 공간 등록 | 공간 정보 수정 | `PUT /api/spaces/{id}` | `SpaceController` |
| F3.6 | 공간 이미지 | 이미지 업로드/조회 | `SpaceImageController` (캐시: `spaceImages`) | `SpaceImageController`, `CacheConfig` |
| F3.7 | 공간 예약 | 예약 신청 | `POST /api/spaces/{spaceId}/reserve` (hours × pricePerHour) | `SpaceController` |
| F3.8 | 공간 예약 | 내 예약 목록 | `GET /api/spaces/my/reservations` | `SpaceController` |
| F3.9 | 공간 예약 | 예약 취소 | `POST /api/spaces/reservations/{id}/cancel` | `SpaceController` |
| F3.10 | 호스트 예약 | 호스트 공간 목록 | `GET /api/spaces/host/spaces` | `SpaceController` |
| F3.11 | 호스트 예약 | 호스트 예약 목록 | `GET /api/spaces/host/reservations` | `SpaceController` |
| F3.12 | 호스트 예약 | 예약 승인/거절 | `PATCH /api/spaces/reservations/{id}/status` | `SpaceController` |

## 4. F4 — 전문가 상담

| ID | L2 | L3 단위 기능 | L4 원자 동작 | 근거 |
| :--- | :--- | :--- | :--- | :--- |
| F4.1 | 전문가 검색 | 컨설팅 홈 | `GET /consulting` | `HomeController` |
| F4.2 | 전문가 검색 | 전문가 목록 조회 | `GET /api/consultants` (type=ALL/PATENT/TAX/ACCOUNT/LABOR/LAWYER + district/keyword/rating/experienceYears/price) | `ConsultantController` |
| F4.3 | 자문요청 | 자문요청 신청 | `POST /api/consulting/requests` (포인트 차감, 시간 기준 가격) | `ConsultingController` |
| F4.4 | 자문요청 | 내 요청 목록 | `GET /api/consulting/my/requests` | 동상 |
| F4.5 | 자문요청 | 전문가 수신함 | `GET /api/consulting/expert/requests` (월 매출 집계) | 동상 |
| F4.6 | 자문요청 | 상태 변경(승인/거절/완료) | `PATCH /api/consulting/requests/{id}/status` | 동상 |
| F4.7 | 자문요청 | 요청 취소(PENDING) | `POST /api/consulting/requests/{id}/cancel` | 동상 |
| F4.8 | 채팅 | 메시지 목록 조회 | `GET /api/consulting/requests/{id}/messages` | 동상 |
| F4.9 | 채팅 | 메시지 전송 | `POST /api/consulting/requests/{id}/messages` | 동상 |
| F4.10 | 통화 운영 | 통화 시작 마크 | `POST /api/consulting/requests/{id}/start-call` (`callStartedAt`) | 동상 |
| F4.11 | 통화 운영 | 통화 종료 마크 | `POST /api/consulting/requests/{id}/end-call` (`callEndedAt`, COMPLETED) | 동상 |
| F4.12 | 통화 운영 | 시간 연장 결제 | `POST /api/consulting/requests/{id}/extend` | 동상 |
| F4.13 | 통화 운영 | 전문가 완료 처리 | `POST /api/consulting/requests/{id}/complete-call` | 동상 |

## 5. F5 — 정책자금

| ID | L2 | L3 단위 기능 | L4 원자 동작 | 근거 |
| :--- | :--- | :--- | :--- | :--- |
| F5.1 | 정책 검색 | 정책 홈 | `GET /policy` | `HomeController` |
| F5.2 | 정책 검색 | 목록 조회 | `GET /api/policies` (category/institution/applicationAvailableYn/keyword) | `PolicyFundController` |
| F5.3 | 스크랩 | 스크랩 토글 | `POST /api/policies/{id}/scrap` | 동상 |
| F5.4 | 스크랩 | 내 스크랩 | `GET /api/policies/my-scraps` | 동상 |

## 6. F6 — 결제/포인트

| ID | L2 | L3 단위 기능 | L4 원자 동작 | 근거 |
| :--- | :--- | :--- | :--- | :--- |
| F6.1 | 포인트 | 충전 페이지 | `GET /charge/recharge` | `ChargeController` |
| F6.2 | 포인트 | 충전 결제 검증 | `POST /charge/verify` (포트원 imp_uid 검증 + 보너스 1만↑=2%, 3만↑=3%, 5만↑=5%) | 동상 |
| F6.3 | 포인트 | 포인트 내역 | `GET /charge/pointHistory` | 동상 |
| F6.4 | 플랜 | 플랜 페이지 | `GET /charge/plan` (현재 플랜 표시) | 동상 |
| F6.5 | 플랜 | 플랜 결제 검증 | `POST /charge/verifyPlan` (MONTHLY 10만/30일, YEARLY 100만/365일) | `PlanService#activatePlan` |
| F6.6 | 플랜 | 활성 플랜 게이트 | `PlanCheckInterceptor` (`/mypage/spaceRegi`, `/spaceEdit`, `/expertProfile`) | `PlanCheckInterceptor` |

## 7. F7 — 지도/위치

| ID | L2 | L3 단위 기능 | L4 원자 동작 | 근거 |
| :--- | :--- | :--- | :--- | :--- |
| F7.1 | 지도 | 전문가 지도 페이지 | `GET /experts/map` | `ExpertMapController` |
| F7.2 | 지도 | 전문가 좌표 데이터 | `GET /experts/map/data` → `ExpertMapDto[]` | `ExpertMapService` |
| F7.3 | 지오코딩 | 좌표 변환 프록시 | `GeocodingProxyController` (Naver Geocoding 서버 사이드 호출) | `GeocodingProxyController` |

## 8. F8 — 실시간/WebRTC

| ID | L2 | L3 단위 기능 | L4 원자 동작 | 근거 |
| :--- | :--- | :--- | :--- | :--- |
| F8.1 | 입장 | 통화 페이지 진입 | `GET /video/call?requestId=` (참가자 검증, ACCEPTED만 허용) | `VideoCallController#videoCallPage` |
| F8.2 | 시그널링 | STOMP 엔드포인트 | `/ws` (SockJS, `VideoCallHandshakeInterceptor` 적용) | `WebSocketConfig` |
| F8.3 | 시그널링 | 통화 요청 | `@MessageMapping /app/video/{requestId}/signal` type=`CALL_REQUEST` → `tryInitiateCall()` | `VideoCallController#handleSignal` |
| F8.4 | 시그널링 | 통화 수락 | type=`CALL_ACCEPTED` → `acceptCall()` (RINGING→IN_CALL) | `VideoCallSessionRegistry` |
| F8.5 | 시그널링 | 통화 종료/거절 | type=`HANGUP` / `CALL_REJECTED` → `endCall()` | 동상 |
| F8.6 | 시그널링 | SDP/ICE 전파 | 외 모든 메시지는 `/topic/video/{requestId}` 브로드캐스트 | `@SendTo` |
| F8.7 | 세션 상태 | 활성 통화 조회 | `isCallActive(requestId)` | `VideoCallSessionRegistry` |

## 9. F9 — 공통/시스템

| ID | L2 | L3 단위 기능 | L4 원자 동작 | 근거 |
| :--- | :--- | :--- | :--- | :--- |
| F9.1 | 홈 | 홈 페이지 | `GET /main` | `HomeController` |
| F9.2 | 홈 | 소개 페이지 | `GET /about` | 동상 |
| F9.3 | 홈 | 사이트 가이드 | `GET /prof` | 동상 |
| F9.4 | 통합 검색 | 통합 검색 결과 | `GET /search` (정책+공간+컨설팅 결과 합산, 지역 필터) | 동상 |
| F9.5 | 에러 | 에러 페이지 | `ErrorPageController` → `error/error.jsp` | `ErrorPageController` |
| F9.6 | 정적 자원 | 공간 이미지 마운트 | `/img_space/**` → `file:///F:/publicservice/img_space/` | `WebConfig` |
| F9.7 | 캐시 | 공간 이미지 캐시 | Caffeine cache `spaceImages` (max=500, TTL=24h) | `CacheConfig` |

---

## 10. 추적성 매트릭스(요약)

| 도메인 | 컨트롤러 수 | 엔티티 수 | 외부 의존 |
| :--- | :---: | :---: | :--- |
| Account / Profile | 2 | 1 (User) | — |
| Space | 2 | 3 (Space, SpaceImage, SpaceReservation) | Naver Maps, Filesystem |
| Consulting | 2 | 7 (Request, Message, 5 expert types) | (옵션) STUN/TURN |
| Policy | 1 | 2 (PolicyFund, PolicyScrap) | — |
| Charge | 1 | 2 (PointHistory, PlanHistory) | PortOne |
| Map | 2 | (집계 뷰) | Naver Maps/Geocoding |
| Realtime | 1 + 1 SignalingHandler | — | (STUN/TURN) |
| System | 2 | — | — |

> 전체 14 엔티티는 `Data Design`, 전체 100여 개 엔드포인트의 상세 규격은 `Integration Spec`을 참조.
