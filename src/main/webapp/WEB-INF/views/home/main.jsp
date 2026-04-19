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
                                <a href="${sessionScope.loginRole == 'PROVIDER' ? '/mypage/spaceManagement' : sessionScope.loginRole == 'EXPERT' ? '/mypage/expertManagement' : '/mypage/status'}" class="flex items-center gap-2 px-4 py-2 bg-white border border-slate-200 rounded-full shadow-sm text-sm font-medium hover:border-blue-300 hover:shadow-md transition-all">
                                    <div class="w-6 h-6 rounded-full bg-gradient-to-tr from-blue-500 to-indigo-500 flex items-center justify-center text-white text-xs font-bold shadow-inner">
                                        ${fn:substring(sessionScope.loginName, 0, 1)}
                                    </div>
                                    <span class="text-slate-700">
                                        <strong class="text-slate-900">${sessionScope.loginName}</strong> 님
                                    </span>
                                </a>
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
                                    <c:when test="${sessionScope.loginRole == 'EXPERT'}">오늘 새로운 상담 요청이 들어왔을 수도 있어요.</c:when>
                                    <c:otherwise>오늘 ${sessionScope.loginName}님께 딱 맞는 지원사업 3건이 새로 올라왔습니다.</c:otherwise>
                                </c:choose>
                            </p>
                        </div>
                    </div>
                    <div class="flex gap-3 w-full md:w-auto">
                        <c:choose>
                            <c:when test="${sessionScope.loginRole == 'PROVIDER'}">
                                <a href="/mypage/spaceRegi?mode=new" class="flex-1 md:flex-none text-center bg-blue-600 text-white px-6 py-3.5 rounded-2xl font-bold hover:bg-blue-700 transition-all shadow-lg shadow-blue-200">추가 공간 등록</a>
                                <button type="button" id="toggleMySpacesBtn" class="flex-1 md:flex-none text-center bg-white border border-slate-200 text-slate-700 px-6 py-3.5 rounded-2xl font-bold hover:bg-slate-50 transition-all flex items-center gap-2 justify-center">
                                    공간 수정
                                    <span id="spaceCountBadge" class="hidden text-xs bg-slate-700 text-white font-bold px-1.5 py-0.5 rounded-full min-w-[1.2rem] text-center leading-none">0</span>
                                    <svg id="mySpacesChevron" xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round" class="transition-transform duration-300" style="pointer-events:none"><polyline points="6 9 12 15 18 9"></polyline></svg>
                                </button>
                                <a href="/mypage/spaceManagement" class="flex-1 md:flex-none text-center bg-white border border-slate-200 text-slate-700 px-6 py-3.5 rounded-2xl font-bold hover:bg-slate-50 transition-all">예약 관리</a>
                            </c:when>
                            <c:when test="${sessionScope.loginRole == 'EXPERT'}">
                                <a href="/mypage/expertProfile" class="flex-1 md:flex-none text-center bg-purple-600 text-white px-6 py-3.5 rounded-2xl font-bold hover:bg-purple-700 transition-all shadow-lg shadow-purple-200">전문가 정보 수정</a>
                                <a href="/mypage/expertManagement" class="flex-1 md:flex-none text-center bg-white border border-slate-200 text-slate-700 px-6 py-3.5 rounded-2xl font-bold hover:bg-slate-50 transition-all">컨설팅 관리</a>
                            </c:when>
                            <c:otherwise>
                                <a href="/mypage/profile" class="flex-1 md:flex-none text-center bg-blue-600 text-white px-6 py-3.5 rounded-2xl font-bold hover:bg-blue-700 transition-all shadow-lg shadow-blue-200">내 정보 수정</a>
                                <a href="/mypage/status" class="flex-1 md:flex-none text-center bg-slate-900 text-white px-6 py-3.5 rounded-2xl font-bold hover:bg-slate-800 transition-all shadow-lg shadow-slate-200">내 활동 내역</a>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <%-- PROVIDER 전용: 내 공간 목록 패널 (공간 수정 클릭 시 표시) --%>
                <c:if test="${sessionScope.loginRole == 'PROVIDER'}">
                    <div id="mySpacesPanel" class="hidden mt-6 pt-6 border-t border-slate-100 w-full">
                        <p class="text-sm font-semibold text-slate-500 mb-4">수정할 공간을 선택하세요</p>
                        <div id="mySpacesList" class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-3">
                            <div class="text-sm text-slate-400 col-span-full py-4 text-center">불러오는 중...</div>
                        </div>
                    </div>
                </c:if>
            </div>
        </c:if>

        <div class="text-center mb-20 relative z-10 w-full">
            <span class="inline-block py-1 px-3 rounded-full bg-blue-50 border border-blue-100 text-blue-600 text-sm font-semibold mb-6 tracking-wide">
                도시 비즈니스 인프라 통합 플랫폼
            </span>
            <h1 class="text-5xl md:text-6xl font-extrabold text-slate-900 mb-6 tracking-tight leading-tight">
                비즈니스의 성공,<br>
                <span class="bg-clip-text text-transparent bg-gradient-to-r from-blue-600 to-indigo-600">올바른 자원</span>에서 시작됩니다.
            </h1>
            <p class="text-xl text-slate-500 max-w-2xl mx-auto font-light mb-10">
                흩어져 있던 창업 공간, 정책 지원금, 전문가 네트워크를 한 곳에서.<br>당신에게 가장 필요한 비즈니스 자원을 지금 만나보세요.
            </p>

            <%-- 통합 검색창 시작 --%>
            <div class="max-w-4xl mx-auto relative z-20">
                <form action="/search" method="GET" class="bg-white p-2 rounded-3xl md:rounded-full shadow-xl border border-slate-200 flex flex-col md:flex-row items-center gap-2" onsubmit="return validateSearch(event)">
                    
                    <%-- 1. 검색어 입력 (keyword) - 잘림 현상 수정을 위해 flex-[1.5] 및 md:min-w-[280px] 적용 --%>
                    <div class="flex-[1.5] md:min-w-[280px] flex items-center px-4 py-3 w-full border-b md:border-b-0 md:border-r border-slate-100">
                        <i data-lucide="search" class="w-5 h-5 text-blue-500 mr-3 shrink-0"></i>
                        <input type="text" name="keyword" placeholder="어떤 비즈니스 자원을 찾으시나요?" class="w-full bg-transparent border-none focus:ring-0 text-slate-700 placeholder-slate-400 outline-none text-base">
                    </div>
                    
                    <%-- 2. 사용자 유형 선택 (userType) --%>
                    <div class="flex-1 flex items-center px-4 py-3 w-full border-b md:border-b-0 md:border-r border-slate-100">
                        <i data-lucide="briefcase" class="w-5 h-5 text-indigo-400 mr-3 shrink-0"></i>
                        <select name="userType" class="w-full bg-transparent border-none focus:ring-0 text-slate-700 outline-none cursor-pointer appearance-none text-base">
                            <option value="" disabled>사용자 유형</option>
                            <option value="예비창업자" selected>예비창업자</option>
                            <option value="초기창업기업">초기창업기업</option>
                            <option value="중소기업">중소기업</option>
                        </select>
                    </div>
                    
                    <%-- 3. 지역 선택 (region) - 서울 25개 구 --%>
                    <div class="flex-1 flex items-center px-4 py-3 w-full">
                        <i data-lucide="map-pin" class="w-5 h-5 text-emerald-400 mr-3 shrink-0"></i>
                        <select name="region" class="w-full bg-transparent border-none focus:ring-0 text-slate-700 outline-none cursor-pointer appearance-none text-base">
                            <option value="" disabled>지역 선택</option>
                            <option value="서울 강남구" selected>서울 강남구</option>
                            <option value="서울 강동구">서울 강동구</option>
                            <option value="서울 강북구">서울 강북구</option>
                            <option value="서울 강서구">서울 강서구</option>
                            <option value="서울 관악구">서울 관악구</option>
                            <option value="서울 광진구">서울 광진구</option>
                            <option value="서울 구로구">서울 구로구</option>
                            <option value="서울 금천구">서울 금천구</option>
                            <option value="서울 노원구">서울 노원구</option>
                            <option value="서울 도봉구">서울 도봉구</option>
                            <option value="서울 동대문구">서울 동대문구</option>
                            <option value="서울 동작구">서울 동작구</option>
                            <option value="서울 마포구">서울 마포구</option>
                            <option value="서울 서대문구">서울 서대문구</option>
                            <option value="서울 서초구">서울 서초구</option>
                            <option value="서울 성동구">서울 성동구</option>
                            <option value="서울 성북구">서울 성북구</option>
                            <option value="서울 송파구">서울 송파구</option>
                            <option value="서울 양천구">서울 양천구</option>
                            <option value="서울 영등포구">서울 영등포구</option>
                            <option value="서울 용산구">서울 용산구</option>
                            <option value="서울 은평구">서울 은평구</option>
                            <option value="서울 종로구">서울 종로구</option>
                            <option value="서울 중구">서울 중구</option>
                            <option value="서울 중랑구">서울 중랑구</option>
                        </select>
                    </div>
                    
                    <%-- 검색 버튼 --%>
                    <button type="submit" class="w-full md:w-auto bg-slate-900 hover:bg-blue-600 text-white px-8 py-4 rounded-2xl md:rounded-full font-bold transition-all shadow-md shrink-0 flex items-center justify-center gap-2 group">
                        <span>검색하기</span>
                        <i data-lucide="arrow-right" class="w-4 h-4 group-hover:translate-x-1 transition-transform"></i>
                    </button>
                    
                </form>
            </div>
            <%-- 통합 검색창 끝 --%>

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
        lucide.createIcons();

        function validateSearch(e) {
            const keyword = document.querySelector('input[name="keyword"]').value.trim();
            if (!keyword) {
                e.preventDefault();
                alert('검색어를 입력해주세요.');
                document.querySelector('input[name="keyword"]').focus();
                return false;
            }
            return true;
        }

        // ── PROVIDER 대시보드 ──────────────────────────────────────────────
        const toggleBtn    = document.getElementById('toggleMySpacesBtn');
        const spacesPanel  = document.getElementById('mySpacesPanel');
        const chevron      = document.getElementById('mySpacesChevron');
        const countBadge   = document.getElementById('spaceCountBadge');

        let mySpacesData   = null;   // 로드된 공간 목록 캐시
        let panelOpen      = false;

        if (toggleBtn && spacesPanel) {
            // 공간 목록 미리 로드 (페이지 오픈과 동시에)
            loadMySpaces();

            toggleBtn.addEventListener('click', function () {
                panelOpen = !panelOpen;
                spacesPanel.classList.toggle('hidden', !panelOpen);
                chevron.style.transform = panelOpen ? 'rotate(180deg)' : '';
            });
        }

        async function loadMySpaces() {
            try {
                const res   = await fetch('/api/spaces/host/spaces');
                const items = await res.json();
                mySpacesData = items;

                // 뱃지 업데이트
                if (countBadge && items.length > 0) {
                    countBadge.textContent = items.length;
                    countBadge.classList.remove('hidden');
                }

                // 목록 렌더링
                const list = document.getElementById('mySpacesList');
                if (!list) return;

                if (!items || items.length === 0) {
                    list.innerHTML = '<div class="text-sm text-slate-400 col-span-full py-4 text-center">등록된 공간이 없습니다.</div>';
                    return;
                }

                const typeLabel = { '상점':'상점', '창고':'창고', '스튜디오':'스튜디오', '회의실':'회의실', '상담실':'상담실', '사무실':'사무실' };
                list.innerHTML = items.map(function(s) {
                    const badgeHtml = s.availableYn === 'N'
                        ? '<span style="font-size:10px;background:#fef3c7;color:#d97706;font-weight:700;padding:1px 6px;border-radius:4px;margin-left:4px;">미완성</span>'
                        : '';
                    const typeTxt   = typeLabel[s.spaceType] || s.spaceType;
                    const locTxt    = (s.district && s.district !== '미설정') ? s.district : (s.region && s.region !== '미설정' ? s.region : '위치 미설정');
                    return '<a href="/mypage/spaceEdit?spaceId=' + s.spaceId + '" '
                         + 'class="flex items-center gap-3 p-4 bg-slate-50 hover:bg-blue-50 border border-slate-200 hover:border-blue-300 rounded-2xl transition-all group">'
                         + '<div class="w-10 h-10 rounded-xl bg-blue-100 text-blue-600 flex items-center justify-center shrink-0 text-sm font-bold">'
                         +   (s.name ? s.name.charAt(0) : '?')
                         + '</div>'
                         + '<div class="min-w-0 flex-1">'
                         +   '<p class="text-sm font-bold text-slate-800 truncate">' + s.name + badgeHtml + '</p>'
                         +   '<p class="text-xs text-slate-400 mt-0.5">' + locTxt + ' · ' + typeTxt + '</p>'
                         + '</div>'
                         + '<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round" class="text-slate-300 group-hover:text-blue-500 ml-auto shrink-0 transition-colors"><polyline points="9 18 15 12 9 6"></polyline></svg>'
                         + '</a>';
                }).join('');
            } catch (err) {
                const list = document.getElementById('mySpacesList');
                if (list) list.innerHTML = '<div class="text-sm text-rose-400 col-span-full py-4 text-center">공간 목록을 불러오지 못했습니다.</div>';
            }
        }
    </script>
</body>
</html>
