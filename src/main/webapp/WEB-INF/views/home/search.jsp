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
            <div class="text-3xl font-bold text-slate-900">6개</div>
        </div>
    </div>

    <div class="grid grid-cols-1 xl:grid-cols-12 gap-10">
        <div class="xl:col-span-8 space-y-10">

            <section class="bg-white rounded-[2.5rem] border border-slate-100 shadow-[0_4px_20px_-4px_rgba(0,0,0,0.05)] overflow-hidden">
                <div class="p-8 sm:p-10 border-b border-slate-50">
                    <div class="flex items-center gap-3 mb-2">
                        <div class="w-8 h-8 bg-blue-100 rounded-lg flex items-center justify-center">
                            <i data-lucide="sparkles" class="w-4 h-4 text-blue-600"></i>
                        </div>
                        <h2 class="text-2xl font-bold text-slate-900 uppercase tracking-tight">1. 추천 지원 사업</h2>
                    </div>
                    <p class="text-slate-500">창업 단계와 지역 조건을 반영하여 활용 가능성이 높은 지원사업입니다.</p>
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
                    <div class="flex items-center gap-3 mb-2">
                        <div class="w-8 h-8 bg-emerald-100 rounded-lg flex items-center justify-center">
                            <i data-lucide="layout" class="w-4 h-4 text-emerald-600"></i>
                        </div>
                        <h2 class="text-2xl font-bold text-slate-900 tracking-tight">2. 추천 창업 공간 / 회의실</h2>
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
                                                            <a href="/space" class="text-blue-600 hover:bg-blue-50 px-3 py-1 rounded-lg text-sm font-bold transition-all">예약하기</a>
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
                    <h2 class="text-2xl font-bold text-slate-900 tracking-tight">3. 추천 컨설팅 기업 / 전문가</h2>
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
                                    <p class="text-slate-500 text-sm mb-6 leading-relaxed">${c.field} 전문</p>
                                    <div class="flex items-center justify-between">
                                        <span class="text-xs font-bold text-slate-400 underline decoration-slate-200 underline-offset-4">
                                            평점 ${c.rating}점 / 경력 ${c.experienceYears}년
                                        </span>
                                        <i data-lucide="arrow-right-circle" class="w-6 h-6 text-slate-300 group-hover:text-purple-500 transition-all"></i>
                                    </div>
                                </div>
                            </c:forEach>
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

<script>
    lucide.createIcons();
</script>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />