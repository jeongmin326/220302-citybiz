# PublicService — Integration Spec

| 항목 | 내용 |
| :--- | :--- |
| 산출물 | Integration Spec (인터페이스 정의서) |
| 버전 | v1.0 |
| 작성일 | 2026-05-20 |
| 프로토콜 | HTTP/1.1, WebSocket(STOMP over SockJS) |
| 직렬화 | JSON (application/json), x-www-form-urlencoded, multipart/form-data |
| 인증 단위 | `HttpSession` 쿠키(`JSESSIONID`), 세션 키: `loginUserId`, `loginRole` |

본 문서는 컴포넌트/컨테이너 간 통신 규격을 정의한다. 코드와 본 문서의 불일치가 발견되면 본 문서를 정정한다(`Decision Records`의 ADR-도큐먼트 일치 원칙 참조).

---

## 0. 공통 규격

### 0.1 표준 응답 봉투

```json
// 성공 — 단일 객체 또는 컬렉션 직접 반환
{ "...": "..." }

// 오류 (권장)
{ "error": "ERR_CODE", "message": "human readable" }
```

### 0.2 표준 오류 코드

| HTTP | 의미 |
| :--- | :--- |
| 400 | 입력 검증 실패 |
| 401 | 비로그인 / 세션 만료 |
| 402 | 포인트 부족 (`NEED_TOPUP`) |
| 403 | 권한 없음 / 활성 플랜 미보유 |
| 404 | 자원 없음 |
| 409 | 충돌(예약 겹침, 통화 중복 등) |
| 422 | 상태 전이 불가 |
| 500 | 서버 오류 |

### 0.3 인증/세션

| 헤더/쿠키 | 설명 |
| :--- | :--- |
| `Cookie: JSESSIONID=…` | 모든 인증 필요 엔드포인트에 필요 |
| `Cookie: rememberEmail=…` | 선택, 로그인 폼 자동 채움 |

세션 속성:

| 키 | 타입 | 설정 시점 |
| :--- | :--- | :--- |
| `loginUser` | `LoginUserDto` | 로그인 성공 |
| `loginUserId` | `Long` | 로그인 성공 |
| `loginRole` | `String` (USER/PROVIDER/EXPERT) | 로그인 성공 |
| `loginName` | `String` | 로그인 성공 |

---

## 1. Account API

### POST `/login`
- **Body** (form): `email`, `password`, `rememberMe?`
- **응답**: 성공 시 `302 → /main`; 실패 시 `200` + view "user/login"(error 모델)

### POST `/signup`
- **Body** (form): `email`, `password`, `name`, `phone`, `role` ∈ {USER, PROVIDER, EXPERT}, `expertType?` ∈ {TAX, ACCOUNT, LABOR, LAWYER, PATENT}
- **응답**: `302 → /main`

### GET `/check-email?email=`
```json
{ "valid": true, "exists": false }
```

### GET `/check-phone?phone=`
```json
{ "exists": false }
```

### POST `/findID`
- **Body**: `name`, `phone` → view "user/findID"에 `foundEmail` 모델

### POST `/findPWD`
- **Body**: `email`, `name`, `phone` → 임시 비밀번호 `"1234"`로 초기화, 안내 메시지

### GET `/logout`
- 세션 무효화 후 `302 → /main`

### GET `/api/user/profile` — JSON 프로필
```json
{
  "userId": 12,
  "email": "user@example.com",
  "name": "...", "phone": "...", "role": "PROVIDER",
  "companyName": "...", "bizNo": "...", "industry": "...",
  "city": "...", "district": "...", "roadAddress": "...", "detailAddress": "...",
  "businessStage": "...", "status": "...",
  "point": 350000,
  "planType": "MONTHLY", "planExpiresAt": "2026-06-19T00:00:00"
}
```

### POST `/api/user/profile` — JSON `UserProfileRequest`
```json
{ "name":"...", "phone":"...", "city":"...", "district":"...",
  "roadAddress":"...", "detailAddress":"...", "companyName":"...",
  "bizNo":"...", "industry":"...", "businessStage":"...", "status":"..." }
```

### GET `/api/user/my-info`
```json
{ "point": 350000 }
```

---

## 2. Space API

### GET `/api/spaces`
- **Query**: `city`, `district`, `keyword`, `spaceTypes[]`, `minPrice`, `maxPrice`, `capacity`, `page`, `size`
- **응답**: `Page<SpaceDto>`

### GET `/api/spaces/{spaceId}/availability?date=YYYY-MM-DD`
```json
{ "date":"2026-05-20",
  "available":["09:00","10:00","11:00","14:00"] }
```

### POST `/api/spaces` (multipart/form-data) — 호스트, 플랜 필수
- Fields: `name`, `spaceType`, `description`, `pricePerHour`, `capacity`, `city`, `district`, `roadAddress`, `detailAddress`, `latitude`, `longitude`, `mainImage`(file), `subImages[]`(file)
- **응답**: 201 + `{spaceId}`

### PUT `/api/spaces/{id}`
- 동일 필드 부분 갱신; 호스트 본인만

### POST `/api/spaces/{spaceId}/reserve`
```json
// req
{ "useDate":"2026-05-25","startTime":"14:00","endTime":"16:00","userMemo":"..." }
// res
{ "reservationId":31, "totalPrice":40000, "status":"PENDING" }
```

### GET `/api/spaces/my/reservations`
- `[{reservationId, spaceName, useDate, startTime, endTime, totalPrice, status}]`

### GET `/api/spaces/host/reservations`
- 호스트 시점, 월 매출 집계 포함
```json
{ "monthlyRevenue": 320000,
  "items":[ {"reservationId":1, "userName":"...", "useDate":"...", ...} ] }
```

### GET `/api/spaces/host/spaces`
- 호스트 보유 공간 리스트

### PATCH `/api/spaces/reservations/{id}/status`
```json
{ "status":"APPROVED" }   // APPROVED | REJECTED
```

### POST `/api/spaces/reservations/{id}/cancel` — 사용자, PENDING만

### 정적 자원
- `GET /img_space/{filename}` → 디스크 `F:\publicservice\img_space\{filename}`

---

## 3. Consulting API

### GET `/api/consultants`
- **Query**: `type` ∈ {ALL, TAX, ACCOUNT, LABOR, LAWYER, PATENT}, `district`, `keyword`, `minRating`, `minExperience`, `minPrice`, `maxPrice`, `page`, `size`
- **응답**: `Page<ExpertDto>`

### POST `/api/consulting/requests`
```json
// req
{ "expertId":12, "expertType":"TAX", "expertUserId":34,
  "title":"...", "content":"...",
  "consultationType":"VIDEO",   // VIDEO | PHONE | CHAT | OFFLINE
  "durationSeconds":1800 }
// res
{ "requestId":7, "sessionPrice":15000, "status":"PENDING",
  "remainingPoint": 285000 }
```
- 오류: `402 NEED_TOPUP`

### GET `/api/consulting/my/requests`
### GET `/api/consulting/expert/requests` — 월 매출 집계 포함

### PATCH `/api/consulting/requests/{id}/status`
```json
{ "status":"ACCEPTED" }   // ACCEPTED | REJECTED | COMPLETED
```

### POST `/api/consulting/requests/{id}/cancel` — PENDING만, 사용자

### GET `/api/consulting/requests/{id}/messages`
```json
[ { "messageId":1, "senderId":5, "senderRole":"USER",
    "content":"...", "createdAt":"2026-05-20T10:00:01" } ]
```

### POST `/api/consulting/requests/{id}/messages`
```json
{ "content":"안녕하세요" }
```

### 통화 운영
| 메서드 | 경로 | 페이로드 |
| :--- | :--- | :--- |
| POST | `/api/consulting/requests/{id}/start-call` | — |
| POST | `/api/consulting/requests/{id}/end-call` | — |
| POST | `/api/consulting/requests/{id}/complete-call` | — (전문가) |
| POST | `/api/consulting/requests/{id}/extend` | `{ "extraMinutes": 10 }` |

---

## 4. Policy API

### GET `/api/policies`
- **Query**: `category` ∈ {융자, 보증, 보험}, `institution`, `applicationAvailableYn` ∈ {Y, N}, `keyword`, `page`, `size`
- **응답**: `Page<PolicyFundDto>`

### POST `/api/policies/{id}/scrap`
```json
{ "scrapped": true }
```

### GET `/api/policies/my-scraps`

---

## 5. Charge API

### GET `/charge/recharge` · `/charge/pointHistory` · `/charge/plan` — 뷰 라우팅

### POST `/charge/verify`
```json
// req (포트원 결제 완료 후)
{ "imp_uid":"imp_1234567890", "merchant_uid":"...", "amount": 50000 }
// res
{ "ok": true, "credited": 52500, "newBalance": 102500 }
```
- 보너스: 10000↑ 2%, 30000↑ 3%, 50000↑ 5%

### POST `/charge/verifyPlan`
```json
// req
{ "imp_uid":"imp_...", "planType":"MONTHLY" }
// res
{ "ok": true, "planType":"MONTHLY", "expiresAt":"2026-06-19T00:00:00" }
```

---

## 6. Map / Geocoding API

### GET `/experts/map/data?type=&city=&district=`
```json
[ { "type":"TAX","id":102,"name":"...","office":"...",
    "latitude":37.5651,"longitude":126.9784,"addr":"서울특별시 ..." } ]
```

### GET `/experts/map` — 뷰 `home/expertMap`

### GeocodingProxyController
- `GET /api/geocode?query=...` — Naver Geocoding REST 프록시
- `{ x, y, roadAddress, jibunAddress }`

---

## 7. WebSocket (STOMP / SockJS) — 시그널링

### 7.1 엔드포인트
- **연결 URL**: `https://<host>/ws` (SockJS handshake, 이후 wss:// upgrade)
- **Handshake Interceptor**: `VideoCallHandshakeInterceptor`
  - 핸드셰이크 시 `HttpSession.loginUserId` 존재 필수(없으면 STOMP 메시지 발행 시 `senderId` 누락)
  - STOMP 세션 attribute에 `userId` 저장

### 7.2 STOMP 토픽 / 데스티네이션

| 방향 | Destination | 페이로드 |
| :--- | :--- | :--- |
| C → S | `/app/video/{requestId}/signal` | `{ type, ...payload }` |
| S → C (broadcast) | `/topic/video/{requestId}` | `{ type, senderId, ...payload }` |

### 7.3 시그널 메시지 타입

| `type` | 송신자 | 추가 필드 | 서버 처리 |
| :--- | :--- | :--- | :--- |
| `CALL_REQUEST` | 발신자 | `targetId:Long` | `consulting_requests.callInitiated=true`, `tryInitiateCall(requestId, callerId, calleeId)` |
| `CALL_ACCEPTED` | 수신자 | — | `acceptCall(requestId)` (RINGING→IN_CALL) |
| `CALL_REJECTED` | 수신자 | — | `callInitiated=false`, `endCall(requestId)` |
| `HANGUP` | 양측 | — | 동상 |
| `SDP_OFFER` | 발신자 | `sdp:string` | broadcast |
| `SDP_ANSWER` | 수신자 | `sdp:string` | broadcast |
| `ICE_CANDIDATE` | 양측 | `candidate:object` | broadcast |
| `CONTROL` | 양측 | `event:"MUTE"\|"VIDEO_OFF"\|...` | broadcast |

### 7.4 연결 검증 시퀀스 (Mermaid 텍스트)

```
Caller            Server (Spring)          Callee
  │  GET /video/call?requestId=  │           │
  │ ───────────────────────────► │           │
  │   200 (page + myUserId,…)    │           │
  │ ◄─────────────────────────── │           │
  │  CONNECT /ws (SockJS)        │           │
  │ ───────────────────────────► │           │
  │   SUBSCRIBE /topic/video/{id}│           │
  │ ───────────────────────────► │           │
  │  SEND /app/video/{id}/signal │           │
  │   {type:CALL_REQUEST,target} │           │
  │ ───────────────────────────► │           │
  │                              │ SessionRegistry.tryInitiateCall
  │                              │ ──broadcast /topic/video/{id}──►
  │                              │                                  │
  │                              │     {type:CALL_ACCEPTED}         │
  │ ◄────────────broadcast───────│ ◄────────────────────────────────│
  │  SDP_OFFER ─────────────────►│ broadcast ──────────────────────►│
  │  ICE_CANDIDATE  …            │  …                               │
  │  HANGUP ─────────────────────►│ endCall(); broadcast ──────────►│
```

> 실제 미디어 트래픽(WebRTC)은 P2P로 직접 흐른다. TURN 사용 시 TURN 서버가 릴레이.

---

## 8. 외부 시스템 통합

### 8.1 PortOne (아임포트)

| 연동 | 방식 |
| :--- | :--- |
| 결제 위젯 | 브라우저 SDK |
| 서버 검증 | `POST https://api.iamport.kr/users/getToken` → access_token; `GET https://api.iamport.kr/payments/{imp_uid}` |
| 보안 | `IMP_KEY`, `IMP_SECRET`은 서버 환경변수, 절대 클라이언트 노출 금지 |

### 8.2 Naver Maps / Geocoding

| 연동 | 방식 |
| :--- | :--- |
| 지도 JS | 클라이언트에서 `clientId` 사용 (`HomeController#space`, `#consulting`에서 모델로 전달) |
| Geocoding | 서버 사이드 `GeocodingProxyController`가 `X-NCP-APIGW-API-KEY-ID`/`X-NCP-APIGW-API-KEY` 헤더로 호출 |

### 8.3 (옵션) STUN/TURN

- 브라우저 측 RTCPeerConnection 설정에 ICE 서버 등록 (서버는 시그널링만 책임)

---

## 9. 컴포넌트 간 통신 매트릭스

| 호출자 | 피호출자 | 채널 | 페이로드 |
| :--- | :--- | :--- | :--- |
| Browser | Spring REST | HTTP+JSON | 위 1~6 |
| Browser | Spring STOMP | WebSocket | 위 7 |
| Browser | Browser | WebRTC P2P | SDP/ICE/Media |
| Spring | MariaDB | JDBC | SQL via JPA |
| Spring | PortOne | HTTPS REST | JSON |
| Spring | Naver | HTTPS REST | JSON |
| Spring | Filesystem | NIO | binary |

---

## 10. 변경 이력

| 버전 | 일자 | 변경 |
| :--- | :--- | :--- |
| v1.0 | 2026-05-20 | 코드 기준 초기 작성 |
