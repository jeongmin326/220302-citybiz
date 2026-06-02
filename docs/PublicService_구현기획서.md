# PublicService_Implementation_Plan_v1.0_260602

---

## 문서 정보

| 항목 | 내용 |
| :--- | :--- |
| **프로젝트명** | PublicService — 소상공인·창업자 통합 공공서비스 플랫폼 |
| **문서 유형** | Implementation Plan (구현 계획서) |
| **버전** | v1.0 |
| **작성일** | 2026-06-02 |
| **현재 상태** | 구현 완료 (Retrospective 문서) |

> **참고:** 본 문서는 구현 완료 후 작성된 회고형(Retrospective) 계획서로, 실제 개발 순서와 의존성을 역추적하여 기록한다.

---

## 1. 개발 로드맵 (Development Roadmap)

```
Phase 1: 기반 구축 (Foundation)
    ├── 프로젝트 초기화 (Spring Boot, Maven, 패키지 구조)
    ├── DB 연결 설정 (application.properties, MySQL)
    ├── 공통 설정 (WebConfig, CacheConfig, WebSocketConfig)
    └── 회원 관리 (User Entity, Repository, Controller, JSP)

Phase 2: 핵심 도메인 구현 (Core Domain)
    ├── 정책자금 (PolicyFund, PolicyScrap)
    ├── 전문가 5종 엔티티 및 Repository
    ├── 공유공간 (Space, SpaceImage, SpaceReservation)
    └── 멤버십·포인트 (PlanHistory, PointHistory, ChargeController)

Phase 3: 서비스 기능 구현 (Service Features)
    ├── 전문가 지도 (ExpertMapController, GeocodingProxyController)
    ├── 전문가 프로필 관리 (ExpertProfileController)
    ├── 컨설팅 요청·메시지 (ConsultingController, ConsultantController)
    └── 공간 이미지 업로드 (SpaceImageService, SpaceImageController)

Phase 4: 고급 기능 구현 (Advanced Features)
    ├── WebRTC 화상통화 (VideoCallController, SessionRegistry, webrtc-client.js)
    ├── 플랜 접근 제어 (PlanCheckInterceptor)
    └── 에러 페이지 처리 (ErrorPageController)

Phase 5: 통합 및 배포 (Integration & Deploy)
    ├── JSP 뷰 완성 (모든 화면)
    ├── 통합 테스트
    └── WAR 빌드 및 배포
```

---

## 2. 모듈별 개발 순서 및 의존성

### 2.1 레이어별 개발 순서 원칙

```
Entity 정의
    ↓
Repository 생성 (JPA)
    ↓
Service 구현 (비즈니스 로직)
    ↓
Controller 구현 (HTTP 매핑)
    ↓
JSP View 작성
```

### 2.2 모듈별 의존성 맵

| 모듈 | 선행 필요 모듈 | 비고 |
| :--- | :--- | :--- |
| User | — | 최초 독립 구현 |
| PolicyFund | User | 스크랩(PolicyScrap)이 User 참조 |
| Expert 5종 | User | 컨설팅 요청 시 User 참조 |
| Space | User | 예약(SpaceReservation)이 User 참조 |
| Consulting | User, Expert 5종 | 상담 요청이 전문가 참조 |
| Charge / Plan | User | 플랜·포인트가 User 참조 |
| VideoCall | User, Consulting | 화상통화는 상담 연계 |
| PlanCheckInterceptor | PlanHistory | 플랜 가입 여부 확인 |

### 2.3 구현 완료 현황

| 구분 | 파일 수 | 완료 여부 |
| :--- | :--- | :--- |
| Controller | 12개 | ✅ 완료 |
| Service | 4개 | ✅ 완료 |
| Repository | 15개 | ✅ 완료 |
| Entity | 15개 | ✅ 완료 |
| DTO | 5개 | ✅ 완료 |
| Config | 3개 | ✅ 완료 |
| Interceptor | 1개 | ✅ 완료 |
| WebRTC | 3개 | ✅ 완료 |
| JSP Views | 27개 | ✅ 완료 |
| WAR 빌드 | — | ✅ 완료 (`publicservice-0.0.1-SNAPSHOT.war`) |

---

## 3. 인력 및 자원 배분

| 역할 | 담당 영역 |
| :--- | :--- |
| 백엔드 개발 | Spring Boot, JPA, Security, WebSocket/WebRTC |
| 프론트엔드 개발 | JSP, CSS, JavaScript (webrtc-client.js) |
| DB 설계 | MySQL 스키마 설계 및 관리 |
| 형상 관리 | Git 브랜치 전략, 코드 리뷰 |

> 소규모 팀(2~4인) 기준 작성. 실제 인원에 따라 역할 겸임.

---

## 4. 의존성 관리 계획

### 4.1 Maven 의존성 관리

- **BOM 활용:** Spring Boot Parent POM을 통해 버전 충돌 방지
- **핵심 의존성 고정 버전:**

| 라이브러리 | 버전 | 관리 방식 |
| :--- | :--- | :--- |
| Spring Boot | 3.5.13 | Parent POM |
| Hibernate | 6.6.45.Final | Spring Boot BOM |
| MySQL Connector | 9.6.0 | 명시적 지정 |
| HikariCP | 6.3.3 | Spring Boot BOM |

### 4.2 외부 서비스 의존성

| 서비스 | 의존성 수준 | 대응 방안 |
| :--- | :--- | :--- |
| MySQL DB 서버 | 필수 | `application.properties` 환경별 분리 |
| 지오코딩 API | 기능 의존 | API 키 환경변수 관리, 장애 시 Fallback |
| PortOne PG | 결제 의존 | 테스트/운영 키 분리 관리 |
| STUN/TURN 서버 | WebRTC 의존 | 공개 STUN 사용 또는 자체 TURN 구축 |

---

## 5. 향후 개선 과제 (Backlog)

| 우선순위 | 과제 | 설명 |
| :--- | :--- | :--- |
| 높음 | UserDAO → UserRepository 통합 | 레거시 DAO 제거 |
| 높음 | 전역 예외 처리 | `@ControllerAdvice` 도입 |
| 중간 | 단위 테스트 확충 | 도메인별 JUnit 테스트 추가 |
| 중간 | PortOne 결제 실연동 | 운영 키 설정 및 결제 로직 검증 |
| 낮음 | Redis 캐시 전환 | 다중 인스턴스 환경 대비 |
| 낮음 | 반응형 UI 개선 | 모바일 사용성 향상 |

---

*파일명 규칙: `{Project_Name}_{EN_Name}_vX.X_YYMMDD.md`*
*본 문서는 `PublicService_Implementation_Plan_v1.0_260602.md`로 저장한다.*
