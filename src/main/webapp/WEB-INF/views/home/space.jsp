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
                        <div class="flex flex-col gap-2.5">
                            <div class="relative">
                                <i data-lucide="map-pin" class="absolute left-3.5 top-1/2 -translate-y-1/2 w-4 h-4 text-slate-400 pointer-events-none"></i>
                                <select id="regionSelect" onchange="onRegionChange()" class="w-full pl-10 pr-4 py-3 bg-white border border-slate-200 rounded-xl text-sm focus:outline-none focus:ring-2 focus:ring-blue-100 focus:border-blue-300 transition-all appearance-none cursor-pointer">
                                    <option value="">전체 지역</option>
                                    <option value="서울">서울</option>
                                </select>
                            </div>
                            <div class="relative">
                                <i data-lucide="navigation" class="absolute left-3.5 top-1/2 -translate-y-1/2 w-4 h-4 text-slate-400 pointer-events-none"></i>
                                <select id="districtSelect" disabled class="w-full pl-10 pr-4 py-3 bg-white border border-slate-200 rounded-xl text-sm focus:outline-none focus:ring-2 focus:ring-blue-100 focus:border-blue-300 transition-all appearance-none cursor-pointer disabled:bg-slate-50 disabled:text-slate-400">
                                    <option value="">먼저 지역을 선택하세요</option>
                                </select>
                            </div>
                        </div>
                    </div>

                    <div>
                        <label class="block text-sm font-semibold text-slate-700 mb-3 tracking-wide">공간 유형</label>
                        <div class="flex flex-wrap gap-2.5">
                            <div class="relative">
                                <input type="checkbox" id="type_shop" name="spaceType" value="shop" class="hidden hidden-checkbox">
                                <label for="type_shop" class="cursor-pointer inline-block px-4 py-2 border border-slate-200 rounded-full text-sm text-slate-600 hover:bg-slate-50 transition-all shadow-sm">상점</label>
                            </div>
                            <div class="relative">
                                <input type="checkbox" id="type_warehouse" name="spaceType" value="warehouse" class="hidden hidden-checkbox">
                                <label for="type_warehouse" class="cursor-pointer inline-block px-4 py-2 border border-slate-200 rounded-full text-sm text-slate-600 hover:bg-slate-50 transition-all shadow-sm">창고</label>
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
                        <div class="flex flex-col gap-3">
                            <label class="flex items-center gap-3 cursor-pointer group">
                                <input type="radio" name="priceRange" value="all" class="accent-blue-600 w-4 h-4" checked>
                                <span class="text-sm font-medium text-slate-700 group-hover:text-blue-600 transition-colors">전체</span>
                            </label>
                            <label class="flex items-center gap-3 cursor-pointer group">
                                <input type="radio" name="priceRange" value="10000" class="accent-blue-600 w-4 h-4">
                                <span class="text-sm font-medium text-slate-700 group-hover:text-blue-600 transition-colors">1만원 이하</span>
                            </label>
                            <label class="flex items-center gap-3 cursor-pointer group">
                                <input type="radio" name="priceRange" value="10001-20000" class="accent-blue-600 w-4 h-4">
                                <span class="text-sm font-medium text-slate-700 group-hover:text-blue-600 transition-colors">1만원 ~ 2만원</span>
                            </label>
                            <label class="flex items-center gap-3 cursor-pointer group">
                                <input type="radio" name="priceRange" value="20001-30000" class="accent-blue-600 w-4 h-4">
                                <span class="text-sm font-medium text-slate-700 group-hover:text-blue-600 transition-colors">2만원 ~ 3만원</span>
                            </label>
                        </div>
                    </div>

                    <div>
                        <label class="block text-sm font-semibold text-slate-700 mb-3 tracking-wide">인원</label>
                        <div class="flex flex-col gap-3">
                            <label class="flex items-center gap-3 cursor-pointer group">
                                <input type="radio" name="capacity" value="all" class="accent-blue-600 w-4 h-4" checked>
                                <span class="text-sm font-medium text-slate-700 group-hover:text-blue-600 transition-colors">전체</span>
                            </label>
                            <label class="flex items-center gap-3 cursor-pointer group">
                                <input type="radio" name="capacity" value="4" class="accent-blue-600 w-4 h-4">
                                <span class="text-sm font-medium text-slate-700 group-hover:text-blue-600 transition-colors flex items-center gap-1">
                                    <i data-lucide="users" class="w-4 h-4 text-slate-400"></i> 4명 이상
                                </span>
                            </label>
                            <label class="flex items-center gap-3 cursor-pointer group">
                                <input type="radio" name="capacity" value="8" class="accent-blue-600 w-4 h-4">
                                <span class="text-sm font-medium text-slate-700 group-hover:text-blue-600 transition-colors flex items-center gap-1">
                                    <i data-lucide="users" class="w-4 h-4 text-slate-400"></i> 8명 이상
                                </span>
                            </label>
                            <label class="flex items-center gap-3 cursor-pointer group">
                                <input type="radio" name="capacity" value="15" class="accent-blue-600 w-4 h-4">
                                <span class="text-sm font-medium text-slate-700 group-hover:text-blue-600 transition-colors flex items-center gap-1">
                                    <i data-lucide="users" class="w-4 h-4 text-slate-400"></i> 15명 이상
                                </span>
                            </label>
                            <label class="flex items-center gap-3 cursor-pointer group">
                                <input type="radio" name="capacity" value="20" class="accent-blue-600 w-4 h-4">
                                <span class="text-sm font-medium text-slate-700 group-hover:text-blue-600 transition-colors flex items-center gap-1">
                                    <i data-lucide="users" class="w-4 h-4 text-slate-400"></i> 20명 이상
                                </span>
                            </label>
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
                    <p class="text-slate-600">총 <strong class="text-blue-600 font-bold" id="resultCount"></strong>개의 공간을 발견했습니다.</p>
                    <div class="flex items-center gap-1.5 text-sm font-medium text-slate-600 cursor-pointer hover:text-blue-600 transition">
                        추천순 <i data-lucide="chevron-down" class="w-4 h-4"></i>
                    </div>
                </div>

                <%-- 공간 카드 리스트 영역 --%>
                <div id="spaceCardContainer" class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
                    <%-- 하드코딩 데이터 (JS에서 동적 생성 전 초기 모습) --%>
                    <!-- <div class="bg-white rounded-3xl overflow-hidden hover:shadow-xl hover:-translate-y-1 transition-all duration-300 border border-slate-50 shadow-[0_4px_20px_-4px_rgba(0,0,0,0.05)] cursor-pointer group">
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
                    </div> -->
                    <%-- 추가 카드는 비워두거나 JS에서 렌더링 --%>
                </div>

                <div id="loadMoreContainer" class="pt-2 hidden">
                    <div class="flex justify-center">
                        <button id="loadMoreButton" type="button" class="bg-white border border-slate-200 hover:border-blue-300 hover:text-blue-600 text-slate-700 px-6 py-3 rounded-2xl text-sm font-bold shadow-sm transition-all">
                            더보기
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </main>

<script>
    // [AI/ML] FastAPI 서버와 통신하는 예시 함수
    async function requestAiRecommendation() {
        try {
            alert('AI가 사용자 데이터를 분석하여 최적의 장소를 추천합니다. (FastAPI 연결 지점)');
        } catch (error) {
            console.error('AI 서버 통신 오류', error);
        }
    }

    // 서울 25개 구 목록
    const districtMap = {
        '서울': [
            '강남구', '강동구', '강북구', '강서구', '관악구',
            '광진구', '구로구', '금천구', '노원구', '도봉구',
            '동대문구', '동작구', '마포구', '서대문구', '서초구',
            '성동구', '성북구', '송파구', '양천구', '영등포구',
            '용산구', '은평구', '종로구', '중구', '중랑구'
        ]
    };

    function onRegionChange() {
        const regionSelect = document.getElementById('regionSelect');
        const districtSelect = document.getElementById('districtSelect');
        const region = regionSelect.value;

        districtSelect.innerHTML = '';

        if (region && districtMap[region]) {
            districtSelect.disabled = false;
            districtSelect.insertAdjacentHTML('beforeend', '<option value="">전체 구</option>');
            districtMap[region].forEach(function(district) {
                districtSelect.insertAdjacentHTML('beforeend',
                    '<option value="' + district + '">' + district + '</option>');
            });
        } else {
            districtSelect.disabled = true;
            districtSelect.insertAdjacentHTML('beforeend', '<option value="">먼저 지역을 선택하세요</option>');
        }
    }

    // 공간 유형 체크박스 토글 스타일
    document.querySelectorAll('.hidden-checkbox').forEach(function(checkbox) {
        checkbox.addEventListener('change', function() {
            const label = this.nextElementSibling;
            if (this.checked) {
                label.classList.add('bg-blue-600', 'text-white', 'border-blue-600');
                label.classList.remove('text-slate-600', 'border-slate-200');
            } else {
                label.classList.remove('bg-blue-600', 'text-white', 'border-blue-600');
                label.classList.add('text-slate-600', 'border-slate-200');
            }
        });
    });

    // 검색 필터 수집
    function getSelectedFilters() {
        const region = document.getElementById('regionSelect').value;
        const district = document.getElementById('districtSelect').value;
        const spaceTypes = Array.from(document.querySelectorAll('input[name="spaceType"]:checked'))
            .map(function(input) { return input.value; });

        // 가격 라디오
        const priceRadio = document.querySelector('input[name="priceRange"]:checked');
        const priceVal = priceRadio ? priceRadio.value : 'all';
        let minPrice = '';
        let maxPrice = '';
        if (priceVal !== 'all') {
            if (priceVal.indexOf('-') !== -1) {
                var parts = priceVal.split('-');
                minPrice = parts[0];
                maxPrice = parts[1];
            } else {
                maxPrice = priceVal;
            }
        }

        // 인원 라디오
        const capacityRadio = document.querySelector('input[name="capacity"]:checked');
        const capacity = (capacityRadio && capacityRadio.value !== 'all') ? capacityRadio.value : '';

        return {
            region: region,
            district: district,
            spaceTypes: spaceTypes,
            minPrice: minPrice,
            maxPrice: maxPrice,
            capacity: capacity
        };
    }

    // 검색 버튼 클릭 시 필터 적용하여 새로 검색
    function searchSpaces() {
        loadSpaces(false);
    }

    const PAGE_SIZE = 12;
    let currentPage = 0;
    let hasNextPage = false;
    let totalElements = 0;
    let isLoading = false;

    function setLoadMoreVisible(visible) {
        const loadMoreContainer = document.getElementById('loadMoreContainer');
        if (!loadMoreContainer) return;

        if (visible) {
            loadMoreContainer.classList.remove('hidden');
        } else {
            loadMoreContainer.classList.add('hidden');
        }
    }

    function renderEmptyState() {
        const container = document.getElementById('spaceCardContainer');
        container.innerHTML =
            '<div class="col-span-1 md:col-span-2 lg:col-span-3 bg-white rounded-3xl border border-dashed border-slate-200 shadow-sm p-10 text-center">' +
                '<div class="mx-auto mb-4 w-14 h-14 rounded-2xl bg-slate-100 flex items-center justify-center">' +
                    '<i data-lucide="building-2" class="w-7 h-7 text-slate-400"></i>' +
                '</div>' +
                '<h3 class="text-lg font-bold text-slate-800 mb-2">공간 목록이 비어 있습니다</h3>' +
                '<p class="text-sm text-slate-500 leading-relaxed">조건에 맞는 공간이 없거나 아직 등록된 공간이 없습니다.</p>' +
            '</div>';
        document.getElementById('resultCount').textContent = '0';
        setLoadMoreVisible(false);
        if (window.lucide) {
            lucide.createIcons();
        }
    }

    // db 공간가져오기 (필터 파라미터 포함)
    async function loadSpaces(appendMode) {
        if (isLoading) {
            return;
        }

        const pageToLoad = appendMode ? currentPage + 1 : 0;
        const loadMoreButton = document.getElementById('loadMoreButton');

        try {
            isLoading = true;
            if (loadMoreButton) {
                loadMoreButton.disabled = true;
                loadMoreButton.textContent = '불러오는 중...';
            }

            const filters = getSelectedFilters();
            const query = new URLSearchParams();

            if (filters.region) {
                query.append('region', filters.region);
            }
            if (filters.district) {
                query.append('district', filters.district);
            }
            filters.spaceTypes.forEach(function(type) {
                query.append('spaceTypes', type);
            });
            if (filters.minPrice) {
                query.append('minPrice', filters.minPrice);
            }
            if (filters.maxPrice) {
                query.append('maxPrice', filters.maxPrice);
            }
            if (filters.capacity) {
                query.append('capacity', filters.capacity);
            }
            query.append('page', String(pageToLoad));
            query.append('size', String(PAGE_SIZE));

            const response = await fetch('/api/spaces?' + query.toString());
            const payload = await response.json();
            const spaces = payload.items || [];
            currentPage = Number(payload.page || 0);
            hasNextPage = Boolean(payload.hasNext);
            totalElements = Number(payload.totalElements || 0);

            const container = document.getElementById('spaceCardContainer');
            if (!appendMode) {
                container.innerHTML = '';
            }

            if (!appendMode && spaces.length === 0) {
                renderEmptyState();
                return;
            }

            spaces.forEach(space => {
                const card =
                    '<div class="bg-white rounded-3xl overflow-hidden hover:shadow-xl hover:-translate-y-1 transition-all duration-300 border border-slate-50 shadow-[0_4px_20px_-4px_rgba(0,0,0,0.05)] cursor-pointer group">' +
                        '<div class="h-56 bg-slate-100 relative overflow-hidden">' +
                            '<img src="' + space.mainImageUrl + '" class="w-full h-full object-cover group-hover:scale-105 transition-transform duration-500" alt="' + space.name + '">' +
                            '<div class="absolute top-4 left-4 bg-white/80 px-3 py-1.5 rounded-full text-xs font-bold text-blue-600 backdrop-blur-sm shadow-inner">' +
                                getSpaceTypeLabel(space.spaceType) +
                            '</div>' +
                        '</div>' +
                        '<div class="p-6">' +
                            '<h4 class="font-extrabold text-xl mb-1.5 truncate text-slate-900 group-hover:text-blue-600 transition">' + space.name + '</h4>' +
                            '<p class="text-sm text-slate-500 flex items-center gap-1.5 mb-4 font-light">' +
                                '<i data-lucide="map-pin" class="w-4 h-4"></i> ' + space.address +
                            '</p>' +
                            '<div class="flex justify-between items-end border-t border-slate-100 pt-4 mt-auto">' +
                                '<p class="text-2xl font-extrabold text-slate-900 tracking-tight">' +
                                    Number(space.pricePerHour).toLocaleString() +
                                    '<span class="text-sm font-normal text-slate-500">원 / 시간</span>' +
                                '</p>' +
                                '<span class="flex items-center gap-1 text-sm text-slate-500 font-medium">' +
                                    '<i data-lucide="users" class="w-4 h-4"></i>' + space.capacity + '명' +
                                '</span>' +
                            '</div>' +
                        '</div>' +
                    '</div>';

                container.insertAdjacentHTML('beforeend', card);
            });

            const resultCount = document.getElementById('resultCount');
            if (resultCount) {
                resultCount.textContent = totalElements;
            }

            setLoadMoreVisible(hasNextPage);

            if (window.lucide) {
                lucide.createIcons();
            }

        } catch (error) {
            console.error('공간 목록 로딩 오류:', error);
            if (!appendMode) {
                renderEmptyState();
            }
        } finally {
            isLoading = false;
            if (loadMoreButton) {
                loadMoreButton.disabled = false;
                loadMoreButton.textContent = '더보기';
            }
        }
    }

    function getSpaceTypeLabel(spaceType) {
        switch (spaceType) {
            case 'shop': return '상점';
            case 'warehouse': return '창고';
            case 'studio': return '스튜디오';
            case 'meeting': return '회의실';
            case 'consulting': return '상담실';
            case 'office': return '사무실';
            default: return spaceType;
        }
    }

    // 초기화 버튼
    document.querySelector('button[type="reset"]').addEventListener('click', function(e) {
        e.preventDefault();
        document.getElementById('regionSelect').value = '';
        onRegionChange();
        document.querySelectorAll('input[name="spaceType"]:checked').forEach(function(cb) {
            cb.checked = false;
            cb.dispatchEvent(new Event('change'));
        });
        document.querySelector('input[name="priceRange"][value="all"]').checked = true;
        document.querySelector('input[name="capacity"][value="all"]').checked = true;
        loadSpaces(false);
    });

    document.getElementById('loadMoreButton')?.addEventListener('click', function() {
        loadSpaces(true);
    });

    // search 페이지에서 넘어온 경우 region 자동 적용
    // region 형식: "서울특별시 강남구" → city="서울특별시", district="강남구"
    (function() {
        var params = new URLSearchParams(window.location.search);
        var region = params.get('region');
        if (region) {
            var parts = region.split(' ');
            var district = parts.length > 1 ? parts[parts.length - 1] : '';
            // regionSelect는 "서울" 형식 → 시/도 전체명에서 "특별시","광역시","도" 제거
            var cityFull = parts.slice(0, parts.length - 1).join(' ');
            var cityShort = cityFull.replace(/특별시|광역시|특별자치시|특별자치도|도$/, '').trim();
            var regionSelect = document.getElementById('regionSelect');
            var districtSelect = document.getElementById('districtSelect');
            if (regionSelect) {
                regionSelect.value = cityShort;
                onRegionChange();
                if (district && districtSelect) {
                    districtSelect.value = district;
                }
            }
        }
    })();
    loadSpaces(false);
</script>

<%-- 푸터 파일 로드 --%>
<jsp:include page="/WEB-INF/views/common/footer.jsp" />
