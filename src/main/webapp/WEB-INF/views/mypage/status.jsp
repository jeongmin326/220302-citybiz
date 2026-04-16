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
    <main class="flex-grow max-w-7xl mx-auto w-full px-4 sm:px-6 lg:px-8 py-10">
        
        <%-- 상단 헤더 영역 --%>
        <div class="mb-10">
            <h1 class="text-3xl font-bold text-slate-900 tracking-tight">내 활동 내역</h1>
            <p class="text-slate-500 mt-2">${not empty sessionScope.loginName ? sessionScope.loginName : '사용자'}님의 비즈니스 활동 현황입니다.</p>
        </div>

        <%-- 1. 대시보드 요약 (Overview) --%>
        <div class="grid grid-cols-1 md:grid-cols-3 gap-6 mb-12">
            <div class="bg-white rounded-2xl p-6 border border-slate-200 shadow-sm flex items-center gap-5">
                <div class="w-14 h-14 rounded-full bg-blue-50 flex items-center justify-center text-blue-600">
                    <i data-lucide="calendar-check" class="w-7 h-7"></i>
                </div>
                <div>
                    <p class="text-sm font-medium text-slate-500">다가오는 예약</p>
                    <p class="text-2xl font-bold text-slate-900 mt-1"><span id="upcomingCount">-</span><span class="text-base font-medium text-slate-500 ml-1">건</span></p>
                </div>
            </div>
            <div class="bg-white rounded-2xl p-6 border border-slate-200 shadow-sm flex items-center gap-5">
                <div class="w-14 h-14 rounded-full bg-indigo-50 flex items-center justify-center text-indigo-600">
                    <i data-lucide="bookmark" class="w-7 h-7"></i>
                </div>
                <div>
                    <p class="text-sm font-medium text-slate-500">스크랩한 정책</p>
                    <p class="text-2xl font-bold text-slate-900 mt-1"><span id="scrapCount">-</span><span class="text-base font-medium text-slate-500 ml-1">건</span></p>
                </div>
            </div>
            <div class="bg-white rounded-2xl p-6 border border-slate-200 shadow-sm flex items-center gap-5">
                <div class="w-14 h-14 rounded-full bg-purple-50 flex items-center justify-center text-purple-600">
                    <i data-lucide="message-square" class="w-7 h-7"></i>
                </div>
                <div>
                    <p class="text-sm font-medium text-slate-500">진행 중인 컨설팅</p>
                    <p class="text-2xl font-bold text-slate-900 mt-1">1<span class="text-base font-medium text-slate-500 ml-1">건</span></p>
                </div>
            </div>
        </div>

        <div class="grid grid-cols-1 lg:grid-cols-3 gap-8">
            
            <%-- 좌측 및 중앙 컨텐츠 영역 --%>
            <div class="lg:col-span-2 space-y-8">
                
                <%-- 2. 공간 대여 이용 내역 --%>
                <section class="bg-white rounded-2xl border border-slate-200 shadow-sm overflow-hidden">
                    <div class="px-6 py-5 border-b border-slate-100 flex justify-between items-center bg-slate-50/50">
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
                <section class="bg-white rounded-2xl border border-slate-200 shadow-sm overflow-hidden">
                    <div class="px-6 py-5 border-b border-slate-100 flex justify-between items-center bg-slate-50/50">
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
                <section class="bg-white rounded-2xl border border-slate-200 shadow-sm overflow-hidden">
                    <div class="px-6 py-5 border-b border-slate-100 flex justify-between items-center bg-slate-50/50">
                        <h2 class="text-lg font-bold text-slate-900 flex items-center gap-2">
                            <i data-lucide="network" class="w-5 h-5 text-purple-500"></i> 컨설팅 진행 현황
                        </h2>
                        <a href="/consulting" class="text-sm font-medium text-purple-600 hover:underline">새 문의하기</a>
                    </div>
                    <div class="p-6 space-y-4">
                        <div class="flex items-center justify-between p-4 rounded-xl border border-slate-100 bg-slate-50">
                            <div>
                                <div class="flex items-center gap-2 mb-1">
                                    <span class="inline-block px-2 py-1 bg-purple-100 text-purple-700 text-xs font-bold rounded">답변 대기</span>
                                    <span class="text-xs text-slate-500">김세무 전문가</span>
                                </div>
                                <h3 class="font-medium text-slate-900">법인 설립 시 초기 세무 기장 관련 문의드립니다.</h3>
                                <p class="text-xs text-slate-400 mt-1">작성일: 2026.04.05</p>
                            </div>
                            <button class="text-sm text-slate-500 hover:text-slate-900 underline underline-offset-2">내용 보기</button>
                        </div>
                    </div>
                </section>

            </div>

            <%-- 우측 사이드바 영역 (프로필 관리) --%>
            <div class="lg:col-span-1">
                <%-- 5. 비즈니스 프로필 관리 --%>
                <section class="bg-slate-900 rounded-2xl shadow-lg overflow-hidden sticky top-28">
                    <div class="px-6 py-5 border-b border-slate-700 flex items-center justify-between">
                        <h2 class="text-lg font-bold text-white flex items-center gap-2">
                            <i data-lucide="settings" class="w-5 h-5 text-slate-400"></i> 맞춤 추천 설정
                        </h2>
                    </div>
                    <div class="p-6">
                        <p class="text-sm text-slate-400 mb-6 leading-relaxed">
                            아래 비즈니스 정보를 최신 상태로 유지하시면, 기업 조건에 맞는 <strong>지원 사업과 전문가를 더 정확하게 추천</strong>해 드립니다.
                        </p>
                        
                        <form action="/mypage/updateProfile" method="POST" class="space-y-4">
                            <div>
                                <label class="block text-xs font-medium text-slate-400 mb-1">기업명 (또는 예비창업팀명)</label>
                                <input type="text" value="시티비즈팀" class="w-full bg-slate-800 border border-slate-700 rounded-lg px-3 py-2.5 text-white text-sm focus:outline-none focus:border-blue-500 focus:ring-1 focus:ring-blue-500 transition-all">
                            </div>
                            <div>
                                <label class="block text-xs font-medium text-slate-400 mb-1">창업 단계</label>
                                <select class="w-full bg-slate-800 border border-slate-700 rounded-lg px-3 py-2.5 text-white text-sm focus:outline-none focus:border-blue-500 focus:ring-1 focus:ring-blue-500 transition-all">
                                    <option value="pre">예비 창업자</option>
                                    <option value="early" selected>초기 창업 (3년 미만)</option>
                                    <option value="jump">도약기 (3~7년)</option>
                                </select>
                            </div>
                            <div>
                                <label class="block text-xs font-medium text-slate-400 mb-1">관심 산업군</label>
                                <select class="w-full bg-slate-800 border border-slate-700 rounded-lg px-3 py-2.5 text-white text-sm focus:outline-none focus:border-blue-500 focus:ring-1 focus:ring-blue-500 transition-all">
                                    <option value="it" selected>IT / 소프트웨어</option>
                                    <option value="manu">제조업</option>
                                    <option value="service">서비스업</option>
                                </select>
                            </div>
                            <button type="button" class="w-full mt-2 bg-blue-600 hover:bg-blue-700 text-white font-bold py-3 rounded-lg text-sm transition-colors shadow-lg shadow-blue-900/50">
                                정보 업데이트
                            </button>
                        </form>
                    </div>
                </section>
            </div>

        </div>
    </main>

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

                var imgStyle = r.mainImageUrl
                    ? 'background-image:url(\'' + escapeHtml(r.mainImageUrl) + '\')'
                    : 'background-color:#e2e8f0';
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

        // 루사이드 아이콘 초기화 및 데이터 로드
        lucide.createIcons();
        loadScrappedPolicies();
        loadMyReservations();
    </script>
</body>
</html>