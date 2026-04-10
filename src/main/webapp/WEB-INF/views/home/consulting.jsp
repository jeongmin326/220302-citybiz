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
        
        <aside class="w-full md:w-[320px] flex-shrink-0 bg-white rounded-3xl border border-slate-100 p-8 sticky top-28 max-h-[calc(100vh-10rem)] overflow-y-auto custom-scrollbar shadow-[0_4px_20px_-4px_rgba(0,0,0,0.05)]">
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
                        <button type="button" onclick="selectMainCategory('IT')" id="btn-IT" class="main-cat-btn flex items-center justify-between px-4 py-3 rounded-xl border border-slate-100 bg-slate-50 text-slate-600 font-semibold transition-all hover:border-purple-300 hover:bg-white shadow-sm">
                             <span>IT / 기술 컨설팅</span>
                            <i data-lucide="chevron-right" class="w-4 h-4 text-slate-400"></i>
                        </button>
                        <button type="button" onclick="selectMainCategory('BIO')" id="btn-BIO" class="main-cat-btn flex items-center justify-between px-4 py-3 rounded-xl border border-slate-100 bg-slate-50 text-slate-600 font-semibold transition-all hover:border-purple-300 hover:bg-white shadow-sm">
                            <span>바이오 / 인증 컨설팅</span>
                            <i data-lucide="chevron-right" class="w-4 h-4 text-slate-400"></i>
                        </button>
                         <button type="button" onclick="selectMainCategory('MANU')" id="btn-MANU" class="main-cat-btn flex items-center justify-between px-4 py-3 rounded-xl border border-slate-100 bg-slate-50 text-slate-600 font-semibold transition-all hover:border-purple-300 hover:bg-white shadow-sm">
                            <span>제조 / R&D 지원</span>
                            <i data-lucide="chevron-right" class="w-4 h-4 text-slate-400"></i>
                        </button>
                        <button type="button" onclick="selectMainCategory('BRAND')" id="btn-BRAND" class="main-cat-btn flex items-center justify-between px-4 py-3 rounded-xl border border-slate-100 bg-slate-50 text-slate-600 font-semibold transition-all hover:border-purple-300 hover:bg-white shadow-sm">
                            <span>브랜딩 / 디자인 / 특허</span>
                            <i data-lucide="chevron-right" class="w-4 h-4 text-slate-400"></i>
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
                            <input type="radio" name="rating" value="4.5" class="accent-purple-600 w-4 h-4"> 
                            <span class="text-sm font-medium text-slate-700 group-hover:text-purple-600 transition-colors flex items-center gap-1">
                                <i data-lucide="star" class="w-4 h-4 text-amber-400 fill-amber-400"></i> 4.5 이상
                            </span>
                        </label>
                        <label class="flex items-center gap-3 cursor-pointer group">
                            <input type="radio" name="rating" value="4.0" class="accent-purple-600 w-4 h-4"> 
                            <span class="text-sm font-medium text-slate-700 group-hover:text-purple-600 transition-colors flex items-center gap-1">
                                <i data-lucide="star" class="w-4 h-4 text-amber-400 fill-amber-400"></i> 4.0 이상
                            </span>
                        </label>
                    </div>
                </div>

                <%-- 상담 방식 필터 --%>
                <div>
                    <label class="block text-sm font-semibold text-slate-700 mb-3 tracking-wide">상담 방식</label>
                    <div class="flex flex-col gap-3">
                        <label class="flex items-center gap-3 p-3 border border-slate-100 rounded-xl cursor-pointer hover:bg-slate-50 transition-colors">
                            <input type="radio" name="method" value="face" class="accent-purple-600 w-4 h-4"> 
                            <span class="text-sm font-medium text-slate-700 flex-grow">대면 상담</span>
                            <i data-lucide="users" class="w-4 h-4 text-slate-400"></i>
                        </label>
                        <label class="flex items-center gap-3 p-3 border border-slate-100 rounded-xl cursor-pointer hover:bg-slate-50 transition-colors">
                            <input type="radio" name="method" value="video" class="accent-purple-600 w-4 h-4"> 
                            <span class="text-sm font-medium text-slate-700 flex-grow">화상 상담</span>
                            <i data-lucide="video" class="w-4 h-4 text-slate-400"></i>
                        </label>
                        <label class="flex items-center gap-3 p-3 border border-slate-100 rounded-xl cursor-pointer hover:bg-slate-50 transition-colors">
                            <input type="radio" name="method" value="call" class="accent-purple-600 w-4 h-4"> 
                            <span class="text-sm font-medium text-slate-700 flex-grow">전화 상담</span>
                            <i data-lucide="phone" class="w-4 h-4 text-slate-400"></i>
                        </label>
                    </div>
                </div>

                <%-- 지역 및 거리 필터 (대면 선택 시 활성화) --%>
                <div id="distanceFilter" class="bg-purple-50/50 p-5 rounded-xl border border-purple-100 hidden transition-all">
                    <label class="block text-sm font-bold text-purple-900 mb-3 flex items-center gap-1.5">
                        <i data-lucide="map-pin" class="w-4 h-4"></i> 대면 상담 지역 설정
                    </label>
                    
                    <div class="grid grid-cols-2 gap-2 mb-4">
                        <select class="w-full bg-white border border-purple-200 text-xs rounded-lg p-2.5 focus:outline-none focus:ring-2 focus:ring-purple-400 text-slate-600">
                            <option>시/도 전체</option>
                            <option>서울특별시</option>
                            <option>경기도</option>
                            <option>인천광역시</option>
                        </select>
                        <select class="w-full bg-white border border-purple-200 text-xs rounded-lg p-2.5 focus:outline-none focus:ring-2 focus:ring-purple-400 text-slate-600">
                             <option>시/군/구</option>
                            <option>강남구</option>
                            <option>서초구</option>
                        </select>
                    </div>

                    <label class="flex justify-between items-center mb-2 text-xs font-semibold text-slate-600">
                        <span>현재 내 위치 반경</span>
                        <span id="distanceValue" class="text-purple-600 font-bold">5km</span>
                    </label>
                    <input type="range" id="radiusRange" min="1" max="20" step="1" value="5" class="w-full h-1.5 bg-purple-200 rounded-full appearance-none cursor-pointer accent-purple-600 mb-2">
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
                    <p class="text-slate-600 font-medium text-sm">총 <strong class="text-blue-600 font-bold" id="resultCount">3</strong>명의 전문가</p>
                    <select class="text-sm border border-slate-200 rounded-lg bg-transparent font-medium text-slate-600 focus:ring-2 focus:ring-blue-100 px-3 py-1.5 cursor-pointer outline-none">
                        <option>추천순</option>
                        <option>평점 높은 순</option>
                        <option>리뷰 많은 순</option>
                    </select>
                </div>
            </div>

            <%-- 전문가 그리드 리스트 (사진 참고형 3단 레이아웃 + 호버 효과) --%>
            <div class="grid grid-cols-1 md:grid-cols-2 xl:grid-cols-3 gap-6" id="consultantListContainer">
                
                <%-- [BACKEND/AI 연동] JSP forEach 문을 활용해 DB 또는 FastAPI의 추천 결과를 렌더링해야 합니다. --%>
                
                <%-- 카드 1 : 비오케이파트너스 --%>
                <div class="bg-white rounded-2xl p-4 border border-slate-200 hover:border-blue-500 shadow-sm hover:shadow-xl transition-all duration-300 group flex flex-col gap-3 relative h-max">
                    <div class="flex items-center gap-2">
                        <h3 class="text-lg font-bold text-slate-800">비오케이파트너스</h3>
                        <span class="bg-blue-600 text-white text-[10px] px-2 py-0.5 rounded-full">서울</span>
                    </div>
                    <div class="flex items-center gap-1 text-slate-500 text-sm mb-1">
                        <i data-lucide="phone" class="w-3.5 h-3.5 text-red-500"></i>
                        <span>010-9122-2234</span>
                    </div>

                    <div class="w-full h-32 rounded-xl bg-slate-900 relative overflow-hidden mb-1 flex items-center p-4">
                        <div class="absolute inset-0 bg-gradient-to-r from-gray-900 to-gray-700 opacity-90"></div>
                        <div class="relative z-10">
                            <p class="text-white font-bold text-sm leading-snug">어렵고 힘들어서 지친<br><span class="text-orange-400 text-lg">당신의 동행인</span></p>
                        </div>
                    </div>

                    <div class="flex justify-between items-center border-b border-slate-100 pb-3">
                        <div class="flex items-center gap-1.5">
                            <i data-lucide="check-circle-2" class="w-4 h-4 text-blue-600 fill-blue-600"></i>
                            <span class="font-bold text-slate-800">김도현</span>
                            <span class="text-xs text-slate-400">대표</span>
                        </div>
                        <div class="text-[11px] text-slate-500 flex gap-2">
                            <span>자문요청수 <strong class="text-blue-600 text-xs">97</strong></span>
                            <span>리뷰 <strong class="text-blue-600 text-xs">0</strong></span>
                        </div>
                    </div>

                    <div class="flex justify-between items-center">
                        <span class="bg-slate-100 text-slate-500 text-[10px] px-2 py-1 rounded-full">자문문의 남기기 가능</span>
                        <span class="text-[11px] text-slate-400">조회수 <strong class="text-blue-600 text-xs">80</strong></span>
                    </div>

                    <%-- Default State (호버 전) --%>
                    <div class="flex flex-wrap gap-1.5 mt-1 group-hover:hidden">
                        <span class="px-3 py-1 bg-slate-50 border border-slate-200 rounded-full text-[11px] text-slate-600">ISO</span>
                        <span class="px-3 py-1 bg-slate-50 border border-slate-200 rounded-full text-[11px] text-slate-600">특허</span>
                        <span class="px-3 py-1 bg-slate-50 border border-slate-200 rounded-full text-[11px] text-slate-600">지원금</span>
                        <span class="px-3 py-1 bg-slate-50 border border-slate-200 text-slate-400 rounded-full text-[11px]">... + 4</span>
                    </div>

                    <%-- Hover State (마우스를 올렸을 때 전체 태그 및 버튼 표시) --%>
                    <div class="hidden group-hover:flex flex-col gap-3 mt-1">
                        <div class="flex flex-wrap gap-1.5">
                            <span class="px-3 py-1 bg-slate-50 border border-slate-200 rounded-full text-[11px] text-slate-600">ISO</span>
                            <span class="px-3 py-1 bg-slate-50 border border-slate-200 rounded-full text-[11px] text-slate-600">특허</span>
                            <span class="px-3 py-1 bg-slate-50 border border-slate-200 rounded-full text-[11px] text-slate-600">지원금</span>
                            <span class="px-3 py-1 bg-slate-50 border border-slate-200 rounded-full text-[11px] text-slate-600">정책자금</span>
                            <span class="px-3 py-1 bg-slate-50 border border-slate-200 rounded-full text-[11px] text-slate-600">연구소</span>
                            <span class="px-3 py-1 bg-slate-50 border border-slate-200 rounded-full text-[11px] text-slate-600">벤처인증</span>
                            <span class="px-3 py-1 bg-slate-50 border border-slate-200 rounded-full text-[11px] text-slate-600">경영청구</span>
                        </div>
                        <div class="flex gap-2 mt-2">
                            <button class="flex-1 bg-orange-500 hover:bg-orange-600 text-white py-2.5 rounded-xl text-sm font-bold transition-colors">자세히 보기</button>
                            <button class="flex-1 bg-blue-600 hover:bg-blue-700 text-white py-2.5 rounded-xl text-sm font-bold transition-colors">자문요청 남기기</button>
                        </div>
                    </div>
                </div>

                <%-- 카드 2 : 클라비스원 --%>
                <div class="bg-white rounded-2xl p-4 border border-slate-200 hover:border-blue-500 shadow-sm hover:shadow-xl transition-all duration-300 group flex flex-col gap-3 relative h-max">
                    <div class="flex items-center gap-2">
                        <h3 class="text-lg font-bold text-slate-800">클라비스원</h3>
                        <span class="bg-blue-600 text-white text-[10px] px-2 py-0.5 rounded-full">경기</span>
                    </div>
                    <div class="flex items-center gap-1 text-slate-500 text-sm mb-1">
                        <i data-lucide="phone" class="w-3.5 h-3.5 text-red-500"></i>
                        <span>1544-1541</span>
                    </div>

                    <div class="w-full h-32 rounded-xl bg-slate-800 relative overflow-hidden mb-1 flex items-center p-4">
                        <div class="absolute inset-0 bg-slate-700 opacity-80"></div>
                        <div class="relative z-10 text-center w-full">
                            <p class="text-white font-bold text-[13px] leading-snug">정책자금의 열쇠 복잡한 자금<br><span class="text-orange-400 text-base">단, 하나의 해답 클라비스원</span></p>
                        </div>
                    </div>

                    <div class="flex justify-between items-center border-b border-slate-100 pb-3">
                        <div class="flex items-center gap-1.5">
                            <i data-lucide="check-circle-2" class="w-4 h-4 text-blue-600 fill-blue-600"></i>
                            <span class="font-bold text-slate-800">박선미</span>
                            <span class="text-xs text-slate-400">대표</span>
                        </div>
                        <div class="text-[11px] text-slate-500 flex gap-2">
                            <span>자문요청수 <strong class="text-blue-600 text-xs">125</strong></span>
                            <span>리뷰 <strong class="text-blue-600 text-xs">0</strong></span>
                        </div>
                    </div>

                    <div class="flex justify-between items-center">
                        <span class="bg-slate-100 text-slate-500 text-[10px] px-2 py-1 rounded-full">자문문의 남기기 가능</span>
                        <span class="text-[11px] text-slate-400">조회수 <strong class="text-blue-600 text-xs">3,467</strong></span>
                    </div>

                    <div class="flex flex-wrap gap-1.5 mt-1 group-hover:hidden">
                        <span class="px-3 py-1 bg-slate-50 border border-slate-200 rounded-full text-[11px] text-slate-600">ISO</span>
                        <span class="px-3 py-1 bg-slate-50 border border-slate-200 rounded-full text-[11px] text-slate-600">특허</span>
                        <span class="px-3 py-1 bg-slate-50 border border-slate-200 rounded-full text-[11px] text-slate-600">지원금</span>
                        <span class="px-3 py-1 bg-slate-50 border border-slate-200 text-slate-400 rounded-full text-[11px]">... + 5</span>
                    </div>

                    <div class="hidden group-hover:flex flex-col gap-3 mt-1">
                        <div class="flex flex-wrap gap-1.5">
                            <span class="px-3 py-1 bg-slate-50 border border-slate-200 rounded-full text-[11px] text-slate-600">ISO</span>
                            <span class="px-3 py-1 bg-slate-50 border border-slate-200 rounded-full text-[11px] text-slate-600">특허</span>
                            <span class="px-3 py-1 bg-slate-50 border border-slate-200 rounded-full text-[11px] text-slate-600">지원금</span>
                            <span class="px-3 py-1 bg-slate-50 border border-slate-200 rounded-full text-[11px] text-slate-600">정책자금</span>
                            <span class="px-3 py-1 bg-slate-50 border border-slate-200 rounded-full text-[11px] text-slate-600">연구소</span>
                            <span class="px-3 py-1 bg-slate-50 border border-slate-200 rounded-full text-[11px] text-slate-600">벤처인증</span>
                            <span class="px-3 py-1 bg-slate-50 border border-slate-200 rounded-full text-[11px] text-slate-600">기업부설연구소</span>
                            <span class="px-3 py-1 bg-slate-50 border border-slate-200 rounded-full text-[11px] text-slate-600">경정청구</span>
                        </div>
                        <div class="flex gap-2 mt-2">
                            <button class="flex-1 bg-orange-500 hover:bg-orange-600 text-white py-2.5 rounded-xl text-sm font-bold transition-colors">자세히 보기</button>
                            <button class="flex-1 bg-blue-600 hover:bg-blue-700 text-white py-2.5 rounded-xl text-sm font-bold transition-colors">자문요청 남기기</button>
                        </div>
                    </div>
                </div>

                <%-- 카드 3 : 미래금융파트너스 --%>
                <div class="bg-white rounded-2xl p-4 border border-slate-200 hover:border-blue-500 shadow-sm hover:shadow-xl transition-all duration-300 group flex flex-col gap-3 relative h-max">
                    <div class="flex items-center gap-2">
                        <h3 class="text-lg font-bold text-slate-800">미래금융파트너스</h3>
                        <span class="bg-blue-600 text-white text-[10px] px-2 py-0.5 rounded-full">서울</span>
                    </div>
                    <div class="flex items-center gap-1 text-slate-500 text-sm mb-1">
                        <i data-lucide="phone" class="w-3.5 h-3.5 text-red-500"></i>
                        <span>010-4077-1724</span>
                    </div>

                    <div class="w-full h-32 rounded-xl bg-[#001E42] relative overflow-hidden mb-1 flex flex-col justify-center p-4">
                        <div class="relative z-10 text-center">
                            <p class="text-white font-bold text-[13px] leading-snug"><span class="bg-blue-600 px-1 rounded">부결된 자금도 되살리는</span><br>정책자금 심폐소생술 전문가</p>
                            <p class="text-[10px] text-gray-300 mt-1">몰라서 못 받는 돈은 없어야 합니다.</p>
                        </div>
                    </div>

                    <div class="flex justify-between items-center border-b border-slate-100 pb-3">
                        <div class="flex items-center gap-1.5">
                            <i data-lucide="check-circle-2" class="w-4 h-4 text-blue-600 fill-blue-600"></i>
                            <span class="font-bold text-slate-800">임상훈</span>
                            <span class="text-xs text-slate-400">대표</span>
                        </div>
                        <div class="text-[11px] text-slate-500 flex gap-2">
                            <span>자문요청수 <strong class="text-blue-600 text-xs">315</strong></span>
                            <span>리뷰 <strong class="text-blue-600 text-xs">0</strong></span>
                        </div>
                    </div>

                    <div class="flex justify-between items-center">
                        <span class="bg-slate-100 text-slate-500 text-[10px] px-2 py-1 rounded-full">자문문의 남기기 가능</span>
                        <span class="text-[11px] text-slate-400">조회수 <strong class="text-blue-600 text-xs">8,086</strong></span>
                    </div>

                    <div class="flex flex-wrap gap-1.5 mt-1 group-hover:hidden">
                        <span class="px-3 py-1 bg-slate-50 border border-slate-200 rounded-full text-[11px] text-slate-600">세무</span>
                        <span class="px-3 py-1 bg-slate-50 border border-slate-200 rounded-full text-[11px] text-slate-600">ISO</span>
                        <span class="px-3 py-1 bg-slate-50 border border-slate-200 rounded-full text-[11px] text-slate-600">특허</span>
                        <span class="px-3 py-1 bg-slate-50 border border-slate-200 text-slate-400 rounded-full text-[11px]">... + 7</span>
                    </div>

                    <div class="hidden group-hover:flex flex-col gap-3 mt-1">
                        <div class="flex flex-wrap gap-1.5">
                            <span class="px-3 py-1 bg-slate-50 border border-slate-200 rounded-full text-[11px] text-slate-600">세무</span>
                            <span class="px-3 py-1 bg-slate-50 border border-slate-200 rounded-full text-[11px] text-slate-600">ISO</span>
                            <span class="px-3 py-1 bg-slate-50 border border-slate-200 rounded-full text-[11px] text-slate-600">특허</span>
                            <span class="px-3 py-1 bg-slate-50 border border-slate-200 rounded-full text-[11px] text-slate-600">지원금</span>
                            <span class="px-3 py-1 bg-slate-50 border border-slate-200 rounded-full text-[11px] text-slate-600">경영인증</span>
                            <span class="px-3 py-1 bg-slate-50 border border-slate-200 rounded-full text-[11px] text-slate-600">기업대출</span>
                            <span class="px-3 py-1 bg-slate-50 border border-slate-200 rounded-full text-[11px] text-slate-600">절세</span>
                            <span class="px-3 py-1 bg-slate-50 border border-slate-200 rounded-full text-[11px] text-slate-600">노무</span>
                            <span class="px-3 py-1 bg-slate-50 border border-slate-200 rounded-full text-[11px] text-slate-600">재무관리</span>
                            <span class="px-3 py-1 bg-slate-50 border border-slate-200 rounded-full text-[11px] text-slate-600">신용등급</span>
                        </div>
                        <div class="flex gap-2 mt-2">
                            <button class="flex-1 bg-orange-500 hover:bg-orange-600 text-white py-2.5 rounded-xl text-sm font-bold transition-colors">자세히 보기</button>
                            <button class="flex-1 bg-blue-600 hover:bg-blue-700 text-white py-2.5 rounded-xl text-sm font-bold transition-colors">자문요청 남기기</button>
                        </div>
                    </div>
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
    if(typeof lucide !== 'undefined') lucide.createIcons();

    // 대분류별 소분류 매핑 데이터
    const categoryMap = {
        'IT': { name: 'IT / 기술', subs: [{id: 'ELEC', name: '전기전자통신'}, {id: 'SW', name: '소프트웨어/IT'}] },
        'BIO': { name: '바이오 / 인증', subs: [{id: 'CHEM', name: '화학생명공학'}, {id: 'BIO_CERT', name: '바이오/의료기기'}] },
        'MANU': { name: '제조 / R&D', subs: [{id: 'MECH', name: '기계금속건설'}, {id: 'PROCESS', name: '공정/품질'}] },
        'BRAND': { name: '브랜딩 / 디자인', subs: [{id: 'DESIGN', name: '상표/디자인'}, {id: 'PATENT', name: '특허/IP'}] }
    };

    let selectedMain = null;
    let selectedSubs = [];

    function selectMainCategory(key) {
        // 왼쪽 사이드바 대분류 버튼 스타일 초기화 및 선택 효과 적용
        document.querySelectorAll('.main-cat-btn').forEach(btn => {
            btn.classList.remove('border-blue-500', 'bg-blue-50', 'text-blue-700', 'shadow-md');
            btn.querySelector('i').classList.remove('text-blue-600', 'rotate-90');
        });

        const selectedBtn = document.getElementById(`btn-\${key}`); 
        if(selectedBtn) {
            selectedBtn.classList.add('border-blue-500', 'bg-blue-50', 'text-blue-700', 'shadow-md');
            selectedBtn.querySelector('i').classList.add('text-blue-600', 'rotate-90');
        }

        selectedMain = key;
        
        // 오른쪽 상단 소분류(세부 분야) 버튼들을 해당 대분류에 맞게 재생성
        const container = document.getElementById('subCategoryContainer');
        container.innerHTML = `<span class="text-sm font-bold text-slate-700 mr-2 border-r border-slate-300 pr-3">\${categoryMap[key].name} 세부 분야</span>` + 
        `<button type="button" onclick="selectAllSubs(this)" class="px-4 py-1.5 rounded-full border border-blue-600 bg-blue-600 text-sm font-medium text-white shadow-sm transition-all">전체</button>` +
        categoryMap[key].subs.map(sub => `
            <button type="button" onclick="toggleSubCategory('\${sub.id}', this)" 
                    class="sub-cat-btn px-4 py-1.5 rounded-full border border-slate-200 bg-white text-sm font-medium text-slate-600 hover:border-blue-400 hover:text-blue-600 transition-all shadow-sm">
                \${sub.name}
            </button>
        `).join('');
    }

    // 소분류 개별 선택 토글 함수
    function toggleSubCategory(subId, el) {
        if (selectedSubs.includes(subId)) {
            selectedSubs = selectedSubs.filter(id => id !== subId);
            el.classList.remove('bg-blue-50', 'text-blue-600', 'border-blue-400', 'font-bold');
            el.classList.add('bg-white', 'text-slate-600', 'border-slate-200');
        } else {
            selectedSubs.push(subId);
            el.classList.add('bg-blue-50', 'text-blue-600', 'border-blue-400', 'font-bold');
            el.classList.remove('bg-white', 'text-slate-600', 'border-slate-200');
        }
    }

    // '전체' 버튼 클릭 시 선택 초기화용 
    function selectAllSubs(el) {
        selectedSubs = [];
        const container = document.getElementById('subCategoryContainer');
        container.querySelectorAll('.sub-cat-btn').forEach(btn => {
            btn.classList.remove('bg-blue-50', 'text-blue-600', 'border-blue-400', 'font-bold');
            btn.classList.add('bg-white', 'text-slate-600', 'border-slate-200');
        });
    }

    document.getElementById('consultingSearchForm').addEventListener('reset', function() {
        selectedMain = null;
        selectedSubs = [];
        
        // 초기화 시 원래 있던 기본 소분류 버튼들로 복구
        const container = document.getElementById('subCategoryContainer');
        container.innerHTML = `
            <span class="text-sm font-bold text-slate-700 mr-2 border-r border-slate-300 pr-3">세부 분야</span>
            <button type="button" class="px-4 py-1.5 rounded-full border border-blue-600 bg-blue-600 text-sm font-medium text-white shadow-sm">전체</button>
            <button type="button" class="px-4 py-1.5 rounded-full border border-slate-200 bg-white text-sm font-medium text-slate-600 hover:border-blue-400 hover:text-blue-600 transition-all shadow-sm">세무/회계</button>
            <button type="button" class="px-4 py-1.5 rounded-full border border-slate-200 bg-white text-sm font-medium text-slate-600 hover:border-blue-400 hover:text-blue-600 transition-all shadow-sm">인사/노무</button>
            <button type="button" class="px-4 py-1.5 rounded-full border border-slate-200 bg-white text-sm font-medium text-slate-600 hover:border-blue-400 hover:text-blue-600 transition-all shadow-sm">법무/특허</button>
            <button type="button" class="px-4 py-1.5 rounded-full border border-slate-200 bg-white text-sm font-medium text-slate-600 hover:border-blue-400 hover:text-blue-600 transition-all shadow-sm">지원금/정책자금</button>
        `;

        document.querySelectorAll('.main-cat-btn').forEach(btn => {
            btn.classList.remove('border-blue-500', 'bg-blue-50', 'text-blue-700', 'shadow-md');
            btn.querySelector('i').classList.remove('text-blue-600', 'rotate-90');
        });
    });

    const methodRadios = document.querySelectorAll('input[name="method"]');
    const distanceFilter = document.getElementById('distanceFilter');
    methodRadios.forEach(radio => {
        radio.addEventListener('change', (e) => {
            if(e.target.value === 'face') {
                distanceFilter.classList.remove('hidden');
            } else {
                distanceFilter.classList.add('hidden');
            }
        });
    });

    const radiusRange = document.getElementById('radiusRange');
    const distanceValue = document.getElementById('distanceValue');
    radiusRange?.addEventListener('input', (e) => {
        distanceValue.textContent = e.target.value + 'km';
    });

    function searchConsultants() {
        alert('선택한 조건 및 지역 정보를 바탕으로 서버에 전문가 데이터를 요청합니다.\n선택된 소분류: ' + (selectedSubs.length > 0 ? selectedSubs.join(', ') : '전체'));
    }

    function openChatWithInput() {
        const input = document.getElementById('heroSearchInput').value;
        if(input.trim() !== '') {
            document.getElementById('chat-input').value = input;
            toggleChat();
            setTimeout(sendChatMessage, 300);
        } else {
            toggleChat();
        }
    }

    function toggleChat() {
        const win = document.getElementById('chat-window');
        if(win.classList.contains('hidden')) {
            win.classList.remove('hidden');
            setTimeout(() => {
                win.classList.remove('translate-y-4', 'opacity-0');
            }, 10);
        } else {
            win.classList.add('translate-y-4', 'opacity-0');
            setTimeout(() => {
                win.classList.add('hidden');
            }, 300);
        }
    }

    function handleChatEnter(e) {
        if(e.key === 'Enter') sendChatMessage();
    }

    async function sendChatMessage() {
        const input = document.getElementById('chat-input');
        const box = document.getElementById('chat-messages');
        const text = input.value.trim();
        if(!text) return;
        
        box.innerHTML += `
            <div class="flex justify-end mb-4">
                <div class="bg-purple-600 text-white p-3 rounded-2xl rounded-br-none shadow-sm text-sm max-w-[85%]">
                    \${text}
                </div>
            </div>
        `;
        input.value = '';
        box.scrollTop = box.scrollHeight;

        const loadingId = 'loading-' + Date.now();
        box.innerHTML += `
            <div id="\${loadingId}" class="flex gap-2 items-end mb-4">
                <div class="w-6 h-6 rounded-full bg-purple-100 flex items-center justify-center flex-shrink-0"><i data-lucide="bot" class="w-3 h-3 text-purple-600"></i></div>
                <div class="bg-white px-4 py-3 rounded-2xl rounded-bl-none shadow-sm border border-slate-100 flex gap-1 items-center">
                    <div class="w-1.5 h-1.5 bg-purple-400 rounded-full animate-bounce"></div>
                    <div class="w-1.5 h-1.5 bg-purple-400 rounded-full animate-bounce" style="animation-delay: 0.1s"></div>
                    <div class="w-1.5 h-1.5 bg-purple-400 rounded-full animate-bounce" style="animation-delay: 0.2s"></div>
                </div>
            </div>
        `;
        box.scrollTop = box.scrollHeight;
        if(typeof lucide !== 'undefined') lucide.createIcons();

        setTimeout(() => {
            document.getElementById(loadingId).remove();
            
            const aiResponse = `
                <div class="flex gap-2 items-end mb-4">
                    <div class="w-6 h-6 rounded-full bg-purple-100 flex items-center justify-center flex-shrink-0"><i data-lucide="bot" class="w-3 h-3 text-purple-600"></i></div>
                    <div class="bg-white p-4 rounded-2xl rounded-bl-none shadow-sm border border-slate-100 text-sm text-slate-700 max-w-[85%]">
                        말씀하신 내용을 바탕으로 <strong>상담 가이드</strong>를 요약했습니다.<br><br>
                        <div class="bg-slate-50 p-3 rounded-lg border border-slate-200 my-2 text-xs">
                            <strong class="text-purple-600">요약 내용:</strong> 초기 스타트업 단계에서의 법인세 및 소득세 절세 방안 문의<br>
                            <strong class="text-purple-600">추천 분야:</strong> 세무/회계
                        </div>
                        이 내용을 컨설턴트에게 바로 전달해 드릴까요? 화면에 가장 적합한 전문가를 매칭해 두었습니다!
                        <button class="mt-3 w-full bg-purple-50 text-purple-600 border border-purple-200 py-2 rounded-lg font-bold text-xs hover:bg-purple-600 hover:text-white transition-colors">이 내용으로 상담 신청하기</button>
                    </div>
                </div>
            `;
            box.innerHTML += aiResponse;
            box.scrollTop = box.scrollHeight;
            if(typeof lucide !== 'undefined') lucide.createIcons();
        }, 1500);
    }
</script>

<%-- 푸터 파일 로드 --%>
<jsp:include page="/WEB-INF/views/common/footer.jsp" />