<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>포인트 이용 내역 - City Biz Hub</title>
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

    <jsp:include page="/WEB-INF/views/common/header.jsp" />

    <main class="flex-grow py-10">
        <div class="max-w-3xl mx-auto px-4 sm:px-6 lg:px-8">

            <div class="flex items-center gap-3 mb-8">
                <button onclick="history.back()" class="p-2 rounded-full hover:bg-slate-200 transition-colors">
                    <i data-lucide="arrow-left" class="w-6 h-6 text-slate-600"></i>
                </button>
                <h1 class="text-2xl font-bold text-slate-900">포인트 이용 내역</h1>
            </div>

            <div class="bg-white rounded-2xl shadow-sm border border-slate-200 overflow-hidden">

                <div class="flex border-b border-slate-200">
                    <button onclick="filterHistory('all')" class="flex-1 py-4 text-center font-semibold text-blue-600 border-b-2 border-blue-600 tab-btn" data-filter="all">전체</button>
                    <button onclick="filterHistory('CHARGE')" class="flex-1 py-4 text-center font-medium text-slate-500 hover:text-slate-700 tab-btn" data-filter="CHARGE">충전</button>
                    <button onclick="filterHistory('USE')" class="flex-1 py-4 text-center font-medium text-slate-500 hover:text-slate-700 tab-btn" data-filter="USE">사용</button>
                </div>

                <div class="divide-y divide-slate-100" id="historyList">
                    <c:choose>
                        <c:when test="${not empty historyList}">
                            <c:forEach var="item" items="${historyList}">
                                <div class="history-item p-6 flex items-center justify-between hover:bg-slate-50 transition-colors" data-type="${item.type}">
                                    <div class="flex items-start gap-4">
                                        <c:choose>
                                            <c:when test="${item.type == 'CHARGE'}">
                                                <div class="w-12 h-12 rounded-full bg-blue-100 flex items-center justify-center text-blue-600 shrink-0">
                                                    <i data-lucide="plus" class="w-6 h-6"></i>
                                                </div>
                                            </c:when>
                                            <c:otherwise>
                                                <div class="w-12 h-12 rounded-full bg-rose-100 flex items-center justify-center text-rose-600 shrink-0">
                                                    <i data-lucide="minus" class="w-6 h-6"></i>
                                                </div>
                                            </c:otherwise>
                                        </c:choose>
                                        <div>
                                            <h3 class="text-base font-bold text-slate-800">${item.description}</h3>
                                            <p class="text-sm text-slate-500 mt-1">
                                                ${item.formattedCreatedAt}
                                            </p>
                                        </div>
                                    </div>
                                    <div class="text-right">
                                        <c:choose>
                                            <c:when test="${item.type == 'CHARGE'}">
                                                <p class="text-lg font-bold text-blue-600">+<span class="point-amount">${item.amount}</span> P</p>
                                            </c:when>
                                            <c:otherwise>
                                                <p class="text-lg font-bold text-rose-600">-<span class="point-amount">${item.amount}</span> P</p>
                                            </c:otherwise>
                                        </c:choose>
                                        <p class="text-sm text-slate-500 mt-1">잔액 <span id="currentPointDisplay">${currentPoint}</span> P</p>
                                    </div>
                                </div>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <div class="p-12 text-center">
                                <p class="text-slate-400">포인트 내역이 없습니다.</p>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </main>

    <jsp:include page="/WEB-INF/views/common/footer.jsp" />

    <script>
        lucide.createIcons();

        // 포인트 금액 포맷팅 (천단위 쉼표)
        function formatPointAmounts() {
            document.querySelectorAll('.point-amount').forEach(element => {
                const amount = parseInt(element.textContent);
                if (!isNaN(amount)) {
                    element.textContent = amount.toLocaleString();
                }
            });
            const currentPointElement = document.getElementById('currentPointDisplay');
            if (currentPointElement) {
                const point = parseInt(currentPointElement.textContent);
                if (!isNaN(point)) {
                    currentPointElement.textContent = point.toLocaleString();
                }
            }
        }

        function filterHistory(filter) {
            const items = document.querySelectorAll('.history-item');
            const tabs = document.querySelectorAll('.tab-btn');

            tabs.forEach(tab => {
                if (tab.dataset.filter === filter) {
                    tab.classList.add('text-blue-600', 'border-b-2', 'border-blue-600', 'font-semibold');
                    tab.classList.remove('text-slate-500', 'font-medium');
                } else {
                    tab.classList.remove('text-blue-600', 'border-b-2', 'border-blue-600', 'font-semibold');
                    tab.classList.add('text-slate-500', 'font-medium');
                }
            });

            items.forEach(item => {
                if (filter === 'all' || item.dataset.type === filter) {
                    item.style.display = 'flex';
                } else {
                    item.style.display = 'none';
                }
            });
        }

        formatPointAmounts();
    </script>
</body>
</html>