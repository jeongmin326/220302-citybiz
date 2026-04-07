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

    <%-- 1. 헤더 불러오기 --%>
    <jsp:include page="/WEB-INF/views/common/header.jsp" />
    
    <main class="flex-grow max-w-6xl mx-auto w-full px-4 sm:px-6 py-12">
        
        <div class="mb-8 flex justify-between items-end">
            <div>
                <span class="bg-indigo-100 text-indigo-700 text-xs font-bold px-3 py-1 rounded-full mb-3 inline-block">호스트 대시보드</span>
                <h1 class="text-3xl font-extrabold text-slate-900 tracking-tight">예약 관리</h1>
                <p class="text-slate-500 mt-2">내 공간에 들어온 예약 요청을 확인하고 승인/거절할 수 있습니다.</p>
            </div>
            <%-- 공간 등록 페이지로 바로갈 수 있는 편의성 버튼 --%>
            <a href="/mypage/spaceRegi" class="hidden sm:flex items-center gap-2 bg-white border border-slate-200 px-4 py-2 rounded-xl text-sm font-bold text-slate-600 hover:bg-slate-50 transition-colors">
                <i data-lucide="plus" class="w-4 h-4"></i> 새 공간 등록
            </a>
        </div>

        <%-- 상단 요약 카드 --%>
        <div class="grid grid-cols-1 md:grid-cols-3 gap-6 mb-8">
            <div class="bg-white rounded-3xl p-6 border border-slate-200 shadow-sm flex items-center gap-4">
                <div class="bg-amber-100 p-4 rounded-2xl text-amber-600">
                    <i data-lucide="clock" class="w-8 h-8"></i>
                </div>
                <div>
                    <p class="text-sm font-semibold text-slate-500">승인 대기</p>
                    <p class="text-2xl font-bold text-slate-900">3<span class="text-base font-medium text-slate-500 ml-1">건</span></p>
                </div>
            </div>
            <div class="bg-white rounded-3xl p-6 border border-slate-200 shadow-sm flex items-center gap-4">
                <div class="bg-blue-100 p-4 rounded-2xl text-blue-600">
                    <i data-lucide="calendar-check" class="w-8 h-8"></i>
                </div>
                <div>
                    <p class="text-sm font-semibold text-slate-500">이번 달 확정 예약</p>
                    <p class="text-2xl font-bold text-slate-900">12<span class="text-base font-medium text-slate-500 ml-1">건</span></p>
                </div>
            </div>
            <div class="bg-white rounded-3xl p-6 border border-slate-200 shadow-sm flex items-center gap-4">
                <div class="bg-emerald-100 p-4 rounded-2xl text-emerald-600">
                    <i data-lucide="banknote" class="w-8 h-8"></i>
                </div>
                <div>
                    <p class="text-sm font-semibold text-slate-500">이번 달 예상 수익</p>
                    <p class="text-2xl font-bold text-slate-900">450,000<span class="text-base font-medium text-slate-500 ml-1">원</span></p>
                </div>
            </div>
        </div>

        <%-- 예약 목록 테이블 영역 --%>
        <section class="bg-white rounded-3xl border border-slate-200 shadow-sm overflow-hidden">
            <div class="p-6 border-b border-slate-100 flex justify-between items-center bg-slate-50/50">
                <h2 class="text-lg font-bold text-slate-900 flex items-center gap-2">
                    <i data-lucide="list" class="w-5 h-5 text-indigo-500"></i> 전체 예약 내역
                </h2>
                <select class="bg-white border border-slate-200 text-sm rounded-lg px-3 py-2 focus:outline-none focus:ring-2 focus:ring-indigo-500">
                    <option>전체 상태</option>
                    <option>승인 대기</option>
                    <option>예약 확정</option>
                    <option>거절/취소</option>
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
                        <%-- 자바스크립트로 데이터가 렌더링 될 영역입니다. --%>
                        <%-- 백엔드가 완성되기 전까지 화면을 볼 수 있게 임시(Mock) 데이터를 JS로 넣겠습니다. --%>
                    </tbody>
                </table>
            </div>
        </section>

    </main>

    <%-- 2. 푸터 불러오기 --%>
    <jsp:include page="/WEB-INF/views/common/footer.jsp" />

    <script>
        // 루사이드 아이콘 초기화
        lucide.createIcons();

        // [프론트엔드 임시 처리] 백엔드 API가 완성되기 전 화면을 확인하기 위한 임시(Mock) 데이터입니다.
        // 추후 fetch('/api/host/reservations') 등으로 실제 데이터를 받아오도록 수정해야 합니다.
        const mockReservations = [
            { id: 1, userName: "김스타트", userPhone: "010-1234-5678", spaceName: "강남역 비즈니스 센터 A호", date: "2024-05-20", time: "14:00 - 16:00 (2시간)", price: 30000, status: "PENDING" },
            { id: 2, userName: "이혁신", userPhone: "010-9876-5432", spaceName: "성수동 크리에이티브 스튜디오", date: "2024-05-21", time: "10:00 - 18:00 (8시간)", price: 120000, status: "APPROVED" },
            { id: 3, userName: "박대표", userPhone: "010-5555-4444", spaceName: "판교 코워킹 스페이스 회의실", date: "2024-05-18", time: "09:00 - 11:00 (2시간)", price: 40000, status: "REJECTED" }
        ];

        function renderReservations() {
            const tbody = document.getElementById('reservation-list');
            tbody.innerHTML = '';

            mockReservations.forEach(res => {
                let statusBadge = '';
                let actionButtons = '';

                // 상태에 따른 뱃지 및 버튼 렌더링
                if(res.status === 'PENDING') {
                    statusBadge = `<span class="bg-amber-100 text-amber-700 px-2.5 py-1 rounded-md text-xs font-bold">승인 대기</span>`;
                    actionButtons = `
                        <button onclick="handleAction(${res.id}, 'approve')" class="px-3 py-1.5 bg-blue-600 text-white rounded-lg text-xs font-bold hover:bg-blue-700 transition-colors">승인</button>
                        <button onclick="handleAction(${res.id}, 'reject')" class="px-3 py-1.5 bg-rose-500 text-white rounded-lg text-xs font-bold hover:bg-rose-600 transition-colors">거절</button>
                    `;
                } else if(res.status === 'APPROVED') {
                    statusBadge = `<span class="bg-blue-100 text-blue-700 px-2.5 py-1 rounded-md text-xs font-bold">예약 확정</span>`;
                    actionButtons = `<span class="text-xs text-slate-400 font-medium">처리 완료</span>`;
                } else {
                    statusBadge = `<span class="bg-slate-100 text-slate-600 px-2.5 py-1 rounded-md text-xs font-bold">거절됨</span>`;
                    actionButtons = `<span class="text-xs text-slate-400 font-medium">처리 완료</span>`;
                }

                const tr = document.createElement('tr');
                tr.className = "hover:bg-slate-50 transition-colors";
                tr.innerHTML = `
                    <td class="px-6 py-4">
                        <p class="font-bold text-slate-900">\${res.userName}</p>
                        <p class="text-xs text-slate-500">\${res.userPhone}</p>
                    </td>
                    <td class="px-6 py-4 font-medium text-slate-800">\${res.spaceName}</td>
                    <td class="px-6 py-4">
                        <p class="text-slate-900">\${res.date}</p>
                        <p class="text-xs text-slate-500">\${res.time}</p>
                    </td>
                    <td class="px-6 py-4 font-bold text-slate-900">\${res.price.toLocaleString()}원</td>
                    <td class="px-6 py-4">\${statusBadge}</td>
                    <td class="px-6 py-4 text-center flex justify-center gap-2">\${actionButtons}</td>
                `;
                tbody.appendChild(tr);
            });
        }

        // 승인/거절 버튼 클릭 이벤트 (임시)
        function handleAction(id, action) {
            const actionText = action === 'approve' ? '승인' : '거절';
            if(confirm(`해당 예약을 \${actionText}하시겠습니까?`)) {
                // TODO: 백엔드 API로 PUT 또는 POST 요청을 보내어 상태값을 변경해야 합니다.
                alert(`예약이 \${actionText} 처리되었습니다. (프론트엔드 테스트)`);
            }
        }

        // 페이지 로드 시 임시 데이터 렌더링
        window.addEventListener('DOMContentLoaded', renderReservations);
    </script>
</body>
</html>