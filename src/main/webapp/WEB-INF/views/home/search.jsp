<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">

<jsp:include page="/WEB-INF/views/common/header.jsp" />

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>도시 비즈니스 자원 통합 검색 플랫폼 - 결과 페이지</title>
    
    <script src="https://cdn.tailwindcss.com"></script>
    <script src="https://unpkg.com/lucide@latest"></script>
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Pretendard:wght@300;400;500;600;700;800&display=swap');
        body { 
            font-family: 'Pretendard', sans-serif; 
            -webkit-font-smoothing: antialiased;
            -moz-osx-font-smoothing: grayscale;
        }
        .glass-card {
            background: rgba(255, 255, 255, 0.8);
            backdrop-filter: blur(12px);
            border: 1px solid rgba(255, 255, 255, 0.3);
        }
    </style>
</head>
<body class="bg-[#F8FAFC] flex flex-col min-h-screen text-slate-800 selection:bg-blue-100 selection:text-blue-900">

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
            <div class="text-3xl font-bold text-slate-900">12개</div>
        </div>
        
        <div class="group bg-white p-8 rounded-[2rem] border border-slate-100 shadow-[0_4px_20px_-4px_rgba(0,0,0,0.05)] hover:shadow-xl hover:-translate-y-1 transition-all duration-300">
            <div class="w-12 h-12 bg-emerald-50 rounded-2xl flex items-center justify-center mb-6 group-hover:bg-emerald-600 transition-colors">
                <i data-lucide="briefcase" class="w-6 h-6 text-emerald-600 group-hover:text-white"></i>
            </div>
            <div class="text-slate-400 text-sm font-semibold mb-1">지원사업</div>
            <div class="text-3xl font-bold text-slate-900">8건</div>
        </div>

        <div class="group bg-white p-8 rounded-[2rem] border border-slate-100 shadow-[0_4px_20px_-4px_rgba(0,0,0,0.05)] hover:shadow-xl hover:-translate-y-1 transition-all duration-300">
            <div class="w-12 h-12 bg-purple-50 rounded-2xl flex items-center justify-center mb-6 group-hover:bg-purple-600 transition-colors">
                <i data-lucide="users" class="w-6 h-6 text-purple-600 group-hover:text-white"></i>
            </div>
            <div class="text-slate-400 text-sm font-semibold mb-1">컨설팅 기업</div>
            <div class="text-3xl font-bold text-slate-900">15개</div>
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
                    <div class="group border border-slate-100 rounded-2xl p-6 hover:bg-slate-50 hover:border-blue-200 transition-all flex flex-col md:flex-row justify-between items-start md:items-center gap-6">
                        <div class="flex-grow">
                            <h3 class="text-lg font-bold text-slate-900 mb-2 group-hover:text-blue-600 transition-colors">초기창업패키지 지원사업</h3>
                            <p class="text-slate-500 text-sm leading-relaxed mb-4">예비창업자 및 초기창업기업 대상 사업화 자금, 멘토링, 교육 지원</p>
                            <div class="flex flex-wrap gap-2">
                                <span class="bg-blue-50 text-blue-600 px-3 py-1 rounded-lg text-xs font-bold">기관: 창업진흥원</span>
                                <span class="bg-slate-100 text-slate-600 px-3 py-1 rounded-lg text-xs font-bold">유형: 사업화 자금</span>
                            </div>
                        </div>
                        <button class="shrink-0 bg-slate-900 text-white px-6 py-3 rounded-xl text-sm font-bold hover:bg-blue-600 transition-all shadow-lg shadow-slate-200">상세보기</button>
                    </div>
                    <div class="group border border-slate-100 rounded-2xl p-6 hover:bg-slate-50 hover:border-blue-200 transition-all flex flex-col md:flex-row justify-between items-start md:items-center gap-6">
                        <div class="flex-grow">
                            <h3 class="text-lg font-bold text-slate-900 mb-2 group-hover:text-blue-600 transition-colors">중소기업 정책자금 지원</h3>
                            <p class="text-slate-500 text-sm leading-relaxed mb-4">창업기업 운영자금 및 시설자금 지원 프로그램</p>
                            <div class="flex flex-wrap gap-2">
                                <span class="bg-blue-50 text-blue-600 px-3 py-1 rounded-lg text-xs font-bold">기관: 중소벤처기업진흥공단</span>
                                <span class="bg-slate-100 text-slate-600 px-3 py-1 rounded-lg text-xs font-bold">유형: 정책자금</span>
                            </div>
                        </div>
                        <button class="shrink-0 border border-slate-200 text-slate-600 px-6 py-3 rounded-xl text-sm font-bold hover:bg-slate-50 transition-all">신청안내</button>
                    </div>
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
                                <tr class="hover:bg-slate-50 transition-colors">
                                    <td class="p-5 font-bold text-slate-900">성남 스타트업 라운지 A</td>
                                    <td class="p-5 text-slate-500 text-sm">성남시 분당구</td>
                                    <td class="p-5 text-slate-500 text-sm">10명</td>
                                    <td class="p-5"><span class="bg-emerald-50 text-emerald-600 px-2 py-1 rounded-md text-[11px] font-black tracking-tight">AVAILABLE</span></td>
                                    <td class="p-5 text-center"><button class="text-blue-600 hover:bg-blue-50 px-3 py-1 rounded-lg text-sm font-bold transition-all">예약하기</button></td>
                                </tr>
                                <tr class="hover:bg-slate-50 transition-colors">
                                    <td class="p-5 font-bold text-slate-900">판교 공유오피스 B</td>
                                    <td class="p-5 text-slate-500 text-sm">성남시 분당구</td>
                                    <td class="p-5 text-slate-500 text-sm">20명</td>
                                    <td class="p-5"><span class="bg-amber-50 text-amber-600 px-2 py-1 rounded-md text-[11px] font-black tracking-tight">WAITING</span></td>
                                    <td class="p-5 text-center"><button class="text-slate-400 px-3 py-1 text-sm font-bold" disabled>대기중</button></td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </section>

            <section class="bg-white rounded-[2.5rem] border border-slate-100 shadow-[0_4px_20px_-4px_rgba(0,0,0,0.05)] overflow-hidden">
                <div class="p-8 sm:p-10 border-b border-slate-50">
                    <h2 class="text-2xl font-bold text-slate-900 tracking-tight">3. 추천 컨설팅 기업 / 전문가</h2>
                </div>
                <div class="p-8 sm:p-10 grid grid-cols-1 md:grid-cols-2 gap-6">
                    <div class="p-6 rounded-2xl bg-slate-50 border border-slate-100 hover:border-purple-200 transition-all group">
                        <div class="text-purple-600 text-[10px] font-black tracking-widest uppercase mb-2">TAX & LAW</div>
                        <h4 class="text-lg font-bold text-slate-900 mb-2 group-hover:text-purple-600 transition-colors">세무 전략 파트너스</h4>
                        <p class="text-slate-500 text-sm mb-6 leading-relaxed">스타트업 세무 신고, 정부지원금 정산 전문</p>
                        <div class="flex items-center justify-between">
                            <span class="text-xs font-bold text-slate-400 underline decoration-slate-200 underline-offset-4">매출액: 12억 원</span>
                            <i data-lucide="arrow-right-circle" class="w-6 h-6 text-slate-300 group-hover:text-purple-500 transition-all"></i>
                        </div>
                    </div>
                    <div class="p-6 rounded-2xl bg-slate-50 border border-slate-100 hover:border-purple-200 transition-all group">
                        <div class="text-purple-600 text-[10px] font-black tracking-widest uppercase mb-2">BUSINESS STRATEGY</div>
                        <h4 class="text-lg font-bold text-slate-900 mb-2 group-hover:text-purple-600 transition-colors">AI 성장전략 연구소</h4>
                        <p class="text-slate-500 text-sm mb-6 leading-relaxed">시장 분석, BM 설계, 데이터 전략 컨설팅</p>
                        <div class="flex items-center justify-between">
                            <span class="text-xs font-bold text-slate-400 underline decoration-slate-200 underline-offset-4">매출액: 25억 원</span>
                            <i data-lucide="arrow-right-circle" class="w-6 h-6 text-slate-300 group-hover:text-purple-500 transition-all"></i>
                        </div>
                    </div>
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

            <div class="bg-slate-900 p-8 rounded-[2.5rem] shadow-xl text-white">
                <h3 class="text-xl font-bold mb-6 flex items-center gap-2">
                    <i data-lucide="bar-chart-3" class="w-5 h-5 text-blue-400"></i>
                    6. 서비스 요약
                </h3>
                <div class="space-y-4">
                    <div class="flex justify-between items-center py-3 border-b border-white/10">
                        <span class="text-white/60 text-sm">공간 예약 건수</span>
                        <span class="font-bold text-blue-400">27건</span>
                    </div>
                    <div class="flex justify-between items-center py-3 border-b border-white/10">
                        <span class="text-white/60 text-sm">컨설팅 예약 건수</span>
                        <span class="font-bold text-blue-400">14건</span>
                    </div>
                    <div class="flex justify-between items-center py-3">
                        <span class="text-white/60 text-sm">전문가 연결 진행</span>
                        <span class="font-bold text-blue-400">9건</span>
                    </div>
                </div>
            </div>

            <div class="bg-blue-600 p-8 rounded-[2.5rem] shadow-xl shadow-blue-200 text-white relative overflow-hidden group">
                <i data-lucide="cpu" class="absolute -right-4 -bottom-4 w-32 h-32 text-white/10 rotate-12 group-hover:scale-110 transition-transform"></i>
                <h3 class="text-xl font-bold mb-4 relative z-10">7. AI 추천 근거</h3>
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

    <div class="mt-20 pt-20 border-t border-slate-200">
        <div class="text-center mb-16">
            <h2 class="text-3xl font-bold text-slate-900 mb-4">8. 고객님에게 제공하는 가치</h2>
            <p class="text-slate-500">더 나은 비즈니스 환경을 위한 플랫폼의 약속입니다.</p>
        </div>
        <div class="grid grid-cols-1 md:grid-cols-3 gap-8 text-center">
            <div class="p-10 bg-white rounded-[2.5rem] shadow-sm border border-slate-50">
                <div class="w-16 h-16 bg-blue-50 rounded-2xl flex items-center justify-center mx-auto mb-6">
                    <i data-lucide="zap" class="w-8 h-8 text-blue-600"></i>
                </div>
                <h4 class="text-xl font-bold text-slate-900 mb-4">빠른 자원 탐색</h4>
                <p class="text-slate-500 text-sm leading-relaxed">분산된 정보를 한곳에서 통합하여<br>비즈니스 효율을 극대화합니다.</p>
            </div>
            <div class="p-10 bg-white rounded-[2.5rem] shadow-sm border border-slate-50">
                <div class="w-16 h-16 bg-emerald-50 rounded-2xl flex items-center justify-center mx-auto mb-6">
                    <i data-lucide="target" class="w-8 h-8 text-emerald-600"></i>
                </div>
                <h4 class="text-xl font-bold text-slate-900 mb-4">맞춤형 추천</h4>
                <p class="text-slate-500 text-sm leading-relaxed">데이터 기반 AI 알고리즘으로<br>최적의 파트너와 공간을 매칭합니다.</p>
            </div>
            <div class="p-10 bg-white rounded-[2.5rem] shadow-sm border border-slate-50">
                <div class="w-16 h-16 bg-purple-50 rounded-2xl flex items-center justify-center mx-auto mb-6">
                    <i data-lucide="trending-up" class="w-8 h-8 text-purple-600"></i>
                </div>
                <h4 class="text-xl font-bold text-slate-900 mb-4">이용 효율 향상</h4>
                <p class="text-slate-500 text-sm leading-relaxed">혼잡도 예측 정보를 통해<br>도시 인프라 활용 효율을 높입니다.</p>
            </div>
        </div>
    </div>

</div>

<script>
    // 아이콘 로드
    lucide.createIcons();
</script>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />

</body>
</html>