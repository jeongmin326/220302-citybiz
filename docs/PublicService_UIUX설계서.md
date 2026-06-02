# PublicService — Interface Layout (UI/UX Design)

| 항목 | 내용 |
| :--- | :--- |
| 산출물 | Interface Layout (UI/UX 설계서) |
| 버전 | v1.0 |
| 작성일 | 2026-05-20 |
| 근거 뷰 | `src/main/webapp/WEB-INF/views/**/*.jsp` |

---

## 1. 화면 인벤토리

| 영역 | 화면 ID | 뷰 파일 | 진입 경로 | 주된 사용자 |
| :--- | :--- | :--- | :--- | :--- |
| Layout | UI-L1 | `common/header.jsp` | (include) | 모두 |
| Layout | UI-L2 | `common/footer.jsp` | (include) | 모두 |
| Home | UI-H1 | `home/main.jsp` | `/main` | 모두 |
| Home | UI-H2 | `home/about.jsp` | `/about` | 모두 |
| Home | UI-H3 | `home/prof.jsp` | `/prof` | 모두 |
| Home | UI-H4 | `home/search.jsp` | `/search` | 모두 |
| Service | UI-S1 | `home/space.jsp` | `/space` | 사용자 |
| Service | UI-S2 | `home/consulting.jsp` | `/consulting` | 사용자 |
| Service | UI-S3 | `home/policy.jsp` | `/policy` | 사용자 |
| Service | UI-S4 | `home/expertMap.jsp` | `/experts/map` | 사용자 |
| Auth | UI-A1 | `user/login.jsp` | `/login` | 비로그인 |
| Auth | UI-A2 | `user/signup.jsp` | `/signup` | 비로그인 |
| Auth | UI-A3 | `user/findID.jsp` | `/findID` | 비로그인 |
| Auth | UI-A4 | `user/findPWD.jsp` | `/findPWD` | 비로그인 |
| MyPage | UI-M1 | `mypage/status.jsp` | `/mypage/status` | 로그인 |
| MyPage | UI-M2 | `mypage/userProfile.jsp` | `/mypage/profile` | 로그인 |
| MyPage | UI-M3 | `mypage/spaceRegi.jsp` | `/mypage/spaceRegi` | PROVIDER + 활성 플랜 |
| MyPage | UI-M4 | `mypage/spaceEdit.jsp` | `/mypage/spaceEdit` | PROVIDER + 활성 플랜 |
| MyPage | UI-M5 | `mypage/spaceManagement.jsp` | `/mypage/spaceManagement` | PROVIDER |
| MyPage | UI-M6 | `mypage/expertProfile.jsp` | `/mypage/expertProfile` | EXPERT + 활성 플랜 |
| MyPage | UI-M7 | `mypage/expertManagement.jsp` | `/mypage/expertManagement` | EXPERT |
| Charge | UI-C1 | `charge/plan.jsp` | `/charge/plan` | 호스트/전문가 |
| Charge | UI-C2 | `charge/recharge.jsp` | `/charge/recharge` | 로그인 |
| Charge | UI-C3 | `charge/pointHistory.jsp` | `/charge/pointHistory` | 로그인 |
| Video | UI-V1 | `video/videoCall.jsp` | `/video/call?requestId=` | 신청자/전문가 |
| Video | UI-V2 | `video/videoCall2.jsp` | (대안 레이아웃) | — |
| Error | UI-E1 | `error/error.jsp` | (forward) | 모두 |

## 2. 공통 레이아웃 (UI-L1 / UI-L2)

```
┌─ HEADER (sticky) ─────────────────────────────────────────────┐
│  [LOGO]  공간  컨설팅  정책자금  지도   |  검색바  | 로그인/MY │
└───────────────────────────────────────────────────────────────┘
│ <main content area>                                            │
┌─ FOOTER ──────────────────────────────────────────────────────┐
│  서비스 소개 · 이용약관 · 사업자 정보 · 고객문의                │
└───────────────────────────────────────────────────────────────┘
```

- 로그인 상태에 따라 우측 영역 토글: `로그인/회원가입` ↔ `MY · 로그아웃`
- 모바일: 햄버거 메뉴, 우측 검색 아이콘만 노출

## 3. 핵심 화면 와이어프레임

### 3.1 UI-H1 홈(`home/main.jsp`)

```
┌──────────────── HERO ──────────────────┐
│  소상공인, 다음 한 걸음을 같이.        │
│   [공간 찾기] [전문가 상담] [정책자금] │
└────────────────────────────────────────┘
┌────────── 빠른 통합검색 ──────────────┐
│ [지역 ▾] [키워드 입력 .............] 🔍│
└────────────────────────────────────────┘
┌──── 추천 공간(가로 스크롤 카드) ──────┐
┌──── 인기 전문가 카드 그리드 ──────────┐
┌──── 신규 정책자금 리스트 (3건) ───────┐
```

### 3.2 UI-H4 통합 검색(`home/search.jsp`)

피드백 #6 반영: 상단 4-탭 클릭 → 해당 결과 섹션으로 부드럽게 스크롤 + “맨 위로” FAB.

```
┌─ Tabs(가로) [공간][컨설팅][정책][전문가지도] ─┐
│   필터: 지역 ▾ / 키워드                        │
├─ 공간 결과 (카드 그리드, 6개씩) ──────────────┤
├─ 컨설팅 결과 (카드 그리드) ───────────────────┤
├─ 정책자금 결과 (리스트) ──────────────────────┤
└─ 우하단: ↑ 맨 위로 FAB ───────────────────────┘
```

### 3.3 UI-S1 공간(`home/space.jsp`)

```
┌── 좌측 필터(Sticky) ──┬── 지도 ─────────────┐
│ 지역(시/구)           │  Naver Map           │
│ 공간 유형(다중)       │  핀(공간 위치)       │
│ 가격대 슬라이더       │                      │
│ 수용 인원             │                      │
│ 키워드                │                      │
├───────────────────────┴──────────────────────┤
│  공간 카드 그리드(이미지 / 가격 / 평점 / 위치)│
│  └ 카드 클릭 → 상세 모달(예약 시간 선택)      │
└──────────────────────────────────────────────┘
```

- **예약 모달**: 날짜 → `GET /api/spaces/{id}/availability` → 가능 시간 그리드 → 시간 다중 선택 → 합계 자동계산 → `POST /api/spaces/{spaceId}/reserve`

### 3.4 UI-S2 컨설팅(`home/consulting.jsp`)

```
┌── 전문가 유형 탭 [전체|세무|회계|노무|변호사|변리사] ──┐
│ 필터: 지역, 평점, 경력, 가격                            │
├── 전문가 카드(사진/소속/평점/가격/거리) 그리드 ────────┤
│  └ 카드 → 상세 → [자문 요청] 버튼                       │
│                                                          │
│  [자문 요청 모달]                                        │
│   ├ 제목 / 내용                                          │
│   ├ 상담 방식: ◉영상 ○전화 ○채팅 ○대면                 │
│   ├ 시간: [30분 ▾] (자동 가격 표시)                     │
│   └ [포인트 차감 후 신청]                                │
└──────────────────────────────────────────────────────────┘
```

### 3.5 UI-V1 영상통화(`video/videoCall.jsp`)

```
┌─────────── 상대방 영상(상단 90%) ────────────┐
│  [상대 이름·소속·직종 라벨]                  │
│  잔여 시간 ⏱ 14:32                           │
│  ┌──── 내 영상(우하단 PIP) ───┐              │
│  │                            │              │
│  └────────────────────────────┘              │
├──────────── 컨트롤 바 ────────────────────────┤
│   🎤 음소거  📷 카메라   ➕ 시간 연장  🔴 종료 │
└───────────────────────────────────────────────┘
```

- 시그널링: SockJS `/ws` 연결 → `/topic/video/{requestId}` 구독 → 메시지 type별 SDP/ICE/CONTROL 처리
- 잔여 시간 만료 임박 시 “⚠️ 1분 남음, 연장하시겠습니까?” 토스트

### 3.6 UI-C1 플랜(`charge/plan.jsp`)

```
┌─ 현재 플랜 카드 ──────────────────────────────┐
│ FREE / MONTHLY / YEARLY · 만료일             │
└───────────────────────────────────────────────┘
┌─ 플랜 선택 ───────────────────────────────────┐
│ [월간 10만원]  [연간 100만원]                 │
│  └ 결제(포트원) → /charge/verifyPlan          │
└───────────────────────────────────────────────┘
┌─ 안내: 호스트/전문가 정보 등록은 활성 플랜 필요 ┐
```

## 4. 사용자 흐름 (Storyboard)

### 4.1 회원 가입 → 활성 플랜 → 공간 등록 (PROVIDER)

```
[/signup] ──POST─→ users(INSERT) + spaces(draft INSERT)
   │
   ├─ 자동 로그인 적재 → session(loginUserId, loginRole=PROVIDER)
   ▼
[/main]
   │
[/mypage/spaceRegi]
   │  ⚙ PlanCheckInterceptor: 활성 플랜? ── NO ──→ [/charge/plan]
   │                                                  │
   │                                              결제(PortOne)
   │                                                  │
   │                                       POST /charge/verifyPlan
   │                                                  │
   │                                       users.plan_type 갱신
   ▼
[/mypage/spaceRegi] (재진입 통과)
   │
   ▼ 폼 제출 POST /api/spaces  →  drafts UPDATE  →  성공
```

### 4.2 사용자 → 전문가 자문요청 → 영상통화

```
[/consulting] ──검색──→ 카드 선택
   │
   ▼ 자문요청 모달 → POST /api/consulting/requests
        (포인트 잔고 < session_price ? → /charge/recharge 안내)
   │
   ▼ status=PENDING
   │       ↑                          전문가: PATCH /api/consulting/requests/{id}/status (ACCEPTED)
   ▼
신청자: [/video/call?requestId=]  ←  진입 가능(상태 ACCEPTED)
   │
   ├─ STOMP /ws 연결 → 통화 신청 (CALL_REQUEST)
   ├─ 전문가 수락(CALL_ACCEPTED) → 미디어 SDP/ICE 교환
   ├─ start-call → 잔여 시간 카운트다운
   ├─ 임박 시 [연장] → POST /requests/{id}/extend (포인트 결제)
   └─ HANGUP → end-call → status=COMPLETED
```

### 4.3 호스트 예약 수락

```
[/mypage/spaceManagement]
   │  GET /api/spaces/host/reservations (월 매출 집계)
   ▼ 예약 리스트(상태 필터) → [승인][거절]
        PATCH /api/spaces/reservations/{id}/status
   ▼
사용자 측 [/mypage/status]에 상태 반영
```

## 5. 컴포넌트 가이드

| 컴포넌트 | 용도 | 사용 화면 |
| :--- | :--- | :--- |
| 검색바(헤더) | 라우팅 가능한 즉시 검색 입력 | UI-L1 |
| 카드 그리드 | 공간/전문가 일관 카드 | UI-S1, UI-S2, UI-H1, UI-H4 |
| 지도 + 핀 클러스터 | 전문가/공간 좌표 시각화 | UI-S4, UI-S1 |
| 모달(예약/자문요청) | 다단 폼 + 자동 가격 계산 | UI-S1, UI-S2 |
| 토스트/스낵바 | 결제·연장 알림 | UI-V1, UI-C1 |
| 데이터 테이블 | 예약 관리, 자문 관리 | UI-M5, UI-M7 |
| 카운트다운 타이머 | 통화 잔여 시간 | UI-V1 |
| PIP 비디오 | 자기 카메라 미리보기 | UI-V1 |

## 6. 접근성 / 반응형

- **반응형 브레이크포인트** — 모바일 ≤ 480, 태블릿 ≤ 1024, 데스크톱 > 1024
- **터치 타깃** — 통화 컨트롤 버튼 최소 48×48
- **컬러 컨트라스트** — 본문 4.5:1 / 가격 라벨은 본문 대비 1 단계 낮은 명도(피드백 #7 반영)
- **포커스 표시** — 모든 인터랙티브 요소에 outline 유지
- **i18n** — 현재 ko-KR 단일 (확장 여지 있음)

## 7. 피드백 반영 매트릭스 (0421feedback.txt)

| 피드백 항목 | 반영 위치 |
| :--- | :--- |
| #1 컨설팅 시간/금액, 영통 잔여시간 알림 | UI-V1 카운트다운/연장 토스트, F4.12 endpoint |
| #2 연회비/플랜 미납 정보 등록 차단 | `PlanCheckInterceptor` + UI-C1 |
| #5 홈 시인성, 그라디언트, 검색창 호버 | UI-H1 헤로/카드 호버 스타일 |
| #6 통합 검색 스크롤 인터페이스 + 맨 위로 FAB | UI-H4 |
| #7 금액 텍스트 명도 조정 | 컴포넌트 가이드 컬러 토큰 |

## 8. 변경 이력

| 버전 | 일자 | 변경 |
| :--- | :--- | :--- |
| v1.0 | 2026-05-20 | 현 JSP 뷰 기준 초기 작성 |
