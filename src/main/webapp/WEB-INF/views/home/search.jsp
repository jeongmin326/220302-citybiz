<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<jsp:include page="/WEB-INF/views/common/header.jsp" />

<%
    // [기능/논리 유지] 기존 로직 절대 수정하지 않음
    request.setCharacterEncoding("UTF-8");
    String keyword = request.getParameter("keyword");
    if(keyword == null || keyword.trim().equals("")){
        keyword = "창업 공간 / 지원사업 / 컨설팅";
    }

    String userType = request.getParameter("userType");
    if(userType == null || userType.trim().equals("")){
        userType = "예비창업자";
    }

    String region = request.getParameter("region");
    if(region == null || region.trim().equals("")){
        region = "경기도 성남시";
    }
%>

<div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-12 w-full">

    <div class="relative bg-gradient-to-br from-slate-900 via-blue-900 to-indigo-800 rounded-[2.5rem] p-10 lg:p-16 shadow-2xl overflow-hidden mb-10 text-white">
        <div class="absolute -top-24 -right-24 w-96 h-96 bg-blue-500/20 rounded-full blur-3xl"></div>
        <div class="absolute -bottom-24 -left-24 w-80 h-80 bg-indigo-500/20 rounded-full blur-3xl"></div>
        
        <div class="relative z-10">
            <div class="flex items-center gap-3 mb-6 opacity-90">
                <div class="p-2 bg-white/10 rounded-xl backdrop-blur-md">
                    <i data-lucide="search" class="w-6 h-6 text-blue-300"></i>
                </div>
                <span class="text-blue-100 font-semibold tracking-wider">SEARCH RESULTS</span>
            </div>
            
            <h1 class="text-3xl lg:text-5xl font-extrabold mb-6 tracking-tight leading-tight">
                도시 비즈니스 자원<br><span class="text-blue-400">통합 검색 결과</span>
            </h1>
            
            <p class="text-white/70 leading-relaxed max-w-2xl mb-10 font-light text-lg">
                분산된 창업공간, 지원사업, 지원기관, 컨설팅 네트워크 정보를 통합하여 고객님께 가장 적합한 비즈니스 자원을 한눈에 보여드립니다.
            </p>

            <div class="flex flex-wrap gap-3 items-center">
                <div class="bg-white/10 backdrop-blur-md border border-white/20 px-5 py-3 rounded-2xl flex items-center gap-3">
                    <span class="text-white/50 text-xs font-bold uppercase tracking-widest">검색어</span>
                    <span class="font-semibold text-blue-100"><%= keyword %></span>
                </div>
                <div class="bg-white/10 backdrop-blur-md border border-white/20 px-5 py-3 rounded-2xl flex items-center gap-3">
                    <span class="text-white/50 text-xs font-bold uppercase tracking-widest">유형</span>
                    <span class="font-semibold text-blue-100"><%= userType %></span>
                </div>
                <div class="bg-white/10 backdrop-blur-md border border-white/20 px-5 py-3 rounded-2xl flex items-center gap-3">
                    <span class="text-white/50 text-xs font-bold uppercase tracking-widest">지역</span>
                    <span class="font-semibold text-blue-100"><%= region %></span>
                </div>
                
                <%-- 다시 검색하기 버튼 --%>
                <a href="/main" class="ml-auto bg-white text-slate-900 hover:bg-blue-50 px-6 py-3 rounded-2xl flex items-center gap-2 transition-all duration-300 font-bold text-sm shadow-lg">
                    <i data-lucide="rotate-ccw" class="w-4 h-4 text-blue-600"></i>
                    다시 검색하기
                </a>
            </div>
        </div>
    </div>

    <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-6 mb-12">
        <div class="group bg-white p-8 rounded-[2rem] border border-slate-100 shadow-[0_4px_20px_-4px_rgba(0,0,0,0.05)] hover:shadow-xl hover:-translate-y-1 transition-all duration-300">
            <div class="w-12 h-12 bg-blue-50 rounded-2xl flex items-center justify-center mb-6 group-hover:bg-blue-600 transition-colors">
                <i data-lucide="map-pin" class="w-6 h-6 text-blue-600 group-hover:text-white"></i>
            </div>
            <div class="text-slate-400 text-sm font-semibold mb-1">추천 공간</div>
            <div class="text-3xl font-bold text-slate-900">${spaceCount}개</div>
        </div>
        
        <div class="group bg-white p-8 rounded-[2rem] border border-slate-100 shadow-[0_4px_20px_-4px_rgba(0,0,0,0.05)] hover:shadow-xl hover:-translate-y-1 transition-all duration-300">
            <div class="w-12 h-12 bg-emerald-50 rounded-2xl flex items-center justify-center mb-6 group-hover:bg-emerald-600 transition-colors">
                <i data-lucide="briefcase" class="w-6 h-6 text-emerald-600 group-hover:text-white"></i>
            </div>
            <div class="text-slate-400 text-sm font-semibold mb-1">지원사업</div>
            <div class="text-3xl font-bold text-slate-900">${policyCount}건</div>
        </div>

        <div class="group bg-white p-8 rounded-[2rem] border border-slate-100 shadow-[0_4px_20px_-4px_rgba(0,0,0,0.05)] hover:shadow-xl hover:-translate-y-1 transition-all duration-300">
            <div class="w-12 h-12 bg-purple-50 rounded-2xl flex items-center justify-center mb-6 group-hover:bg-purple-600 transition-colors">
                <i data-lucide="users" class="w-6 h-6 text-purple-600 group-hover:text-white"></i>
            </div>
            <div class="text-slate-400 text-sm font-semibold mb-1">컨설팅 기업</div>
            <div class="text-3xl font-bold text-slate-900">${consultingCount}명</div>
        </div>

        <div class="group bg-white p-8 rounded-[2rem] border border-slate-100 shadow-[0_4px_20px_-4px_rgba(0,0,0,0.05)] hover:shadow-xl hover:-translate-y-1 transition-all duration-300">
            <div class="w-12 h-12 bg-amber-50 rounded-2xl flex items-center justify-center mb-6 group-hover:bg-amber-600 transition-colors">
                <i data-lucide="building" class="w-6 h-6 text-amber-600 group-hover:text-white"></i>
            </div>
            <div class="text-slate-400 text-sm font-semibold mb-1">지원기관</div>
            <div class="text-3xl font-bold text-slate-900">${institutionCount}개</div>
        </div>
    </div>

    <div class="grid grid-cols-1 xl:grid-cols-12 gap-10">
        <div class="xl:col-span-8 space-y-10">

            <section class="bg-white rounded-[2.5rem] border border-slate-100 shadow-[0_4px_20px_-4px_rgba(0,0,0,0.05)] overflow-hidden">
                <div class="p-8 sm:p-10 border-b border-slate-50">
                    <div class="flex justify-between items-start">
                        <div class="flex items-center gap-3">
                            <div class="w-8 h-8 bg-blue-100 rounded-lg flex items-center justify-center">
                                <i data-lucide="map-pin" class="w-4 h-4 text-blue-600"></i>
                            </div>
                            <h2 class="text-2xl font-bold text-slate-900 tracking-tight">1. 추천 창업 공간 / 회의실</h2>
                        </div>
                        <c:url value="/space" var="spaceUrl"><c:param name="region" value="${param.region}"/></c:url>
                        <a href="${spaceUrl}" class="shrink-0 text-sm font-bold text-emerald-600 hover:text-emerald-800 flex items-center gap-1">
                            전체보기 <i data-lucide="arrow-right" class="w-4 h-4"></i>
                        </a>
                    </div>
                </div>
                <div class="p-8 sm:p-10">
                    <c:choose>
                        <c:when test="${empty spaceResults}">
                            <div class="text-center py-8">
                                <p class="text-slate-400 text-sm">선택한 지역에 등록된 공간이 없습니다.</p>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="overflow-x-auto rounded-2xl border border-slate-100">
                                <table class="w-full text-left border-collapse">
                                    <thead>
                                        <tr class="bg-slate-50/50 text-slate-500 text-xs font-bold uppercase tracking-widest border-b border-slate-100">
                                            <th class="p-5">공간명</th>
                                            <th class="p-5">위치</th>
                                            <th class="p-5">수용인원</th>
                                            <th class="p-5">상태</th>
                                            <th class="p-5 text-center">예약</th>
                                        </tr>
                                    </thead>
                                    <tbody class="divide-y divide-slate-50">
                                        <c:forEach var="s" items="${spaceResults}" begin="0" end="1">
                                            <tr class="hover:bg-slate-50 transition-colors">
                                                <td class="p-5 font-bold text-slate-900">${s.name}</td>
                                                <td class="p-5 text-slate-500 text-sm">${s.district}</td>
                                                <td class="p-5 text-slate-500 text-sm">${s.capacity}명</td>
                                                <td class="p-5">
                                                    <c:choose>
                                                        <c:when test="${s.availableYn == 'Y'}">
                                                            <span class="bg-emerald-50 text-emerald-600 px-2 py-1 rounded-md text-[11px] font-black tracking-tight">AVAILABLE</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="bg-amber-50 text-amber-600 px-2 py-1 rounded-md text-[11px] font-black tracking-tight">WAITING</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td class="p-5 text-center">
                                                    <c:choose>
                                                        <c:when test="${s.availableYn == 'Y'}">
                                                            <button type="button"
                                                                data-space-id="${s.spaceId}"
                                                                data-space-name="${s.name}"
                                                                data-space-type="${s.spaceType}"
                                                                data-space-address="${s.address}"
                                                                data-price="${s.pricePerHour}"
                                                                data-capacity="${s.capacity}"
                                                                onclick="openReservationModalFromData(this)"
                                                                class="text-blue-600 hover:bg-blue-50 px-3 py-1 rounded-lg text-sm font-bold transition-all cursor-pointer">예약하기</button>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="text-slate-400 px-3 py-1 text-sm font-bold">대기중</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </section>

            <section class="bg-white rounded-[2.5rem] border border-slate-100 shadow-[0_4px_20px_-4px_rgba(0,0,0,0.05)] overflow-hidden">
                <div class="p-8 sm:p-10 border-b border-slate-50">
                    <div class="flex justify-between items-start">
                        <div>
                            <div class="flex items-center gap-3 mb-2">
                                <div class="w-8 h-8 bg-emerald-100 rounded-lg flex items-center justify-center">
                                    <i data-lucide="briefcase" class="w-4 h-4 text-emerald-600"></i>
                                </div>
                                <h2 class="text-2xl font-bold text-slate-900 uppercase tracking-tight">2. 추천 지원 사업</h2>
                            </div>
                            <p class="text-slate-500">창업 단계와 지역 조건을 반영하여 활용 가능성이 높은 지원사업입니다.</p>
                        </div>
                        <c:url value="/policy" var="policyUrl"><c:param name="keyword" value="${param.keyword}"/></c:url>
                        <a href="${policyUrl}" class="shrink-0 text-sm font-bold text-blue-600 hover:text-blue-800 flex items-center gap-1 mt-1">
                            전체보기 <i data-lucide="arrow-right" class="w-4 h-4"></i>
                        </a>
                    </div>
                </div>
                <div class="p-8 sm:p-10 space-y-4">
                    <c:choose>
                        <c:when test="${empty policyResults}">
                            <div class="text-center py-8">
                                <p class="text-slate-400 text-sm">검색 조건에 맞는 지원사업이 없습니다.</p>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="p" items="${policyResults}" begin="0" end="1">
                                <div class="group border border-slate-100 rounded-2xl p-6 hover:bg-slate-50 hover:border-blue-200 transition-all flex flex-col md:flex-row justify-between items-start md:items-center gap-6">
                                    <div class="flex-grow">
                                        <div class="flex items-center gap-2 mb-2">
                                            <span class="bg-indigo-50 text-indigo-600 border border-indigo-100 px-2.5 py-0.5 rounded-md text-xs font-bold">${p.category}</span>
                                            <c:if test="${p.applicationAvailableYn == 'Y'}">
                                                <span class="bg-rose-50 text-rose-600 border border-rose-100 px-2.5 py-0.5 rounded-full text-xs font-bold">접수중</span>
                                            </c:if>
                                        </div>
                                        <h3 class="text-lg font-bold text-slate-900 mb-2 group-hover:text-blue-600 transition-colors">${p.fundName}</h3>
                                        <p class="text-slate-500 text-sm leading-relaxed mb-4 line-clamp-2">${p.businessDescription}</p>
                                        <div class="flex flex-wrap gap-2">
                                            <span class="bg-blue-50 text-blue-600 px-3 py-1 rounded-lg text-xs font-bold">기관: ${p.institution}</span>
                                            <span class="bg-slate-100 text-slate-600 px-3 py-1 rounded-lg text-xs font-bold">유형: ${p.category}</span>
                                        </div>
                                    </div>
                                    <a href="/policy" class="shrink-0 bg-slate-900 text-white px-6 py-3 rounded-xl text-sm font-bold hover:bg-blue-600 transition-all shadow-lg shadow-slate-200">상세보기</a>
                                </div>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </div>
            </section>

            <section class="bg-white rounded-[2.5rem] border border-slate-100 shadow-[0_4px_20px_-4px_rgba(0,0,0,0.05)] overflow-hidden">
                <div class="p-8 sm:p-10 border-b border-slate-50">
                    <div class="flex justify-between items-center">
                        <div class="flex items-center gap-3">
                            <div class="w-8 h-8 bg-purple-100 rounded-lg flex items-center justify-center">
                                <i data-lucide="users" class="w-4 h-4 text-purple-600"></i>
                            </div>
                            <h2 class="text-2xl font-bold text-slate-900 tracking-tight">3. 추천 컨설팅 기업 / 전문가</h2>
                        </div>
                        <c:url value="/consulting" var="consultingUrl"><c:param name="region" value="${param.region}"/></c:url>
                        <a href="${consultingUrl}" class="shrink-0 text-sm font-bold text-purple-600 hover:text-purple-800 flex items-center gap-1">
                            전체보기 <i data-lucide="arrow-right" class="w-4 h-4"></i>
                        </a>
                    </div>
                </div>
                <div class="p-8 sm:p-10 grid grid-cols-1 md:grid-cols-2 gap-6">
                    <c:choose>
                        <c:when test="${empty consultingResults}">
                            <div class="col-span-2 text-center py-8">
                                <p class="text-slate-400 text-sm">선택한 지역에 등록된 전문가가 없습니다.</p>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="c" items="${consultingResults}">
                                <div class="p-6 rounded-2xl bg-slate-50 border border-slate-100 hover:border-purple-200 transition-all group">
                                    <div class="text-purple-600 text-[10px] font-black tracking-widest uppercase mb-2">${c.expertType}</div>
                                    <h4 class="text-lg font-bold text-slate-900 mb-2 group-hover:text-purple-600 transition-colors truncate">${c.office}</h4>
                                    <p class="text-slate-500 text-sm mb-4 leading-relaxed">${c.field} 전문</p>
                                    <div class="flex items-center justify-between">
                                        <span class="text-xs font-bold text-slate-400 underline decoration-slate-200 underline-offset-4">
                                            평점 ${c.rating}점 / 경력 ${c.experienceYears}년
                                        </span>
                                        <div class="flex items-center gap-2">
                                            <button
                                                data-expert-id="${c.id}"
                                                data-expert-type="${c.expertType}"
                                                data-expert-name="${c.name}"
                                                data-expert-office="${c.office}"
                                                onclick="openSearchMapModal(this)"
                                                class="text-xs font-bold text-white bg-orange-500 hover:bg-orange-600 px-3 py-1.5 rounded-lg transition-colors flex-shrink-0">
                                                위치 보기
                                            </button>
                                            <button
                                                data-expert-id="${c.id}"
                                                data-expert-type="${c.expertType}"
                                                data-expert-name="${c.name}"
                                                data-expert-office="${c.office}"
                                                onclick="openSearchRequestModal(this)"
                                                class="text-xs font-bold text-white bg-blue-600 hover:bg-blue-700 px-3 py-1.5 rounded-lg transition-colors flex items-center gap-1 flex-shrink-0">
                                                자문요청
                                            </button>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </div>
            </section>
            <section class="bg-white rounded-[2.5rem] border border-slate-100 shadow-[0_4px_20px_-4px_rgba(0,0,0,0.05)] overflow-hidden">
                <div class="p-8 sm:p-10 border-b border-slate-50">
                    <div class="flex items-center gap-3">
                        <div class="w-8 h-8 bg-amber-100 rounded-lg flex items-center justify-center">
                            <i data-lucide="building" class="w-4 h-4 text-amber-600"></i>
                        </div>
                        <h2 class="text-2xl font-bold text-slate-900 tracking-tight">4. 지원기관</h2>
                    </div>
                </div>
                <div class="p-8 sm:p-10">
                    <c:choose>
                        <c:when test="${empty institutionList}">
                            <div class="text-center py-8">
                                <p class="text-slate-400 text-sm">등록된 지원기관이 없습니다.</p>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="flex flex-wrap gap-2">
                                <c:forEach var="inst" items="${institutionList}">
                                    <span class="bg-amber-50 text-amber-700 border border-amber-100 px-3 py-1.5 rounded-xl text-sm font-semibold">${inst}</span>
                                </c:forEach>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </section>
        </div>

        <aside class="xl:col-span-4 space-y-8">
            <div class="bg-white p-8 rounded-[2.5rem] border border-slate-100 shadow-[0_4px_20px_-4px_rgba(0,0,0,0.05)]">
                <h3 class="text-xl font-bold text-slate-900 mb-6 flex items-center gap-2">
                    <i data-lucide="map" class="w-5 h-5 text-blue-600"></i>
                    5. 위치 / 길안내
                </h3>
                <div class="aspect-square bg-slate-50 rounded-[2rem] border border-dashed border-slate-200 flex flex-col items-center justify-center p-8 text-center">
                    <div class="w-16 h-16 bg-white rounded-2xl shadow-sm flex items-center justify-center mb-4">
                        <i data-lucide="navigation" class="w-8 h-8 text-blue-500"></i>
                    </div>
                    <p class="text-slate-900 font-bold mb-2">지도 API 영역</p>
                    <p class="text-slate-400 text-xs leading-relaxed">인근 자원 추천 결과를 기반으로<br>최적의 이동 경로를 표시합니다.</p>
                </div>
            </div>

            <div class="bg-blue-600 p-8 rounded-[2.5rem] shadow-xl shadow-blue-200 text-white relative overflow-hidden group">
                <i data-lucide="cpu" class="absolute -right-4 -bottom-4 w-32 h-32 text-white/10 rotate-12 group-hover:scale-110 transition-transform"></i>
                <h3 class="text-xl font-bold mb-4 relative z-10">6. AI 추천 근거</h3>
                <ul class="space-y-3 relative z-10">
                    <li class="flex items-start gap-2 text-sm text-blue-100">
                        <span class="w-1.5 h-1.5 rounded-full bg-blue-300 mt-1.5 shrink-0"></span>
                        현재 지역과의 거리 및 접근성
                    </li>
                    <li class="flex items-start gap-2 text-sm text-blue-100">
                        <span class="w-1.5 h-1.5 rounded-full bg-blue-300 mt-1.5 shrink-0"></span>
                        실시간 공간 예약 가능 여부
                    </li>
                    <li class="flex items-start gap-2 text-sm text-blue-100">
                        <span class="w-1.5 h-1.5 rounded-full bg-blue-300 mt-1.5 shrink-0"></span>
                        기업 성장 단계별 최적 지원사업
                    </li>
                </ul>
            </div>
        </aside>
    </div>
</div>

<%-- ── 예약 모달 ──────────────────────────────────────────────────── --%>
<div id="reservationModal"
     class="fixed inset-0 z-50 hidden flex items-center justify-center p-4"
     onclick="closeModalOnBackdrop(event)">
    <div class="absolute inset-0 bg-slate-900/50 backdrop-blur-sm"></div>
    <div class="relative bg-white rounded-3xl shadow-2xl w-full max-w-2xl max-h-[90vh] overflow-y-auto">

        <%-- 모달 헤더 --%>
        <div class="px-8 pt-8 pb-5 border-b border-slate-100 sticky top-0 bg-white z-10 rounded-t-3xl">
            <div class="flex justify-between items-start">
                <div>
                    <p class="text-xs font-bold text-blue-600 mb-1" id="modalSpaceType"></p>
                    <h2 class="text-xl font-extrabold text-slate-900" id="modalSpaceName"></h2>
                    <p class="text-sm text-slate-500 mt-1" id="modalSpaceAddress"></p>
                </div>
                <button onclick="closeReservationModal()" class="text-slate-400 hover:text-slate-700 transition-colors mt-1">
                    <i data-lucide="x" class="w-6 h-6"></i>
                </button>
            </div>
            <div class="mt-3 flex items-center gap-4 text-sm text-slate-600">
                <span class="font-extrabold text-blue-600 text-lg" id="modalPrice"></span>
                <span class="text-slate-300">|</span>
                <span class="flex items-center gap-1"><i data-lucide="users" class="w-4 h-4"></i><span id="modalCapacity"></span>명</span>
            </div>
        </div>

        <%-- 예약 폼 --%>
        <form id="reservationForm" class="px-8 py-6 space-y-5" onsubmit="submitReservation(event)">
            <input type="hidden" id="modalSpaceId">

            <%-- 날짜 선택 --%>
            <div>
                <label class="block text-sm font-semibold text-slate-700 mb-2">이용 날짜 <span class="text-rose-500">*</span></label>
                <input type="date" id="resUseDate" required onchange="loadTimeline()"
                       class="w-full px-4 py-3 bg-slate-50 border border-slate-200 rounded-xl focus:bg-white focus:outline-none focus:ring-2 focus:ring-blue-500 transition-all text-slate-700">
            </div>

            <%-- 타임라인 --%>
            <div>
                <div class="flex items-center justify-between mb-2">
                    <label class="text-sm font-semibold text-slate-700">이용 시간 <span class="text-rose-500">*</span></label>
                    <button type="button" id="resetSelBtn" onclick="resetSelection()"
                            class="hidden text-xs text-slate-400 hover:text-rose-500 transition-colors">선택 초기화</button>
                </div>
                <div id="timelinePlaceholder"
                     class="bg-slate-50 border border-dashed border-slate-200 rounded-2xl p-6 text-center text-sm text-slate-400">
                    날짜를 선택하면 예약 현황이 표시됩니다.
                </div>
                <div id="timelineLoading" class="hidden bg-slate-50 rounded-2xl p-6 text-center">
                    <div class="inline-block w-5 h-5 border-2 border-blue-500 border-t-transparent rounded-full animate-spin"></div>
                </div>
                <div id="timelineGrid" class="hidden space-y-2"></div>
                <div id="timelineLegend" class="hidden flex items-center gap-4 mt-2 text-xs text-slate-500">
                    <span class="flex items-center gap-1.5">
                        <span class="w-3 h-3 rounded-sm bg-slate-200 inline-block"></span>마감
                    </span>
                    <span class="flex items-center gap-1.5">
                        <span class="w-3 h-3 rounded-sm bg-white border border-slate-300 inline-block"></span>예약 가능
                    </span>
                    <span class="flex items-center gap-1.5">
                        <span class="w-3 h-3 rounded-sm bg-blue-500 inline-block"></span>선택됨
                    </span>
                </div>
                <div id="selectionInfo" class="hidden mt-3 bg-slate-50 border border-slate-200 rounded-xl px-4 py-3 flex items-center justify-between">
                    <p class="text-sm font-semibold text-slate-700" id="selectionText"></p>
                </div>
            </div>

            <%-- 총 금액 --%>
            <div id="priceSection" class="hidden bg-blue-50 rounded-2xl px-5 py-4 flex justify-between items-center">
                <span class="text-sm font-semibold text-slate-600">예상 총 금액</span>
                <span class="text-2xl font-extrabold text-blue-600" id="totalPricePreview">-</span>
            </div>

            <%-- 메모 --%>
            <div>
                <label class="block text-sm font-semibold text-slate-700 mb-2">요청 메모 <span class="text-slate-400 font-normal">(선택)</span></label>
                <textarea id="resUserMemo" rows="2" placeholder="호스트에게 전달할 내용을 입력하세요."
                          class="w-full px-4 py-3 bg-slate-50 border border-slate-200 rounded-xl focus:bg-white focus:outline-none focus:ring-2 focus:ring-blue-500 transition-all resize-none text-slate-700 text-sm"></textarea>
            </div>

            <button type="submit" id="reserveSubmitBtn" disabled
                    class="w-full py-4 bg-blue-600 hover:bg-blue-700 disabled:bg-slate-200 disabled:text-slate-400 disabled:cursor-not-allowed text-white font-bold rounded-xl shadow-lg shadow-blue-200 disabled:shadow-none transition-all text-base">
                예약 신청하기
            </button>
        </form>
    </div>
</div>

<script>
    lucide.createIcons();

    // ── 예약 모달 JS ───────────────────────────────────────────────
    const SLOT_START = 8;
    const SLOT_END   = 22;
    let timelineBookedHours = new Set();
    let selStart = null;
    let selEnd   = null;
    let tlPricePerHour = 0;

    function getSpaceTypeLabel(spaceType) {
        switch (spaceType) {
            case 'shop':       return '상점';
            case 'warehouse':  return '창고';
            case 'studio':     return '스튜디오';
            case 'meeting':    return '회의실';
            case 'consulting': return '상담실';
            case 'office':     return '사무실';
            default:           return spaceType;
        }
    }

    function openReservationModalFromData(btn) {
        const spaceId     = btn.dataset.spaceId;
        const name        = btn.dataset.spaceName;
        const spaceType   = btn.dataset.spaceType;
        const address     = btn.dataset.spaceAddress;
        const pricePerHour = parseInt(btn.dataset.price) || 0;
        const capacity    = btn.dataset.capacity;

        document.getElementById('modalSpaceId').value            = spaceId;
        document.getElementById('modalSpaceType').textContent    = getSpaceTypeLabel(spaceType);
        document.getElementById('modalSpaceName').textContent    = name;
        document.getElementById('modalSpaceAddress').textContent = address;
        document.getElementById('modalPrice').textContent        = Number(pricePerHour).toLocaleString() + '원 / 시간';
        document.getElementById('modalCapacity').textContent     = capacity;

        const _d = new Date();
        const today = _d.getFullYear() + '-' + String(_d.getMonth()+1).padStart(2,'0') + '-' + String(_d.getDate()).padStart(2,'0');
        document.getElementById('resUseDate').value = today;
        document.getElementById('resUseDate').min   = today;
        document.getElementById('resUserMemo').value = '';

        resetTimelineState(false);
        document.getElementById('reservationModal').classList.remove('hidden');
        lucide.createIcons();
        loadTimeline();
    }

    function closeReservationModal() {
        document.getElementById('reservationModal').classList.add('hidden');
    }

    function closeModalOnBackdrop(e) {
        if (e.target === document.getElementById('reservationModal')) {
            closeReservationModal();
        }
    }

    function resetTimelineState(keepGrid) {
        selStart = null;
        selEnd   = null;
        document.getElementById('selectionInfo').classList.add('hidden');
        document.getElementById('priceSection').classList.add('hidden');
        document.getElementById('reserveSubmitBtn').disabled = true;
        document.getElementById('resetSelBtn').classList.add('hidden');
        if (!keepGrid) {
            document.getElementById('timelinePlaceholder').classList.remove('hidden');
            document.getElementById('timelineLoading').classList.add('hidden');
            document.getElementById('timelineGrid').classList.add('hidden');
            document.getElementById('timelineLegend').classList.add('hidden');
        }
    }

    function resetSelection() {
        selStart = null;
        selEnd   = null;
        document.getElementById('selectionInfo').classList.add('hidden');
        document.getElementById('priceSection').classList.add('hidden');
        document.getElementById('reserveSubmitBtn').disabled = true;
        document.getElementById('resetSelBtn').classList.add('hidden');
        renderTimelineGrid();
    }

    async function loadTimeline() {
        const spaceId = document.getElementById('modalSpaceId').value;
        const date    = document.getElementById('resUseDate').value;
        if (!date || !spaceId) return;

        selStart = null;
        selEnd   = null;

        document.getElementById('timelinePlaceholder').classList.add('hidden');
        document.getElementById('timelineLoading').classList.remove('hidden');
        document.getElementById('timelineGrid').classList.add('hidden');
        document.getElementById('timelineLegend').classList.add('hidden');
        document.getElementById('selectionInfo').classList.add('hidden');
        document.getElementById('priceSection').classList.add('hidden');
        document.getElementById('reserveSubmitBtn').disabled = true;
        document.getElementById('resetSelBtn').classList.add('hidden');

        try {
            const res  = await fetch('/api/spaces/' + spaceId + '/availability?date=' + date);
            const data = await res.json();

            tlPricePerHour = data.pricePerHour || 0;
            document.getElementById('modalPrice').textContent =
                Number(tlPricePerHour).toLocaleString() + '원 / 시간';

            timelineBookedHours = new Set();
            (data.bookedSlots || []).forEach(function(slot) {
                const s = parseInt(slot.startTime.split(':')[0]);
                const e = parseInt(slot.endTime.split(':')[0]);
                for (let h = s; h < e; h++) timelineBookedHours.add(h);
            });

            document.getElementById('timelineLoading').classList.add('hidden');
            document.getElementById('timelineGrid').classList.remove('hidden');
            document.getElementById('timelineLegend').classList.remove('hidden');
            renderTimelineGrid();
        } catch (err) {
            document.getElementById('timelineLoading').classList.add('hidden');
            document.getElementById('timelineGrid').innerHTML =
                '<p class="text-sm text-rose-500 text-center py-4">예약 현황을 불러오지 못했습니다.</p>';
            document.getElementById('timelineGrid').classList.remove('hidden');
        }
    }

    function renderTimelineGrid() {
        const grid = document.getElementById('timelineGrid');

        let headerHtml = '<div class="flex min-w-max gap-px">';
        for (let h = SLOT_START; h < SLOT_END; h++) {
            const displayH = h < 12 ? h : (h === 12 ? 12 : h - 12);
            const ampm     = (h === SLOT_START) ? '오전' : (h === 12 ? '오후' : '');
            headerHtml +=
                '<div class="flex-shrink-0 w-10 text-center">' +
                    '<p class="text-xs font-bold text-blue-400 h-4">' + ampm + '</p>' +
                    '<p class="text-xs font-semibold text-slate-500">' + displayH + '시</p>' +
                '</div>';
        }
        headerHtml += '</div>';

        let cellsHtml = '<div class="flex min-w-max gap-px mt-1">';
        for (let h = SLOT_START; h < SLOT_END; h++) {
            const booked      = timelineBookedHours.has(h);
            const inRange     = selStart !== null && selEnd !== null && h >= selStart && h < selEnd;
            const isOnlyStart = selStart !== null && selEnd === null && h === selStart;
            const isFirst     = inRange && h === selStart;
            const isLast      = inRange && h === selEnd - 1;

            let cls = 'flex-shrink-0 w-10 h-12 flex flex-col items-center justify-center text-xs font-medium transition-all select-none ';
            let inner = '';

            if (booked) {
                cls += 'bg-slate-200 text-slate-400 cursor-not-allowed';
                inner = '<span class="text-xs leading-none">마감</span>';
            } else if (isFirst || isLast) {
                const rounded = isFirst && isLast ? 'rounded-lg' : (isFirst ? 'rounded-l-xl' : 'rounded-r-xl');
                cls += 'bg-blue-600 text-white cursor-pointer ' + rounded;
            } else if (inRange) {
                cls += 'bg-blue-500 text-white cursor-pointer';
            } else if (isOnlyStart) {
                cls += 'bg-blue-600 text-white cursor-pointer rounded-xl ring-2 ring-blue-300';
            } else {
                cls += 'bg-white border border-slate-200 text-slate-400 hover:bg-blue-50 hover:border-blue-300 cursor-pointer';
            }

            const onclick = booked ? '' : 'onclick="handleCellClick(' + h + ')"';
            cellsHtml += '<div class="' + cls + '" ' + onclick + '>' + inner + '</div>';
        }
        cellsHtml += '</div>';

        grid.innerHTML = '<div class="overflow-x-auto pb-1">' + headerHtml + cellsHtml + '</div>';
        updateSelectionInfo();
    }

    function handleCellClick(h) {
        if (timelineBookedHours.has(h)) return;

        if (selStart === null || selEnd !== null) {
            selStart = h;
            selEnd   = null;
        } else if (h < selStart) {
            selStart = h;
            selEnd   = null;
        } else {
            let allFree = true;
            for (let i = selStart; i <= h; i++) {
                if (timelineBookedHours.has(i)) { allFree = false; break; }
            }
            if (allFree) {
                selEnd = h + 1;
            } else {
                selStart = h;
                selEnd   = null;
            }
        }
        renderTimelineGrid();
    }

    function updateSelectionInfo() {
        const info     = document.getElementById('selectionInfo');
        const text     = document.getElementById('selectionText');
        const priceSec = document.getElementById('priceSection');
        const preview  = document.getElementById('totalPricePreview');
        const btn      = document.getElementById('reserveSubmitBtn');
        const resetBtn = document.getElementById('resetSelBtn');

        if (selStart === null) {
            info.classList.add('hidden');
            priceSec.classList.add('hidden');
            btn.disabled = true;
            resetBtn.classList.add('hidden');
            return;
        }

        resetBtn.classList.remove('hidden');
        info.classList.remove('hidden');

        if (selEnd === null) {
            text.textContent = selStart + ':00 선택됨 — 종료 시간 셀을 클릭하세요';
            priceSec.classList.add('hidden');
            btn.disabled = true;
        } else {
            const hours = selEnd - selStart;
            text.textContent = selStart + ':00 ~ ' + selEnd + ':00  (' + hours + '시간)';
            preview.textContent = Number(hours * tlPricePerHour).toLocaleString() + '원';
            priceSec.classList.remove('hidden');
            btn.disabled = false;
        }
    }

    async function submitReservation(e) {
        e.preventDefault();

        if (selStart === null || selEnd === null) {
            alert('이용 시간을 선택해 주세요.');
            return;
        }

        const spaceId  = document.getElementById('modalSpaceId').value;
        const useDate  = document.getElementById('resUseDate').value;
        const userMemo = document.getElementById('resUserMemo').value;
        const btn      = document.getElementById('reserveSubmitBtn');

        const startTime = String(selStart).padStart(2, '0') + ':00';
        const endTime   = String(selEnd).padStart(2, '0')   + ':00';

        btn.disabled    = true;
        btn.textContent = '신청 중...';

        try {
            const params = new URLSearchParams({ useDate, startTime, endTime, userMemo });
            const res    = await fetch('/api/spaces/' + spaceId + '/reserve?' + params,
                                       { method: 'POST' });
            const data   = await res.json();

            if (data.success) {
                closeReservationModal();
                alert('예약이 신청되었습니다!\n' + startTime + ' ~ ' + endTime +
                      '\n총 금액: ' + Number(data.totalPrice).toLocaleString() + '원\n호스트 승인 후 확정됩니다.');
            } else {
                alert('예약 실패: ' + (data.error || '알 수 없는 오류'));
                loadTimeline();
            }
        } catch (err) {
            alert('서버 통신 오류가 발생했습니다.');
        } finally {
            btn.disabled    = false;
            btn.textContent = '예약 신청하기';
        }
    }
</script>

<%-- 자문요청 모달 --%>
<div id="searchRequestModal" class="fixed inset-0 z-[200] hidden items-center justify-center">
    <div class="absolute inset-0 bg-black/40 backdrop-blur-sm" onclick="closeSearchRequestModal()"></div>
    <div class="relative bg-white rounded-3xl shadow-2xl w-full max-w-lg mx-4 p-8 flex flex-col gap-5">
        <div class="flex justify-between items-center">
            <div>
                <h3 class="text-xl font-extrabold text-slate-900">자문요청 남기기</h3>
                <p id="searchModalExpertInfo" class="text-sm text-slate-500 mt-1"></p>
            </div>
            <button onclick="closeSearchRequestModal()" class="text-slate-400 hover:text-slate-600 transition-colors">
                <svg xmlns="http://www.w3.org/2000/svg" class="w-6 h-6" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path stroke-linecap="round" stroke-linejoin="round" d="M6 18L18 6M6 6l12 12"/></svg>
            </button>
        </div>
        <div class="flex flex-col gap-4">
            <div>
                <label class="block text-sm font-semibold text-slate-700 mb-1.5">자문 제목 <span class="text-red-500">*</span></label>
                <input type="text" id="searchModalTitle" maxlength="200" placeholder="예: 초기 스타트업 절세 방법 문의"
                       class="w-full px-4 py-3 border border-slate-200 rounded-xl text-sm focus:outline-none focus:ring-2 focus:ring-blue-100 focus:border-blue-400 transition-all">
            </div>
            <div>
                <label class="block text-sm font-semibold text-slate-700 mb-1.5">상세 내용</label>
                <textarea id="searchModalContent" rows="4" maxlength="1000" placeholder="고민하시는 내용을 자세히 적어주세요."
                          class="w-full px-4 py-3 border border-slate-200 rounded-xl text-sm focus:outline-none focus:ring-2 focus:ring-blue-100 focus:border-blue-400 transition-all resize-none"></textarea>
            </div>
        </div>
        <div id="searchModalError" class="hidden text-sm text-red-500 bg-red-50 border border-red-200 rounded-xl px-4 py-2.5"></div>
        <div class="flex gap-3 pt-1">
            <button onclick="closeSearchRequestModal()" class="flex-1 py-3 border border-slate-200 rounded-xl text-sm font-bold text-slate-600 hover:bg-slate-50 transition-colors">취소</button>
            <button id="searchModalSubmitBtn" onclick="submitSearchRequest()" class="flex-1 py-3 bg-blue-600 hover:bg-blue-700 text-white rounded-xl text-sm font-bold transition-colors shadow-sm">자문요청 보내기</button>
        </div>
    </div>
</div>

<script>
    let _searchExpertId   = null;
    let _searchExpertType = '';

    window.openSearchRequestModal = function (btn) {
        _searchExpertId   = btn.dataset.expertId;
        _searchExpertType = btn.dataset.expertType;
        const name   = btn.dataset.expertName;
        const office = btn.dataset.expertOffice;

        document.getElementById('searchModalExpertInfo').textContent =
            office + ' · ' + name + ' ' + _searchExpertType;
        document.getElementById('searchModalTitle').value   = '';
        document.getElementById('searchModalContent').value = '';
        document.getElementById('searchModalError').classList.add('hidden');

        const modal = document.getElementById('searchRequestModal');
        modal.classList.remove('hidden');
        modal.classList.add('flex');
        document.getElementById('searchModalTitle').focus();
    };

    window.closeSearchRequestModal = function () {
        const modal = document.getElementById('searchRequestModal');
        modal.classList.add('hidden');
        modal.classList.remove('flex');
    };

    window.submitSearchRequest = async function () {
        const title   = document.getElementById('searchModalTitle').value.trim();
        const content = document.getElementById('searchModalContent').value.trim();
        const errEl   = document.getElementById('searchModalError');
        const btn     = document.getElementById('searchModalSubmitBtn');

        if (!title) {
            errEl.textContent = '자문 제목을 입력해 주세요.';
            errEl.classList.remove('hidden');
            return;
        }

        btn.disabled    = true;
        btn.textContent = '전송 중...';
        errEl.classList.add('hidden');

        try {
            const params = new URLSearchParams();
            params.append('expertId',   _searchExpertId);
            params.append('expertType', _searchExpertType);
            params.append('title',      title);
            if (content) params.append('content', content);

            const res  = await fetch('/api/consulting/requests', { method: 'POST', body: params });
            const data = await res.json();

            if (data.error) {
                errEl.textContent = data.error;
                errEl.classList.remove('hidden');
            } else {
                closeSearchRequestModal();
                const toast = document.createElement('div');
                toast.className = 'fixed bottom-8 left-1/2 -translate-x-1/2 bg-slate-900 text-white text-sm font-semibold px-6 py-3 rounded-2xl shadow-xl z-[300]';
                toast.textContent = '자문요청이 성공적으로 전송되었습니다!';
                document.body.appendChild(toast);
                setTimeout(function () { toast.style.opacity = '0'; toast.style.transition = 'opacity 0.5s'; }, 2500);
                setTimeout(function () { toast.remove(); }, 3000);
            }
        } catch (e) {
            errEl.textContent = '요청 중 오류가 발생했습니다. 다시 시도해 주세요.';
            errEl.classList.remove('hidden');
        } finally {
            btn.disabled    = false;
            btn.textContent = '자문요청 보내기';
        }
    };
</script>

<script type="text/javascript"
        src="https://oapi.map.naver.com/openapi/v3/maps.js?ncpKeyId=${naverClientId}"></script>

<%-- 위치 보기 모달 --%>
<div id="searchMapModal" class="fixed inset-0 z-[200] hidden items-center justify-center">
    <div class="absolute inset-0 bg-black/40 backdrop-blur-sm" onclick="closeSearchMapModal()"></div>
    <div class="relative bg-white rounded-3xl shadow-2xl w-full max-w-2xl mx-4 flex flex-col" style="max-height:90vh;">
        <div class="flex justify-between items-start px-8 pt-7 pb-5 border-b border-slate-100 shrink-0">
            <div>
                <p id="searchMapModalType" class="text-xs font-black tracking-widest uppercase text-purple-600 mb-1"></p>
                <h3 id="searchMapModalTitle" class="text-xl font-extrabold text-slate-900"></h3>
            </div>
            <button onclick="closeSearchMapModal()" class="text-slate-400 hover:text-slate-600 transition-colors mt-1">
                <svg xmlns="http://www.w3.org/2000/svg" class="w-6 h-6" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path stroke-linecap="round" stroke-linejoin="round" d="M6 18L18 6M6 6l12 12"/></svg>
            </button>
        </div>
        <div id="searchMapModalInfo" class="px-8 py-3 shrink-0 text-sm text-slate-500 flex items-center gap-3">
            <span id="searchMapModalPhone"></span>
            <span id="searchMapModalAddress"></span>
        </div>
        <div id="searchModalNaverMap" style="width:100%;height:400px;border-radius:0 0 1.5rem 1.5rem;"></div>
        <div id="searchMapModalNoLocation" class="hidden flex flex-col items-center justify-center py-16 text-slate-400">
            <p class="text-base font-medium text-slate-500">위치 정보가 등록되지 않은 전문가입니다.</p>
            <p class="text-sm mt-1">전화 또는 주소로 직접 문의해 주세요.</p>
        </div>
    </div>
</div>

<script>
    var _searchMapInstance = null;

    window.openSearchMapModal = async function (btn) {
        var expertId     = btn.dataset.expertId;
        var expertType   = btn.dataset.expertType;
        var expertName   = btn.dataset.expertName;
        var expertOffice = btn.dataset.expertOffice;

        document.getElementById('searchMapModalType').textContent  = expertType;
        document.getElementById('searchMapModalTitle').textContent = expertOffice || expertName;
        document.getElementById('searchMapModalPhone').textContent   = '';
        document.getElementById('searchMapModalAddress').textContent = '';
        document.getElementById('searchModalNaverMap').style.display   = 'block';
        document.getElementById('searchMapModalNoLocation').classList.add('hidden');

        var modal = document.getElementById('searchMapModal');
        modal.classList.remove('hidden');
        modal.classList.add('flex');

        if (_searchMapInstance) {
            _searchMapInstance = null;
            document.getElementById('searchModalNaverMap').innerHTML = '';
        }

        try {
            var typeCodeMap = {'세무사':'tax','회계사':'accountant','노무사':'labor','변호사':'lawyer','변리사':'patent'};
            var typeCode = typeCodeMap[expertType] || 'tax';
            var res = await fetch('/experts/map/data?type=' + typeCode + '&id=' + expertId);
            if (!res.ok) throw new Error('status ' + res.status);
            var data = await res.json();

            if (data.phone)   document.getElementById('searchMapModalPhone').textContent   = data.phone;
            if (data.address) document.getElementById('searchMapModalAddress').textContent = data.address;

            if (!data.latitude || !data.longitude) {
                document.getElementById('searchModalNaverMap').style.display = 'none';
                document.getElementById('searchMapModalNoLocation').classList.remove('hidden');
                return;
            }

            var lat = parseFloat(data.latitude);
            var lng = parseFloat(data.longitude);
            _searchMapInstance = new naver.maps.Map('searchModalNaverMap', {
                center: new naver.maps.LatLng(lat, lng),
                zoom: 17
            });
            var marker = new naver.maps.Marker({
                position: new naver.maps.LatLng(lat, lng),
                map: _searchMapInstance
            });
            var phoneHtml = data.phone ? '<div style="font-size:12px;color:#64748b;margin-top:3px;">' + data.phone + '</div>' : '';
            var infowindow = new naver.maps.InfoWindow({
                content: '<div style="padding:12px 16px;font-family:sans-serif;min-width:160px">'
                    + '<div style="font-size:13px;font-weight:700;color:#1e293b;margin-bottom:3px;">' + (data.office || expertOffice) + '</div>'
                    + '<div style="font-size:12px;color:#64748b;">' + expertType + ' · ' + (data.name || expertName) + '</div>'
                    + phoneHtml
                    + '</div>',
                borderRadius: '12px'
            });
            infowindow.open(_searchMapInstance, marker);
        } catch (e) {
            console.error('[SearchMapModal] error:', e);
            document.getElementById('searchModalNaverMap').style.display = 'none';
            document.getElementById('searchMapModalNoLocation').classList.remove('hidden');
        }
    };

    window.closeSearchMapModal = function () {
        var modal = document.getElementById('searchMapModal');
        modal.classList.add('hidden');
        modal.classList.remove('flex');
        _searchMapInstance = null;
        document.getElementById('searchModalNaverMap').innerHTML = '';
    };
</script>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />