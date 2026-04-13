<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<%-- 헤더 파일 로드 --%>
<jsp:include page="/WEB-INF/views/common/header.jsp" />

<main class="flex-grow max-w-[1400px] mx-auto w-full px-4 sm:px-6 lg:px-8 py-12 flex flex-col gap-10 relative overflow-hidden">
    
    <div class="absolute top-[-5%] left-[-5%] w-96 h-96 bg-purple-400/15 rounded-full blur-3xl pointer-events-none"></div>

    <section class="relative z-10 bg-gradient-to-r from-purple-600 to-fuchsia-600 rounded-3xl p-10 flex flex-col md:flex-row items-center justify-between shadow-lg overflow-hidden group">
        <div class="relative z-10 w-full md:w-2/3">
            <span class="bg-white/20 text-white text-xs font-bold px-3 py-1.5 rounded backdrop-blur-sm mb-4 inline-block tracking-wide">AI 맞춤 추천</span>
            <h2 class="text-3xl md:text-4xl font-extrabold text-white mb-4 tracking-tight">무엇이 고민이신가요?</h2>
            <p class="text-purple-100 text-base font-light mb-8">AI가 고민을 분석하여 최적의 전문가를 찾고, 상담 신청서까지 자동으로 작성해 드립니다.</p>
            
            <div class="relative max-w-xl">
                <input type="text" id="heroSearchInput" placeholder="예: 초기 스타트업 절세 방법이 궁금해요."
class="w-full pl-6 pr-32 py-4 rounded-2xl text-slate-900 shadow-sm focus:outline-none focus:ring-4 focus:ring-purple-300/50 transition-all text-sm font-medium">
                <button onclick="openChatWithInput()" class="absolute right-2 top-2 bottom-2 bg-slate-900 text-white px-6 rounded-xl text-sm font-bold hover:bg-slate-800 transition-colors shadow-md">
                    AI 찾기
                </button>
            </div>
        </div>
 
        <i data-lucide="bot" class="absolute right-10 bottom-10 w-40 h-40 text-white opacity-20 group-hover:scale-110 group-hover:rotate-12 transition-transform duration-700 pointer-events-none"></i>
    </section>

    <div class="flex flex-col md:flex-row gap-10 items-start relative z-10">
        
        <aside class="w-full md:w-[320px] flex-shrink-0 bg-white rounded-3xl border border-slate-100 p-8 sticky top-28 shadow-[0_4px_20px_-4px_rgba(0,0,0,0.05)]">
            <div class="flex justify-between items-center mb-8 pb-4 border-b border-slate-100">
               
 <h3 class="font-extrabold text-xl flex items-center gap-2.5 text-slate-900">
                    <i data-lucide="sliders-horizontal" class="w-6 h-6 text-purple-500"></i> 상세 필터
                </h3>
                <button type="reset" form="consultingSearchForm" class="text-sm font-medium text-slate-400 hover:text-rose-500 underline transition-colors flex items-center gap-1.5">
                    <i data-lucide="rotate-ccw" class="w-4 h-4"></i>초기화
                </button>
            </div>

            <form id="consultingSearchForm" class="space-y-8">
         
                <%-- 대분류 필터 (왼쪽 사이드바) --%>
                <div>
                    <label class="block text-sm font-semibold text-slate-700 mb-3 tracking-wide">상담 분야 (대분류)</label>
                    <div class="grid grid-cols-1 gap-2.5">
                        <button type="button" onclick="selectMainCategory('IT')" id="btn-IT" class="main-cat-btn flex items-center justify-center px-4 py-3 rounded-xl border border-slate-100 bg-slate-50 text-slate-600 font-semibold transition-all hover:border-blue-400 hover:bg-white shadow-sm w-full">
                            <span>IT / 기술 컨설팅</span>
                        </button>
                        <button type="button" onclick="selectMainCategory('BIO')" id="btn-BIO" class="main-cat-btn flex items-center justify-center px-4 py-3 rounded-xl border border-slate-100 bg-slate-50 text-slate-600 font-semibold transition-all hover:border-blue-400 hover:bg-white shadow-sm w-full">
                            <span>바이오 / 인증 컨설팅</span>
                        </button>
                        <button type="button" onclick="selectMainCategory('MANU')" id="btn-MANU" class="main-cat-btn flex items-center justify-center px-4 py-3 rounded-xl border border-slate-100 bg-slate-50 text-slate-600 font-semibold transition-all hover:border-blue-400 hover:bg-white shadow-sm w-full">
                            <span>제조 / R&D 지원</span>
                        </button>
                        <button type="button" onclick="selectMainCategory('BRAND')" id="btn-BRAND" class="main-cat-btn flex items-center justify-center px-4 py-3 rounded-xl border border-slate-100 bg-slate-50 text-slate-600 font-semibold transition-all hover:border-blue-400 hover:bg-white shadow-sm w-full">
                            <span>브랜딩 / 디자인 / 특허</span>
                        </button>
                    </div>
                </div>

                <%-- 별점 필터 --%>
                <div>
                    <label class="block text-sm font-semibold text-slate-700 mb-3 tracking-wide">전문가 평점</label>
                    <div class="flex flex-col gap-3">
                        <label class="flex items-center gap-3 cursor-pointer group">
                            <input type="radio" name="rating" value="all" class="accent-purple-600 w-4 h-4" checked> 
                            <span class="text-sm font-medium text-slate-700 group-hover:text-purple-600 transition-colors">전체보기</span>
                        </label>
                        <label class="flex items-center gap-3 cursor-pointer group">
                            <input type="radio" name="rating" value="4.0" class="accent-purple-600 w-4 h-4"> 
                            <span class="text-sm font-medium text-slate-700 group-hover:text-purple-600 transition-colors flex items-center gap-1">
                                <i data-lucide="star" class="w-4 h-4 text-amber-400 fill-amber-400"></i> 4.0 이상
                            </span>
                        </label>
                    </div>
                </div>

                <%-- 상담 가능 시간 필터 --%>
                <div>
                    <label class="block text-sm font-semibold text-slate-700 mb-3 tracking-wide">상담 가능 시간</label>
                    <div class="flex flex-col gap-3">
                        <label class="flex items-center gap-3 p-3 border border-slate-100 rounded-xl cursor-pointer hover:bg-slate-50 transition-colors">
                            <input type="checkbox" name="consultTimeOption" value="주말" class="accent-purple-600 w-4 h-4">
                            <span class="text-sm font-medium text-slate-700 flex-grow">주말</span>
                            <i data-lucide="calendar-days" class="w-4 h-4 text-slate-400"></i>
                        </label>
                        <label class="flex items-center gap-3 p-3 border border-slate-100 rounded-xl cursor-pointer hover:bg-slate-50 transition-colors">
                            <input type="checkbox" name="consultTimeOption" value="야간" class="accent-purple-600 w-4 h-4">
                            <span class="text-sm font-medium text-slate-700 flex-grow">야간</span>
                            <i data-lucide="phone" class="w-4 h-4 text-slate-400"></i>
                        </label>
                    </div>
                </div>

                <%-- 경력 필터 --%>
                <div>
                    <label class="block text-sm font-semibold text-slate-700 mb-3 tracking-wide">경력</label>
                    <div class="flex flex-col gap-3">
                        <label class="flex items-center gap-3 cursor-pointer group">
                            <input type="radio" name="experienceYears" value="all" class="accent-purple-600 w-4 h-4" checked>
                            <span class="text-sm font-medium text-slate-700 group-hover:text-purple-600 transition-colors">전체보기</span>
                        </label>
                        <label class="flex items-center gap-3 cursor-pointer group">
                            <input type="radio" name="experienceYears" value="5" class="accent-purple-600 w-4 h-4">
                            <span class="text-sm font-medium text-slate-700 group-hover:text-purple-600 transition-colors">5년 이상</span>
                        </label>
                        <label class="flex items-center gap-3 cursor-pointer group">
                            <input type="radio" name="experienceYears" value="10" class="accent-purple-600 w-4 h-4">
                            <span class="text-sm font-medium text-slate-700 group-hover:text-purple-600 transition-colors">10년 이상</span>
                        </label>
                    </div>
                </div>

                <%-- 상담 비용 필터 --%>
                <div>
                    <label class="block text-sm font-semibold text-slate-700 mb-3 tracking-wide">상담 비용</label>
                    <div class="flex flex-col gap-3">
                        <label class="flex items-center gap-3 cursor-pointer group">
                            <input type="radio" name="price" value="all" class="accent-purple-600 w-4 h-4" checked>
                            <span class="text-sm font-medium text-slate-700 group-hover:text-purple-600 transition-colors">전체보기</span>
                        </label>
                        <label class="flex items-center gap-3 cursor-pointer group">
                            <input type="radio" name="price" value="3" class="accent-purple-600 w-4 h-4">
                            <span class="text-sm font-medium text-slate-700 group-hover:text-purple-600 transition-colors">3만원 이하</span>
                        </label>
                        <label class="flex items-center gap-3 cursor-pointer group">
                            <input type="radio" name="price" value="5" class="accent-purple-600 w-4 h-4">
                            <span class="text-sm font-medium text-slate-700 group-hover:text-purple-600 transition-colors">5만원 이하</span>
                        </label>
                    </div>
                </div>

                <button type="button" onclick="searchConsultants()" class="w-full bg-slate-900 text-white font-bold py-4 rounded-xl hover:bg-slate-800 transition-all duration-300 shadow-md hover:shadow-lg hover:-translate-y-0.5 tracking-wide">
                    조건 적용하기
                </button>
            </form>
        </aside>

        <div class="flex-grow flex flex-col w-full min-w-0">
            
            <%-- 상단 필터 및 정렬 영역 (소분류 버튼 + 추천순 정렬 통합) --%>
            <div class="bg-white rounded-2xl border border-slate-200 shadow-sm mb-6 p-5 transition-all duration-300">
                
                <%-- 소분류 선택 영역 --%>
                <div class="flex flex-wrap items-center gap-2 mb-4" id="subCategoryContainer">
                    <span class="text-sm font-bold text-slate-700 mr-2 border-r border-slate-300 pr-3">세부 분야</span>
                    <button type="button" class="px-4 py-1.5 rounded-full border border-blue-600 bg-blue-600 text-sm font-medium text-white shadow-sm">전체</button>
                    <button type="button" class="px-4 py-1.5 rounded-full border border-slate-200 bg-white text-sm font-medium text-slate-600 hover:border-blue-400 hover:text-blue-600 transition-all shadow-sm">세무/회계</button>
                    <button type="button" class="px-4 py-1.5 rounded-full border border-slate-200 bg-white text-sm font-medium text-slate-600 hover:border-blue-400 hover:text-blue-600 transition-all shadow-sm">인사/노무</button>
                    <button type="button" class="px-4 py-1.5 rounded-full border border-slate-200 bg-white text-sm font-medium text-slate-600 hover:border-blue-400 hover:text-blue-600 transition-all shadow-sm">법무/특허</button>
                    <button type="button" class="px-4 py-1.5 rounded-full border border-slate-200 bg-white text-sm font-medium text-slate-600 hover:border-blue-400 hover:text-blue-600 transition-all shadow-sm">지원금/정책자금</button>
                </div>
                
                <div class="w-full h-px bg-slate-100 my-2"></div>

                <%-- 정렬 영역 --%>
                <div class="flex justify-between items-center mt-2">
                    <p class="text-slate-600 font-medium text-sm">총 <strong class="text-blue-600 font-bold" id="resultCount">0</strong>명의 전문가</p>
                    <select class="text-sm border border-slate-200 rounded-lg bg-transparent font-medium text-slate-600 focus:ring-2 focus:ring-blue-100 px-3 py-1.5 cursor-pointer outline-none">
                        <option>추천순</option>
                        <option>평점 높은 순</option>
                        <option>리뷰 많은 순</option>
                    </select>
                </div>
            </div>

            <%-- 전문가 그리드 리스트 (사진 참고형 3단 레이아웃 + 호버 효과) --%>
            <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6 w-full" id="consultantListContainer">
                <div id="emptyConsultantState" class="col-span-1 md:col-span-2 lg:col-span-3 bg-white rounded-2xl border border-dashed border-slate-200 shadow-sm p-10 text-center">
                    <div class="mx-auto mb-4 w-14 h-14 rounded-2xl bg-slate-100 flex items-center justify-center">
                        <i data-lucide="briefcase-business" class="w-7 h-7 text-slate-400"></i>
                    </div>
                    <h3 class="text-lg font-bold text-slate-800 mb-2">전문가 목록이 비어 있습니다</h3>
                    <p class="text-sm text-slate-500 leading-relaxed">상담 분야를 선택하거나 조건을 적용하면 같은 카드 형태로 전문가 목록이 표시됩니다.</p>
                </div>
            </div>

            <div id="loadMoreContainer" class="pt-6 hidden">
                <div class="flex justify-center">
                    <button id="loadMoreButton" type="button" class="bg-white border border-slate-200 hover:border-blue-300 hover:text-blue-600 text-slate-700 px-6 py-3 rounded-2xl text-sm font-bold shadow-sm transition-all">
                        더보기
                    </button>
                </div>
            </div>
        </div>
    </div>
</main>

<%-- 챗봇 UI 생략하지 않고 그대로 포함 --%>
<div id="chat-widget-button" onclick="toggleChat()" class="fixed bottom-8 right-8 w-16 h-16 bg-gradient-to-tr from-purple-600 to-indigo-600 rounded-full shadow-[0_10px_25px_rgba(147,51,234,0.4)] flex items-center justify-center cursor-pointer hover:scale-110 transition-transform duration-300 z-[100] group">
    <i data-lucide="message-square-text" class="w-7 h-7 text-white group-hover:animate-pulse"></i>
    <span class="absolute -top-2 -right-2 w-4 h-4 bg-rose-500 rounded-full border-2 border-white animate-bounce"></span>
</div>

<div id="chat-window" class="fixed bottom-28 right-8 w-[380px] h-[600px] bg-white rounded-3xl shadow-[0_20px_50px_rgba(0,0,0,0.15)] border border-slate-100 hidden flex-col z-[100] overflow-hidden transition-all duration-300 transform translate-y-4 opacity-0">
    <div class="bg-gradient-to-r from-purple-600 to-indigo-600 p-5 text-white flex justify-between items-center shadow-md z-10">
        <div class="flex items-center gap-3">
            <div class="w-8 h-8 rounded-full bg-white/20 flex items-center justify-center backdrop-blur-sm"><i data-lucide="bot" class="w-5 h-5"></i></div>
            <div>
                <h4 class="font-bold text-sm">AI 비즈니스 어드바이저</h4>
                <p class="text-[10px] text-purple-100">자동 상담 신청서 작성 지원</p>
            </div>
        </div>
        <button onclick="toggleChat()" class="text-white hover:text-purple-200 transition-colors"><i data-lucide="x" class="w-5 h-5"></i></button>
    </div>
    <div id="chat-messages" class="flex-1 overflow-y-auto p-5 space-y-4 bg-slate-50 custom-scrollbar relative">
        <div class="text-center text-[10px] text-slate-400 mb-4">오늘</div>
        <div class="flex gap-2 items-end">
            <div class="w-6 h-6 rounded-full bg-purple-100 flex items-center justify-center flex-shrink-0"><i data-lucide="bot" class="w-3 h-3 text-purple-600"></i></div>
            <div class="bg-white p-3 rounded-2xl rounded-bl-none shadow-sm text-sm text-slate-700 border border-slate-100 max-w-[85%] leading-relaxed">
                안녕하세요! 찾고 계신 전문가나 고민 중인 비즈니스 문제를 편하게 말씀해 주세요.
                <br><br>대화를 바탕으로 알맞은 전문가를 추천하고 <strong>상담 신청서 양식까지 알아서 요약</strong>해 드릴게요! ✨
            </div>
        </div>
    </div>
    <div class="p-4 bg-white border-t border-slate-100">
        <div class="relative flex items-center">
            <input type="text" id="chat-input" class="w-full bg-slate-50 border border-slate-200 rounded-full pl-4 pr-12 py-3 text-sm focus:outline-none focus:ring-2 focus:ring-purple-200 focus:border-purple-400 transition-all text-slate-700" placeholder="메시지를 입력하세요..." onkeypress="handleChatEnter(event)">
            <button onclick="sendChatMessage()" class="absolute right-2 w-8 h-8 bg-purple-600 rounded-full flex items-center justify-center text-white hover:bg-purple-700 transition-colors shadow-sm">
                <i data-lucide="arrow-up" class="w-4 h-4"></i>
            </button>
        </div>
    </div>
</div>

<script>
    if (typeof lucide !== 'undefined') {
        lucide.createIcons();
    }

    (function () {
        const PAGE_SIZE = 12;
        const categoryMap = {
            IT: { name: 'IT / 기술', subs: [{ id: 'ELEC', name: '전기전자통신' }] },
            BIO: { name: '바이오 / 인증', subs: [{ id: 'CHEM', name: '화학생명공학' }] },
            MANU: { name: '제조 / R&D', subs: [{ id: 'MECH', name: '기계금속건설' }] },
            BRAND: { name: '브랜딩 / 디자인', subs: [{ id: 'DESIGN', name: '상표/디자인' }] }
        };
        const fieldLabels = {
            ELEC: '전기전자통신',
            SW: '소프트웨어/IT',
            CHEM: '화학생명공학',
            MECH: '기계금속건설',
            DESIGN: '상표/디자인'
        };

        const consultantListContainer = document.getElementById('consultantListContainer');
        const resultCount = document.getElementById('resultCount');
        const subCategoryContainer = document.getElementById('subCategoryContainer');
        const consultingSearchForm = document.getElementById('consultingSearchForm');
        const loadMoreContainer = document.getElementById('loadMoreContainer');
        const loadMoreButton = document.getElementById('loadMoreButton');

        let selectedMain = null;
        let selectedSubs = [];
        let currentPage = 0;
        let totalElements = 0;
        let hasNext = false;
        let loading = false;

        function refreshIcons() {
            if (typeof lucide !== 'undefined') {
                lucide.createIcons();
            }
        }

        function escapeHtml(value) {
            return String(value || '')
                .replace(/&/g, '&amp;')
                .replace(/</g, '&lt;')
                .replace(/>/g, '&gt;')
                .replace(/"/g, '&quot;')
                .replace(/'/g, '&#39;');
        }

        function getFieldLabel(fieldCode) {
            return fieldLabels[fieldCode] || fieldCode || '전문 분야';
        }

        function getRegionLabel(address) {
            if (!address) {
                return '전국';
            }
            const first = address.trim().split(/\s+/)[0];
            return first || '전국';
        }

        function getConsultTimeLabel(consultTime) {
            if (consultTime === '주말야간') {
                return '주말 야간';
            }
            return consultTime || '상담시간 문의';
        }

        function getExperienceLabel(experienceYears) {
            if (experienceYears === null || experienceYears === undefined) {
                return '경력 문의';
            }
            return String(experienceYears) + '년';
        }

        function getPriceLabel(price) {
            if (price === null || price === undefined) {
                return '비용 문의';
            }
            return String(price) + '만원';
        }

        function getRatingLabel(rating) {
            if (rating === null || rating === undefined || rating === '') {
                return '평점 미등록';
            }
            return String(rating) + '점';
        }

        function getCurrentFields() {
            if (selectedSubs.length > 0) {
                return selectedSubs.slice();
            }
            if (selectedMain && categoryMap[selectedMain]) {
                return categoryMap[selectedMain].subs.map(function (sub) {
                    return sub.id;
                });
            }
            return [];
        }

        function getSelectedFilters() {
            const rating = document.querySelector('input[name="rating"]:checked');
            const consultTimeOptions = Array.from(document.querySelectorAll('input[name="consultTimeOption"]:checked'))
                .map(function (input) {
                    return input.value;
                });
            const experienceYears = document.querySelector('input[name="experienceYears"]:checked');
            const price = document.querySelector('input[name="price"]:checked');

            let consultTime = '';
            if (consultTimeOptions.length === 2) {
                consultTime = '주말야간';
            } else if (consultTimeOptions.length === 1) {
                consultTime = consultTimeOptions[0];
            }

            return {
                minRating: rating && rating.value !== 'all' ? rating.value : '',
                consultTime: consultTime,
                minExperienceYears: experienceYears && experienceYears.value !== 'all' ? experienceYears.value : '',
                maxPrice: price && price.value !== 'all' ? price.value : ''
            };
        }

        function createTag(label) {
            return '<span class="px-3 py-1 bg-slate-50 border border-slate-200 rounded-full text-[11px] text-slate-600">' + escapeHtml(label) + '</span>';
        }

        function createConsultantCard(consultant) {
            const office = escapeHtml(consultant.office || '변리사 사무소');
            const name = escapeHtml(consultant.name || '이름 미등록');
            const phone = escapeHtml(consultant.phone || '연락처 정보 없음');
            const address = escapeHtml(consultant.address || '주소 정보 없음');
            const fieldLabel = getFieldLabel(consultant.field);
            const regionLabel = getRegionLabel(consultant.address);
            const consultTimeLabel = getConsultTimeLabel(consultant.consultTime);
            const experienceLabel = getExperienceLabel(consultant.experienceYears);
            const priceLabel = getPriceLabel(consultant.price);
            const ratingLabel = getRatingLabel(consultant.rating);
            const summaryTags = createTag(fieldLabel) + createTag(regionLabel);
            const detailTags = summaryTags
                + createTag('평점 ' + ratingLabel)
                + createTag(getConsultTimeLabel(consultant.consultTime))
                + createTag('경력 ' + experienceLabel)
                + createTag('비용 ' + priceLabel);

            return ''
                + '<div class="bg-white rounded-2xl p-4 border border-slate-200 shadow-sm transition-all duration-500 ease-out group flex flex-col gap-3 relative h-max transform will-change-transform hover:border-blue-300 hover:shadow-2xl hover:-translate-y-2 hover:scale-[1.01]">'
                + '<div class="flex items-center gap-2">'
                + '<h3 class="text-lg font-bold text-slate-800">' + office + '</h3>'
                + '<span class="bg-blue-600 text-white text-[10px] px-2 py-0.5 rounded-full">' + escapeHtml(regionLabel) + '</span>'
                + '</div>'
                + '<div class="flex items-center gap-1 text-slate-500 text-sm mb-1">'
                + '<i data-lucide="phone" class="w-3.5 h-3.5 text-red-500"></i>'
                + '<span>' + phone + '</span>'
                + '</div>'
                + '<div class="w-full h-32 rounded-xl bg-slate-900 relative overflow-hidden mb-1 flex items-center p-4">'
                + '<div class="absolute inset-0 bg-gradient-to-r from-gray-900 to-gray-700 opacity-90"></div>'
                + '<div class="relative z-10">'
                + '<p class="text-white font-bold text-sm leading-snug">' + escapeHtml(fieldLabel) + '<br><span class="text-orange-400 text-lg">' + name + '</span></p>'
                + '</div>'
                + '</div>'
                + '<div class="flex justify-between items-center border-b border-slate-100 pb-3">'
                + '<div class="flex items-center gap-1.5">'
                + '<i data-lucide="check-circle-2" class="w-4 h-4 text-blue-600 fill-blue-600"></i>'
                + '<span class="font-bold text-slate-800">' + name + '</span>'
                + '<span class="text-xs text-slate-400">대표</span>'
                + '</div>'
                + '<div class="text-[11px] text-slate-500 flex gap-2">'
                + '<span>자문요청수 <strong class="text-blue-600 text-xs">0</strong></span>'
                + '<span>리뷰 <strong class="text-blue-600 text-xs">0</strong></span>'
                + '</div>'
                + '</div>'
                + '<div class="flex justify-between items-center">'
                + '<span class="bg-slate-100 text-slate-500 text-[10px] px-2 py-1 rounded-full">자문문의 남기기 가능</span>'
                + '<span class="text-[11px] text-slate-400">조회수 <strong class="text-blue-600 text-xs">0</strong></span>'
                + '</div>'
                + '<div class="flex flex-wrap gap-1.5 mt-1 group-hover:hidden">'
                + detailTags
                + '</div>'
                + '<div class="hidden md:group-hover:flex flex-col gap-3 mt-1">'
                + '<div class="flex flex-wrap gap-1.5">'
                + detailTags
                + '</div>'
                + '<div class="bg-slate-50 border border-slate-200 rounded-xl p-3 text-xs text-slate-600 leading-relaxed">' + address + '</div>'
                + '<div class="flex gap-2 mt-2">'
                + '<button class="flex-1 bg-orange-500 hover:bg-orange-600 text-white py-2.5 rounded-xl text-sm font-bold transition-colors">자세히 보기</button>'
                + '<button class="flex-1 bg-blue-600 hover:bg-blue-700 text-white py-2.5 rounded-xl text-sm font-bold transition-colors">자문요청 남기기</button>'
                + '</div>'
                + '</div>'
                + '<div class="flex md:hidden flex-col gap-3 mt-1">'
                + '<div class="flex flex-wrap gap-1.5">'
                + detailTags
                + '</div>'
                + '<div class="bg-slate-50 border border-slate-200 rounded-xl p-3 text-xs text-slate-600 leading-relaxed">' + address + '</div>'
                + '<div class="flex gap-2 mt-2">'
                + '<button class="flex-1 bg-orange-500 text-white py-2.5 rounded-xl text-sm font-bold transition-colors">자세히 보기</button>'
                + '<button class="flex-1 bg-blue-600 text-white py-2.5 rounded-xl text-sm font-bold transition-colors">자문요청 남기기</button>'
                + '</div>'
                + '</div>'
                + '</div>';
        }

        function setLoadMoreVisible(visible) {
            if (visible) {
                loadMoreContainer.classList.remove('hidden');
            } else {
                loadMoreContainer.classList.add('hidden');
            }
        }

        function renderEmptyState(message) {
            consultantListContainer.innerHTML = ''
                + '<div id="emptyConsultantState" class="col-span-1 md:col-span-2 lg:col-span-3 bg-white rounded-2xl border border-dashed border-slate-200 shadow-sm p-10 text-center">'
                + '<div class="mx-auto mb-4 w-14 h-14 rounded-2xl bg-slate-100 flex items-center justify-center">'
                + '<i data-lucide="briefcase-business" class="w-7 h-7 text-slate-400"></i>'
                + '</div>'
                + '<h3 class="text-lg font-bold text-slate-800 mb-2">' + escapeHtml(message) + '</h3>'
                + '<p class="text-sm text-slate-500 leading-relaxed">상담 분야를 선택하거나 조건을 적용하면 같은 카드 형태로 전문가 목록이 표시됩니다.</p>'
                + '</div>';
            resultCount.textContent = '0';
            setLoadMoreVisible(false);
            refreshIcons();
        }

        function renderConsultants(items, appendMode) {
            if (!appendMode && (!items || items.length === 0)) {
                renderEmptyState('조건에 맞는 전문가가 없습니다');
                return;
            }

            const html = items.map(createConsultantCard).join('');
            if (appendMode) {
                consultantListContainer.insertAdjacentHTML('beforeend', html);
            } else {
                consultantListContainer.innerHTML = html;
            }

            resultCount.textContent = String(totalElements);
            setLoadMoreVisible(hasNext);
            refreshIcons();
        }

        async function loadConsultants(fields, appendMode) {
            if (loading) {
                return;
            }

            const targetPage = appendMode ? currentPage + 1 : 0;
            const query = new URLSearchParams();
            const selectedFilters = getSelectedFilters();
            fields.forEach(function (field) {
                query.append('fields', field);
            });
            if (selectedFilters.minRating) {
                query.append('minRating', selectedFilters.minRating);
            }
            if (selectedFilters.consultTime) {
                query.append('consultTime', selectedFilters.consultTime);
            }
            if (selectedFilters.minExperienceYears) {
                query.append('minExperienceYears', selectedFilters.minExperienceYears);
            }
            if (selectedFilters.maxPrice) {
                query.append('maxPrice', selectedFilters.maxPrice);
            }
            query.append('page', String(targetPage));
            query.append('size', String(PAGE_SIZE));

            try {
                loading = true;
                loadMoreButton.disabled = true;
                loadMoreButton.textContent = '불러오는 중...';

                const response = await fetch('/api/consultants?' + query.toString());
                if (!response.ok) {
                    throw new Error('HTTP ' + response.status);
                }

                const payload = await response.json();
                currentPage = Number(payload.page || 0);
                totalElements = Number(payload.totalElements || 0);
                hasNext = Boolean(payload.hasNext);
                renderConsultants(payload.items || [], appendMode);
            } catch (error) {
                console.error('Failed to load consultants:', error);
                renderEmptyState('전문가 목록을 불러오지 못했습니다');
            } finally {
                loading = false;
                loadMoreButton.disabled = false;
                loadMoreButton.textContent = '더보기';
            }
        }

        function renderDefaultSubCategories() {
            subCategoryContainer.innerHTML = ''
                + '<span class="text-sm font-bold text-slate-700 mr-2 border-r border-slate-300 pr-3">세부 분야</span>'
                + '<button type="button" class="px-4 py-1.5 rounded-full border border-blue-600 bg-blue-600 text-sm font-medium text-white shadow-sm">전체</button>'
                + '<button type="button" class="px-4 py-1.5 rounded-full border border-slate-200 bg-white text-sm font-medium text-slate-600 hover:border-blue-400 hover:text-blue-600 transition-all shadow-sm">세무/회계</button>'
                + '<button type="button" class="px-4 py-1.5 rounded-full border border-slate-200 bg-white text-sm font-medium text-slate-600 hover:border-blue-400 hover:text-blue-600 transition-all shadow-sm">인사/노무</button>'
                + '<button type="button" class="px-4 py-1.5 rounded-full border border-slate-200 bg-white text-sm font-medium text-slate-600 hover:border-blue-400 hover:text-blue-600 transition-all shadow-sm">법무/특허</button>'
                + '<button type="button" class="px-4 py-1.5 rounded-full border border-slate-200 bg-white text-sm font-medium text-slate-600 hover:border-blue-400 hover:text-blue-600 transition-all shadow-sm">지원금/정책자금</button>';
        }

        function renderSubCategories(key) {
            const category = categoryMap[key];
            if (!category) {
                renderDefaultSubCategories();
                return;
            }

            let buttons = '';
            category.subs.forEach(function (sub) {
                buttons += '<button type="button" onclick="toggleSubCategory(\'' + sub.id + '\', this)" class="sub-cat-btn px-4 py-1.5 rounded-full border border-slate-200 bg-white text-sm font-medium text-slate-600 hover:border-blue-400 hover:text-blue-600 transition-all shadow-sm">' + escapeHtml(sub.name) + '</button>';
            });

            subCategoryContainer.innerHTML = ''
                + '<span class="text-sm font-bold text-slate-700 mr-2 border-r border-slate-300 pr-3">' + escapeHtml(category.name) + ' 세부 분야</span>'
                + '<button type="button" onclick="selectAllSubs()" class="px-4 py-1.5 rounded-full border border-blue-600 bg-blue-600 text-sm font-medium text-white shadow-sm transition-all">전체</button>'
                + buttons;
        }

        window.selectMainCategory = function (key) {
            document.querySelectorAll('.main-cat-btn').forEach(function (btn) {
                btn.classList.remove('border-blue-500', 'bg-blue-50', 'text-blue-700', 'shadow-md');
            });

            const selectedBtn = document.getElementById('btn-' + key);
            if (selectedBtn) {
                selectedBtn.classList.add('border-blue-500', 'bg-blue-50', 'text-blue-700', 'shadow-md');
            }

            selectedMain = key;
            selectedSubs = [];
            currentPage = 0;
            renderSubCategories(key);
            loadConsultants(getCurrentFields(), false);
        };

        window.toggleSubCategory = function (subId, el) {
            if (selectedSubs.indexOf(subId) >= 0) {
                selectedSubs = selectedSubs.filter(function (id) {
                    return id !== subId;
                });
                el.classList.remove('bg-blue-50', 'text-blue-600', 'border-blue-400', 'font-bold');
                el.classList.add('bg-white', 'text-slate-600', 'border-slate-200');
            } else {
                selectedSubs.push(subId);
                el.classList.add('bg-blue-50', 'text-blue-600', 'border-blue-400', 'font-bold');
                el.classList.remove('bg-white', 'text-slate-600', 'border-slate-200');
            }
        };

        window.selectAllSubs = function () {
            selectedSubs = [];
            subCategoryContainer.querySelectorAll('.sub-cat-btn').forEach(function (btn) {
                btn.classList.remove('bg-blue-50', 'text-blue-600', 'border-blue-400', 'font-bold');
                btn.classList.add('bg-white', 'text-slate-600', 'border-slate-200');
            });
        };

        window.searchConsultants = function () {
            currentPage = 0;
            loadConsultants(getCurrentFields(), false);
        };

        consultingSearchForm.addEventListener('reset', function () {
            selectedMain = null;
            selectedSubs = [];
            currentPage = 0;
            totalElements = 0;
            hasNext = false;

            document.querySelectorAll('.main-cat-btn').forEach(function (btn) {
                btn.classList.remove('border-blue-500', 'bg-blue-50', 'text-blue-700', 'shadow-md');
            });

            renderDefaultSubCategories();
            setTimeout(function () {
                loadConsultants([], false);
            }, 0);
        });

        loadMoreButton.addEventListener('click', function () {
            loadConsultants(getCurrentFields(), true);
        });

        window.openChatWithInput = function () {
            const input = document.getElementById('heroSearchInput').value;
            if (input.trim() !== '') {
                document.getElementById('chat-input').value = input;
                toggleChat();
                setTimeout(sendChatMessage, 300);
            } else {
                toggleChat();
            }
        };

        window.toggleChat = function () {
            const win = document.getElementById('chat-window');
            if (win.classList.contains('hidden')) {
                win.classList.remove('hidden');
                setTimeout(function () {
                    win.classList.remove('translate-y-4', 'opacity-0');
                }, 10);
            } else {
                win.classList.add('translate-y-4', 'opacity-0');
                setTimeout(function () {
                    win.classList.add('hidden');
                }, 300);
            }
        };

        window.handleChatEnter = function (e) {
            if (e.key === 'Enter') {
                sendChatMessage();
            }
        };

        window.sendChatMessage = function () {
            const input = document.getElementById('chat-input');
            const box = document.getElementById('chat-messages');
            const text = input.value.trim();
            if (!text) {
                return;
            }

            box.innerHTML += ''
                + '<div class="flex justify-end mb-4">'
                + '<div class="bg-purple-600 text-white p-3 rounded-2xl rounded-br-none shadow-sm text-sm max-w-[85%]">'
                + escapeHtml(text)
                + '</div>'
                + '</div>';
            input.value = '';
            box.scrollTop = box.scrollHeight;

            const loadingId = 'loading-' + Date.now();
            box.innerHTML += ''
                + '<div id="' + loadingId + '" class="flex gap-2 items-end mb-4">'
                + '<div class="w-6 h-6 rounded-full bg-purple-100 flex items-center justify-center flex-shrink-0"><i data-lucide="bot" class="w-3 h-3 text-purple-600"></i></div>'
                + '<div class="bg-white px-4 py-3 rounded-2xl rounded-bl-none shadow-sm border border-slate-100 flex gap-1 items-center">'
                + '<div class="w-1.5 h-1.5 bg-purple-400 rounded-full animate-bounce"></div>'
                + '<div class="w-1.5 h-1.5 bg-purple-400 rounded-full animate-bounce" style="animation-delay: 0.1s"></div>'
                + '<div class="w-1.5 h-1.5 bg-purple-400 rounded-full animate-bounce" style="animation-delay: 0.2s"></div>'
                + '</div>'
                + '</div>';
            box.scrollTop = box.scrollHeight;
            refreshIcons();

            setTimeout(function () {
                const loadingNode = document.getElementById(loadingId);
                if (loadingNode) {
                    loadingNode.remove();
                }

                box.innerHTML += ''
                    + '<div class="flex gap-2 items-end mb-4">'
                    + '<div class="w-6 h-6 rounded-full bg-purple-100 flex items-center justify-center flex-shrink-0"><i data-lucide="bot" class="w-3 h-3 text-purple-600"></i></div>'
                    + '<div class="bg-white p-4 rounded-2xl rounded-bl-none shadow-sm border border-slate-100 text-sm text-slate-700 max-w-[85%]">'
                    + '말씀하신 내용을 바탕으로 <strong>상담 가이드</strong>를 요약했습니다.<br><br>'
                    + '<div class="bg-slate-50 p-3 rounded-lg border border-slate-200 my-2 text-xs">'
                    + '<strong class="text-purple-600">요약 내용:</strong> 초기 스타트업 단계에서의 법인세 및 소득세 절세 방안 문의<br>'
                    + '<strong class="text-purple-600">추천 분야:</strong> 세무/회계'
                    + '</div>'
                    + '이 내용을 컨설턴트에게 바로 전달해 드릴까요? 화면에 가장 적합한 전문가를 매칭해 두었습니다!'
                    + '<button class="mt-3 w-full bg-purple-50 text-purple-600 border border-purple-200 py-2 rounded-lg font-bold text-xs hover:bg-purple-600 hover:text-white transition-colors">이 내용으로 상담 신청하기</button>'
                    + '</div>'
                    + '</div>';
                box.scrollTop = box.scrollHeight;
                refreshIcons();
            }, 1500);
        };

        renderDefaultSubCategories();
        loadConsultants([], false);
        refreshIcons();
    })();
</script>

<%-- 푸터 파일 로드 --%>
<jsp:include page="/WEB-INF/views/common/footer.jsp" />
