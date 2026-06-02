# PublicService_Project_Charter_v1.0_260602

---

## 문서 정보

| 항목 | 내용 |
| :--- | :--- |
| **프로젝트명** | PublicService — 소상공인·창업자 통합 공공서비스 플랫폼 |
| **문서 유형** | Project Charter (프로젝트 기획서) |
| **버전** | v1.0 |
| **작성일** | 2026-06-02 |
| **참조 방법론** | AI소프트웨어 개발방법론 (Samsung SDS Innovator 기반) |

---

## 1. 프로젝트 승인 정보 (Project Approval)

| 항목 | 내용 |
| :--- | :--- |
| **프로젝트 코드명** | `publicservice` |
| **패키지 기반** | `com.publicservice` |
| **빌드 산출물** | `publicservice-0.0.1-SNAPSHOT.war` |
| **기술 스택** | Spring Boot 3.5 / Spring MVC / Spring Data JPA / Spring Security |
| **DB** | MySQL (mysql-connector-j 9.6.0) |
| **뷰 기술** | JSP + JSTL |
| **실시간 통신** | WebSocket / WebRTC |
| **프로젝트 상태** | 구현 완료 (WAR 빌드 완료 확인) |

---

## 2. 비즈니스 요구사항 (BRD: Business Requirements Document)

### 2.1 배경 및 문제 정의

소상공인 및 창업자는 다음과 같은 어려움에 직면해 있다.

- **정보 단절:** 정부 정책자금, 전문가(변호사·세무사·노무사 등) 정보가 여러 기관에 분산되어 있어 한 곳에서 탐색 불가
- **접근성 부족:** 창업 초기 비용 문제로 전문 컨설팅 접근이 제한적
- **공간 연계 부재:** 창업 공간(사무실·회의실) 정보와 전문가 매칭이 별개로 운영됨
- **비대면 한계:** 원격 상담 수요가 높으나 화상 상담 인프라가 미흡

### 2.2 비즈니스 목표

| # | 목표 | 측정 지표 |
| :--- | :--- | :--- |
| BR-01 | 소상공인·창업자 대상 통합 공공서비스 포털 구축 | 핵심 기능 5개 이상 통합 제공 |
| BR-02 | 정부 정책자금 정보 원스톱 검색 제공 | 정책자금(PolicyFund) 검색 및 스크랩 기능 |
| BR-03 | 전문가(법률·세무·노무·특허·회계) 매칭 서비스 제공 | 지도 기반 전문가 탐색 + 채팅 상담 |
| BR-04 | 공유공간 예약 서비스 제공 | 공간 등록·예약·관리 기능 |
| BR-05 | 화상 컨설팅 서비스 제공 | WebRTC 기반 1:1 실시간 화상 상담 |
| BR-06 | 멤버십 플랜 기반 수익 모델 구축 | 플랜 구독 + 포인트 충전 기능 |

### 2.3 이해관계자 (Stakeholders)

| 구분 | 역할 |
| :--- | :--- |
| **일반 사용자 (창업자·소상공인)** | 정책자금 검색, 공간 예약, 전문가 상담 신청 |
| **전문가 (Expert)** | 프로필 등록, 상담 요청 수락, 화상 미팅 진행 |
| **공간 제공자** | 공간 등록, 예약 관리 |
| **플랫폼 운영자** | 회원·플랜·포인트 관리, 콘텐츠 운영 |

---

## 3. 시스템 범위 (SS: System Scope)

### 3.1 범위 내 (In-Scope)

| 모듈 | 주요 기능 | 핵심 소스 |
| :--- | :--- | :--- |
| **회원 관리** | 회원가입, 로그인, 프로필 관리, ID/PW 찾기 | `UserController`, `UserService`, `User` |
| **정책자금** | 정책자금 목록 조회, 상세 보기, 스크랩 | `PolicyFundController`, `PolicyFund`, `PolicyScrap` |
| **전문가 지도** | 지도 기반 전문가 탐색, 지오코딩 프록시 | `ExpertMapController`, `GeocodingProxyController` |
| **전문가 프로필** | 전문가 5종 등록/관리 (변호사·세무사·노무사·특허사·회계사) | `ExpertProfileController`, 5개 Entity |
| **컨설팅** | 상담 요청, 메시지 교환 | `ConsultingController`, `ConsultantController` |
| **공간** | 공간 등록·수정·예약, 이미지 관리 | `SpaceController`, `SpaceImageController` |
| **화상 통화** | WebRTC 기반 실시간 영상 상담 | `VideoCallController`, `webrtc-client.js` |
| **멤버십·포인트** | 플랜 구독, 포인트 충전/내역 조회 | `ChargeController`, `PlanService` |

### 3.2 범위 외 (Out-of-Scope)

- 모바일 앱 (Android / iOS) — 웹 반응형으로 대체
- 결제 PG 실연동 (PortOne 키 미설정 상태, 테스트 모드)
- 관리자(Admin) 전용 백오피스 페이지

### 3.3 가정 및 제약

| 구분 | 내용 |
| :--- | :--- |
| **가정** | 배포 서버는 Tomcat WAR 배포 환경 또는 내장 Tomcat 사용 |
| **가정** | 지오코딩은 외부 API(Kakao/Naver 등) 프록시 방식 사용 |
| **제약** | Spring Security 세션 기반 인증 (JWT 미적용) |
| **제약** | JSP 뷰로 인해 SPA 방식 불가, 서버 사이드 렌더링 |
| **제약** | 캐시는 Spring Cache + 인메모리 방식 (`CacheConfig`) |

---

## 4. 프로젝트 구성 요약

```
publicservice/
├── src/main/java/com/publicservice/
│   ├── controller/     (12개 — HTTP 요청 처리)
│   ├── service/        (4개 — 비즈니스 로직)
│   ├── repository/     (15개 — JPA Repository)
│   ├── entity/         (15개 — DB 매핑 엔티티)
│   ├── dto/            (5개 — 데이터 전송 객체)
│   ├── dao/            (1개 — 레거시 DAO)
│   ├── config/         (3개 — Web/Cache/WebSocket 설정)
│   ├── interceptor/    (1개 — 플랜 체크)
│   └── webrtc/         (3개 — 화상통화 세션 관리)
├── src/main/webapp/WEB-INF/views/
│   ├── home/           (메인·정책·공간·지도·컨설팅 등 8개 JSP)
│   ├── mypage/         (마이페이지 6개 JSP)
│   ├── user/           (회원 관련 4개 JSP)
│   ├── charge/         (결제·포인트 3개 JSP)
│   └── video/          (화상통화 2개 JSP)
└── docs/               (설계 문서 7종)
```

---

*파일명 규칙: `{Project_Name}_{EN_Name}_vX.X_YYMMDD.md`*
*본 문서는 `PublicService_Project_Charter_v1.0_260602.md`로 저장한다.*
