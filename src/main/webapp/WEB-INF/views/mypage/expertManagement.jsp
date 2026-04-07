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
        body { font-family: 'Pretendard', sans-serif; }
    </style>
</head>
<body class="bg-[#F8FAFC] flex flex-col min-h-screen text-slate-800">

    <jsp:include page="/WEB-INF/views/common/header.jsp" />
    
    <main class="flex-grow max-w-6xl mx-auto w-full px-4 sm:px-6 py-12">
        
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
                <div class="bg-indigo-100 p-4 rounded-2xl text-indigo-600">
                    <i data-lucide="message-square" class="w-8 h-8"></i>
                </div>
                <div>
                    <p class="text-sm font-semibold text-slate-500">새 신청</p>
                    <p class="text-2xl font-bold text-slate-900">2<span class="text-base font-medium text-slate-500 ml-1">건</span></p>
                </div>
            </div>
            <div class="bg-white rounded-3xl p-6 border border-slate-200 shadow-sm flex items-center gap-4">
                <div class="bg-emerald-100 p-4 rounded-2xl text-emerald-600">
                    <i data-lucide="check-circle" class="w-8 h-8"></i>
                </div>
                <div>
                    <p class="text-sm font-semibold text-slate-500">진행 중</p>
                    <p class="text-2xl font-bold text-slate-900">5<span class="text-base font-medium text-slate-500 ml-1">건</span></p>
                </div>
            </div>
            <div class="bg-white rounded-3xl p-6 border border-slate-200 shadow-sm flex items-center gap-4">
                <div class="bg-purple-100 p-4 rounded-2xl text-purple-600">
                    <i data-lucide="star" class="w-8 h-8"></i>
                </div>
                <div>
                    <p class="text-sm font-semibold text-slate-500">누적 완료</p>
                    <p class="text-2xl font-bold text-slate-900">48<span class="text-base font-medium text-slate-500 ml-1">건</span></p>
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
                            <th class="px-6 py-4">상담 분야</th>
                            <th class="px-6 py-4">신청일</th>
                            <th class="px-6 py-4">상태</th>
                            <th class="px-6 py-4 text-center">관리</th>
                        </tr>
                    </thead>
                    <tbody id="consulting-list" class="divide-y divide-slate-100 text-slate-600">
                        <%-- 임시 데이터 --%>
                        <tr class="hover:bg-slate-50 transition-colors">
                            <td class="px-6 py-4">
                                <p class="font-bold text-slate-900">홍길동 대표</p>
                                <p class="text-xs text-slate-500">새싹 테크</p>
                            </td>
                            <td class="px-6 py-4 font-medium">퍼포먼스 마케팅 진단</td>
                            <td class="px-6 py-4">2024-05-15</td>
                            <td class="px-6 py-4"><span class="bg-amber-100 text-amber-700 px-2.5 py-1 rounded-md text-xs font-bold">승인 대기</span></td>
                            <td class="px-6 py-4 text-center">
                                <div class="flex justify-center gap-2">
                                    <button class="px-3 py-1.5 bg-purple-600 text-white rounded-lg text-xs font-bold hover:bg-purple-700">수락</button>
                                    <button class="px-3 py-1.5 bg-slate-200 text-slate-600 rounded-lg text-xs font-bold hover:bg-slate-300">거절</button>
                                </div>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </section>
    </main>

    <jsp:include page="/WEB-INF/views/common/footer.jsp" />
    <script>lucide.createIcons();</script>
</body>
</html>