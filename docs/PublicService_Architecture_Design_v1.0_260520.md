# PublicService — Architecture Design

| 항목 | 내용 |
| :--- | :--- |
| 프로젝트 | PublicService (CityBiz — 소상공인·창업자 통합 지원 플랫폼) |
| 산출물 | Architecture Design (시스템 아키텍처 설계서) |
| 버전 | v1.0 |
| 작성일 | 2026-05-20 |
| 근거 코드 | `pom.xml`, `src/main/java/com/publicservice/**`, `checkDB.txt` |

---

## 1. 시스템 개요

PublicService는 소상공인과 예비창업자를 대상으로 다음 세 가지 핵심 서비스를 제공하는 단일 모놀리식 웹 애플리케이션이다.

1. **공간 공유(SpaceLinking)** — 사무 공간 등록 / 검색 / 시간 단위 예약
2. **전문가 상담(ConsultingHub)** — 5개 직군(세무·회계·노무·법률·변리) 전문가 검색 / 자문요청 / 채팅 / WebRTC 영상통화
3. **정책자금 정보(PolicyHub)** — 정책자금 검색 / 스크랩

부가 기능으로 포인트(prepaid) 결제, 정기 플랜(MONTHLY/YEARLY) 구독, 지도(네이버 Maps) 기반 시각화를 포함한다.

## 2. 아키텍처 스타일

- **Layered Monolith (Spring Boot 3.5.13, Java 17, WAR 패키징)**
- **MVC + REST 혼합**: 페이지 렌더링은 JSP(Server-Side Rendering), 비동기 데이터 교환은 REST + JSON
- **실시간 채널**: STOMP over WebSocket(SockJS) + WebRTC P2P (시그널링만 서버 경유)
- **단일 데이터베이스**: MariaDB (스키마 `citybizdb`) — 모든 도메인을 동일 RDB에 격리

배포 단위는 하나의 WAR이며, 임베디드/외부 Tomcat 어느 쪽에도 배치 가능(`spring-boot-starter-tomcat` scope=provided + `ServletInitializer`).

## 3. 컴포넌트/컨테이너 위상 (Topology)

```
┌──────────────────────────────────────────────────────────────────┐
│                          Client Tier                              │
│  Browser (JSP-rendered HTML + Vanilla JS + SockJS/STOMP +         │
│           WebRTC API + Naver Maps JS SDK)                         │
└───────────────┬──────────────────────────────┬───────────────────┘
                │ HTTP/HTTPS                   │ wss:// (SockJS)
                │ + REST(JSON)                 │ STOMP frame
┌───────────────▼──────────────────────────────▼───────────────────┐
│                Application Tier — Spring Boot WAR                 │
│                                                                   │
│  [Controller Layer]                                               │
│   HomeController · UserController · SpaceController ·             │
│   ConsultingController · ConsultantController ·                   │
│   ExpertMapController · ExpertProfileController ·                 │
│   PolicyFundController · ChargeController ·                       │
│   SpaceImageController · GeocodingProxyController ·               │
│   ErrorPageController · VideoCallController (@MessageMapping)     │
│                                                                   │
│  [Service Layer]                                                  │
│   UserService · PlanService · ExpertMapService · SpaceImageService│
│                                                                   │
│  [Repository / DAO Layer]                                         │
│   Spring Data JPA Repositories(×14) + UserDAO(JdbcTemplate)       │
│                                                                   │
│  [Cross-cutting]                                                  │
│   WebConfig(Resource/Interceptor) · WebSocketConfig(STOMP) ·      │
│   CacheConfig(Caffeine, "spaceImages") ·                          │
│   PlanCheckInterceptor · VideoCallHandshakeInterceptor ·          │
│   VideoCallSessionRegistry(ConcurrentHashMap)                     │
└───────────────┬─────────────────────────────────┬─────────────────┘
                │ JDBC                            │ HTTPS
┌───────────────▼─────────────┐   ┌───────────────▼─────────────────┐
│   Data Tier — MariaDB       │   │   External Services             │
│   schema: citybizdb         │   │   - PortOne(아임포트) 결제 검증 │
│   15 tables                 │   │   - Naver Maps / Geocoding API  │
│                             │   │   - (선택) STUN/TURN for WebRTC │
└─────────────────────────────┘   └─────────────────────────────────┘

┌──────────────────────────────────────────────────────────────────┐
│  Filesystem Volume                                                │
│   F:\publicservice\img_space\  ← Space 이미지 정적 서빙          │
│   (`WebConfig#addResourceHandlers` → /img_space/**)               │
└──────────────────────────────────────────────────────────────────┘
```

### 3.1 컴포넌트 책임

| 컴포넌트 | 책임 | 핵심 클래스 |
| :--- | :--- | :--- |
| **Web Controllers** | HTTP 요청 라우팅, 세션 검증, 뷰/JSON 응답 | `controller/*Controller.java` |
| **WebRTC Signaling** | STOMP 시그널 라우팅 및 통화 세션 상태 관리 | `webrtc/VideoCallController`, `VideoCallSessionRegistry` |
| **Service Layer** | 도메인 비즈니스 로직, 트랜잭션 경계 | `service/*Service.java` |
| **Repositories** | 영속성 추상화 (Spring Data JPA) | `repository/*Repository.java` |
| **Interceptors** | 플랜 검증(`PlanCheckInterceptor`), 웹소켓 인증(`VideoCallHandshakeInterceptor`) | `interceptor/`, `webrtc/` |
| **Cache** | 공간 이미지 인메모리 캐시 | `CacheConfig` (Caffeine, max 500, TTL 24h) |
| **Static Mount** | 디스크 이미지 정적 매핑 | `WebConfig#addResourceHandlers` |

## 4. 인프라 구성

| 계층 | 기술 / 사양 | 비고 |
| :--- | :--- | :--- |
| 런타임 | Java 17 | `pom.xml` `<java.version>17</java.version>` |
| 프레임워크 | Spring Boot 3.5.13 | starter-web, starter-data-jpa, starter-websocket, starter-actuator, starter-cache |
| 패키징 | WAR | `<packaging>war</packaging>` + `ServletInitializer extends SpringBootServletInitializer` |
| 서블릿 컨테이너 | Tomcat (embed 또는 external) | `spring-boot-starter-tomcat` scope=provided |
| 뷰 엔진 | JSP + JSTL (Jakarta) | `tomcat-embed-jasper`, `jakarta.servlet.jsp.jstl-api` |
| DB | MariaDB (`mariadb-java-client 3.5.8`) | 스키마 `citybizdb` |
| ORM | Hibernate (Spring Data JPA) | 엔티티 14종 |
| 캐시 | Caffeine | `spaceImages` 캐시 한 종 |
| 메시징 | STOMP Simple Broker (`/topic`, `/queue`) | `WebSocketConfig` — 외부 브로커 미사용 |
| 보안 | Spring Security Crypto only (BCrypt) | full `spring-security` 미도입; 인증은 `HttpSession` 기반 |
| 개발지원 | `spring-boot-devtools`, Lombok | runtime/dev only |
| 정적 파일 | 로컬 디스크 `F:\publicservice\img_space\` | URL prefix `/img_space/**` |

## 5. 분산 처리 / 동시성 전략

| 영역 | 전략 |
| :--- | :--- |
| HTTP 요청 | Tomcat NIO 스레드 풀 (기본값) — 무상태 컨트롤러 |
| WebSocket 세션 | STOMP Simple Broker (in-memory) — **단일 인스턴스 가정** |
| 통화 세션 상태 | `VideoCallSessionRegistry`의 `ConcurrentHashMap<Long, CallSession>` — 동일 JVM 내 race condition만 방어 |
| HTTP 세션 | 컨테이너 기본 sticky session (스케일아웃 시 외부 세션 저장소 필요) |
| 캐시 | Caffeine local cache — 인스턴스별 독립 |

> **확장성 메모**: 현재 구성은 1-노드 가정. 스케일아웃 시 (a) HTTP 세션 외부화(Redis), (b) STOMP Broker 외부화(RabbitMQ/ActiveMQ), (c) `VideoCallSessionRegistry` 분산화(Redis Pub/Sub)가 필요 — 자세한 트레이드오프는 `Decision Records` 참조.

## 6. 보안 전략

| 위협 | 통제 | 구현 위치 |
| :--- | :--- | :--- |
| 자격증명 노출 | BCrypt 해시 저장 | `users.password_hash` (`spring-security-crypto`) |
| 인증 | `HttpSession` 기반, 로그인 후 `loginUser`/`loginRole`/`loginUserId` 세션 속성 설정 | `UserController#login` |
| 인가 (구독 게이트) | 호스트/전문가의 등록·수정 페이지 진입 시 활성 플랜 검증 | `PlanCheckInterceptor` (경로: `/mypage/spaceRegi`, `/mypage/spaceEdit`, `/mypage/expertProfile`) |
| WebSocket 인가 | 핸드셰이크 단계에서 `HttpSession.loginUserId`를 STOMP 세션 속성으로 승격 | `VideoCallHandshakeInterceptor` |
| 통화 무단 접속 | 통화 페이지 진입 시 요청의 `userId == req.userId || req.expertUserId` 검증 | `VideoCallController#videoCallPage` |
| 결제 검증 | 클라이언트 금액 신뢰 금지 — 포트원 `imp_uid`로 서버 사이드 재검증 | `ChargeController#verify`, `#verifyPlan` |
| 정적 자원 격리 | 업로드 디렉터리(`F:\publicservice\img_space\`)만 URL 매핑 | `WebConfig#addResourceHandlers` |
| 입력 검증 | 이메일/전화 중복 체크 엔드포인트로 사전 차단 | `/check-email`, `/check-phone` |

> **현재 미적용 / 향후 과제**: CSRF 토큰(Spring Security 미도입), HTTPS 강제(서버 단 설정), 휴대폰 본인인증(피드백 항목 #3), Rate Limiting, Content-Security-Policy.

## 7. 외부 의존성 (Boundary)

| 외부 시스템 | 사용 목적 | 결합도 |
| :--- | :--- | :--- |
| 포트원(아임포트) | 결제 모듈/검증 | 서버: `ChargeController#verify*` — `imp_uid` 검증 콜아웃 |
| Naver Maps | 지도, 좌표 시각화, Geocoding | 클라이언트 JS + `GeocodingProxyController`(서버 프록시) |
| (선택) STUN/TURN | WebRTC NAT 트래버설 | 클라이언트 JS 설정 |

## 8. 비기능 요구 매핑

| 비기능 항목 | 충족 메커니즘 |
| :--- | :--- |
| 응답성 | Caffeine 캐시(`spaceImages`), JPA 페이지네이션, 정적 자원 분리 |
| 가용성 | WAR 단일 배포 / Actuator(`spring-boot-starter-actuator`) 헬스 체크 노출 |
| 추적성 | `Requirement Spec`의 기능 ID ↔ Controller 메서드 ↔ Service 메서드 1:1 매핑 (Function Map 참조) |
| 보존성 | `created_at` / `updated_at`을 모든 도메인 테이블에 표준 부여 |
| 확장성(코드) | 5개 전문가 직군의 동일한 컬럼 구조 — `ExpertDto.from()` 컨버터로 통합 노출 |

---

## 9. 변경 이력

| 버전 | 일자 | 작성자 | 변경 내용 |
| :--- | :--- | :--- | :--- |
| v1.0 | 2026-05-20 | AI Agent | 현 소스 기준 초기 작성 |
