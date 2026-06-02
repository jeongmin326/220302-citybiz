# PublicService_Internal_Assessment_v1.0_260602

---

## 문서 정보

| 항목 | 내용 |
| :--- | :--- |
| **프로젝트명** | PublicService — 소상공인·창업자 통합 공공서비스 플랫폼 |
| **문서 유형** | Internal Assessment (현황 분석서) |
| **버전** | v1.0 |
| **작성일** | 2026-06-02 |

---

## 1. 기존 비즈니스 프로세스 분석

### 1.1 AS-IS 프로세스 (현재 상태)

소상공인·창업자가 지원 자원에 접근하는 기존 흐름은 다음과 같이 단절되어 있다.

```
[창업자]
    │
    ├─ 정책자금 검색 ──→ 중소벤처기업부 사이트 / 소진공 / 진흥공단 (각각 별도 접속)
    │
    ├─ 전문가 탐색 ────→ 법률 포털 / 세무사 협회 / 지인 추천 (체계적 탐색 불가)
    │
    ├─ 공간 예약 ──────→ 각 지자체 창업지원센터 개별 문의
    │
    └─ 전문 상담 ──────→ 오프라인 방문 상담 (비용·시간 부담)
```

**핵심 문제점:**

| # | 문제 | 영향 |
| :--- | :--- | :--- |
| P-01 | 정보 분산 — 정책자금 정보가 다수 기관 사이트에 산재 | 탐색 시간 과다, 누락 발생 |
| P-02 | 전문가 접근성 낮음 — 비용·정보 부족으로 초기 창업자 접근 제한 | 법적·세무 리스크 증가 |
| P-03 | 공간-전문가 연계 없음 — 상담 공간과 전문가 정보가 별개 | 이용 불편 |
| P-04 | 비대면 컨설팅 인프라 부재 — 원격 상담 수요 증가에도 체계 없음 | 지방 창업자 소외 |

### 1.2 TO-BE 프로세스 (목표 상태)

```
[창업자]
    │
    └─ PublicService 단일 포털 접속
            │
            ├─ 정책자금 통합 검색 + 스크랩
            ├─ 지도 기반 전문가 탐색 + 채팅 상담 신청
            ├─ 공유공간 검색 + 온라인 예약
            └─ WebRTC 화상 컨설팅 (멤버십 플랜 기반)
```

---

## 2. 기존 시스템 구조 분석

### 2.1 기술 스택 현황

| 계층 | 기술 | 버전 | 비고 |
| :--- | :--- | :--- | :--- |
| **프레임워크** | Spring Boot | 3.5.13 | WAR 배포 방식 |
| **ORM** | Spring Data JPA / Hibernate | 6.6.45.Final | MySQL 방언 |
| **DB** | MySQL | 9.6.0 (connector) | 외부 MySQL 서버 |
| **뷰** | JSP + JSTL | Jakarta EE 6 | 서버 사이드 렌더링 |
| **보안** | Spring Security | 6.5.9 | 세션 기반 인증 |
| **실시간** | WebSocket + WebRTC | Spring WebSocket | 화상통화용 |
| **캐시** | Spring Cache (인메모리) | — | `CacheConfig` |
| **빌드** | Maven | Wrapper 포함 | WAR 패키징 |

### 2.2 레이어 구조

```
Presentation (JSP Views)
    ↓↑
Controller Layer (12개 Controller)
    ↓↑
Service Layer (4개 Service)
    ↓↑
Repository Layer (15개 JPA Repository)
    ↓↑
Entity / DAO Layer (15개 Entity + UserDAO)
    ↓↑
Database (MySQL)
```

**이원화 구조 주의:**
- `UserDAO.java` (레거시 DAO 방식)와 `UserRepository.java` (JPA 방식)가 혼용 → 향후 통일 필요

### 2.3 엔티티 구조 현황

| 도메인 | 엔티티 | 역할 |
| :--- | :--- | :--- |
| 회원 | `User` | 일반 사용자 |
| 전문가 (5종) | `Lawyer`, `TaxAccountant`, `Accountant`, `LaborAttorney`, `PatentAttorney` | 전문가 유형별 분리 |
| 컨설팅 | `ConsultingRequest`, `ConsultingMessage` | 상담 요청 및 메시지 |
| 공간 | `Space`, `SpaceImage`, `SpaceReservation` | 공간 정보·이미지·예약 |
| 정책 | `PolicyFund`, `PolicyScrap` | 정책자금 및 사용자 스크랩 |
| 결제/이력 | `PlanHistory`, `PointHistory` | 플랜 구독 및 포인트 내역 |

---

## 3. 사용자 기대 및 요청사항

| 사용자 유형 | 기대 기능 | 현재 구현 여부 |
| :--- | :--- | :--- |
| 창업자 | 정책자금 검색·스크랩 | ✅ 구현 (`PolicyFundController`) |
| 창업자 | 전문가 지도 검색 | ✅ 구현 (`ExpertMapController`) |
| 창업자 | 공간 예약 | ✅ 구현 (`SpaceController`) |
| 창업자 | 화상 상담 | ✅ 구현 (`VideoCallController`) |
| 전문가 | 프로필 등록 및 관리 | ✅ 구현 (`ExpertProfileController`) |
| 사용자 공통 | 포인트 충전 및 플랜 관리 | ✅ 구현 (`ChargeController`) |
| 사용자 공통 | ID/PW 찾기 | ✅ 구현 (findID.jsp, findPWD.jsp) |

---

## 4. 내부 데이터 연계 현황

| 연계 포인트 | 설명 |
| :--- | :--- |
| **User ↔ ConsultingRequest** | 사용자가 전문가에게 상담 요청 |
| **User ↔ SpaceReservation** | 사용자가 공간 예약 |
| **User ↔ PolicyScrap** | 사용자가 정책자금 스크랩 |
| **User ↔ PlanHistory / PointHistory** | 플랜 가입 및 포인트 이력 |
| **ConsultingRequest ↔ ConsultingMessage** | 상담 요청 하위 메시지 관리 |
| **Space ↔ SpaceImage** | 공간과 다중 이미지 연결 |
| **PlanCheckInterceptor** | 플랜 미가입 사용자의 유료 기능 접근 차단 |

---

## 5. 현황 분석 종합 및 개선 방향

| 항목 | 현황 | 개선 방향 |
| :--- | :--- | :--- |
| DAO/Repository 혼용 | `UserDAO` + `UserRepository` 이원화 | 단일 JPA Repository로 통합 |
| 예외 처리 | `ErrorPageController` 존재하나 범위 제한적 | 전역 `@ControllerAdvice` 적용 권장 |
| 캐시 전략 | 인메모리 단순 캐시 | 세션 클러스터링 시 Redis 도입 검토 |
| 결제 연동 | PortOne 키 미설정 | 운영 시 `application.properties`에 키 설정 필요 |
| 테스트 커버리지 | 단일 통합 테스트만 존재 | 도메인별 단위 테스트 보강 필요 |

---

*파일명 규칙: `{Project_Name}_{EN_Name}_vX.X_YYMMDD.md`*
*본 문서는 `PublicService_Internal_Assessment_v1.0_260602.md`로 저장한다.*
