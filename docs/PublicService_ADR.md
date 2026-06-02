# PublicService — Architecture Decision Records (ADR)

| 항목 | 내용 |
| :--- | :--- |
| 산출물 | Decision Records (아키텍처 결정 기록) |
| 버전 | v1.0 |
| 작성일 | 2026-05-20 |
| 형식 | Nygard ADR (Context / Decision / Consequences) |

본 문서는 현재 코드에서 관찰되는 구조적 선택의 의도와 배경, 그리고 검토된 대안을 기록한다. 새로운 의사결정은 신규 ADR로 추가(append-only)하고, 기존 결정은 `Superseded by ADR-NNN`으로 표기한다.

---

## ADR-001 · Layered Monolith on Spring Boot WAR

**Status**: Accepted

**Context**
- 학교 프로젝트 수준의 개발 인원(2~3명)과 기능 범위(공간/컨설팅/정책/결제/실시간 통화)를 동시에 충족해야 한다.
- 단일 RDB와 단일 JVM에서 모든 트랜잭션을 관리하면 운영 복잡도가 가장 낮다.

**Decision**
Spring Boot 3.5.13 + Java 17 + JSP/JSTL + Spring Data JPA를 사용하는 **Layered Monolith**를 채택. 패키징은 `war`로, 내장 Tomcat과 외부 Tomcat 양쪽에 배치할 수 있도록 `ServletInitializer`를 둔다.

**Consequences**
- (+) 빠른 개발/디버깅, 단순한 배포 모델.
- (+) 단일 트랜잭션 경계 — 결제·포인트·요청 일관성 보장 용이.
- (−) 스케일아웃 시 세션/캐시/시그널링이 모두 인스턴스 로컬 → 분산 전환 비용 발생(ADR-007 참조).

**Alternatives Considered**
- Spring + Thymeleaf: 학습 곡선은 낮지만 기존 인력의 JSP 익숙도를 우선.
- 마이크로서비스 분리: 인원·운영 비용 대비 과도.

---

## ADR-002 · 인증을 Spring Security 전체 도입 대신 HttpSession 기반으로 처리

**Status**: Accepted, 2026 후반 재검토 예정

**Context**
- 로그인 화면, 세션 유지, 로그아웃, 권한 분기(USER/PROVIDER/EXPERT)만 필요.
- Spring Security 전체 도입 시 CSRF/AuthorizationFilter/UserDetailsService 등 구성 비용이 크다.

**Decision**
- 자격증명 검증은 `spring-security-crypto`의 BCryptPasswordEncoder만 사용.
- 인증 상태는 `HttpSession`의 `loginUser*`, `loginRole` 속성으로 보관.
- 인가는 `PlanCheckInterceptor`로 자원 등록 페이지에만 적용.

**Consequences**
- (+) 구현 단순, 학습/검토 비용 낮음.
- (−) CSRF 토큰·세션 고정·Brute-force 방어 등이 누락됨.
- (−) 다중 인스턴스/SSO 확장 시 재설계 필요.

**Mitigation/Future Work**
- 폼 제출 라우트에 CSRF 토큰 도입.
- 로그인 실패 카운터/IP 제한 (Bucket4j 등).
- Spring Security 단계적 도입 — 우선 필터 체인만 추가하고 `formLogin` 위임.

---

## ADR-003 · 전문가 도메인을 단일 테이블 상속 대신 5개 도메인별 테이블로 분리

**Status**: Accepted

**Context**
- 도메인 모델상 5개 직군(세무·회계·노무·법률·변리)이 공통 컬럼 95%를 공유하면서, 라이선스 식별자나 분야 정의가 다를 수 있다.
- JPA Single Table 상속은 NULL 컬럼 증가, Joined 상속은 조인 비용을 가진다.

**Decision**
물리적으로 분리된 5개 테이블(`tax_accountants`, `accountants`, `labor_attorneys`, `lawyers`, `patent_attorneys`)을 사용하고, 통합 노출은 DTO 레이어의 `ExpertDto.from()` 컨버터로 처리.

**Consequences**
- (+) 테이블별 인덱스 최적화 자유, 도메인 진화 시 schema migration 격리.
- (+) 직군별 통계/매출 산출이 단순.
- (−) 직군 추가 시 테이블 신설과 모든 검색 코드의 union 분기 필요.
- (−) `consulting_requests`가 `expert_type + expert_id`로 다형성을 가진다(`PolicyHub`와 달리 FK 미부여).

**Alternatives Considered**
- Single Table 상속(`experts` + discriminator).
- 노드형 EAV. (검색 효율 문제로 기각.)

---

## ADR-004 · 공간 이미지: DB BLOB + 디스크 마운트 병행

**Status**: Tentative (재검토 필요)

**Context**
- `space_images.image_data LONGBLOB` 컬럼이 존재(테이블 INSERT 사용 중).
- 동시에 `WebConfig#addResourceHandlers`로 `/img_space/**` → `file:///F:/publicservice/img_space/`가 마운트되어 있다.

**Decision (현재)**
신규 업로드는 디스크에 저장하고 URL을 `spaces.main_image_url`에 기록. 기존 BLOB 데이터는 마이그레이션이 끝날 때까지 폴백 경로로 유지. `Caffeine` 캐시 `spaceImages`로 자주 조회되는 이미지를 메모리 캐시(maxSize=500, TTL=24h).

**Consequences**
- (+) 이미지 응답을 정적 자원으로 위임 → 애플리케이션 스레드 절약.
- (−) 두 저장소 간 일관성을 사람이 보장해야 함.
- (−) 디스크 경로가 `F:\publicservice\img_space\`로 윈도우 의존 — 컨테이너/Linux 배포 시 외부 볼륨 매핑 필요.

**Mitigation/Future Work**
- 단일화 결정 후 마이그레이션 ADR-005로 분리하여 종결.
- 디스크 경로를 환경변수(`app.storage.space-images.dir`)로 외부화.

---

## ADR-005 · 결제 검증은 항상 서버 사이드(포트원 콜아웃)에서 금액을 재산출

**Status**: Accepted

**Context**
- 포인트 충전(`/charge/verify`)과 플랜 구독(`/charge/verifyPlan`)에서 결제 금액·식별자가 클라이언트로부터 전달된다.
- 클라이언트 페이로드를 신뢰하면 위·변조 시 부당 적립이 가능하다.

**Decision**
- 항상 `imp_uid`만 신뢰 입력으로 받고, 서버가 PortOne `getPaymentByImpUid`를 호출해 `payment.amount`/`payment.status="paid"`를 검증.
- 포인트 보너스 비율(10000↑ 2%, 30000↑ 3%, 50000↑ 5%)은 서버 상수.
- 플랜 금액(MONTHLY 100,000 / YEARLY 1,000,000)도 서버 상수.

**Consequences**
- (+) 위·변조 차단, 회계 일관성.
- (−) PortOne 가용성에 의존(장애 시 검증 실패 → 충전 보류).

---

## ADR-006 · 실시간 통신: STOMP Simple Broker + WebRTC P2P

**Status**: Accepted

**Context**
- 1:1 영상통화만 필요(다자간 미고려). 시그널 트래픽은 통화당 수십~수백 메시지.
- 미디어는 P2P(혹은 TURN 릴레이)로 처리하여 서버 부담 최소화.

**Decision**
- Spring `EnableWebSocketMessageBroker` + Simple Broker(`/topic`, `/queue`).
- 클라이언트는 SockJS 폴백을 갖춘 `/ws` 엔드포인트에 연결.
- 통화 상태(`RINGING`/`IN_CALL`)는 `VideoCallSessionRegistry`의 `ConcurrentHashMap`로 관리.
- 인증 정보는 `VideoCallHandshakeInterceptor`가 핸드셰이크 시 `HttpSession.loginUserId`를 STOMP 세션 속성으로 승격.

**Consequences**
- (+) 외부 메시지 브로커 미필요 — 인프라 단순.
- (+) 단일 인스턴스에서 통화 중복 방지(`tryInitiateCall`의 `containsKey` 가드).
- (−) **단일 인스턴스 가정** — 스케일아웃 시 시그널링이 인스턴스 간 라우팅되지 않는다.

**Future Work** (ADR-007 참조)
- RabbitMQ/ActiveMQ Relay 전환 + `VideoCallSessionRegistry`를 Redis 기반으로 외부화.

---

## ADR-007 · 스케일아웃 대비 — 외부화 후보 명세

**Status**: Proposed (필요 시점에 결정)

**Context**
- 동시 사용자 1,000명 이하에서는 모놀리스 단일 인스턴스로 충분.
- 그 이상 또는 24/7 가용성 요구 시 다음 컴포넌트가 병목/단일 장애 지점이 된다.

**Decision (계획)**
| 후보 | 외부화 방안 | 트리거 |
| :--- | :--- | :--- |
| `HttpSession` | Spring Session + Redis | LB 도입 + 다중 인스턴스 |
| STOMP Broker | RabbitMQ Relay (`enableStompBrokerRelay`) | 통화 동시성 ≥ 30 |
| `VideoCallSessionRegistry` | Redis 키 `call:{requestId}` + Pub/Sub | STOMP 외부화와 동시 |
| Caffeine `spaceImages` | Redis or CDN | 디스크 마운트 단일화 이후 |

**Consequences**
- (+) 운영 비용을 단계적으로 증액.
- (−) 트리거 이전엔 단일 인스턴스 가정이 깨지면 안 됨.

---

## ADR-008 · 데이터 모델: 주소 컬럼은 분해 저장 + GENERATED `addr` 컬럼

**Status**: Accepted

**Context**
- 검색은 `city`/`district` 단위, 표시는 전체 문자열로 일관되게 필요.

**Decision**
- 모든 위치 보유 테이블(`spaces`, 5개 전문가 테이블)에 `city/district/road_address/detail_address` 분해 저장.
- `addr` 컬럼을 `GENERATED ALWAYS AS (… STORED)`로 부여하여 표시용 통합 문자열을 즉시 사용.

**Consequences**
- (+) 검색·통계 일관성 + 표시용 가독성을 동시에 확보.
- (+) Trigger 불필요 — DB가 자동 갱신.
- (−) DBMS 의존(MariaDB/MySQL 한정).

---

## ADR-009 · 활성 플랜 게이트는 인터셉터 레벨에서 강제

**Status**: Accepted

**Context**
- 호스트/전문가가 정보 등록 페이지에 접근하려면 활성 플랜(`MONTHLY`/`YEARLY`)이 필요하다는 비즈니스 요구.
- 컨트롤러마다 중복 체크 코드 작성 시 누락 위험.

**Decision**
`PlanCheckInterceptor`를 `/mypage/spaceRegi`, `/mypage/spaceEdit`, `/mypage/expertProfile`에 적용. USER 역할은 통과, 그 외는 `planType ≠ FREE && planExpiresAt > now()`만 통과.

**Consequences**
- (+) 단일 게이트, 누락 없음.
- (+) 정책 변경 시 한 곳만 수정.
- (−) 게이트되는 경로 목록은 코드 상수 — 신규 보호 라우트 추가 시 함께 갱신해야 함.

---

## ADR-010 · 산출물 명명/포맷 — `{Project}_{EN_Name}_vX.X_YYMMDD.md`

**Status**: Accepted

**Context**
- 본 방법론(`개발방법론__AIsw.md`)은 산출물의 추적성과 가독성을 강제하기 위해 명명 규칙을 정의한다.

**Decision**
- 모든 설계/이행 산출물을 `{Project_Name}_{EN_Name}_vX.X_YYMMDD.md` (예: `PublicService_Integration_Spec_v1.0_260520.md`)로 저장.
- 본문은 Markdown, 표·코드블록 사용.
- 변경은 새 버전 번호로 append-only.

**Consequences**
- (+) AI 에이전트가 산출물 검색·교차참조 시 일관된 키를 얻는다.
- (+) 인간 리뷰가 용이.
- (−) 동시 편집 시 충돌 가능 — Git 기반 머지로 해결.

---

## ADR-011 · 임시 비밀번호 정책 (1234) — 단기적 한계, 본인인증 모듈로 교체 예정

**Status**: Tentative

**Context**
- 현재 `POST /findPWD`는 본인 정보(email+name+phone) 일치 시 비밀번호를 `"1234"`로 초기화한다.
- 발표/시연 단계에서는 운영 단순성을 우선했으나 보안상 부적절.

**Decision**
- 운영 전환 전 OTP(이메일·SMS) 기반 재설정 토큰 흐름으로 대체.
- 동시 작업: 회원가입 단계의 휴대폰 인증(피드백 항목 #3)도 함께 도입.

**Consequences**
- (−) 현재 상태에서는 사회공학 공격에 취약. 시연 외 운영 금지.
- (+) 본인인증 모듈 도입 시 양 경로를 일관 흐름으로 통합.

---

## 부록 A · ADR 인덱스

| ID | 제목 | 상태 |
| :--- | :--- | :--- |
| 001 | Layered Monolith on Spring Boot WAR | Accepted |
| 002 | HttpSession 기반 인증 | Accepted |
| 003 | 전문가 도메인 5개 분리 테이블 | Accepted |
| 004 | 이미지 저장: BLOB + 디스크 병행 | Tentative |
| 005 | 결제 서버 사이드 검증 | Accepted |
| 006 | STOMP Simple Broker + WebRTC | Accepted |
| 007 | 스케일아웃 외부화 계획 | Proposed |
| 008 | 주소 분해 + GENERATED `addr` | Accepted |
| 009 | 활성 플랜 인터셉터 게이트 | Accepted |
| 010 | 산출물 명명/포맷 | Accepted |
| 011 | 임시 비밀번호 1234 → 인증 모듈 | Tentative |

## 부록 B · 변경 이력

| 버전 | 일자 | 변경 |
| :--- | :--- | :--- |
| v1.0 | 2026-05-20 | 11건 초기 ADR 등재 |
