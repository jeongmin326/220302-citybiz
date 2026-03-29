<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%-- 헤더 파일 로드 --%>
<jsp:include page="/WEB-INF/views/common/header.jsp" />

    <main class="flex-grow max-w-[1400px] mx-auto w-full px-4 sm:px-6 lg:px-8 py-12 flex flex-col gap-10 relative overflow-hidden">
        
        <div class="absolute top-[-5%] left-[-5%] w-96 h-96 bg-blue-400/15 rounded-full blur-3xl pointer-events-none"></div>

        <section class="grid grid-cols-1 md:grid-cols-2 gap-6 relative z-10">
            <%-- [AI/ML] 사용자의 선호 데이터(과거 예약, 관심지역)를 FastAPI에 전달하여 추천 리스트 반환 요청 --%>
            <button onclick="requestAiRecommendation()" class="bg-gradient-to-r from-blue-600 to-indigo-600 rounded-3xl p-8 text-left relative overflow-hidden group shadow-md hover:shadow-xl transition-all duration-300">
                <div class="relative z-10">
                    <span class="bg-white/20 text-white text-xs font-bold px-3 py-1.5 roundedbackdrop-blur-sm mb-4 inline-block tracking-wide">AI Powered</span>
                    <h2 class="text-3xl font-extrabold text-white mb-3 tracking-tight">✨ 내 비즈니스 맞춤 장소 추천</h2>
                    <p class="text-blue-100 text-base font-light">업종, 예산, 선호 지역을 분석해 딱 맞는 공간을 찾아드려요.</p>
                </div>
                <i data-lucide="sparkles" class="absolute right-6 bottom-6 w-28 h-28 text-white opacity-25 group-hover:scale-110 transition-transform duration-500"></i>
            </button>

            <%-- [AI/ML] '상황(Category)' 태그를 기반으로 클러스터링된 장소 그룹 API 호출 --%>
            <button onclick="alert('상황별 공간 패키지를 로드합니다.')" class="bg-white border border-slate-100 rounded-3xl p-8 text-left relative overflow-hidden group shadow-[0_4px_20px_-4px_rgba(0,0,0,0.05)] hover:shadow-xl transition-all duration-300">
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

                <%-- [Backend/DB] 검색 폼 데이터 제출 시 PostGIS의 ST_DWithin 등을 사용하여 반경 검색 구현 권장 --%>
                <form id="searchForm" class="space-y-8">
                    <div>
                        <label class="block text-sm font-semibold text-slate-700 mb-3 tracking-wide">지역</label>
                        <div class="relative">
                            <i data-lucide="map-pin" class="absolute left-3.5 top-1/2 -translate-y-1/2 w-4 h-4 text-slate-400"></i>
                            <input type="text" id="locationInput" placeholder="예: 강남구, 성수동" class="w-full pl-10 pr-4 py-3 bg-white border border-slate-200 rounded-xl text-sm focus:outline-none focus:ring-2 focus:ring-blue-100 focus:border-blue-300 transition-all">
                        </div>
                    </div>

                    <div>
                        <label class="block text-sm font-semibold text-slate-700 mb-3 tracking-wide">공간 유형</label>
                        <div class="flex flex-wrap gap-2.5">
                            <c:forEach var="type" items="${['shop', 'warehouse', 'studio', 'meeting', 'consulting', 'office']}">
                                <div class="relative">
                                    <input type="checkbox" id="type_${type}" name="spaceType" value="${type}" class="hidden hidden-checkbox">
                                    <label for="type_${type}" class="cursor-pointer inline-block px-4 py-2 border border-slate-200 rounded-full text-sm text-slate-600 hover:bg-slate-50 transition-all shadow-sm">
                                        ${type == 'shop' ? '상점' : type == 'warehouse' ? '창고' : type == 'studio' ? '스튜디오' : type == 'meeting' ? '회의실' : type == 'consulting' ? '상담실' : '사무실'}
                                    </label>
                                </div>
                            </c:forEach>
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

                    <button type="button" onclick="searchSpaces()" class="w-full bg-slate-900 text-white font-bold py-4 rounded-xl hover:bg-slate-800 transition-all duration-300 mt-4 shadow-md hover:shadow-lg hover:-translate-y-0.5 tracking-wide">
                        공간 검색하기
                    </button>
                </form>
            </aside>

            <div class="flex-grow flex flex-col gap-8">
                <div class="flex justify-between items-center px-4 py-3 bg-white rounded-2xl border border-slate-100 shadow-sm">
                    <%-- [Backend] 검색 결과 카운트 반영 --%>
                    <p class="text-slate-600">총 <strong class="text-blue-600 font-bold" id="resultCount">24</strong>개의 공간을 발견했습니다.</p>
                    <div class="flex items-center gap-1.5 text-sm font-medium text-slate-600 cursor-pointer hover:text-blue-600 transition">
                        추천순 <i data-lucide="chevron-down" class="w-4 h-4"></i>
                    </div>
                </div>

                <%-- 공간 카드 리스트 영역 --%>
                <div id="spaceCardContainer" class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
                    <%-- 하드코딩 데이터 (JS에서 동적 생성 전 초기 모습) --%>
                    <div class="bg-white rounded-3xl overflow-hidden hover:shadow-xl hover:-translate-y-1 transition-all duration-300 border border-slate-50 shadow-[0_4px_20px_-4px_rgba(0,0,0,0.05)] cursor-pointer group">
                        <div class="h-56 bg-slate-100 relative overflow-hidden">
                            <img src="https://images.unsplash.com/photo-1497366216548-37526070297c?auto=format&fit=crop&q=80&w=600" class="w-full h-full object-cover group-hover:scale-105 transition-transform duration-500">
                            <div class="absolute top-4 left-4 bg-white/80 px-3 py-1.5 rounded-full text-xs font-bold text-blue-600 backdrop-blur-sm shadow-inner">회의실</div>
                        </div>
                        <div class="p-6">
                            <h4 class="font-extrabold text-xl mb-1.5 truncate text-slate-900 group-hover:text-blue-600 transition">강남역 비즈니스 센터 A호</h4>
                            <p class="text-sm text-slate-500 flex items-center gap-1.5 mb-4 font-light"><i data-lucide="map-pin" class="w-4 h-4"></i> 서울특별시 강남구 역삼동</p>
                            <div class="flex justify-between items-end border-t border-slate-100 pt-4 mt-auto">
                                <p class="text-2xl font-extrabold text-slate-900 tracking-tight">15,000<span class="text-sm font-normal text-slate-500">원 / 시간</span></p>
                                <i data-lucide="arrow-right" class="w-5 h-5 text-blue-600 opacity-0 group-hover:opacity-100 transition duration-300 group-hover:translate-x-1"></i>
                            </div>
                        </div>
                    </div>
                    <%-- 추가 카드는 비워두거나 JS에서 렌더링 --%>
                </div>
            </div>
        </div>
    </main>

<script>
    // [AI/ML] FastAPI 서버와 통신하는 예시 함수
    async function requestAiRecommendation() {
        try {
            // const response = await axios.post('http://ai-server:8000/recommend', { user_id: 123 });
            alert('AI가 사용자 데이터를 분석하여 최적의 장소를 추천합니다. (FastAPI 연결 지점)');
        } catch (error) {
            console.error('AI 서버 통신 오류', error);
        }
    }

    // [Backend] Spring Boot API와 통신하여 공간 리스트 가져오기
    async function searchSpaces() {
        try {
            // const response = await axios.get('/api/spaces', { params: { location: '강남' } });
            alert('검색 필터에 맞는 데이터를 Spring Boot 서버에 요청합니다.');
        } catch (error) {
            console.error('API 서버 통신 오류', error);
        }
    }

    // 가격 슬라이더 동기화
    const maxPriceInput = document.getElementById('maxPrice');
    const priceRange = document.getElementById('priceRange');
    priceRange.addEventListener('input', function() { maxPriceInput.value = this.value; });
    maxPriceInput.addEventListener('input', function() {
        let val = parseInt(this.value);
        if(val > parseInt(priceRange.max)) val = priceRange.max;
        priceRange.value = val;
    });
</script>

<%-- 푸터 파일 로드 --%>
<jsp:include page="/WEB-INF/views/common/footer.jsp" />