<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%-- 헤더 파일 로드 --%>
<jsp:include page="/WEB-INF/views/common/header.jsp" />

    <main class="flex-grow max-w-[1400px] mx-auto w-full px-4 sm:px-6 lg:px-8 py-12 flex flex-col gap-10 relative overflow-hidden">
        
        <div class="absolute top-[-5%] left-[-5%] w-96 h-96 bg-blue-400/15 rounded-full blur-3xl pointer-events-none"></div>

            <div class="mt-20 pt-20 border-t border-slate-200">
            <div class="text-center mb-16">
                <h2 class="text-3xl font-bold text-slate-900 mb-4">고객님에게 제공하는 가치</h2>
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
    </main>

    <jsp:include page="/WEB-INF/views/common/footer.jsp" />