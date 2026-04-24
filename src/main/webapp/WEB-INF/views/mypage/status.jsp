<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>내 활동 내역 - City Biz Hub</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script src="https://unpkg.com/lucide@latest"></script>
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Pretendard:wght@300;400;500;600;700;800&display=swap');
        body { 
            font-family: 'Pretendard', sans-serif; 
            -webkit-font-smoothing: antialiased;
        }
    </style>
</head>
<body class="bg-[#F8FAFC] flex flex-col min-h-screen text-slate-800">

    <%-- 1. 헤더 불러오기 (경로는 프로젝트 실제 구조에 맞게 수정해 주세요) --%>
    <jsp:include page="../common/header.jsp" />
    
    <%-- 2. 메인 컨텐츠 영역 --%>
    <main class="flex-grow max-w-7xl mx-auto w-full px-4 sm:px-6 py-12">
    
        <section class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 pt-8 mb-20"> <div class="flex items-center gap-3 mb-6">
                <i data-lucide="coins" class="w-8 h-8 text-amber-500"></i>
                <h1 class="text-3xl font-extrabold text-slate-900 tracking-tight">내 포인트</h1>
            </div>

            <div class="bg-white rounded-3xl p-10 shadow-sm border border-slate-200 flex flex-col md:flex-row items-center justify-between">
                <div class="mb-8 md:mb-0 flex items-baseline gap-2">
                    <span class="text-6xl font-black text-slate-900" id="statusPointDisplay">${currentPoint != null ? currentPoint : '0'}</span>
                    <span class="text-2xl font-bold text-slate-400">P</span>
                </div>
                
                <div class="flex flex-col sm:flex-row gap-4 w-full md:w-auto">
                    <a href="/charge/pointHistory" class="flex-1 md:flex-none flex justify-center items-center gap-2 bg-slate-50 hover:bg-slate-100 text-slate-700 font-bold text-lg py-5 px-10 rounded-2xl border border-slate-200 transition-all active:scale-[0.98]">
                        <i data-lucide="history" class="w-6 h-6 text-slate-500"></i>
                        이용 내역
                    </a>
                    <a href="/charge/recharge" class="flex-1 md:flex-none flex justify-center items-center gap-2 bg-blue-600 hover:bg-blue-700 text-white font-bold text-lg py-5 px-10 rounded-2xl shadow-lg shadow-blue-200 transition-all active:scale-[0.98]">
                        <i data-lucide="plus-circle" class="w-6 h-6 text-yellow-300"></i>
                        충전하기
                    </a>
                </div>
            </div>

        </section>
        
        <%-- 상단 헤더 영역 --%>
        <div class="mb-8">
            <span class="bg-purple-100 text-purple-700 text-xs font-bold px-3 py-1 rounded-full mb-3 inline-block">내 활동 현황</span>
            <h1 class="text-3xl font-extrabold text-slate-900 tracking-tight">내 활동 내역</h1>
            <p class="text-slate-500 mt-2">${not empty sessionScope.loginName ? sessionScope.loginName : '사용자'}님의 비즈니스 활동 현황입니다.</p>
        </div>

        <div>
                <%-- 1. 대시보드 요약 (Overview) --%>
                <div class="grid grid-cols-1 md:grid-cols-3 gap-6 mb-8">
                    <div class="bg-white rounded-3xl p-6 border border-slate-200 shadow-sm flex items-center gap-4">
                        <div class="bg-blue-100 p-4 rounded-2xl text-blue-600">
                            <i data-lucide="calendar-check" class="w-8 h-8"></i>
                        </div>
                        <div>
                            <p class="text-sm font-semibold text-slate-500">다가오는 예약</p>
                            <p class="text-2xl font-bold text-slate-900"><span id="upcomingCount">-</span><span class="text-base font-medium text-slate-500 ml-1">건</span></p>
                        </div>
                    </div>
                    <div class="bg-white rounded-3xl p-6 border border-slate-200 shadow-sm flex items-center gap-4">
                        <div class="bg-indigo-100 p-4 rounded-2xl text-indigo-600">
                            <i data-lucide="bookmark" class="w-8 h-8"></i>
                        </div>
                        <div>
                            <p class="text-sm font-semibold text-slate-500">스크랩한 정책</p>
                            <p class="text-2xl font-bold text-slate-900"><span id="scrapCount">-</span><span class="text-base font-medium text-slate-500 ml-1">건</span></p>
                        </div>
                    </div>
                    <div class="bg-white rounded-3xl p-6 border border-slate-200 shadow-sm flex items-center gap-4">
                        <div class="bg-purple-100 p-4 rounded-2xl text-purple-600">
                            <i data-lucide="message-square" class="w-8 h-8"></i>
                        </div>
                        <div>
                            <p class="text-sm font-semibold text-slate-500">진행 중인 컨설팅</p>
                            <p class="text-2xl font-bold text-slate-900"><span id="consultingCount">-</span><span class="text-base font-medium text-slate-500 ml-1">건</span></p>
                        </div>
                    </div>
                </div>

                <div>

                    <%-- 컨텐츠 영역 --%>
                    <div class="space-y-8">
                        
                        <%-- 2. 공간 대여 이용 내역 --%>
                        <section class="bg-white rounded-3xl border border-slate-200 shadow-sm overflow-hidden">
                            <div class="p-6 border-b border-slate-100 flex justify-between items-center bg-slate-50/50">
                                <h2 class="text-lg font-bold text-slate-900 flex items-center gap-2">
                                    <i data-lucide="map-pin" class="w-5 h-5 text-blue-500"></i> 공간 대여 내역
                                </h2>
                                <a href="/space" class="text-sm font-medium text-blue-600 hover:underline">더보기</a>
                            </div>
                            <div class="p-6 space-y-4" id="reservationList">
                                <p class="text-sm text-slate-400 text-center py-4">불러오는 중...</p>
                            </div>
                        </section>

                        <%-- 3. 맞춤 정책 지원 스크랩 --%>
                        <section class="bg-white rounded-3xl border border-slate-200 shadow-sm overflow-hidden">
                            <div class="p-6 border-b border-slate-100 flex justify-between items-center bg-slate-50/50">
                                <h2 class="text-lg font-bold text-slate-900 flex items-center gap-2">
                                    <i data-lucide="pie-chart" class="w-5 h-5 text-indigo-500"></i> 관심 정책 목록
                                </h2>
                                <a href="/policy" class="text-sm font-medium text-indigo-600 hover:underline">더보기</a>
                            </div>
                            <div class="p-6 space-y-4" id="scrapList">
                                <p class="text-sm text-slate-400 text-center py-4">불러오는 중...</p>
                            </div>
                        </section>

                        <%-- 4. 컨설팅 진행 현황 --%>
                        <section class="bg-white rounded-3xl border border-slate-200 shadow-sm overflow-hidden">
                            <div class="p-6 border-b border-slate-100 flex justify-between items-center bg-slate-50/50">
                                <h2 class="text-lg font-bold text-slate-900 flex items-center gap-2">
                                    <i data-lucide="network" class="w-5 h-5 text-purple-500"></i> 컨설팅 진행 현황
                                </h2>
                                <a href="/consulting" class="text-sm font-medium text-purple-600 hover:underline">새 문의하기</a>
                            </div>
                            <div class="p-6 space-y-4" id="consultingList">
                                <p class="text-sm text-slate-400 text-center py-4">불러오는 중...</p>
                            </div>
                        </section>

                    </div>

                </div>
        </div>
    </main>

    <%-- 채팅 사이드 패널 (수락된 자문용) --%>
    <div id="statusChatPanel" class="fixed top-0 right-0 h-full w-full md:w-[420px] bg-white shadow-2xl z-[150] flex flex-col border-l border-slate-200"
         style="transform: translateX(100%); opacity: 0; pointer-events: none; transition: transform 0.3s ease, opacity 0.3s ease;">
        <div class="bg-gradient-to-r from-violet-600 to-purple-600 px-6 py-5 flex items-center justify-between flex-shrink-0">
            <div class="min-w-0">
                <p class="text-purple-200 text-xs font-semibold mb-0.5">자문 채팅</p>
                <h3 class="text-white font-bold text-base truncate" id="statusChatTitle">-</h3>
                <p class="text-purple-200 text-xs mt-0.5">전문가와의 실시간 채팅</p>
            </div>
            <button onclick="closeStatusChat()" class="text-white/70 hover:text-white transition-colors ml-4 flex-shrink-0">
                <svg xmlns="http://www.w3.org/2000/svg" class="w-6 h-6" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path stroke-linecap="round" stroke-linejoin="round" d="M6 18L18 6M6 6l12 12"/></svg>
            </button>
        </div>
        <div id="statusChatMessages" class="flex-1 overflow-y-auto p-5 space-y-3 bg-slate-50" style="scrollbar-width: thin;">
            <p class="text-center text-slate-400 text-xs py-8">불러오는 중...</p>
        </div>
        <div class="px-4 py-4 bg-white border-t border-slate-100 flex-shrink-0">
            <div class="flex gap-2 items-end">
                <textarea id="statusChatInput" rows="2" placeholder="메시지를 입력하세요..."
                    class="flex-1 bg-slate-50 border border-slate-200 rounded-2xl px-4 py-3 text-sm resize-none focus:outline-none focus:ring-2 focus:ring-purple-200 focus:border-purple-400 transition-all"
                    onkeydown="handleStatusChatKey(event)"></textarea>
                <button onclick="sendStatusChatMessage()" class="w-11 h-11 bg-violet-600 hover:bg-violet-700 rounded-2xl flex items-center justify-center text-white transition-colors shadow-sm flex-shrink-0">
                    <svg xmlns="http://www.w3.org/2000/svg" class="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path stroke-linecap="round" stroke-linejoin="round" d="M5 12h14M12 5l7 7-7 7"/></svg>
                </button>
            </div>
        </div>
    </div>
    <div id="statusChatOverlay" class="fixed inset-0 bg-black/20 z-[140] hidden md:hidden" onclick="closeStatusChat()"></div>

    <%-- 3. 푸터 불러오기 (경로는 프로젝트 실제 구조에 맞게 수정해 주세요) --%>
    <jsp:include page="../common/footer.jsp" />

    <script>
        function escapeHtml(val) {
            return String(val || '').replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;').replace(/"/g,'&quot;');
        }

        var allScrapItems = [];
        var scrapExpanded = false;
        var SCRAP_SHOW = 3;

        function renderScrapList() {
            var container = document.getElementById('scrapList');
            if (allScrapItems.length === 0) {
                container.innerHTML = '<p class="text-sm text-slate-400 text-center py-4">스크랩한 정책이 없습니다.<br><a href="/policy" class="text-indigo-500 hover:underline mt-1 inline-block">정책 둘러보기</a></p>';
                lucide.createIcons();
                return;
            }

            var visible = scrapExpanded ? allScrapItems : allScrapItems.slice(0, SCRAP_SHOW);
            var remaining = allScrapItems.length - SCRAP_SHOW;

            var html = visible.map(function(p) {
                var badge = p.applicationAvailableYn === 'Y'
                    ? '<span class="text-xs font-bold px-2 py-0.5 bg-rose-100 text-rose-600 rounded">접수중</span>'
                    : '<span class="text-xs font-bold px-2 py-0.5 bg-slate-100 text-slate-600 rounded">마감</span>';
                return '<div class="flex justify-between items-center border-b border-slate-100 pb-4 last:border-0 last:pb-0" data-policy-id="' + p.id + '">' +
                    '<div>' +
                        '<div class="flex items-center gap-2 mb-1">' +
                            badge +
                            '<span class="text-xs text-slate-500">' + escapeHtml(p.institution) + '</span>' +
                        '</div>' +
                        '<h3 class="font-bold text-slate-900 hover:text-indigo-600 cursor-pointer">' + escapeHtml(p.fundName) + '</h3>' +
                    '</div>' +
                    '<button onclick="removeScrap(event,' + p.id + ')" class="text-rose-500 hover:text-rose-700 transition-colors flex-shrink-0 ml-4" title="스크랩 해제">' +
                        '<i data-lucide="bookmark" class="w-5 h-5 fill-rose-500"></i>' +
                    '</button>' +
                '</div>';
            }).join('');

            if (!scrapExpanded && remaining > 0) {
                html += '<button onclick="toggleScrapExpand()" class="w-full mt-2 py-2.5 text-sm font-medium text-indigo-600 hover:bg-indigo-50 rounded-xl transition-colors flex items-center justify-center gap-1">' +
                    '<i data-lucide="chevron-down" class="w-4 h-4"></i> 더보기 (' + remaining + '개 더)' +
                '</button>';
            } else if (scrapExpanded && allScrapItems.length > SCRAP_SHOW) {
                html += '<button onclick="toggleScrapExpand()" class="w-full mt-2 py-2.5 text-sm font-medium text-slate-400 hover:bg-slate-50 rounded-xl transition-colors flex items-center justify-center gap-1">' +
                    '<i data-lucide="chevron-up" class="w-4 h-4"></i> 접기' +
                '</button>';
            }

            container.innerHTML = html;
            lucide.createIcons();
        }

        function toggleScrapExpand() {
            scrapExpanded = !scrapExpanded;
            renderScrapList();
        }

        async function loadScrappedPolicies() {
            try {
                var res = await fetch('/api/policies/my-scraps');
                var data = await res.json();
                allScrapItems = data.items || [];
                document.getElementById('scrapCount').textContent = data.count || 0;
                renderScrapList();
            } catch (err) {
                console.error('스크랩 목록 로딩 오류:', err);
                document.getElementById('scrapList').innerHTML = '<p class="text-sm text-slate-400 text-center py-4">불러오기 실패</p>';
            }
        }

        async function removeScrap(event, policyId) {
            event.preventDefault();
            event.stopPropagation();
            var res = await fetch('/api/policies/' + policyId + '/scrap', { method: 'POST' });
            var data = await res.json();
            if (!data.error) {
                // 삭제 후 접혀있던 상태 유지
                if (allScrapItems.length - 1 <= SCRAP_SHOW) scrapExpanded = false;
                loadScrappedPolicies();
            }
        }

        // ── 공간 예약 내역 로드 ──────────────────────────────────────
        function statusBadgeClass(status) {
            if (status === 'PENDING')   return 'bg-amber-100 text-amber-700';
            if (status === 'APPROVED')  return 'bg-blue-100 text-blue-700';
            if (status === 'REJECTED')  return 'bg-slate-100 text-slate-500';
            if (status === 'CANCELLED') return 'bg-rose-100 text-rose-500';
            return 'bg-slate-100 text-slate-500';
        }
        function statusLabel(status) {
            if (status === 'PENDING')   return '승인 대기';
            if (status === 'APPROVED')  return '예약 확정';
            if (status === 'REJECTED')  return '거절됨';
            if (status === 'CANCELLED') return '취소됨';
            return status;
        }

        var allReservationItems = [];
        var reservationExpanded = false;
        var RES_SHOW = 3;

        function getTodayStr() {
            var d = new Date();
            return d.getFullYear() + '-' + String(d.getMonth()+1).padStart(2,'0') + '-' + String(d.getDate()).padStart(2,'0');
        }

        function updateUpcomingCount() {
            var now = new Date();
            var count = allReservationItems.filter(function(r) {
                if (r.status !== 'PENDING' && r.status !== 'APPROVED') return false;
                // 종료 시간 기준으로 아직 끝나지 않은 예약만 카운트
                var endDateTime = new Date(r.useDate + 'T' + r.endTime);
                return endDateTime > now;
            }).length;
            document.getElementById('upcomingCount').textContent = count;
        }

        function renderReservationList() {
            var container = document.getElementById('reservationList');

            if (allReservationItems.length === 0) {
                container.innerHTML = '<p class="text-sm text-slate-400 text-center py-4">예약 내역이 없습니다.<br><a href="/space" class="text-blue-500 hover:underline mt-1 inline-block">공간 둘러보기</a></p>';
                lucide.createIcons();
                return;
            }

            var now = new Date();
            var visible   = reservationExpanded ? allReservationItems : allReservationItems.slice(0, RES_SHOW);
            var remaining = allReservationItems.length - RES_SHOW;

            var html = visible.map(function(r) {
                var isPast = new Date(r.useDate + 'T' + r.endTime) <= now;
                var isCompleted = isPast && (r.status === 'PENDING' || r.status === 'APPROVED');

                var badgeClass = isCompleted ? 'bg-slate-100 text-slate-500' : statusBadgeClass(r.status);
                var label      = isCompleted ? '이용 완료'                    : statusLabel(r.status);
                var cancelBtn  = (!isPast && (r.status === 'PENDING' || r.status === 'APPROVED'))
                    ? '<button onclick="cancelReservation(' + r.reservationId + ')" ' +
                      'class="mt-1.5 text-xs text-rose-500 hover:text-rose-700 hover:underline transition-colors">예약 취소</button>'
                    : '';

                var imgUrl = r.mainImageUrl || '/space-images/main/0';
                var imgStyle = 'background-image:url(\'' + imgUrl + '\')';
                return '<div class="flex items-center justify-between p-4 rounded-xl border border-slate-100 hover:bg-slate-50/60 transition-colors">' +
                    '<div class="flex gap-4 items-center min-w-0">' +
                        '<div class="w-14 h-14 rounded-lg bg-slate-200 bg-cover bg-center flex-shrink-0" style="' + imgStyle + '"></div>' +
                        '<div class="min-w-0">' +
                            '<span class="inline-block px-2 py-0.5 ' + badgeClass + ' text-xs font-bold rounded mb-1">' + label + '</span>' +
                            '<h3 class="font-bold text-slate-900 truncate">' + escapeHtml(r.spaceName) + '</h3>' +
                            '<p class="text-xs text-slate-500 mt-0.5">' + escapeHtml(r.useDate) + ' ' + escapeHtml(r.startTime) + ' ~ ' + escapeHtml(r.endTime) + '</p>' +
                            cancelBtn +
                        '</div>' +
                    '</div>' +
                    '<p class="text-sm font-bold text-slate-700 flex-shrink-0 ml-4">' + Number(r.totalPrice).toLocaleString() + '원</p>' +
                '</div>';
            }).join('');

            if (!reservationExpanded && remaining > 0) {
                html += '<button onclick="toggleReservationExpand()" ' +
                    'class="w-full mt-2 py-2.5 text-sm font-medium text-blue-600 hover:bg-blue-50 rounded-xl transition-colors flex items-center justify-center gap-1">' +
                    '<i data-lucide="chevron-down" class="w-4 h-4"></i> 더보기 (' + remaining + '개 더)' +
                '</button>';
            } else if (reservationExpanded && allReservationItems.length > RES_SHOW) {
                html += '<button onclick="toggleReservationExpand()" ' +
                    'class="w-full mt-2 py-2.5 text-sm font-medium text-slate-400 hover:bg-slate-50 rounded-xl transition-colors flex items-center justify-center gap-1">' +
                    '<i data-lucide="chevron-up" class="w-4 h-4"></i> 접기' +
                '</button>';
            }

            container.innerHTML = html;
            lucide.createIcons();
        }

        function toggleReservationExpand() {
            reservationExpanded = !reservationExpanded;
            renderReservationList();
        }

        async function cancelReservation(reservationId) {
            if (!confirm('예약을 취소하시겠습니까?\n취소 후에는 되돌릴 수 없습니다.')) return;
            try {
                const res  = await fetch('/api/spaces/reservations/' + reservationId + '/cancel', { method: 'POST' });
                const data = await res.json();
                if (data.success) {
                    // 전체 재로드 없이 해당 항목 상태만 업데이트
                    var item = allReservationItems.find(function(r) { return r.reservationId === reservationId; });
                    if (item) item.status = 'CANCELLED';
                    if (allReservationItems.length - 1 <= RES_SHOW) reservationExpanded = false;
                    updateUpcomingCount();
                    renderReservationList();
                } else {
                    alert('취소 실패: ' + (data.error || '알 수 없는 오류'));
                }
            } catch (err) {
                alert('서버 통신 오류가 발생했습니다.');
            }
        }

        async function loadMyReservations() {
            try {
                const res  = await fetch('/api/spaces/my/reservations');
                const data = await res.json();

                allReservationItems = data.items || [];
                updateUpcomingCount();
                renderReservationList();
            } catch (err) {
                console.error('예약 목록 로딩 오류:', err);
                document.getElementById('reservationList').innerHTML =
                    '<p class="text-sm text-slate-400 text-center py-4">불러오기 실패</p>';
            }
        }

        // ── 컨설팅 내역 로드 ──────────────────────────────────────────
        function consultingStatusBadge(status) {
            if (status === 'PENDING')   return '<span class="inline-block px-2 py-1 bg-amber-100 text-amber-700 text-xs font-bold rounded">답변 대기</span>';
            if (status === 'ACCEPTED')  return '<span class="inline-block px-2 py-1 bg-emerald-100 text-emerald-700 text-xs font-bold rounded">진행 중</span>';
            if (status === 'REJECTED')  return '<span class="inline-block px-2 py-1 bg-red-100 text-red-600 text-xs font-bold rounded">거절됨</span>';
            if (status === 'CANCELLED') return '<span class="inline-block px-2 py-1 bg-slate-100 text-slate-500 text-xs font-bold rounded">취소됨</span>';
            return '';
        }

        async function loadMyConsultings() {
            try {
                var res  = await fetch('/api/consulting/my/requests');
                var data = await res.json();
                var items = data.items || [];

                // 진행 중(PENDING + ACCEPTED) 건수
                var activeCount = items.filter(function(i) {
                    return i.status === 'PENDING' || i.status === 'ACCEPTED';
                }).length;
                document.getElementById('consultingCount').textContent = activeCount;

                var container = document.getElementById('consultingList');
                if (items.length === 0) {
                    container.innerHTML = '<p class="text-sm text-slate-400 text-center py-4">자문 요청 내역이 없습니다.<br><a href="/consulting" class="text-purple-500 hover:underline mt-1 inline-block">전문가 찾기</a></p>';
                    lucide.createIcons();
                    return;
                }

                var html = items.slice(0, 5).map(function(r) {
                    var actionBtn = '';
                    if (r.status === 'PENDING') {
                        actionBtn = '<button onclick="cancelConsulting(' + r.requestId + ')" class="mt-2 text-xs text-rose-500 hover:underline">요청 취소</button>';
                    } else if (r.status === 'ACCEPTED') {
                        actionBtn = '<button onclick="openStatusChat(' + r.requestId + ')" class="mt-2 inline-flex items-center gap-1 text-xs font-bold text-violet-600 hover:text-violet-800 transition-colors">'
                            + '<svg xmlns="http://www.w3.org/2000/svg" class="w-3.5 h-3.5" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2.5"><path stroke-linecap="round" stroke-linejoin="round" d="M8 10h.01M12 10h.01M16 10h.01M9 16H5a2 2 0 01-2-2V6a2 2 0 012-2h14a2 2 0 012 2v8a2 2 0 01-2 2h-5l-5 5v-5z"/></svg>'
                            + '채팅하기</button>';
                    }
                    return '<div class="flex items-start justify-between p-4 rounded-xl border border-slate-100 bg-slate-50">' +
                        '<div class="min-w-0">' +
                            '<div class="flex items-center gap-2 mb-1">' +
                                consultingStatusBadge(r.status) +
                                '<span class="text-xs text-slate-500">' + escapeHtml(r.expertOffice) + ' ' + escapeHtml(r.expertType) + '</span>' +
                            '</div>' +
                            '<h3 class="font-medium text-slate-900 truncate">' + escapeHtml(r.title) + '</h3>' +
                            '<p class="text-xs text-slate-400 mt-1">작성일: ' + escapeHtml(r.createdAt) + '</p>' +
                            actionBtn +
                        '</div>' +
                    '</div>';
                }).join('');

                if (items.length > 5) {
                    html += '<a href="/consulting" class="block text-center text-sm font-medium text-purple-600 hover:underline mt-2">전체 보기 (' + items.length + '건)</a>';
                }

                container.innerHTML = html;
                lucide.createIcons();
            } catch (err) {
                console.error('컨설팅 목록 로딩 오류:', err);
                document.getElementById('consultingList').innerHTML =
                    '<p class="text-sm text-slate-400 text-center py-4">불러오기 실패</p>';
            }
        }

        async function cancelConsulting(requestId) {
            if (!confirm('자문요청을 취소하시겠습니까?')) return;
            try {
                var res  = await fetch('/api/consulting/requests/' + requestId + '/cancel', { method: 'POST' });
                var data = await res.json();
                if (data.success) {
                    loadMyConsultings();
                } else {
                    alert('취소 실패: ' + (data.error || '알 수 없는 오류'));
                }
            } catch (err) {
                alert('서버 통신 오류가 발생했습니다.');
            }
        }

        // ── 채팅 패널 (사용자 측) ──────────────────────────────────────
        let _statusChatRequestId = null;
        let _statusPollTimer = null;
        let _statusLastMsgCount = 0;

        window.openStatusChat = async function (requestId) {
            _statusChatRequestId = requestId;
            _statusLastMsgCount  = -1; // -1로 초기화해야 0개 메시지도 정상 렌더링됨
            const panel   = document.getElementById('statusChatPanel');
            const overlay = document.getElementById('statusChatOverlay');
            panel.style.transform    = 'translateX(0)';
            panel.style.opacity      = '1';
            panel.style.pointerEvents= 'auto';
            overlay.classList.remove('hidden');
            document.getElementById('statusChatInput').value = ''; // 이전 입력 내용 초기화
            document.getElementById('statusChatMessages').innerHTML =
                '<p class="text-center text-slate-400 text-xs py-8">불러오는 중...</p>';
            await fetchStatusMessages();
            _statusPollTimer = setInterval(fetchStatusMessages, 3000);
        };

        window.closeStatusChat = function () {
            if (_statusPollTimer) { clearInterval(_statusPollTimer); _statusPollTimer = null; }
            _statusChatRequestId = null;
            const panel   = document.getElementById('statusChatPanel');
            const overlay = document.getElementById('statusChatOverlay');
            panel.style.transform    = 'translateX(100%)';
            panel.style.opacity      = '0';
            panel.style.pointerEvents= 'none';
            overlay.classList.add('hidden');
        };

        async function fetchStatusMessages() {
            if (!_statusChatRequestId) return;
            try {
                const res  = await fetch('/api/consulting/requests/' + _statusChatRequestId + '/messages');
                const data = await res.json();
                if (data.error) return;

                document.getElementById('statusChatTitle').textContent = data.requestTitle || '자문 채팅';

                const items = data.items || [];
                if (items.length === _statusLastMsgCount) return;
                _statusLastMsgCount = items.length;

                const box = document.getElementById('statusChatMessages');
                if (items.length === 0) {
                    box.innerHTML = '<p class="text-center text-slate-400 text-xs py-8">아직 메시지가 없습니다.<br>전문가의 첫 메시지를 기다려 주세요.</p>';
                    return;
                }

                box.innerHTML = items.map(function(m) {
                    var isMine = m.isMine;
                    var bubbleCls = isMine
                        ? 'background:#6d28d9;color:white;border-radius:18px 18px 4px 18px;'
                        : 'background:#f1f5f9;color:#1e293b;border-radius:18px 18px 18px 4px;';
                    var wrapCls = isMine ? 'display:flex;justify-content:flex-end;' : 'display:flex;justify-content:flex-start;';
                    var roleLabel = m.senderRole === 'EXPERT' ? '전문가' : '나';
                    return '<div style="' + wrapCls + 'margin-bottom:8px;">'
                        + '<div style="max-width:75%;">'
                        + (!isMine ? '<p style="font-size:10px;color:#94a3b8;margin-bottom:3px;margin-left:4px;">' + roleLabel + '</p>' : '')
                        + '<div style="' + bubbleCls + 'padding:10px 14px;font-size:14px;line-height:1.5;">' + escapeHtml(m.content) + '</div>'
                        + '<p style="font-size:10px;color:#94a3b8;margin-top:3px;' + (isMine ? 'text-align:right;margin-right:4px;' : 'margin-left:4px;') + '">' + escapeHtml(m.createdAt) + '</p>'
                        + '</div>'
                        + '</div>';
                }).join('');

                box.scrollTop = box.scrollHeight;
            } catch (e) {
                console.error('채팅 폴링 오류:', e);
            }
        }

        window.handleStatusChatKey = function (e) {
            if (e.key === 'Enter' && !e.shiftKey) {
                e.preventDefault();
                sendStatusChatMessage();
            }
        };

        window.sendStatusChatMessage = async function () {
            if (!_statusChatRequestId) return;
            const input   = document.getElementById('statusChatInput');
            const content = input.value.trim();
            if (!content) return;
            input.value    = '';
            input.disabled = true;
            try {
                const params = new URLSearchParams();
                params.append('content', content);
                const res  = await fetch('/api/consulting/requests/' + _statusChatRequestId + '/messages', {
                    method: 'POST', body: params
                });
                const data = await res.json();
                if (data.error) { alert(data.error); return; }
                _statusLastMsgCount = -1; // 강제 리렌더
                await fetchStatusMessages();
            } catch (e) {
                alert('전송 중 오류가 발생했습니다.');
            } finally {
                input.disabled = false;
                input.focus();
            }
        };

        // 포인트 포맷팅 (천단위 쉼표)
        function formatPoint() {
            const pointElement = document.getElementById('statusPointDisplay');
            if (pointElement) {
                const point = parseInt(pointElement.textContent);
                if (!isNaN(point)) {
                    pointElement.textContent = point.toLocaleString();
                }
            }
        }

        // 루사이드 아이콘 초기화 및 데이터 로드
        lucide.createIcons();
        formatPoint();
        loadScrappedPolicies();
        loadMyReservations();
        loadMyConsultings();
    </script>
</body>
</html>
