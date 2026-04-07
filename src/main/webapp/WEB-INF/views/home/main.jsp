<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>City Biz Hub - 프리미엄 비즈니스 자원 플랫폼</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script src="https://cdn.jsdelivr.net/npm/axios/dist/axios.min.js"></script>
    <script src="https://unpkg.com/lucide@latest"></script>
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Pretendard:wght@300;400;500;600;700;800&display=swap');
        body { 
            font-family: 'Pretendard', sans-serif; 
            -webkit-font-smoothing: antialiased;
            -moz-osx-font-smoothing: grayscale;
        }
    </style>
</head>
<body class="bg-[#F8FAFC] flex flex-col min-h-screen text-slate-800 selection:bg-blue-100 selection:text-blue-900">

    <%-- 네비게이션 바 --%>
    <nav class="sticky top-0 z-50 bg-white/80 backdrop-blur-md border-b border-slate-200/60">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
            <div class="flex justify-between h-20 items-center">
                
                <div class="flex items-center gap-8">
                    <a href="/main" class="text-3xl font-extrabold tracking-tight flex items-center gap-2 group">
                        <div class="p-2 bg-gradient-to-br from-blue-600 to-indigo-600 rounded-xl text-white shadow-lg group-hover:scale-105 transition-transform duration-300">
                            <i data-lucide="building-2" class="w-6 h-6"></i>
                        </div>
                        <span class="bg-clip-text text-transparent bg-gradient-to-r from-slate-900 to-slate-700">CityBiz</span>
                    </a>
                </div>
                
                <div class="flex items-center gap-5">
                    <c:choose>
                        <c:when test="${not empty sessionScope.loginUser}">
                            <div class="flex items-center gap-4">
                                <div class="flex items-center gap-2 px-4 py-2 bg-white border border-slate-200 rounded-full shadow-sm text-sm font-medium">
                                    <div class="w-6 h-6 rounded-full bg-gradient-to-tr from-blue-500 to-indigo-500 flex items-center justify-center text-white text-xs font-bold shadow-inner">
                                        ${fn:substring(sessionScope.loginName, 0, 1)}
                                    </div>
                                    <span class="text-slate-700">
                                        <strong class="text-slate-900">${sessionScope.loginName}</strong> 님
                                        <%-- 백엔드 변수명 loginRole로 수정 --%>
                                        <span class="text-[10px] bg-slate-100 px-1.5 py-0.5 rounded ml-1 text-slate-500">${sessionScope.loginRole}</span>
                                    </span>
                                </div>
                                <a href="/logout" class="text-sm font-medium text-slate-500 hover:text-rose-500 transition-colors flex items-center gap-1.5">
                                    <i data-lucide="log-out" class="w-4 h-4"></i> 로그아웃
                                </a>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <a href="/login" class="text-sm font-semibold text-slate-600 hover:text-blue-600 transition-colors">
                                로그인
                            </a>
                            <a href="/signup" class="bg-slate-900 hover:bg-slate-800 text-white px-5 py-2.5 rounded-xl text-sm font-semibold transition-all duration-200 shadow-md hover:shadow-lg hover:-translate-y-0.5">
                                시작하기
                            </a>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </nav>
    
    <main class="flex-grow flex flex-col items-center pt-16 pb-32 px-4 relative overflow-hidden">
        
        <%-- 배경 데코레이션 --%>
        <div class="absolute top-[-10%] left-[-10%] w-96 h-96 bg-blue-400/20 rounded-full blur-3xl pointer-events-none"></div>
        <div class="absolute bottom-[-10%] right-[-10%] w-96 h-96 bg-purple-400/20 rounded-full blur-3xl pointer-events-none"></div>

        <%-- 로그인 유저의 역할(Role)별 맞춤형 대시보드 배너 --%>
        <c:if test="${not empty sessionScope.loginUser}">
            <div class="max-w-6xl w-full mb-16 z-10 animate-in fade-in slide-in-from-top-4 duration-700">
                <div class="bg-white/60 backdrop-blur-sm border border-white/50 rounded-[2.5rem] p-8 shadow-[0_8px_30px_rgb(0,0,0,0.04)] flex flex-col md:flex-row justify-between items-center gap-8">
                    <div class="flex items-center gap-6">
                        <div class="w-16 h-16 rounded-full bg-gradient-to-br from-slate-800 to-slate-900 flex items-center justify-center text-white shadow-xl">
                            <i data-lucide="sparkles" class="w-8 h-8"></i>
                        </div>
                        <div>
                            <h2 class="text-2xl font-bold text-slate-900">안녕하세요, ${sessionScope.loginName}님!</h2>
                            <p class="text-slate-500 mt-1">
                                <c:choose>
                                    <c:when test="${sessionScope.loginRole == 'PROVIDER'}">운영 중인 공간의 새로운 예약 건이 있는지 확인해보세요.</c:when>
                                    <c:when test="${sessionScope.loginRole == 'EXPERT'}">전문가 매칭 시스템을 통해 비즈니스 기회를 발견하세요.</c:when>
                                    <c:otherwise>오늘 ${sessionScope.loginName}님께 딱 맞는 지원사업 3건이 새로 올라왔습니다.</c:otherwise>
                                </c:choose>
                            </p>
                        </div>
                    </div>
                    
                    <div class="flex gap-3 w-full md:w-auto">
                        <c:choose>
                            <c:when test="${sessionScope.loginRole == 'PROVIDER'}">
                                <a href="/mypage/spaceRegi" class="flex-1 md:flex-none text-center bg-blue-600 text-white px-6 py-3.5 rounded-2xl font-bold hover:bg-blue-700 transition-all shadow-lg shadow-blue-200">공간 등록하기</a>
                                <a href="/mypage/spaceManagement" class="flex-1 md:flex-none text-center bg-white border border-slate-200 text-slate-700 px-6 py-3.5 rounded-2xl font-bold hover:bg-slate-50 transition-all">예약 관리</a>
                            </c:when>
                            <c:when test="${sessionScope.loginRole == 'EXPERT'}">
                                <a href="/pro/profile" class="flex-1 md:flex-none text-center bg-purple-600 text-white px-6 py-3.5 rounded-2xl font-bold hover:bg-purple-700 transition-all shadow-lg shadow-purple-200">전문가 프로필 수정</a>
                            </c:when>
                            <c:otherwise>
                                <a href="/mypage/status" class="flex-1 md:flex-none text-center bg-slate-900 text-white px-6 py-3.5 rounded-2xl font-bold hover:bg-slate-800 transition-all shadow-lg shadow-slate-200">내 활동 내역</a>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
        </c:if>

        <div class="text-center mb-20 relative z-10">
            <span class="inline-block py-1 px-3 rounded-full bg-blue-50 border border-blue-100 text-blue-600 text-sm font-semibold mb-6 tracking-wide">
                도시 비즈니스 인프라 통합 플랫폼
            </span>
            <h1 class="text-5xl md:text-6xl font-extrabold text-slate-900 mb-6 tracking-tight leading-tight">
                비즈니스의 성공,<br>
                <span class="bg-clip-text text-transparent bg-gradient-to-r from-blue-600 to-indigo-600">올바른 자원</span>에서 시작됩니다.
            </h1>
            <p class="text-xl text-slate-500 max-w-2xl mx-auto font-light">
                흩어져 있던 창업 공간, 정책 지원금, 전문가 네트워크를 한 곳에서.<br>당신에게 가장 필요한 비즈니스 자원을 지금 만나보세요.
            </p>
        </div>

        <div class="max-w-6xl w-full grid grid-cols-1 md:grid-cols-3 gap-8 relative z-10">
            
            <%-- 공간 대여 카드 --%>
            <a href="/space" class="group bg-white p-10 rounded-[2rem] border border-slate-100 shadow-[0_4px_20px_-4px_rgba(0,0,0,0.05)] hover:shadow-[0_20px_40px_-10px_rgba(0,0,0,0.1)] hover:-translate-y-2 transition-all duration-300 relative overflow-hidden flex flex-col h-full">
                <i data-lucide="building" class="absolute -bottom-6 -right-6 w-40 h-40 text-slate-50 opacity-50 group-hover:scale-110 transition-transform duration-500"></i>
                <div class="w-16 h-16 rounded-2xl bg-blue-50 text-blue-600 flex items-center justify-center mb-8 group-hover:bg-blue-600 group-hover:text-white transition-colors duration-300 z-10 shadow-sm">
                    <i data-lucide="map-pin" class="w-8 h-8"></i>
                </div>
                <h2 class="text-2xl font-bold mb-4 text-slate-900 z-10">공간 대여</h2>
                <p class="text-slate-500 leading-relaxed z-10 flex-grow">
                    회의실부터 공유오피스까지.<br>지도 기반으로 가까운 창업 지원 공간을 찾고 실시간으로 예약하세요.
                </p>
                <div class="mt-8 flex items-center text-blue-600 font-semibold text-sm z-10 group-hover:gap-2 transition-all">
                    자세히 보기 <i data-lucide="arrow-right" class="w-4 h-4 ml-1"></i>
                </div>
            </a>
            
            <%-- 정책 지원 카드 --%>
            <a href="/policy" class="group bg-white p-10 rounded-[2rem] border border-slate-100 shadow-[0_4px_20px_-4px_rgba(0,0,0,0.05)] hover:shadow-[0_20px_40px_-10px_rgba(0,0,0,0.1)] hover:-translate-y-2 transition-all duration-300 relative overflow-hidden flex flex-col h-full">
                <i data-lucide="banknote" class="absolute -bottom-6 -right-6 w-40 h-40 text-slate-50 opacity-50 group-hover:scale-110 transition-transform duration-500"></i>
                <div class="w-16 h-16 rounded-2xl bg-indigo-50 text-indigo-600 flex items-center justify-center mb-8 group-hover:bg-indigo-600 group-hover:text-white transition-colors duration-300 z-10 shadow-sm">
                     <i data-lucide="pie-chart" class="w-8 h-8"></i>
                </div>
                <h2 class="text-2xl font-bold mb-4 text-slate-900 z-10">정책 지원</h2>
                <p class="text-slate-500 leading-relaxed z-10 flex-grow">
                    중소벤처진흥공단, 기술보증기금 등 내 기업 규모와 상황에 딱 맞는 맞춤형 지원 사업을 찾아드립니다.
                </p>
                <div class="mt-8 flex items-center text-indigo-600 font-semibold text-sm z-10 group-hover:gap-2 transition-all">
                    자세히 보기 <i data-lucide="arrow-right" class="w-4 h-4 ml-1"></i>
                </div>
            </a>

            <%-- 컨설팅 네트워크 카드 --%>
            <a href="/consulting" class="group bg-white p-10 rounded-[2rem] border border-slate-100 shadow-[0_4px_20px_-4px_rgba(0,0,0,0.05)] hover:shadow-[0_20px_40px_-10px_rgba(0,0,0,0.1)] hover:-translate-y-2 transition-all duration-300 relative overflow-hidden flex flex-col h-full">
                <i data-lucide="users" class="absolute -bottom-6 -right-6 w-40 h-40 text-slate-50 opacity-50 group-hover:scale-110 transition-transform duration-500"></i>
                <div class="w-16 h-16 rounded-2xl bg-purple-50 text-purple-600 flex items-center justify-center mb-8 group-hover:bg-purple-600 group-hover:text-white transition-colors duration-300 z-10 shadow-sm">
                   <i data-lucide="network" class="w-8 h-8"></i>
                </div>
                <h2 class="text-2xl font-bold mb-4 text-slate-900 z-10">컨설팅 네트워크</h2>
                <p class="text-slate-500 leading-relaxed z-10 flex-grow">
                    세무, 법률, 마케팅까지.<br>전문성이 검증된 컨설팅 기업과 네트워크를 형성하고 역량을 강화하세요.
                </p>
                <div class="mt-8 flex items-center text-purple-600 font-semibold text-sm z-10 group-hover:gap-2 transition-all">
                    자세히 보기 <i data-lucide="arrow-right" class="w-4 h-4 ml-1"></i>
                </div>
            </a>

        </div>
    </main>

    <footer class="border-t border-slate-200 bg-white py-12 mt-auto">
        <div class="max-w-7xl mx-auto px-4 flex flex-col md:flex-row justify-between items-center gap-6">
            <div class="flex items-center gap-2 opacity-50">
                <i data-lucide="building-2" class="w-5 h-5 text-slate-900"></i>
                <span class="text-xl font-bold text-slate-900">CityBiz</span>
            </div>
            <div class="text-center md:text-left">
                <p class="text-slate-400 text-sm">AI 소프트웨어 학과 졸업작품 프로젝트</p>
                <p class="text-slate-400 text-sm mt-1">&copy; 2026 CityBiz Team. All rights reserved.</p>
            </div>
            <div class="flex gap-4">
                <a href="#" class="text-slate-400 hover:text-slate-600 transition-colors"><i data-lucide="github" class="w-5 h-5"></i></a>
            </div>
        </div>
    </footer>

    <script>
        // 루사이드 아이콘 초기화
        lucide.createIcons();
    </script>
</body>
</html>