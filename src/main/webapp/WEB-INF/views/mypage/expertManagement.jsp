<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>컨설팅 관리 - City Biz Hub</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script src="https://unpkg.com/lucide@latest"></script>
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Pretendard:wght@300;400;500;600;700;800&display=swap');
        body { font-family: 'Pretendard', sans-serif; -webkit-font-smoothing: antialiased; }
        .chat-bubble-expert { background: #6d28d9; color: white; border-radius: 18px 18px 4px 18px; }
        .chat-bubble-user   { background: #f1f5f9; color: #1e293b; border-radius: 18px 18px 18px 4px; }
        #chatPanel { transition: transform 0.3s ease, opacity 0.3s ease; }
        .custom-scrollbar::-webkit-scrollbar { width: 4px; }
        .custom-scrollbar::-webkit-scrollbar-thumb { background: #cbd5e1; border-radius: 2px; }
    </style>
</head>
<body class="bg-[#F8FAFC] flex flex-col min-h-screen text-slate-800">

    <jsp:include page="/WEB-INF/views/common/header.jsp" />

    <main class="flex-grow max-w-6xl mx-auto w-full px-4 sm:px-6 py-12" id="mainContent">

        <div class="mb-8 flex justify-between items-end">
            <div>
                <span class="bg-purple-100 text-purple-700 text-xs font-bold px-3 py-1 rounded-full mb-3 inline-block">전문가 대시보드</span>
                <h1 class="text-3xl font-extrabold text-slate-900 tracking-tight">컨설팅 신청 관리</h1>
                <p class="text-slate-500 mt-2">나에게 들어온 비즈니스 상담 요청 내역을 확인하고 관리합니다.</p>
            </div>
            <a href="/mypage/expertProfile" class="hidden sm:flex items-center gap-2 bg-white border border-slate-200 px-4 py-2 rounded-xl text-sm font-bold text-slate-600 hover:bg-slate-50 transition-colors">
                <i data-lucide="user-cog" class="w-4 h-4"></i> 프로필 수정
            </a>
        </div>

        <%-- 요약 카드 --%>
        <div class="grid grid-cols-1 md:grid-cols-3 gap-6 mb-8">
            <div class="bg-white rounded-3xl p-6 border border-slate-200 shadow-sm flex items-center gap-4">
                <div class="bg-indigo-100 p-4 rounded-2xl text-indigo-600"><i data-lucide="message-square" class="w-8 h-8"></i></div>
                <div>
                    <p class="text-sm font-semibold text-slate-500">새 신청</p>
                    <p class="text-2xl font-bold text-slate-900" id="summaryPending">-<span class="text-base font-medium text-slate-500 ml-1">건</span></p>
                </div>
            </div>
            <div class="bg-white rounded-3xl p-6 border border-slate-200 shadow-sm flex items-center gap-4">
                <div class="bg-emerald-100 p-4 rounded-2xl text-emerald-600"><i data-lucide="check-circle" class="w-8 h-8"></i></div>
                <div>
                    <p class="text-sm font-semibold text-slate-500">진행 중</p>
                    <p class="text-2xl font-bold text-slate-900" id="summaryAccepted">-<span class="text-base font-medium text-slate-500 ml-1">건</span></p>
                </div>
            </div>
            <div class="bg-white rounded-3xl p-6 border border-slate-200 shadow-sm flex items-center gap-4">
                <div class="bg-purple-100 p-4 rounded-2xl text-purple-600"><i data-lucide="star" class="w-8 h-8"></i></div>
                <div>
                    <p class="text-sm font-semibold text-slate-500">누적 신청</p>
                    <p class="text-2xl font-bold text-slate-900" id="summaryTotal">-<span class="text-base font-medium text-slate-500 ml-1">건</span></p>
                </div>
            </div>
        </div>

        <%-- 신청 목록 테이블 --%>
        <section class="bg-white rounded-3xl border border-slate-200 shadow-sm overflow-hidden">
            <div class="p-6 border-b border-slate-100 flex justify-between items-center bg-slate-50/50">
                <h2 class="text-lg font-bold text-slate-900">상담 신청 내역</h2>
            </div>
            <div class="overflow-x-auto">
                <table class="w-full text-left text-sm">
                    <thead class="bg-slate-50 text-slate-500 font-semibold border-b border-slate-200">
                        <tr>
                            <th class="px-6 py-4">신청자</th>
                            <th class="px-6 py-4">자문 제목</th>
                            <th class="px-6 py-4">신청일</th>
                            <th class="px-6 py-4">상태</th>
                            <th class="px-6 py-4 text-center">관리</th>
                        </tr>
                    </thead>
                    <tbody id="consulting-list" class="divide-y divide-slate-100 text-slate-600">
                        <tr id="loadingRow">
                            <td colspan="5" class="px-6 py-10 text-center text-slate-400 text-sm">불러오는 중...</td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </section>
    </main>

    <%-- 내용 확인 모달 --%>
    <div id="contentModal" class="fixed inset-0 z-[200] hidden items-center justify-center">
        <div class="absolute inset-0 bg-black/40 backdrop-blur-sm" onclick="closeContentModal()"></div>
        <div class="relative bg-white rounded-3xl shadow-2xl w-full max-w-lg mx-4 p-8 flex flex-col gap-4">
            <div class="flex justify-between items-start">
                <div>
                    <h3 class="text-lg font-extrabold text-slate-900" id="contentModalTitle"></h3>
                    <p class="text-sm text-slate-500 mt-1" id="contentModalMeta"></p>
                </div>
                <button onclick="closeContentModal()" class="text-slate-400 hover:text-slate-600 ml-4 flex-shrink-0">
                    <svg xmlns="http://www.w3.org/2000/svg" class="w-6 h-6" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path stroke-linecap="round" stroke-linejoin="round" d="M6 18L18 6M6 6l12 12"/></svg>
                </button>
            </div>
            <div id="contentModalBody" class="bg-slate-50 border border-slate-100 rounded-2xl p-4 text-sm text-slate-700 leading-relaxed min-h-[80px] whitespace-pre-wrap"></div>
            <button onclick="closeContentModal()" class="w-full py-3 border border-slate-200 rounded-xl text-sm font-bold text-slate-600 hover:bg-slate-50 transition-colors">닫기</button>
        </div>
    </div>

    <%-- 채팅 사이드 패널 --%>
    <div id="chatPanel" class="fixed top-0 right-0 h-full w-full md:w-[420px] bg-white shadow-2xl z-[150] flex flex-col translate-x-full opacity-0 pointer-events-none border-l border-slate-200">
        <%-- 채팅 헤더 --%>
        <div class="bg-gradient-to-r from-purple-600 to-violet-600 px-6 py-5 flex items-center justify-between flex-shrink-0">
            <div class="min-w-0">
                <p class="text-purple-200 text-xs font-semibold mb-0.5">자문 채팅</p>
                <h3 class="text-white font-bold text-base truncate" id="chatTitle">-</h3>
                <p class="text-purple-200 text-xs mt-0.5" id="chatSubtitle">-</p>
            </div>
            <button onclick="closeChat()" class="text-white/70 hover:text-white transition-colors ml-4 flex-shrink-0">
                <svg xmlns="http://www.w3.org/2000/svg" class="w-6 h-6" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path stroke-linecap="round" stroke-linejoin="round" d="M6 18L18 6M6 6l12 12"/></svg>
            </button>
        </div>

        <%-- 메시지 영역 --%>
        <div id="chatMessages" class="flex-1 overflow-y-auto p-5 space-y-3 bg-slate-50 custom-scrollbar">
            <p class="text-center text-slate-400 text-xs py-8">메시지를 불러오는 중...</p>
        </div>

        <%-- 입력창 --%>
        <div class="px-4 py-4 bg-white border-t border-slate-100 flex-shrink-0">
            <div class="flex gap-2 items-end">
                <textarea id="chatInput" rows="2" placeholder="메시지를 입력하세요..."
                    class="flex-1 bg-slate-50 border border-slate-200 rounded-2xl px-4 py-3 text-sm resize-none focus:outline-none focus:ring-2 focus:ring-purple-200 focus:border-purple-400 transition-all"
                    onkeydown="handleChatKey(event)"></textarea>
                <button onclick="sendChatMessage()" class="w-11 h-11 bg-purple-600 hover:bg-purple-700 rounded-2xl flex items-center justify-center text-white transition-colors shadow-sm flex-shrink-0">
                    <svg xmlns="http://www.w3.org/2000/svg" class="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path stroke-linecap="round" stroke-linejoin="round" d="M5 12h14M12 5l7 7-7 7"/></svg>
                </button>
            </div>
        </div>
    </div>

    <%-- 채팅 패널 열릴 때 배경 오버레이 (모바일) --%>
    <div id="chatOverlay" class="fixed inset-0 bg-black/20 z-[140] hidden md:hidden" onclick="closeChat()"></div>

    <jsp:include page="/WEB-INF/views/common/footer.jsp" />

    <script>
        lucide.createIcons();

        function escapeHtml(v) {
            return String(v || '')
                .replace(/&/g,'&amp;').replace(/</g,'&lt;')
                .replace(/>/g,'&gt;').replace(/"/g,'&quot;');
        }

        function statusBadge(status) {
            const map = {
                PENDING:   '<span class="bg-amber-100 text-amber-700 px-2.5 py-1 rounded-md text-xs font-bold">대기 중</span>',
                ACCEPTED:  '<span class="bg-emerald-100 text-emerald-700 px-2.5 py-1 rounded-md text-xs font-bold">진행 중</span>',
                REJECTED:  '<span class="bg-red-100 text-red-600 px-2.5 py-1 rounded-md text-xs font-bold">거절됨</span>',
                CANCELLED: '<span class="bg-slate-100 text-slate-500 px-2.5 py-1 rounded-md text-xs font-bold">취소됨</span>'
            };
            return map[status] || '<span class="bg-slate-100 text-slate-500 px-2.5 py-1 rounded-md text-xs font-bold">' + escapeHtml(status) + '</span>';
        }

        function actionButtons(item) {
            if (item.status === 'PENDING') {
                return '<div class="flex justify-center gap-2">'
                    + '<button onclick="updateStatus(' + item.requestId + ',\'ACCEPTED\')" class="px-3 py-1.5 bg-purple-600 text-white rounded-lg text-xs font-bold hover:bg-purple-700 transition-colors">수락</button>'
                    + '<button onclick="updateStatus(' + item.requestId + ',\'REJECTED\')" class="px-3 py-1.5 bg-slate-200 text-slate-600 rounded-lg text-xs font-bold hover:bg-slate-300 transition-colors">거절</button>'
                    + '</div>';
            }
            if (item.status === 'ACCEPTED') {
                return '<div class="flex justify-center">'
                    + '<button onclick="openChat(' + item.requestId + ')" class="px-3 py-1.5 bg-violet-600 text-white rounded-lg text-xs font-bold hover:bg-violet-700 transition-colors flex items-center gap-1.5">'
                    + '<svg xmlns="http://www.w3.org/2000/svg" class="w-3.5 h-3.5" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2.5"><path stroke-linecap="round" stroke-linejoin="round" d="M8 10h.01M12 10h.01M16 10h.01M9 16H5a2 2 0 01-2-2V6a2 2 0 012-2h14a2 2 0 012 2v8a2 2 0 01-2 2h-5l-5 5v-5z"/></svg>'
                    + '채팅하기</button>'
                    + '</div>';
            }
            return '<div class="text-center text-slate-400 text-xs">-</div>';
        }

        function renderRow(item) {
            const hasContent = item.content && item.content.trim() !== '';
            const titleCell  = hasContent
                ? '<button onclick="openContentModal(' + item.requestId + ')" class="text-left font-medium text-blue-600 hover:underline">' + escapeHtml(item.title) + '</button>'
                : '<span class="font-medium text-slate-700">' + escapeHtml(item.title) + '</span>';

            return '<tr class="hover:bg-slate-50 transition-colors" data-id="' + item.requestId + '">'
                + '<td class="px-6 py-4"><p class="font-bold text-slate-900">' + escapeHtml(item.userName) + '</p><p class="text-xs text-slate-500">' + escapeHtml(item.companyName || '') + '</p></td>'
                + '<td class="px-6 py-4">' + titleCell + '</td>'
                + '<td class="px-6 py-4">' + escapeHtml(item.createdAt) + '</td>'
                + '<td class="px-6 py-4 status-cell">' + statusBadge(item.status) + '</td>'
                + '<td class="px-6 py-4 action-cell">' + actionButtons(item) + '</td>'
                + '</tr>';
        }

        let _requestsCache = [];

        async function loadRequests() {
            try {
                const res  = await fetch('/api/consulting/expert/requests');
                const data = await res.json();

                if (data.error) {
                    document.getElementById('loadingRow').innerHTML =
                        '<td colspan="5" class="px-6 py-10 text-center text-slate-400 text-sm">' + escapeHtml(data.error) + '</td>';
                    return;
                }

                _requestsCache = data.items || [];

                document.getElementById('summaryPending').innerHTML  = data.pendingCount  + '<span class="text-base font-medium text-slate-500 ml-1">건</span>';
                document.getElementById('summaryAccepted').innerHTML = data.acceptedCount + '<span class="text-base font-medium text-slate-500 ml-1">건</span>';
                document.getElementById('summaryTotal').innerHTML    = data.totalCount    + '<span class="text-base font-medium text-slate-500 ml-1">건</span>';

                const tbody = document.getElementById('consulting-list');
                if (_requestsCache.length === 0) {
                    tbody.innerHTML = '<tr><td colspan="5" class="px-6 py-10 text-center text-slate-400 text-sm">접수된 자문요청이 없습니다.</td></tr>';
                } else {
                    tbody.innerHTML = _requestsCache.map(renderRow).join('');
                }
            } catch (e) {
                document.getElementById('loadingRow').innerHTML =
                    '<td colspan="5" class="px-6 py-10 text-center text-red-400 text-sm">데이터를 불러오지 못했습니다.</td>';
            }
        }

        window.updateStatus = async function (requestId, newStatus) {
            try {
                const params = new URLSearchParams();
                params.append('status', newStatus);
                const res  = await fetch('/api/consulting/requests/' + requestId + '/status', {
                    method: 'PATCH', body: params
                });
                const data = await res.json();
                if (data.error) { alert(data.error); return; }

                const updatedItem = _requestsCache.find(function(i) { return i.requestId === requestId; });
                if (updatedItem) {
                    updatedItem.status = newStatus;
                    const row = document.querySelector('tr[data-id="' + requestId + '"]');
                    if (row) {
                        row.querySelector('.status-cell').innerHTML = statusBadge(newStatus);
                        row.querySelector('.action-cell').innerHTML = actionButtons(updatedItem);
                    }
                }
                // 수락 시 바로 채팅 열기
                if (newStatus === 'ACCEPTED') {
                    loadRequests().then(function() { openChat(requestId); });
                } else {
                    loadRequests();
                }
            } catch (e) {
                alert('처리 중 오류가 발생했습니다.');
            }
        };

        // ── 내용 모달 ────────────────────────────────────────────────
        window.openContentModal = function (requestId) {
            const item = _requestsCache.find(function(i) { return i.requestId === requestId; });
            if (!item) return;
            document.getElementById('contentModalTitle').textContent = item.title;
            document.getElementById('contentModalMeta').textContent  =
                item.userName + (item.companyName ? ' · ' + item.companyName : '') + ' · ' + item.createdAt;
            document.getElementById('contentModalBody').textContent  = item.content || '(상세 내용 없음)';
            const modal = document.getElementById('contentModal');
            modal.classList.remove('hidden');
            modal.classList.add('flex');
        };
        window.closeContentModal = function () {
            const modal = document.getElementById('contentModal');
            modal.classList.add('hidden');
            modal.classList.remove('flex');
        };

        // ── 채팅 패널 ────────────────────────────────────────────────
        let _activeChatRequestId = null;
        let _pollTimer = null;
        let _lastMessageCount = 0;

        window.openChat = async function (requestId) {
            _activeChatRequestId = requestId;
            _lastMessageCount = -1; // -1로 초기화해야 0개 메시지도 정상 렌더링됨

            const panel   = document.getElementById('chatPanel');
            const overlay = document.getElementById('chatOverlay');
            panel.classList.remove('translate-x-full', 'opacity-0', 'pointer-events-none');
            overlay.classList.remove('hidden');

            document.getElementById('chatInput').value = ''; // 이전 입력 내용 초기화
            document.getElementById('chatMessages').innerHTML =
                '<p class="text-center text-slate-400 text-xs py-8">불러오는 중...</p>';

            await fetchMessages();
            startPolling();
        };

        window.closeChat = function () {
            stopPolling();
            _activeChatRequestId = null;
            const panel   = document.getElementById('chatPanel');
            const overlay = document.getElementById('chatOverlay');
            panel.classList.add('translate-x-full', 'opacity-0', 'pointer-events-none');
            overlay.classList.add('hidden');
        };

        function startPolling() {
            stopPolling();
            _pollTimer = setInterval(fetchMessages, 3000);
        }
        function stopPolling() {
            if (_pollTimer) { clearInterval(_pollTimer); _pollTimer = null; }
        }

        async function fetchMessages() {
            if (!_activeChatRequestId) return;
            try {
                const res  = await fetch('/api/consulting/requests/' + _activeChatRequestId + '/messages');
                const data = await res.json();
                if (data.error) return;

                // 헤더 업데이트 (처음 로드 시)
                document.getElementById('chatTitle').textContent    = data.requestTitle || '자문 채팅';
                document.getElementById('chatSubtitle').textContent = '수락된 자문 · 실시간 채팅';

                const items = data.items || [];
                if (items.length === _lastMessageCount) return; // 변화 없으면 DOM 업데이트 안 함
                _lastMessageCount = items.length;

                const box = document.getElementById('chatMessages');
                if (items.length === 0) {
                    box.innerHTML = '<p class="text-center text-slate-400 text-xs py-8">아직 메시지가 없습니다.<br>먼저 인사를 건네 보세요!</p>';
                    return;
                }

                box.innerHTML = items.map(function(m) {
                    const isMine = m.isMine;
                    const bubbleClass = isMine ? 'chat-bubble-expert' : 'chat-bubble-user';
                    const wrapper = isMine ? 'flex justify-end' : 'flex justify-start';
                    const roleLabel = m.senderRole === 'EXPERT' ? '전문가' : '신청자';
                    return '<div class="' + wrapper + '">'
                        + '<div class="max-w-[75%]">'
                        + (!isMine ? '<p class="text-[10px] text-slate-400 mb-1 ml-1">' + roleLabel + '</p>' : '')
                        + '<div class="' + bubbleClass + ' px-4 py-2.5 text-sm leading-relaxed">' + escapeHtml(m.content) + '</div>'
                        + '<p class="text-[10px] text-slate-400 mt-1 ' + (isMine ? 'text-right mr-1' : 'ml-1') + '">' + escapeHtml(m.createdAt) + '</p>'
                        + '</div>'
                        + '</div>';
                }).join('');

                box.scrollTop = box.scrollHeight;
            } catch (e) {
                console.error('메시지 폴링 오류:', e);
            }
        }

        window.handleChatKey = function (e) {
            if (e.key === 'Enter' && !e.shiftKey) {
                e.preventDefault();
                sendChatMessage();
            }
        };

        window.sendChatMessage = async function () {
            if (!_activeChatRequestId) return;
            const input   = document.getElementById('chatInput');
            const content = input.value.trim();
            if (!content) return;

            input.value    = '';
            input.disabled = true;

            try {
                const params = new URLSearchParams();
                params.append('content', content);
                const res  = await fetch('/api/consulting/requests/' + _activeChatRequestId + '/messages', {
                    method: 'POST', body: params
                });
                const data = await res.json();
                if (data.error) { alert(data.error); return; }
                _lastMessageCount = -1; // 강제 리렌더
                await fetchMessages();
            } catch (e) {
                alert('전송 중 오류가 발생했습니다.');
            } finally {
                input.disabled = false;
                input.focus();
            }
        };

        loadRequests();
    </script>
</body>
</html>