<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>예약 관리 대시보드 - City Biz Hub</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script src="https://unpkg.com/lucide@latest"></script>
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Pretendard:wght@300;400;500;600;700;800&display=swap');
        body { font-family: 'Pretendard', sans-serif; -webkit-font-smoothing: antialiased; }
    </style>
</head>
<body class="bg-[#F8FAFC] flex flex-col min-h-screen text-slate-800">

    <jsp:include page="/WEB-INF/views/common/header.jsp" />

    <main class="flex-grow max-w-6xl mx-auto w-full px-4 sm:px-6 py-12">

        <div class="mb-8 flex justify-between items-end">
            <div>
                <span class="bg-indigo-100 text-indigo-700 text-xs font-bold px-3 py-1 rounded-full mb-3 inline-block">호스트 대시보드</span>
                <h1 class="text-3xl font-extrabold text-slate-900 tracking-tight">예약 관리</h1>
                <p class="text-slate-500 mt-2">내 공간에 들어온 예약 요청을 확인하고 승인/거절할 수 있습니다.</p>
            </div>
            <%-- [수정된 부분] href를 막고 onclick 이벤트로 자바스크립트 함수를 호출하도록 변경 --%>
            <a href="javascript:void(0);" onclick="checkSubscriptionAndRedirect()" class="hidden sm:flex items-center gap-2 bg-white border border-slate-200 px-4 py-2 rounded-xl text-sm font-bold text-slate-600 hover:bg-slate-50 transition-colors">
                <i data-lucide="plus" class="w-4 h-4"></i> 새 공간 등록
            </a>
        </div>

        <%-- 플랜 정보 카드 --%>
        <div class="bg-gradient-to-r from-indigo-50 to-purple-50 rounded-3xl p-6 border border-indigo-200 shadow-sm mb-8">
            <div class="flex items-center justify-between">
                <div class="flex items-center gap-4">
                    <div class="bg-indigo-100 p-4 rounded-2xl text-indigo-600">
                        <i data-lucide="star" class="w-8 h-8"></i>
                    </div>
                    <div>
                        <p class="text-sm font-semibold text-slate-600">현재 플랜</p>
                        <c:choose>
                            <c:when test="${planType == 'MONTHLY'}">
                                <p class="text-2xl font-bold text-indigo-900">월간 플랜</p>
                            </c:when>
                            <c:when test="${planType == 'YEARLY'}">
                                <p class="text-2xl font-bold text-indigo-900">연간 플랜</p>
                            </c:when>
                            <c:otherwise>
                                <p class="text-2xl font-bold text-slate-500">플랜 미가입</p>
                            </c:otherwise>
                        </c:choose>
                        <c:if test="${planExpiresAt != null}">
                            <p class="text-sm text-slate-600 mt-1">
                                <span id="daysRemaining">계산 중...</span>일 남음
                            </p>
                        </c:if>
                    </div>
                </div>
                <c:if test="${planType == 'MONTHLY' || planType == 'YEARLY'}">
                    <a href="/charge/plan" class="bg-indigo-600 text-white px-6 py-3 rounded-xl font-semibold hover:bg-indigo-700 transition">플랜 갱신</a>
                </c:if>
                <c:if test="${planType == 'FREE' || planType == null}">
                    <a href="/charge/plan" class="bg-indigo-600 text-white px-6 py-3 rounded-xl font-semibold hover:bg-indigo-700 transition">플랜 가입하기</a>
                </c:if>
            </div>
        </div>

        <%-- 상단 요약 카드 --%>
        <div class="grid grid-cols-1 md:grid-cols-3 gap-6 mb-8">
            <div class="bg-white rounded-3xl p-6 border border-slate-200 shadow-sm flex items-center gap-4">
                <div class="bg-amber-100 p-4 rounded-2xl text-amber-600">
                    <i data-lucide="clock" class="w-8 h-8"></i>
                </div>
                <div>
                    <p class="text-sm font-semibold text-slate-500">승인 대기</p>
                    <p class="text-2xl font-bold text-slate-900"><span id="pendingCount">-</span><span class="text-base font-medium text-slate-500 ml-1">건</span></p>
                </div>
            </div>
            <div class="bg-white rounded-3xl p-6 border border-slate-200 shadow-sm flex items-center gap-4">
                <div class="bg-blue-100 p-4 rounded-2xl text-blue-600">
                    <i data-lucide="calendar-check" class="w-8 h-8"></i>
                </div>
                <div>
                    <p class="text-sm font-semibold text-slate-500">이번 달 확정 예약</p>
                    <p class="text-2xl font-bold text-slate-900"><span id="approvedCount">-</span><span class="text-base font-medium text-slate-500 ml-1">건</span></p>
                </div>
            </div>
            <div class="bg-white rounded-3xl p-6 border border-slate-200 shadow-sm flex items-center gap-4">
                <div class="bg-emerald-100 p-4 rounded-2xl text-emerald-600">
                    <i data-lucide="banknote" class="w-8 h-8"></i>
                </div>
                <div>
                    <p class="text-sm font-semibold text-slate-500">이번 달 예상 수익</p>
                    <p class="text-2xl font-bold text-slate-900"><span id="monthRevenue">-</span><span class="text-base font-medium text-slate-500 ml-1">원</span></p>
                </div>
            </div>
        </div>

        <%-- 예약 목록 테이블 --%>
        <section class="bg-white rounded-3xl border border-slate-200 shadow-sm overflow-hidden">
            <div class="p-6 border-b border-slate-100 flex justify-between items-center bg-slate-50/50">
                <h2 class="text-lg font-bold text-slate-900 flex items-center gap-2">
                    <i data-lucide="list" class="w-5 h-5 text-indigo-500"></i> 전체 예약 내역
                </h2>
                <select id="statusFilter" onchange="applyFilter()"
                        class="bg-white border border-slate-200 text-sm rounded-lg px-3 py-2 focus:outline-none focus:ring-2 focus:ring-indigo-500">
                    <option value="">전체 상태</option>
                    <option value="PENDING">승인 대기</option>
                    <option value="APPROVED">예약 확정</option>
                    <option value="REJECTED">거절됨</option>
                    <option value="CANCELLED">신청자 취소</option>
                </select>
            </div>

            <div class="overflow-x-auto">
                <table class="w-full text-left text-sm text-slate-600">
                    <thead class="bg-slate-50 text-slate-500 font-semibold border-b border-slate-200">
                        <tr>
                            <th class="px-6 py-4">예약자 정보</th>
                            <th class="px-6 py-4">예약 공간</th>
                            <th class="px-6 py-4">이용 일시</th>
                            <th class="px-6 py-4">결제 금액</th>
                            <th class="px-6 py-4">상태</th>
                            <th class="px-6 py-4 text-center">관리</th>
                        </tr>
                    </thead>
                    <tbody id="reservation-list" class="divide-y divide-slate-100">
                        <tr id="loadingRow">
                            <td colspan="6" class="px-6 py-10 text-center text-slate-400">불러오는 중...</td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </section>

    </main>

    <jsp:include page="/WEB-INF/views/common/footer.jsp" />

    <script>
        lucide.createIcons();

        // 플랜 남은 일수 계산
        const planExpiresAt = '${planExpiresAt}';
        if (planExpiresAt) {
            const expiresDate = new Date(planExpiresAt);
            const today = new Date();
            const diffTime = expiresDate - today;
            const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24));
            document.getElementById('daysRemaining').textContent = Math.max(0, diffDays);
        }

        let allReservations = [];

        function escapeHtml(val) {
            return String(val || '').replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;').replace(/"/g,'&quot;');
        }

        function statusBadge(status) {
            if (status === 'PENDING')   return '<span class="bg-amber-100 text-amber-700 px-2.5 py-1 rounded-md text-xs font-bold">승인 대기</span>';
            if (status === 'APPROVED')  return '<span class="bg-blue-100 text-blue-700 px-2.5 py-1 rounded-md text-xs font-bold">예약 확정</span>';
            if (status === 'REJECTED')  return '<span class="bg-slate-100 text-slate-600 px-2.5 py-1 rounded-md text-xs font-bold">거절됨</span>';
            if (status === 'CANCELLED') return '<span class="bg-rose-100 text-rose-600 px-2.5 py-1 rounded-md text-xs font-bold">신청자 취소</span>';
            return '<span class="bg-slate-100 text-slate-500 px-2.5 py-1 rounded-md text-xs font-bold">' + escapeHtml(status) + '</span>';
        }

        function actionButtons(res) {
            if (res.status === 'PENDING') {
                return '<button onclick="handleAction(' + res.reservationId + ',\'APPROVED\')" class="px-3 py-1.5 bg-blue-600 text-white rounded-lg text-xs font-bold hover:bg-blue-700 transition-colors">승인</button>' +
                       '<button onclick="handleAction(' + res.reservationId + ',\'REJECTED\')" class="px-3 py-1.5 bg-rose-500 text-white rounded-lg text-xs font-bold hover:bg-rose-600 transition-colors">거절</button>';
            }
            return '<span class="text-xs text-slate-400 font-medium">처리 완료</span>';
        }

        function renderTable(list) {
            const tbody = document.getElementById('reservation-list');
            if (list.length === 0) {
                tbody.innerHTML = '<tr><td colspan="6" class="px-6 py-10 text-center text-slate-400">예약 내역이 없습니다.</td></tr>';
                return;
            }
            tbody.innerHTML = list.map(function(res) {
                return '<tr class="hover:bg-slate-50 transition-colors">' +
                    '<td class="px-6 py-4"><p class="font-bold text-slate-900">' + escapeHtml(res.userName) + '</p>' +
                        '<p class="text-xs text-slate-500">' + escapeHtml(res.userPhone) + '</p></td>' +
                    '<td class="px-6 py-4 font-medium text-slate-800">' + escapeHtml(res.spaceName) + '</td>' +
                    '<td class="px-6 py-4"><p class="text-slate-900">' + escapeHtml(res.useDate) + '</p>' +
                        '<p class="text-xs text-slate-500">' + escapeHtml(res.startTime) + ' ~ ' + escapeHtml(res.endTime) + '</p>' +
                        (res.userMemo ? '<p class="text-xs text-indigo-500 mt-0.5">"' + escapeHtml(res.userMemo) + '"</p>' : '') + '</td>' +
                    '<td class="px-6 py-4 font-bold text-slate-900">' + Number(res.totalPrice).toLocaleString() + '원</td>' +
                    '<td class="px-6 py-4">' + statusBadge(res.status) + '</td>' +
                    '<td class="px-6 py-4"><div class="flex justify-center gap-2">' + actionButtons(res) + '</div></td>' +
                '</tr>';
            }).join('');
            lucide.createIcons();
        }

        function applyFilter() {
            const filter = document.getElementById('statusFilter').value;
            const filtered = filter ? allReservations.filter(function(r) { return r.status === filter; }) : allReservations;
            renderTable(filtered);
        }

        async function handleAction(reservationId, newStatus) {
            const label = newStatus === 'APPROVED' ? '승인' : '거절';
            if (!confirm('해당 예약을 ' + label + '하시겠습니까?')) return;

            try {
                const res  = await fetch('/api/spaces/reservations/' + reservationId + '/status?status=' + newStatus, { method: 'PATCH' });
                const data = await res.json();
                if (data.success) {
                    const r = allReservations.find(function(x) { return x.reservationId === reservationId; });
                    if (r) r.status = newStatus;
                    applyFilter();
                    loadSummary();
                } else {
                    alert('처리 실패: ' + (data.error || '알 수 없는 오류'));
                }
            } catch (err) {
                alert('서버 통신 오류가 발생했습니다.');
            }
        }

        function loadSummary() {
            const pending  = allReservations.filter(function(r) { return r.status === 'PENDING'; }).length;
            document.getElementById('pendingCount').textContent  = pending;
        }

        async function loadReservations() {
            try {
                const res  = await fetch('/api/spaces/host/reservations');
                const data = await res.json();

                if (data.error) {
                    document.getElementById('reservation-list').innerHTML =
                        '<tr><td colspan="6" class="px-6 py-10 text-center text-rose-400">' + escapeHtml(data.error) + '</td></tr>';
                    return;
                }

                allReservations = data.items || [];
                document.getElementById('pendingCount').textContent  = data.pendingCount  || 0;
                document.getElementById('approvedCount').textContent = data.approvedCount || 0;
                document.getElementById('monthRevenue').textContent  = Number(data.monthRevenue || 0).toLocaleString();

                applyFilter();
            } catch (err) {
                console.error('예약 목록 로딩 오류:', err);
                document.getElementById('reservation-list').innerHTML =
                    '<tr><td colspan="6" class="px-6 py-10 text-center text-slate-400">불러오기 실패</td></tr>';
            }
        }

        // [수정된 부분] 중복된 함수들을 하나로 통합하고 경로를 컨트롤러에 맞게(/charge/plan) 설정
        function checkSubscriptionAndRedirect() {
            // 세션에서 로그인 유저의 멤버십 상태를 가져옴 (FREE 또는 PAID)
            const userMembership = '${sessionScope.loginUserMembership}'; 

            if (userMembership !== 'PAID') {
                if (confirm('공간 등록은 유료 플랜 가입 후 이용 가능합니다.\n요금제 안내 페이지로 이동하시겠습니까?')) {
                    location.href = '/charge/plan';
                }
            } else {
                location.href = '/mypage/spaceRegi';
            }
        }

        // 페이지 로드 시 예약 목록 불러오기 실행
        loadReservations();
    </script>
</body>
</html>