<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>서비스 플랜 선택 - City Biz Hub</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script src="https://unpkg.com/lucide@latest"></script>
    <script src="https://cdn.iamport.kr/v1/iamport.js"></script>
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Pretendard:wght@300;400;500;600;700;800&display=swap');
        body { font-family: 'Pretendard', sans-serif; -webkit-font-smoothing: antialiased; }
        .plan-card:hover { transform: translateY(-8px); transition: all 0.3s ease; }
    </style>
</head>
<body class="bg-[#F8FAFC] flex flex-col min-h-screen text-slate-800">

    <jsp:include page="/WEB-INF/views/common/header.jsp" />

    <main class="flex-grow max-w-6xl mx-auto w-full px-4 py-16">
        <div class="text-center mb-16">
            <h1 class="text-4xl font-bold text-slate-900 mb-4">비즈니스 성장을 위한 최적의 플랜</h1>
            <p class="text-lg text-slate-600">공간 등록 및 전문가 네트워크를 통해 도시의 비즈니스 자원을 연결하세요.</p>
        </div>

        <div class="grid grid-cols-1 md:grid-cols-3 gap-8">
            <div class="plan-card bg-white rounded-3xl p-8 border border-slate-200 shadow-sm flex flex-col">
                <div class="mb-8">
                    <span class="text-indigo-600 font-semibold px-3 py-1 bg-indigo-50 rounded-full text-sm">탐색형</span>
                    <h2 class="text-2xl font-bold mt-4">무료로 구경하기</h2>
                    <p class="text-slate-500 mt-2">플랫폼의 기능을 미리 체험해보세요.</p>
                </div>
                <div class="mb-8">
                    <span class="text-4xl font-bold text-slate-900">0원</span>
                    <span class="text-slate-500">/ 평생</span>
                </div>
                <ul class="space-y-4 mb-10 flex-grow">
                    <li class="flex items-center text-slate-600"><i data-lucide="check" class="w-5 h-5 mr-3 text-emerald-500"></i>모든 공간/전문가 검색</li>
                    <li class="flex items-center text-slate-600"><i data-lucide="check" class="w-5 h-5 mr-3 text-emerald-500"></i>공공 지원사업 조회</li>
                    <li class="flex items-center text-slate-400 line-through"><i data-lucide="x" class="w-5 h-5 mr-3"></i>공간 및 오피스 등록</li>
                    <li class="flex items-center text-slate-400 line-through"><i data-lucide="x" class="w-5 h-5 mr-3"></i>전문가 프로필 등록</li>
                </ul>
                <button onclick="location.href='/main'" class="w-full py-4 px-6 rounded-xl border border-slate-300 font-semibold text-slate-700 hover:bg-slate-50 transition">지금 바로 시작</button>
            </div>

            <div class="plan-card bg-white rounded-3xl p-8 border-2 border-indigo-500 shadow-xl relative flex flex-col transform scale-105">
                <div class="absolute -top-4 left-1/2 -translate-x-1/2 bg-indigo-500 text-white px-4 py-1 rounded-full text-sm font-bold">
                    <c:choose>
                        <c:when test="${currentPlan == 'MONTHLY'}">현재 이용 중</c:when>
                        <c:otherwise>인기</c:otherwise>
                    </c:choose>
                </div>
                <div class="mb-8">
                    <span class="text-indigo-600 font-semibold px-3 py-1 bg-indigo-50 rounded-full text-sm">성장형</span>
                    <h2 class="text-2xl font-bold mt-4">월간 플랜</h2>
                    <p class="text-slate-500 mt-2">유연한 운영이 필요한 파트너용</p>
                </div>
                <div class="mb-8">
                    <span class="text-4xl font-bold text-slate-900">100,000원</span>
                    <span class="text-slate-500">/ 월</span>
                </div>
                <ul class="space-y-4 mb-10 flex-grow">
                    <li class="flex items-center text-slate-600"><i data-lucide="check" class="w-5 h-5 mr-3 text-emerald-500"></i>공간/전문가 무제한 등록</li>
                    <li class="flex items-center text-slate-600"><i data-lucide="check" class="w-5 h-5 mr-3 text-emerald-500"></i>AI 수요 예측 리포트 제공</li>
                    <li class="flex items-center text-slate-600"><i data-lucide="check" class="w-5 h-5 mr-3 text-emerald-500"></i>예약 관리 대시보드 이용</li>
                </ul>
                <c:choose>
                    <c:when test="${currentPlan == 'MONTHLY'}">
                        <button disabled class="w-full py-4 px-6 rounded-xl bg-slate-300 font-semibold text-slate-600 cursor-not-allowed">현재 이용 중</button>
                    </c:when>
                    <c:otherwise>
                        <button onclick="subscribe('MONTHLY')" class="w-full py-4 px-6 rounded-xl bg-indigo-600 font-semibold text-white hover:bg-indigo-700 transition shadow-lg shadow-indigo-200">플랜 가입하기</button>
                    </c:otherwise>
                </c:choose>
            </div>

            <div class="plan-card bg-white rounded-3xl p-8 border border-slate-200 shadow-sm flex flex-col">
                <div class="mb-8">
                    <span class="text-emerald-600 font-semibold px-3 py-1 bg-emerald-50 rounded-full text-sm">가성비</span>
                    <h2 class="text-2xl font-bold mt-4">연간 플랜</h2>
                    <p class="text-slate-500 mt-2">안정적인 사업 확장을 위한 선택</p>
                </div>
                <div class="mb-8">
                    <span class="text-4xl font-bold text-slate-900">1,000,000원</span>
                    <span class="text-slate-500">/ 년</span>
                    <div class="text-emerald-500 text-sm font-bold mt-1">약 17% 절약 (월 8.3만원 꼴)</div>
                </div>
                <ul class="space-y-4 mb-10 flex-grow">
                    <li class="flex items-center text-slate-600"><i data-lucide="check" class="w-5 h-5 mr-3 text-emerald-500"></i>월간 플랜의 모든 혜택</li>
                    <li class="flex items-center text-slate-600"><i data-lucide="check" class="w-5 h-5 mr-3 text-emerald-500"></i>플랫폼 메인 우선 노출</li>
                    <li class="flex items-center text-slate-600"><i data-lucide="check" class="w-5 h-5 mr-3 text-emerald-500"></i>1:1 기술 지원 서비스</li>
                </ul>
                <c:choose>
                    <c:when test="${currentPlan == 'YEARLY'}">
                        <button disabled class="w-full py-4 px-6 rounded-xl bg-slate-300 font-semibold text-slate-600 cursor-not-allowed">현재 이용 중</button>
                    </c:when>
                    <c:otherwise>
                        <button onclick="subscribe('YEARLY')" class="w-full py-4 px-6 rounded-xl border border-indigo-600 font-semibold text-indigo-600 hover:bg-indigo-50 transition">연간 플랜 선택</button>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </main>

    <script>
        lucide.createIcons();

        const IMP_KEY = '${impKey}';
        const channelKeys = {
            card:  '${cardChannelKey}',
            kakao: '${kakaoChannelKey}',
            toss:  '${tossChannelKey}'
        };
        const PLAN_AMOUNTS = { MONTHLY: 100000, YEARLY: 1000000 };
        const PLAN_NAMES   = { MONTHLY: '월간 플랜 (100,000원)', YEARLY: '연간 플랜 (1,000,000원)' };

        IMP.init(IMP_KEY);

        async function subscribe(planType) {
            const amount = PLAN_AMOUNTS[planType];
            const merchantUid = 'plan_' + planType + '_' + Date.now();

            IMP.request_pay({
                channelKey: channelKeys['card'],
                pay_method: 'card',
                merchant_uid: merchantUid,
                name: PLAN_NAMES[planType],
                amount: amount,
            }, async function(rsp) {
                if (!rsp.success) {
                    alert('결제가 취소되었습니다: ' + rsp.error_msg);
                    return;
                }

                try {
                    const res = await fetch('/charge/verifyPlan', {
                        method: 'POST',
                        headers: { 'Content-Type': 'application/json' },
                        body: JSON.stringify({
                            imp_uid: rsp.imp_uid,
                            merchant_uid: merchantUid,
                            amount: amount,
                            planType: planType
                        })
                    });
                    const data = await res.json();
                    if (data.success) {
                        alert(PLAN_NAMES[planType] + ' 가입이 완료되었습니다!');
                        location.reload();
                    } else {
                        alert('플랜 가입 실패: ' + data.message);
                    }
                } catch (error) {
                    alert('오류 발생: ' + error.message);
                }
            });
        }
    </script>
</body>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />

</html>