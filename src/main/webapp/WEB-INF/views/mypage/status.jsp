<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>내 활동 내역 - City Biz Hub</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script src="https://unpkg.com/lucide@latest"></script>
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Pretendard:wght@300;400;500;600;700;800&display=swap');
        body { 
            font-family: 'Pretendard', sans-serif; 
            -webkit-font-smoothing: antialiased;
        }
    </style>
</head>
<body class="bg-[#F8FAFC] flex flex-col min-h-screen text-slate-800">

    <%-- 1. 헤더 불러오기 (경로는 프로젝트 실제 구조에 맞게 수정해 주세요) --%>
    <jsp:include page="../common/header.jsp" />
    
    <%-- 2. 메인 컨텐츠 영역 --%>
    <main class="flex-grow max-w-7xl mx-auto w-full px-4 sm:px-6 lg:px-8 py-10">
        
        <%-- 상단 헤더 영역 --%>
        <div class="mb-10">
            <h1 class="text-3xl font-bold text-slate-900 tracking-tight">내 활동 내역</h1>
            <p class="text-slate-500 mt-2">${not empty sessionScope.loginName ? sessionScope.loginName : '사용자'}님의 비즈니스 활동 현황입니다.</p>
        </div>

        <%-- 1. 대시보드 요약 (Overview) --%>
        <div class="grid grid-cols-1 md:grid-cols-3 gap-6 mb-12">
            <div class="bg-white rounded-2xl p-6 border border-slate-200 shadow-sm flex items-center gap-5">
                <div class="w-14 h-14 rounded-full bg-blue-50 flex items-center justify-center text-blue-600">
                    <i data-lucide="calendar-check" class="w-7 h-7"></i>
                </div>
                <div>
                    <p class="text-sm font-medium text-slate-500">다가오는 예약</p>
                    <p class="text-2xl font-bold text-slate-900 mt-1">2<span class="text-base font-medium text-slate-500 ml-1">건</span></p>
                </div>
            </div>
            <div class="bg-white rounded-2xl p-6 border border-slate-200 shadow-sm flex items-center gap-5">
                <div class="w-14 h-14 rounded-full bg-indigo-50 flex items-center justify-center text-indigo-600">
                    <i data-lucide="bookmark" class="w-7 h-7"></i>
                </div>
                <div>
                    <p class="text-sm font-medium text-slate-500">스크랩한 정책</p>
                    <p class="text-2xl font-bold text-slate-900 mt-1">5<span class="text-base font-medium text-slate-500 ml-1">건</span></p>
                </div>
            </div>
            <div class="bg-white rounded-2xl p-6 border border-slate-200 shadow-sm flex items-center gap-5">
                <div class="w-14 h-14 rounded-full bg-purple-50 flex items-center justify-center text-purple-600">
                    <i data-lucide="message-square" class="w-7 h-7"></i>
                </div>
                <div>
                    <p class="text-sm font-medium text-slate-500">진행 중인 컨설팅</p>
                    <p class="text-2xl font-bold text-slate-900 mt-1">1<span class="text-base font-medium text-slate-500 ml-1">건</span></p>
                </div>
            </div>
        </div>

        <div class="grid grid-cols-1 lg:grid-cols-3 gap-8">
            
            <%-- 좌측 및 중앙 컨텐츠 영역 --%>
            <div class="lg:col-span-2 space-y-8">
                
                <%-- 2. 공간 대여 이용 내역 --%>
                <section class="bg-white rounded-2xl border border-slate-200 shadow-sm overflow-hidden">
                    <div class="px-6 py-5 border-b border-slate-100 flex justify-between items-center bg-slate-50/50">
                        <h2 class="text-lg font-bold text-slate-900 flex items-center gap-2">
                            <i data-lucide="map-pin" class="w-5 h-5 text-blue-500"></i> 공간 대여 내역
                        </h2>
                        <a href="/space" class="text-sm font-medium text-blue-600 hover:underline">더보기</a>
                    </div>
                    <div class="p-6 space-y-4">
                        <div class="flex items-center justify-between p-4 rounded-xl border border-slate-100 hover:border-blue-100 hover:bg-blue-50/30 transition-colors">
                            <div class="flex gap-4 items-center">
                                <div class="w-16 h-16 rounded-lg bg-slate-200 bg-[url('https://images.unsplash.com/photo-1497366216548-37526070297c?auto=format&fit=crop&q=80&w=200')] bg-cover bg-center"></div>
                                <div>
                                    <span class="inline-block px-2 py-1 bg-blue-100 text-blue-700 text-xs font-bold rounded mb-1">예약 확정</span>
                                    <h3 class="font-bold text-slate-900">스타트업 라운지 강남점 (4인 회의실)</h3>
                                    <p class="text-sm text-slate-500 mt-0.5">2026. 04. 15 (수) 14:00 - 16:00</p>
                                </div>
                            </div>
                            <button class="px-4 py-2 text-sm font-medium text-slate-600 border border-slate-200 rounded-lg hover:bg-slate-50">상세 보기</button>
                        </div>
                    </div>
                </section>

                <%-- 3. 맞춤 정책 지원 스크랩 --%>
                <section class="bg-white rounded-2xl border border-slate-200 shadow-sm overflow-hidden">
                    <div class="px-6 py-5 border-b border-slate-100 flex justify-between items-center bg-slate-50/50">
                        <h2 class="text-lg font-bold text-slate-900 flex items-center gap-2">
                            <i data-lucide="pie-chart" class="w-5 h-5 text-indigo-500"></i> 관심 정책 목록
                        </h2>
                        <a href="/policy" class="text-sm font-medium text-indigo-600 hover:underline">더보기</a>
                    </div>
                    <div class="p-6 space-y-4">
                        <div class="flex justify-between items-center border-b border-slate-100 pb-4 last:border-0 last:pb-0">
                            <div>
                                <div class="flex items-center gap-2 mb-1">
                                    <span class="text-xs font-bold px-2 py-0.5 bg-rose-100 text-rose-600 rounded">D-5</span>
                                    <span class="text-xs text-slate-500">중소벤처기업부</span>
                                </div>
                                <h3 class="font-bold text-slate-900 hover:text-indigo-600 cursor-pointer">2026년 청년창업사관학교 입교생 모집</h3>
                            </div>
                            <button class="text-slate-400 hover:text-rose-500 transition-colors"><i data-lucide="heart" class="w-5 h-5 fill-rose-500 text-rose-500"></i></button>
                        </div>
                        <div class="flex justify-between items-center border-b border-slate-100 pb-4 last:border-0 last:pb-0">
                            <div>
                                <div class="flex items-center gap-2 mb-1">
                                    <span class="text-xs font-bold px-2 py-0.5 bg-slate-100 text-slate-600 rounded">상시</span>
                                    <span class="text-xs text-slate-500">기술보증기금</span>
                                </div>
                                <h3 class="font-bold text-slate-900 hover:text-indigo-600 cursor-pointer">예비창업자 사전보증 제도</h3>
                            </div>
                            <button class="text-slate-400 hover:text-rose-500 transition-colors"><i data-lucide="heart" class="w-5 h-5 fill-rose-500 text-rose-500"></i></button>
                        </div>
                    </div>
                </section>

                <%-- 4. 컨설팅 진행 현황 --%>
                <section class="bg-white rounded-2xl border border-slate-200 shadow-sm overflow-hidden">
                    <div class="px-6 py-5 border-b border-slate-100 flex justify-between items-center bg-slate-50/50">
                        <h2 class="text-lg font-bold text-slate-900 flex items-center gap-2">
                            <i data-lucide="network" class="w-5 h-5 text-purple-500"></i> 컨설팅 진행 현황
                        </h2>
                        <a href="/consulting" class="text-sm font-medium text-purple-600 hover:underline">새 문의하기</a>
                    </div>
                    <div class="p-6 space-y-4">
                        <div class="flex items-center justify-between p-4 rounded-xl border border-slate-100 bg-slate-50">
                            <div>
                                <div class="flex items-center gap-2 mb-1">
                                    <span class="inline-block px-2 py-1 bg-purple-100 text-purple-700 text-xs font-bold rounded">답변 대기</span>
                                    <span class="text-xs text-slate-500">김세무 전문가</span>
                                </div>
                                <h3 class="font-medium text-slate-900">법인 설립 시 초기 세무 기장 관련 문의드립니다.</h3>
                                <p class="text-xs text-slate-400 mt-1">작성일: 2026.04.05</p>
                            </div>
                            <button class="text-sm text-slate-500 hover:text-slate-900 underline underline-offset-2">내용 보기</button>
                        </div>
                    </div>
                </section>

            </div>

            <%-- 우측 사이드바 영역 (프로필 관리) --%>
            <div class="lg:col-span-1">
                <%-- 5. 비즈니스 프로필 관리 --%>
                <section class="bg-slate-900 rounded-2xl shadow-lg overflow-hidden sticky top-28">
                    <div class="px-6 py-5 border-b border-slate-700 flex items-center justify-between">
                        <h2 class="text-lg font-bold text-white flex items-center gap-2">
                            <i data-lucide="settings" class="w-5 h-5 text-slate-400"></i> 맞춤 추천 설정
                        </h2>
                    </div>
                    <div class="p-6">
                        <p class="text-sm text-slate-400 mb-6 leading-relaxed">
                            아래 비즈니스 정보를 최신 상태로 유지하시면, 기업 조건에 맞는 <strong>지원 사업과 전문가를 더 정확하게 추천</strong>해 드립니다.
                        </p>
                        
                        <form action="/mypage/updateProfile" method="POST" class="space-y-4">
                            <div>
                                <label class="block text-xs font-medium text-slate-400 mb-1">기업명 (또는 예비창업팀명)</label>
                                <input type="text" value="시티비즈팀" class="w-full bg-slate-800 border border-slate-700 rounded-lg px-3 py-2.5 text-white text-sm focus:outline-none focus:border-blue-500 focus:ring-1 focus:ring-blue-500 transition-all">
                            </div>
                            <div>
                                <label class="block text-xs font-medium text-slate-400 mb-1">창업 단계</label>
                                <select class="w-full bg-slate-800 border border-slate-700 rounded-lg px-3 py-2.5 text-white text-sm focus:outline-none focus:border-blue-500 focus:ring-1 focus:ring-blue-500 transition-all">
                                    <option value="pre">예비 창업자</option>
                                    <option value="early" selected>초기 창업 (3년 미만)</option>
                                    <option value="jump">도약기 (3~7년)</option>
                                </select>
                            </div>
                            <div>
                                <label class="block text-xs font-medium text-slate-400 mb-1">관심 산업군</label>
                                <select class="w-full bg-slate-800 border border-slate-700 rounded-lg px-3 py-2.5 text-white text-sm focus:outline-none focus:border-blue-500 focus:ring-1 focus:ring-blue-500 transition-all">
                                    <option value="it" selected>IT / 소프트웨어</option>
                                    <option value="manu">제조업</option>
                                    <option value="service">서비스업</option>
                                </select>
                            </div>
                            <button type="button" class="w-full mt-2 bg-blue-600 hover:bg-blue-700 text-white font-bold py-3 rounded-lg text-sm transition-colors shadow-lg shadow-blue-900/50">
                                정보 업데이트
                            </button>
                        </form>
                    </div>
                </section>
            </div>

        </div>
    </main>

    <%-- 3. 푸터 불러오기 (경로는 프로젝트 실제 구조에 맞게 수정해 주세요) --%>
    <jsp:include page="../common/footer.jsp" />

    <script>
        // 루사이드 아이콘 초기화
        lucide.createIcons();
    </script>
</body>
</html>