<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>공간 대여 - 프리미엄 비즈니스 자원 플랫폼</title>
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
        /* 커스텀 스크롤바 (필터 영역용) - main 무드 맞춤 */
        .custom-scrollbar::-webkit-scrollbar { width: 5px; }
        .custom-scrollbar::-webkit-scrollbar-track { background: transparent; }
        .custom-scrollbar::-webkit-scrollbar-thumb { background-color: #E2E8F0; border-radius: 20px; }
        
        /* 체크박스 숨기기 및 커스텀 라벨 스타일링 - main 무드 맞춤 */
        .hidden-checkbox:checked + label {
            background-color: #EFF6FF; /* blue-50 */
            border-color: #BFDBFE; /* blue-200 */
            color: #2563EB; /* blue-600 */
            font-weight: 600;
        }
    </style>
</head>
<body class="bg-[#F8FAFC] flex flex-col min-h-screen text-slate-800">

    <nav class="sticky top-0 z-50 bg-white/80 backdrop-blur-md border-b border-slate-200/60">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
            <div class="flex justify-between h-20 items-center">
                
                <div class="flex items-center gap-8">
                    <a href="/" class="text-3xl font-extrabold tracking-tight flex items-center gap-2 group">
                        <div class="p-2 bg-gradient-to-br from-blue-600 to-indigo-600 rounded-xl text-white shadow-lg group-hover:scale-105 transition-transform duration-300">
                            <i data-lucide="building-2" class="w-6 h-6"></i>
                        </div>
                        <span class="bg-clip-text text-transparent bg-gradient-to-r from-slate-900 to-slate-700 hover:opacity-80 transition">CityBiz</span>
                    </a>
                </div>
                
                <nav class="hidden md:flex space-x-9">
                    <a href="/space" class="text-base font-semibold text-blue-600 relative after:content-[''] after:absolute after:bottom-[-6px] after:left-0 after:w-full after:h-[2px] after:bg-blue-600 after:rounded-full">공간 대여</a>
                    <a href="/policy" class="text-base font-medium text-slate-600 hover:text-blue-600 transition-colors">정책 지원</a>
                    <a href="/consulting" class="text-base font-medium text-slate-600 hover:text-blue-600 transition-colors">컨설팅 네트워크</a>
                </nav>

                <div class="flex items-center gap-5">
                    <c:choose>
                        <%-- [Backend] 세션의 로그인 유저 확인 로직 --%>
                        <c:when test="${not empty sessionScope.loginUser}">
                            <div class="flex items-center gap-4">
                                <div class="flex items-center gap-2 px-4 py-2 bg-white border border-slate-200 rounded-full shadow-sm text-sm font-medium">
                                    <div class="w-6 h-6 rounded-full bg-gradient-to-tr from-blue-500 to-indigo-500 flex items-center justify-center text-white text-xs font-bold shadow-inner">
                                        ${fn:substring(sessionScope.loginName, 0, 1)}
                                    </div>
                                    <span class="text-slate-700"><strong class="text-slate-900">${sessionScope.loginName}</strong> 님</span>
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

    <main class="flex-grow max-w-[1400px] mx-auto w-full px-4 sm:px-6 lg:px-8 py-12 flex flex-col gap-10 relative overflow-hidden">
        
        <div class="absolute top-[-5%] left-[-5%] w-96 h-96 bg-blue-400/15 rounded-full blur-3xl pointer-events-none"></div>

        <section class="grid grid-cols-1 md:grid-cols-2 gap-6 relative z-10">
            <button onclick="alert('AI가 사용자 데이터를 분석하여 최적의 장소를 추천합니다.')" class="bg-gradient-to-r from-blue-600 to-indigo-600 rounded-3xl p-8 text-left relative overflow-hidden group shadow-md hover:shadow-xl transition-all duration-300">
                <div class="relative z-10">
                    <span class="bg-white/20 text-white text-xs font-bold px-3 py-1.5 roundedbackdrop-blur-sm mb-4 inline-block tracking-wide">AI Powered</span>
                    <h2 class="text-3xl font-extrabold text-white mb-3 tracking-tight">✨ 내 비즈니스 맞춤 장소 추천</h2>
                    <p class="text-blue-100 text-base font-light">업종, 예산, 선호 지역을 분석해 딱 맞는 공간을 찾아드려요.</p>
                </div>
                <i data-lucide="sparkles" class="absolute right-6 bottom-6 w-28 h-28 text-white opacity-25 group-hover:scale-110 transition-transform duration-500"></i>
            </button>

            <button onclick="alert('상황별(예: 팝업스토어 준비, 투자자 미팅 등) 공간 패키지를 추천합니다.')" class="bg-white border border-slate-100 rounded-3xl p-8 text-left relative overflow-hidden group shadow-[0_4px_20px_-4px_rgba(0,0,0,0.05)] hover:shadow-xl transition-all duration-300">
                <div class="relative z-10">
                    <span class="bg-purple-50 text-purple-600 border border-purple-100 text-xs font-bold px-3 py-1.5 rounded mb-4 inline-block tracking-wide">Curation</span>
                    <h2 class="text-3xl font-extrabold text-slate-900 mb-3 tracking-tight">🎯 상황별 장소 묶음 추천</h2>
                    <p class="text-slate-500 text-base font-light">"투자자 피칭", "1일 팝업스토어" 등 상황에 맞는 공간을 모아보세요.</p>
                </div>
                <i data-lucide="layers" class="absolute right-6 bottom-6 w-28 h-28 text-slate-100 group-hover:scale-110 transition-transform duration-500"></i>
            </button>
        </section>

        <div class="flex flex-col md:flex-row gap-10 items-start relative z-10">
            
            <aside class="w-full md:w-[360px] flex-shrink-0 bg-white rounded-3xl border border-slate-100 p-8 sticky top-28 max-h-[calc(100vh-10rem)] overflow-y-auto custom-scrollbar shadow-[0_4px_20px_-4px_rgba(0,0,0,0.05)]">
                <div class="flex justify-between items-center mb-8 pb-4 border-b border-slate-100">
                    <h3 class="font-extrabold text-xl flex items-center gap-2.5 text-slate-900"><i data-lucide="sliders-horizontal" class="w-6 h-6 text-blue-500"></i> 상세 검색</h3>
                    <button type="reset" class="text-sm font-medium text-slate-400 hover:text-rose-500 underline transition-colors flex items-center gap-1.5"><i data-lucide="rotate-ccw" class="w-4 h-4"></i>초기화</button>
                </div>

                <div class="space-y-8">
                    
                    <div>
                        <label class="block text-sm font-semibold text-slate-700 mb-3 tracking-wide">지역</label>
                        <div class="relative">
                            <i data-lucide="map-pin" class="absolute left-3.5 top-1/2 -translate-y-1/2 w-4 h-4 text-slate-400"></i>
                            <input type="text" placeholder="예: 강남구, 성수동" class="w-full pl-10 pr-4 py-3 bg-white border border-slate-200 rounded-xl text-sm focus:outline-none focus:ring-2 focus:ring-blue-100 focus:border-blue-300 transition-all">
                        </div>
                    </div>

                    <div>
                        <label class="block text-sm font-semibold text-slate-700 mb-3 tracking-wide">공간 유형</label>
                        <div class="flex flex-wrap gap-2.5">
                            <div class="relative">
                                <input type="checkbox" id="type_shop" name="spaceType" value="shop" class="hidden hidden-checkbox">
                                <label for="type_shop" class="cursor-pointer inline-block px-4 py-2 border border-slate-200 rounded-full text-sm text-slate-600 hover:bg-slate-50 transition-all shadow-sm">상점(쇼룸)</label>
                            </div>
                            <div class="relative">
                                <input type="checkbox" id="type_warehouse" name="spaceType" value="warehouse" class="hidden hidden-checkbox">
                                <label for="type_warehouse" class="cursor-pointer inline-block px-4 py-2 border border-slate-200 rounded-full text-sm text-slate-600 hover:bg-slate-50 transition-all shadow-sm">창고(물류)</label>
                            </div>
                            <div class="relative">
                                <input type="checkbox" id="type_studio" name="spaceType" value="studio" class="hidden hidden-checkbox">
                                <label for="type_studio" class="cursor-pointer inline-block px-4 py-2 border border-slate-200 rounded-full text-sm text-slate-600 hover:bg-slate-50 transition-all shadow-sm">스튜디오</label>
                            </div>
                            <div class="relative">
                                <input type="checkbox" id="type_meeting" name="spaceType" value="meeting" class="hidden hidden-checkbox">
                                <label for="type_meeting" class="cursor-pointer inline-block px-4 py-2 border border-slate-200 rounded-full text-sm text-slate-600 hover:bg-slate-50 transition-all shadow-sm">회의실</label>
                            </div>
                            <div class="relative">
                                <input type="checkbox" id="type_consulting" name="spaceType" value="consulting" class="hidden hidden-checkbox">
                                <label for="type_consulting" class="cursor-pointer inline-block px-4 py-2 border border-slate-200 rounded-full text-sm text-slate-600 hover:bg-slate-50 transition-all shadow-sm">상담실</label>
                            </div>
                            <div class="relative">
                                <input type="checkbox" id="type_office" name="spaceType" value="office" class="hidden hidden-checkbox">
                                <label for="type_office" class="cursor-pointer inline-block px-4 py-2 border border-slate-200 rounded-full text-sm text-slate-600 hover:bg-slate-50 transition-all shadow-sm">사무실</label>
                            </div>
                        </div>
                    </div>

                    <div>
                        <label class="block text-sm font-semibold text-slate-700 mb-3 tracking-wide">가격 (1시간 기준)</label>
                        <div class="flex items-center gap-2.5 mb-4">
                            <input type="number" id="minPrice" placeholder="0" class="w-full px-3.5 py-2.5 bg-white border border-slate-200 rounded-xl text-sm focus:outline-none focus:ring-2 focus:ring-blue-100 transition-all">
                            <span class="text-slate-400 font-bold">~</span>
                            <input type="number" id="maxPrice" value="50000" class="w-full px-3.5 py-2.5 bg-white border border-slate-200 rounded-xl text-sm focus:outline-none focus:ring-2 focus:ring-blue-100 transition-all">
                            <span class="text-sm font-medium text-slate-600">원</span>
                        </div>
                        <input type="range" id="priceRange" min="0" max="100000" step="5000" value="50000" class="w-full h-1.5 bg-slate-200 rounded-full appearance-none cursor-pointer accent-blue-600">
                    </div>

                    <hr class="border-slate-100">

                    <div class="grid grid-cols-2 gap-4">
                        <div>
                            <label class="block text-sm font-semibold text-slate-700 mb-3 tracking-wide">날짜</label>
                            <input type="date" class="w-full px-3.5 py-2.5 bg-white border border-slate-200 rounded-xl text-sm focus:outline-none focus:ring-2 focus:ring-blue-100 transition-all text-slate-600">
                        </div>
                        <div>
                            <label class="block text-sm font-semibold text-slate-700 mb-3 tracking-wide">인원</label>
                            <div class="relative">
                                <input type="number" min="1" placeholder="1" class="w-full pl-3.5 pr-9 py-2.5 bg-white border border-slate-200 rounded-xl text-sm focus:outline-none focus:ring-2 focus:ring-blue-100 transition-all pr-8">
                                <span class="absolute right-3.5 top-1/2 -translate-y-1/2 text-sm text-slate-500 font-medium">명</span>
                            </div>
                        </div>
                    </div>

                    <hr class="border-slate-100">

                    <div>
                        <label class="block text-sm font-semibold text-slate-700 mb-3 tracking-wide">기타 서비스</label>
                        <div class="flex flex-wrap gap-2.5">
                            <div class="relative">
                                <input type="checkbox" id="svc_parking" class="hidden hidden-checkbox">
                                <label for="svc_parking" class="cursor-pointer inline-flex items-center gap-1.5 px-4 py-2 border border-slate-200 rounded-full text-sm text-slate-600 hover:bg-slate-50 transition-all shadow-sm"><i data-lucide="car" class="w-4 h-4 text-blue-500"></i> 주차장</label>
                            </div>
                            <div class="relative">
                                <input type="checkbox" id="svc_wifi" class="hidden hidden-checkbox">
                                <label for="svc_wifi" class="cursor-pointer inline-flex items-center gap-1.5 px-4 py-2 border border-slate-200 rounded-full text-sm text-slate-600 hover:bg-slate-50 transition-all shadow-sm"><i data-lucide="wifi" class="w-4 h-4 text-blue-500"></i> 와이파이</label>
                            </div>
                            <div class="relative">
                                <input type="checkbox" id="svc_ac" class="hidden hidden-checkbox">
                                <label for="svc_ac" class="cursor-pointer inline-flex items-center gap-1.5 px-4 py-2 border border-slate-200 rounded-full text-sm text-slate-600 hover:bg-slate-50 transition-all shadow-sm"><i data-lucide="thermometer-snowflake" class="w-4 h-4 text-blue-500"></i> 냉/난방</label>
                            </div>
                            <div class="relative">
                                <input type="checkbox" id="svc_coffee" class="hidden hidden-checkbox">
                                <label for="svc_coffee" class="cursor-pointer inline-flex items-center gap-1.5 px-4 py-2 border border-slate-200 rounded-full text-sm text-slate-600 hover:bg-slate-50 transition-all shadow-sm"><i data-lucide="coffee" class="w-4 h-4 text-blue-500"></i> 음료 제공</label>
                            </div>
                        </div>
                    </div>

                    <button class="w-full bg-slate-900 text-white font-bold py-4 rounded-xl hover:bg-slate-800 transition-all duration-300 mt-4 shadow-md hover:shadow-lg hover:-translate-y-0.5 tracking-wide">
                        공간 검색하기
                    </button>
                </div>
            </aside>

            <div class="flex-grow flex flex-col gap-8">
                <div class="flex justify-between items-center px-4 py-3 bg-white rounded-2xl border border-slate-100 shadow-sm">
                    <p class="text-slate-600">총 <strong class="text-blue-600 font-bold">24</strong>개의 공간을 발견했습니다.</p>
                    <div class="flex items-center gap-1.5 text-sm font-medium text-slate-600 cursor-pointer hover:text-blue-600 transition">
                        추천순 <i data-lucide="chevron-down" class="w-4 h-4"></i>
                        </div>
                </div>

                <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
                    
                    <div class="bg-white rounded-3xl overflow-hidden hover:shadow-xl hover:-translate-y-1 transition-all duration-300 border border-slate-50 shadow-[0_4px_20px_-4px_rgba(0,0,0,0.05)] cursor-pointer group">
                        <div class="h-56 bg-slate-100 relative overflow-hidden">
                            <img src="https://images.unsplash.com/photo-1497366216548-37526070297c?auto=format&fit=crop&q=80&w=600" alt="공간 사진" class="w-full h-full object-cover group-hover:scale-105 transition-transform duration-500">
                            <div class="absolute top-4 left-4 bg-white/80 px-3 py-1.5 rounded-full text-xs font-bold text-blue-600 backdrop-blur-sm shadow-inner">회의실</div>
                        </div>
                        <div class="p-6">
                            <h4 class="font-extrabold text-xl mb-1.5 truncate text-slate-900 group-hover:text-blue-600 transition">강남역 비즈니스 센터 A호</h4>
                            <p class="text-sm text-slate-500 flex items-center gap-1.5 mb-4 font-light"><i data-lucide="map-pin" class="w-4 h-4"></i> 서울특별시 강남구 역삼동</p>
                            <div class="flex wrap gap-2 mb-5">
                                <span class="bg-slate-50 text-slate-600 text-xs px-2.5 py-1.5 rounded border border-slate-100 font-medium">최대 8명</span>
                                <span class="bg-slate-50 text-slate-600 text-xs px-2.5 py-1.5 rounded border border-slate-100 font-medium">주차가능</span>
                                <span class="bg-slate-50 text-slate-600 text-xs px-2.5 py-1.5 rounded border border-slate-100 font-medium">화이트보드</span>
                            </div>
                            <div class="flex justify-between items-end border-t border-slate-100 pt-4 mt-auto">
                                <p class="text-2xl font-extrabold text-slate-900 tracking-tight">15,000<span class="text-sm font-normal text-slate-500">원 / 시간</span></p>
                                <i data-lucide="arrow-right" class="w-5 h-5 text-blue-600 opacity-0 group-hover:opacity-100 transition duration-300 group-hover:translate-x-1"></i>
                            </div>
                        </div>
                    </div>

                    <div class="bg-white rounded-3xl overflow-hidden hover:shadow-xl hover:-translate-y-1 transition-all duration-300 border border-slate-50 shadow-[0_4px_20px_-4px_rgba(0,0,0,0.05)] cursor-pointer group">
                        <div class="h-56 bg-slate-100 relative overflow-hidden">
                            <img src="https://images.unsplash.com/photo-1600508673752-19e4963e6392?auto=format&fit=crop&q=80&w=600" alt="공간 사진" class="w-full h-full object-cover group-hover:scale-105 transition-transform duration-500">
                            <div class="absolute top-4 left-4 bg-white/80 px-3 py-1.5 rounded-full text-xs font-bold text-indigo-600 backdrop-blur-sm shadow-inner">스튜디오</div>
                        </div>
                        <div class="p-6">
                            <h4 class="font-extrabold text-xl mb-1.5 truncate text-slate-900 group-hover:text-blue-600 transition">성수 자연광 스튜디오</h4>
                            <p class="text-sm text-slate-500 flex items-center gap-1.5 mb-4 font-light"><i data-lucide="map-pin" class="w-4 h-4"></i> 서울특별시 성동구 성수동</p>
                            <div class="flex wrap gap-2 mb-5">
                                <span class="bg-slate-50 text-slate-600 text-xs px-2.5 py-1.5 rounded border border-slate-100 font-medium">최대 4명</span>
                                <span class="bg-slate-50 text-slate-600 text-xs px-2.5 py-1.5 rounded border border-slate-100 font-medium">조명기기</span>
                            </div>
                            <div class="flex justify-between items-end border-t border-slate-100 pt-4 mt-auto">
                                <p class="text-2xl font-extrabold text-slate-900 tracking-tight">30,000<span class="text-sm font-normal text-slate-500">원 / 시간</span></p>
                                <i data-lucide="arrow-right" class="w-5 h-5 text-indigo-600 opacity-0 group-hover:opacity-100 transition duration-300 group-hover:translate-x-1"></i>
                            </div>
                        </div>
                    </div>

                    <div class="bg-white rounded-3xl overflow-hidden hover:shadow-xl hover:-translate-y-1 transition-all duration-300 border border-slate-50 shadow-[0_4px_20px_-4px_rgba(0,0,0,0.05)] cursor-pointer group">
                        <div class="h-56 bg-slate-100 relative overflow-hidden">
                            <img src="https://images.unsplash.com/photo-1522071820081-009f0129c71c?auto=format&fit=crop&q=80&w=600" alt="공간 사진" class="w-full h-full object-cover group-hover:scale-105 transition-transform duration-500">
                            <div class="absolute top-4 left-4 bg-white/80 px-3 py-1.5 rounded-full text-xs font-bold text-purple-600 backdrop-blur-sm shadow-inner">사무실</div>
                        </div>
                        <div class="p-6">
                            <h4 class="font-extrabold text-xl mb-1.5 truncate text-slate-900 group-hover:text-blue-600 transition">판교 코워킹 스페이스</h4>
                            <p class="text-sm text-slate-500 flex items-center gap-1.5 mb-4 font-light"><i data-lucide="map-pin" class="w-4 h-4"></i> 경기도 성남시 분당구 삼평동</p>
                            <div class="flex wrap gap-2 mb-5">
                                <span class="bg-slate-50 text-slate-600 text-xs px-2.5 py-1.5 rounded border border-slate-100 font-medium">1인 지정석</span>
                                <span class="bg-slate-50 text-slate-600 text-xs px-2.5 py-1.5 rounded border border-slate-100 font-medium">24시간</span>
                            </div>
                            <div class="flex justify-between items-end border-t border-slate-100 pt-4 mt-auto">
                                <p class="text-2xl font-extrabold text-slate-900 tracking-tight">250,000<span class="text-sm font-normal text-slate-500">원 / 월</span></p>
                                <i data-lucide="arrow-right" class="w-5 h-5 text-purple-600 opacity-0 group-hover:opacity-100 transition duration-300 group-hover:translate-x-1"></i>
                            </div>
                        </div>
                    </div>

                </div>
            </div>
        </div>
    </main>

    <footer class="border-t border-slate-200 bg-white py-12 mt-16">
        <div class="max-w-[1400px] mx-auto px-4 flex flex-col md:flex-row justify-between items-center gap-6">
            <div class="flex items-center gap-2.5 opacity-60 hover:opacity-100 transition">
                <div class="p-2 bg-gradient-to-br from-slate-600 to-slate-800 rounded-lg text-white shadow">
                    <i data-lucide="building-2" class="w-5 h-5"></i>
                </div>
                <span class="text-xl font-bold text-slate-900">CityBiz</span>
            </div>
            <div class="text-center md:text-left">
                <p class="text-slate-500 text-sm">AI 소프트웨어 학과 졸업작품 프로젝트</p>
                <p class="text-slate-400 text-xs mt-1">&copy; 2026 CityBiz Team. All rights reserved.</p>
            </div>
            <div class="flex gap-4">
                <a href="#" class="text-slate-400 hover:text-blue-600 transition-colors"><i data-lucide="github" class="w-5 h-5"></i></a>
            </div>
        </div>
    </footer>

    <script>
        lucide.createIcons();

        // 가격 슬라이더와 입력창 동기화 로직
        const maxPriceInput = document.getElementById('maxPrice');
        const priceRange = document.getElementById('priceRange');

        priceRange.addEventListener('input', function() {
            maxPriceInput.value = this.value;
        });

        maxPriceInput.addEventListener('input', function() {
            let val = parseInt(this.value);
            if(val > parseInt(priceRange.max)) val = priceRange.max;
            if(val < parseInt(priceRange.min)) val = priceRange.min;
            priceRange.value = val;
        });
    </script>
</body>
</html>