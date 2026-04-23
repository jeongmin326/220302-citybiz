<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
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
                    <button class="flex-1 py-4 text-center font-semibold text-blue-600 border-b-2 border-blue-600">전체</button>
                    <button class="flex-1 py-4 text-center font-medium text-slate-500 hover:text-slate-700">충전</button>
                    <button class="flex-1 py-4 text-center font-medium text-slate-500 hover:text-slate-700">사용</button>
                </div>

                <div class="divide-y divide-slate-100">
                    
                    <%-- 
                        Backend: Model로 넘어온 List 객체를 c:forEach로 반복문 돌려서 렌더링해야 합니다. 
                        아래는 프론트엔드 UI 확인을 위한 하드코딩 예시입니다.
                    --%>
                    
                    <div class="p-6 flex items-center justify-between hover:bg-slate-50 transition-colors">
                        <div class="flex items-start gap-4">
                            <div class="w-12 h-12 rounded-full bg-blue-100 flex items-center justify-center text-blue-600 shrink-0">
                                <i data-lucide="plus" class="w-6 h-6"></i>
                            </div>
                            <div>
                                <h3 class="text-base font-bold text-slate-800">포인트 충전 (토스페이)</h3>
                                <p class="text-sm text-slate-500 mt-1">2026.04.24 14:30</p>
                            </div>
                        </div>
                        <div class="text-right">
                            <p class="text-lg font-bold text-blue-600">+50,000 P</p>
                            <p class="text-sm text-slate-500 mt-1">잔액 100,000 P</p>
                        </div>
                    </div>

                    <div class="p-6 flex items-center justify-between hover:bg-slate-50 transition-colors">
                        <div class="flex items-start gap-4">
                            <div class="w-12 h-12 rounded-full bg-rose-100 flex items-center justify-center text-rose-600 shrink-0">
                                <i data-lucide="minus" class="w-6 h-6"></i>
                            </div>
                            <div>
                                <h3 class="text-base font-bold text-slate-800">회의실 예약 (A센터)</h3>
                                <p class="text-sm text-slate-500 mt-1">2026.04.22 10:15</p>
                            </div>
                        </div>
                        <div class="text-right">
                            <p class="text-lg font-bold text-rose-600">-20,000 P</p>
                            <p class="text-sm text-slate-500 mt-1">잔액 50,000 P</p>
                        </div>
                    </div>

                </div>
            </div>
        </div>
    </main>

    <jsp:include page="/WEB-INF/views/common/footer.jsp" />

    <script>
        lucide.createIcons();
        // Backend 연동 후 필요한 필터링(전체/충전/사용) 로직이나 페이징 JS 처리는 여기에 작성합니다.
    </script>
</body>
</html>