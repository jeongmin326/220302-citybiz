# PublicService — Process Logic

| 항목 | 내용 |
| :--- | :--- |
| 산출물 | Process Logic (프로세스 설계서) |
| 버전 | v1.0 |
| 작성일 | 2026-05-20 |
| 표기법 | 의사코드(Pseudo-code) + 시퀀스 텍스트 |

본 문서는 주요 비즈니스 흐름의 알고리즘과 트랜잭션 경계를 정의한다. BDD(Given/When/Then) 시나리오는 `Test Specification`에서 일치하도록 작성한다.

---

## PL-01. 회원가입 (USER / PROVIDER / EXPERT 분기)

**핸들러**: `UserController#signup(POST /signup)`

```pseudo
INPUT: email, password, name, phone, role ∈ {USER, PROVIDER, EXPERT},
       (EXPERT만) expertType ∈ {TAX, ACCOUNT, LABOR, LAWYER, PATENT}

PRE  : !UserDAO.existsByEmail(email)
       !UserDAO.existsByPhone(phone)
TX BEGIN
  hash ← BCrypt.encode(password)
  userId ← UserDAO.insertUser(email, hash, name, phone, role, ...)
  IF role == PROVIDER:
      spacesRepo.save(draft Space with hostId=userId, available_yn='N')
  ELSE IF role == EXPERT:
      switch(expertType):
        TAX     → taxAccountantRepo.save(new with user_id=userId)
        ACCOUNT → accountantRepo.save(...)
        LABOR   → laborAttorneyRepo.save(...)
        LAWYER  → lawyerRepo.save(...)
        PATENT  → patentAttorneyRepo.save(...)
TX COMMIT

session ← {loginUserId=userId, loginRole=role, loginName=name}
REDIRECT /main
```

**불변식**: `users.email` UNIQUE, `users.phone` UNIQUE.

## PL-02. 로그인

**핸들러**: `UserController#login(POST /login)`

```pseudo
user ← userRepo.findByEmail(email)
IF user == null OR !BCrypt.matches(password, user.passwordHash):
    RETURN view "user/login" with error
session.setAttribute("loginUser", LoginUserDto.from(user))
session.setAttribute("loginUserId", user.userId)
session.setAttribute("loginRole",   user.role)
session.setAttribute("loginName",   user.name)
IF rememberMe: SET Cookie rememberEmail = email (maxAge 30d)
ELSE         : DELETE Cookie rememberEmail
REDIRECT /main
```

## PL-03. 활성 플랜 검증 (Interceptor)

**위치**: `PlanCheckInterceptor#preHandle`
**적용 경로**: `/mypage/spaceRegi`, `/mypage/spaceEdit`, `/mypage/expertProfile`

```pseudo
userId ← session.loginUserId
IF userId == null:           redirect /login; return false
role   ← session.loginRole
IF role == "USER":           return true            # USER는 통과
user   ← userRepo.findById(userId)
IF user == null:             redirect /login; return false
hasActivePlan ← user.planType != "FREE"
              AND user.planExpiresAt != null
              AND user.planExpiresAt > NOW()
IF !hasActivePlan:           redirect /charge/plan; return false
RETURN true
```

## PL-04. 포인트 충전 결제 검증

**핸들러**: `ChargeController#verify(POST /charge/verify)`

```pseudo
INPUT: imp_uid, merchant_uid (from PortOne front-end)

1. portoneToken ← PortOne.getAccessToken(impKey, impSecret)
2. payment ← PortOne.getPaymentByImpUid(imp_uid, portoneToken)
3. ASSERT payment.status == "paid"
4. amount ← payment.amount
5. bonus  ← computeBonus(amount):
            IF amount >= 50000:  amount * 0.05
            ELSE IF amount >= 30000: amount * 0.03
            ELSE IF amount >= 10000: amount * 0.02
            ELSE 0
6. credit ← amount + bonus
7. TX BEGIN
     users.point += credit
     pointHistoryRepo.save({userId, amount=credit, type=CHARGE,
                            description="충전(+보너스)", imp_uid})
   TX COMMIT
8. RETURN { ok:true, credited:credit, newBalance:users.point }
```

**보안**: 클라이언트 신뢰 금지 — 금액 결정은 PortOne 조회 응답에서만 산출.

## PL-05. 플랜 결제 검증 / 활성화

**핸들러**: `ChargeController#verifyPlan` → `PlanService#activatePlan`

```pseudo
INPUT: imp_uid, planType ∈ {MONTHLY, YEARLY}
1. payment ← PortOne.getPaymentByImpUid(imp_uid)
2. ASSERT payment.status == "paid"
3. expectedAmount ← (planType == MONTHLY ? 100_000 : 1_000_000)
4. ASSERT payment.amount == expectedAmount
5. duration ← (planType == MONTHLY ? 30 days : 365 days)
6. TX BEGIN
     IF user.planType == planType AND user.planExpiresAt > NOW():
         user.planExpiresAt += duration         # 누적 연장
     ELSE:
         user.planType      = planType
         user.planExpiresAt = NOW() + duration
     planHistoryRepo.save({userId, planType, amount, imp_uid,
                           startsAt=NOW(), expiresAt=user.planExpiresAt})
   TX COMMIT
7. RETURN { ok:true, planType, expiresAt:user.planExpiresAt }
```

## PL-06. 공간 예약 신청

**핸들러**: `SpaceController#reserve(POST /api/spaces/{spaceId}/reserve)`

```pseudo
INPUT: spaceId, useDate, startTime, endTime, userMemo
1. space ← spaceRepo.findById(spaceId); ASSERT space.availableYn=='Y'
2. hours ← (endTime - startTime) in hours (must be integer, >=1)
3. totalPrice ← hours * space.pricePerHour
4. TX BEGIN
     # 동일 공간/날짜에 시간 겹침 검사
     conflict ← reservationRepo.existsOverlapping(spaceId, useDate, startTime, endTime,
                  status IN {PENDING, APPROVED})
     ASSERT !conflict ELSE THROW 409 CONFLICT
     reservationRepo.save({spaceId, userId, useDate, start, end,
                           totalPrice, status='PENDING', userMemo})
   TX COMMIT
5. RETURN created reservation
```

## PL-07. 공간 가용 시간 조회

**핸들러**: `SpaceController#availability(GET /api/spaces/{id}/availability?date=)`

```pseudo
INPUT: spaceId, date(YYYY-MM-DD)
slots ← generateHourlySlots(09:00..22:00)   # 운영 시간 가정
booked ← reservationRepo.findByDate(spaceId, date,
                                    status IN {PENDING, APPROVED})
available ← slots \ unionOf(booked.intervals)
RETURN { date, available: available[] }     # ["09:00","10:00",...]
```

## PL-08. 자문 요청 신청 (포인트 차감)

**핸들러**: `ConsultingController#createRequest(POST /api/consulting/requests)`

```pseudo
INPUT: expertId, expertType, expertUserId,
       title, content, consultationType, durationSeconds
1. expert ← lookupExpert(expertType, expertId)     # 5개 테이블 분기
2. unitPrice ← priceTableByConsultationType(expert, consultationType)
3. sessionPrice ← unitPrice * (durationSeconds / 60)   # 분 단가 가정
4. TX BEGIN
     ASSERT users.point >= sessionPrice ELSE THROW 402 NEED_TOPUP
     users.point -= sessionPrice
     pointHistoryRepo.save({type:USE, amount:-sessionPrice, description:"자문요청"})
     req ← consultingRequestRepo.save({userId, expertId, expertType, expertUserId,
                                       title, content, consultationType,
                                       durationSeconds, sessionPrice,
                                       remainingSeconds: durationSeconds,
                                       status: PENDING})
   TX COMMIT
5. RETURN req
```

## PL-09. 자문요청 상태 전이

**핸들러**: `PATCH /api/consulting/requests/{id}/status`

```pseudo
                ┌─ CANCELLED (사용자, PENDING만)
PENDING ────────┤
                ├─ REJECTED (전문가)
                └─ ACCEPTED (전문가) ──→ IN_CALL(시그널링 상) ──→ COMPLETED
규칙:
  - 권한: status 변경자는 (사용자 OR 전문가) ∧ 요청 당사자
  - 전이: 위 다이어그램 외 전이는 409 CONFLICT
  - REJECTED/CANCELLED 시 차감 포인트 환불 정책: REJECTED → 환불, CANCELLED → 환불(PENDING만 가능)
```

## PL-10. WebRTC 통화 시그널링

**핸들러**: `VideoCallController#handleSignal(@MessageMapping)` + `VideoCallSessionRegistry`

```pseudo
INBOUND  /app/video/{requestId}/signal  msg = { type, ...payload }
OUTBOUND /topic/video/{requestId}       msg + { senderId }

switch msg.type:
  CASE "CALL_REQUEST":
     consultingRequestRepo.find(requestId).callInitiated = true; save
     sessionRegistry.tryInitiateCall(requestId, callerId=senderId, calleeId=targetId)
       → 신규: state=RINGING; OK
       → 이미 존재: NO-OP (false)
  CASE "CALL_ACCEPTED":
     sessionRegistry.acceptCall(requestId): RINGING → IN_CALL
  CASE "HANGUP" or "CALL_REJECTED":
     consultingRequestRepo.find(requestId).callInitiated = false; save
     sessionRegistry.endCall(requestId)
  DEFAULT (SDP_OFFER / SDP_ANSWER / ICE_CANDIDATE / CONTROL):
     단순 broadcast — 별도 상태 변경 없음
```

**동시성**: `ConcurrentHashMap` + `tryInitiateCall` containsKey 가드로 중복 콜 방지.

## PL-11. 통화 종료 → 정산

**핸들러**: `POST /api/consulting/requests/{id}/end-call` + `/complete-call`

```pseudo
1. req ← consultingRequestRepo.findById(id)
2. ASSERT user is participant
3. req.callEndedAt = NOW()
4. usedSeconds = (req.callEndedAt - req.callStartedAt) seconds
5. req.remainingSeconds = max(0, req.durationSeconds - usedSeconds)
6. req.status = "COMPLETED"
7. req.callInitiated = false
8. (정산) 전문가 매출 집계는 별도 월 조회 시 sessionPrice + extraPaid 합산
```

## PL-12. 통화 시간 연장

**핸들러**: `POST /api/consulting/requests/{id}/extend`

```pseudo
INPUT: extraMinutes
extraPrice ← unitPricePerMinute(req) * extraMinutes
TX BEGIN
  ASSERT users.point >= extraPrice ELSE THROW 402 NEED_TOPUP
  users.point -= extraPrice
  req.durationSeconds += extraMinutes*60
  req.remainingSeconds += extraMinutes*60
  req.extraPaid = (req.extraPaid ?? 0) + extraPrice
  pointHistoryRepo.save({type:USE, amount:-extraPrice, description:"통화연장"})
TX COMMIT
```

## PL-13. 정책 스크랩 토글

**핸들러**: `POST /api/policies/{id}/scrap`

```pseudo
existing ← policyScrapRepo.findByUserAndPolicy(userId, policyId)
IF existing: delete(existing); RETURN { scrapped:false }
ELSE       : save(new PolicyScrap(userId, policyId)); RETURN { scrapped:true }
# UNIQUE(user_id, policy_fund_id) 보장
```

## PL-14. 통합 검색 (Cross-domain)

**핸들러**: `HomeController#search(GET /search)`

```pseudo
INPUT: keyword, city, district, tab(optional)
results.spaces   = spaceRepo.search(city, district, keyword, page=0, size=6)
results.experts  = unionOf(
                     taxRepo.search(...), accountantRepo.search(...),
                     laborRepo.search(...), lawyerRepo.search(...),
                     patentRepo.search(...))
results.policies = policyFundRepo.search(keyword, page=0, size=6)
results.tab      = tab ?? "spaces"     # JS는 이 값으로 초기 스크롤 위치 결정
RETURN view "home/search" with results
```

## PL-15. 공간 이미지 캐싱 / 서빙

**관련**: `SpaceImageService`, `CacheConfig`

```pseudo
GET /api/space-images/{imageId}  (예시 라우트)
@Cacheable("spaceImages", key=imageId)
load:
  img ← spaceImageRepo.findById(imageId)
  RETURN ResponseEntity(img.image_data, contentType=img.content_type)
# Caffeine: maximumSize=500, expireAfterWrite=24h
```

## PL-16. 전문가 지도 좌표 조회

**핸들러**: `GET /experts/map/data`

```pseudo
INPUT: type ∈ {ALL, TAX, ACCOUNT, LABOR, LAWYER, PATENT}, city?, district?
points ← expertMapService.findByTypeAndId(type, ...)
        → 각 마스터 테이블에서 (latitude, longitude, name, office, addr) 선별
RETURN [ ExpertMapDto{type, id, lat, lng, ...} ]
```

## PL-17. 비밀번호 초기화

**핸들러**: `POST /findPWD`

```pseudo
INPUT: email, name, phone
user ← userRepo.findByEmailAndNameAndPhone(...)
ASSERT user.exists
TX BEGIN
  user.passwordHash = BCrypt.encode("1234")     # 기본값
TX COMMIT
RETURN view "user/findPWD" with message "임시비밀번호: 1234"
# 향후: 이메일/SMS OTP로 교체 (피드백 #3과 함께 모듈화 권장)
```

---

## 18. 트랜잭션 경계 & 일관성

| 흐름 | 경계 |
| :--- | :--- |
| 회원가입(전문가/호스트) | users + (전문가 마스터 OR draft space) 단일 TX |
| 포인트 충전 검증 | users.point + point_history 단일 TX |
| 자문요청 생성 | users.point − + point_history(USE) + consulting_request 단일 TX |
| 통화 연장 결제 | users.point − + point_history(USE) + consulting_request 갱신 단일 TX |
| 통화 시그널링 | DB I/O는 `callInitiated`만 영향; 본 메시지는 트랜잭션 없이 broadcast |

## 19. 오류 처리 원칙

| 카테고리 | 처리 |
| :--- | :--- |
| 입력 검증 실패 | 400 + 메시지 (JSON 응답군) / 폼 응답군은 view 재렌더링 |
| 인증 실패 | 401 또는 `/login` 리다이렉트 |
| 인가 실패(플랜·소유권) | 403 또는 `/charge/plan` 리다이렉트 |
| 자원 없음 | `error/notfound` 또는 404 JSON |
| 결제 검증 실패 | 회계 무결성을 위해 절대 차감 적용 안 함 |
| 동시성 충돌(예약/통화) | 409 CONFLICT + 사용자 안내 |

## 20. 변경 이력

| 버전 | 일자 | 변경 |
| :--- | :--- | :--- |
| v1.0 | 2026-05-20 | 핵심 17개 프로세스 초기 정의 |
