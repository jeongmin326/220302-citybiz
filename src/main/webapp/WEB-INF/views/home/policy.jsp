<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<%-- 헤더 파일 로드 --%>
<jsp:include page="/WEB-INF/views/common/header.jsp" />

<main class="flex-grow max-w-[1400px] mx-auto w-full px-4 sm:px-6 lg:px-8 py-12 flex flex-col gap-10 relative overflow-hidden">
    
    <div class="absolute top-[-5%] right-[-5%] w-96 h-96 bg-indigo-400/15 rounded-full blur-3xl pointer-events-none"></div>

    <section class="grid grid-cols-1 lg:grid-cols-3 gap-6 relative z-10">
        
        <%-- [AI/ML] 사용자 입력 폼 데이터를 받아 FastAPI에서 합격 확률 및 추천 정책 목록을 반환 --%>
        <button onclick="openAiDiagnosisModal()" class="lg:col-span-2 bg-gradient-to-r from-indigo-600 to-purple-600 rounded-3xl p-8 text-left relative overflow-hidden group shadow-md hover:shadow-xl transition-all duration-300 flex flex-col justify-center">
            <div class="relative z-10">
                <span class="bg-white/20 text-white text-xs font-bold px-3 py-1.5 rounded backdrop-blur-sm mb-4 inline-block tracking-wide">AI 자가진단</span>
                <h2 class="text-3xl font-extrabold text-white mb-3 tracking-tight">✨ 내 기업에 딱 맞는 정책지원금 찾기</h2>
                <p class="text-indigo-100 text-base font-light">업력, 매출액, 산업군만 입력하면 AI가 합격 가능성이 가장 높은 지원사업을 찾아드립니다.</p>
                <div class="mt-6 inline-flex items-center gap-2 bg-white text-indigo-600 px-5 py-2.5 rounded-xl font-bold text-sm shadow-sm group-hover:scale-105 transition-transform">
                    진단 시작하기 <i data-lucide="arrow-right" class="w-4 h-4"></i>
                </div>
            </div>
            <i data-lucide="cpu" class="absolute right-8 bottom-8 w-32 h-32 text-white opacity-20 group-hover:scale-110 transition-transform duration-500 transform rotate-12"></i>
        </button>

        <%-- [Backend] 가장 임박한 지원사업 마감일 데이터를 DB에서 가져와 렌더링 --%>
        <div class="bg-white border border-slate-100 rounded-3xl p-8 shadow-[0_4px_20px_-4px_rgba(0,0,0,0.05)] relative overflow-hidden flex flex-col">
            <div class="flex justify-between items-center mb-6">
                <h3 class="text-xl font-extrabold text-slate-900 flex items-center gap-2"><i data-lucide="calendar-clock" class="w-6 h-6 text-indigo-500"></i> 정책 마감 캘린더</h3>
                <a href="#calendar-full" class="text-sm text-slate-400 hover:text-indigo-600">전체보기</a>
            </div>
            <div class="flex flex-col gap-4 flex-grow">
                <div class="flex items-center gap-4 p-3 rounded-xl bg-rose-50 border border-rose-100">
                    <div class="text-center font-bold text-rose-600 flex flex-col leading-tight"><span class="text-xs font-medium">D-3</span><span>마감</span></div>
                    <div class="flex-grow"><p class="text-sm font-bold text-slate-800 truncate">2026 청년창업사관학교 모집</p></div>
                </div>
                <div class="flex items-center gap-4 p-3 rounded-xl hover:bg-slate-50 transition">
                    <div class="text-center font-bold text-slate-500 flex flex-col leading-tight"><span class="text-xs font-medium">D-12</span><span>진행</span></div>
                    <div class="flex-grow"><p class="text-sm font-bold text-slate-800 truncate">예비창업패키지 (일반분야)</p></div>
                </div>
            </div>
        </div>
    </section>

    <div class="flex flex-col md:flex-row gap-10 items-start relative z-10">
        
        <aside class="w-full md:w-[320px] flex-shrink-0 bg-white rounded-3xl border border-slate-100 p-8 sticky top-28 max-h-[calc(100vh-10rem)] overflow-y-auto shadow-[0_4px_20px_-4px_rgba(0,0,0,0.05)]">
            <div class="flex justify-between items-center mb-8 pb-4 border-b border-slate-100">
                <h3 class="font-extrabold text-lg flex items-center gap-2.5 text-slate-900"><i data-lucide="filter" class="w-5 h-5 text-indigo-500"></i> 맞춤 필터</h3>
                <button type="reset" form="policySearchForm" class="text-xs font-medium text-slate-400 hover:text-rose-500 underline">초기화</button>
            </div>

            <%-- [Backend/DB] 수정됨: policy_funds 스키마에 맞춘 동적 쿼리용 필터 폼 --%>
            <form id="policySearchForm" class="space-y-6">
                <div>
                    <label class="block text-sm font-semibold text-slate-700 mb-3">자금 구분</label>
                    <select name="category" class="w-full px-4 py-3 bg-slate-50 border border-slate-200 rounded-xl text-sm focus:ring-2 focus:ring-indigo-100 focus:border-indigo-300">
                        <option value="">전체 구분</option>
                        <option value="융자">융자</option>
                        <option value="보증">보증</option>
                        <option value="보험">보험</option>
                    </select>
                </div>

                <div>
                    <label class="block text-sm font-semibold text-slate-700 mb-3">운영 기관</label>
                    <input type="text" name="institution" placeholder="예: 기술보증기금, 중진공" class="w-full px-4 py-3 bg-slate-50 border border-slate-200 rounded-xl text-sm focus:ring-2 focus:ring-indigo-100 focus:border-indigo-300">
                </div>

                <div>
                    <label class="block text-sm font-semibold text-slate-700 mb-3">접수 상태</label>
                    <div class="flex flex-col gap-2">
                        <label class="flex items-center gap-2 text-sm text-slate-600"><input type="radio" name="application_available_yn" value="Y" class="accent-indigo-600" checked> 접수중 (Y)</label>
                        <label class="flex items-center gap-2 text-sm text-slate-600"><input type="radio" name="application_available_yn" value="N" class="accent-indigo-600"> 마감 (N)</label>
                        <label class="flex items-center gap-2 text-sm text-slate-600"><input type="radio" name="application_available_yn" value="" class="accent-indigo-600"> 상태 무관</label>
                    </div>
                </div>

                <div>
                    <label class="block text-sm font-semibold text-slate-700 mb-3">키워드 검색</label>
                    <input type="text" name="keyword" placeholder="해시태그, 자금명 검색" class="w-full px-4 py-3 bg-slate-50 border border-slate-200 rounded-xl text-sm focus:ring-2 focus:ring-indigo-100 focus:border-indigo-300">
                </div>

                <button type="button" onclick="searchPolicies()" class="w-full bg-slate-900 text-white font-bold py-3.5 rounded-xl hover:bg-slate-800 transition-all duration-300 mt-2 shadow-md hover:-translate-y-0.5">
                    조건 검색
                </button>
            </form>
        </aside>

        <div class="flex-grow flex flex-col gap-8 w-full">
            
            <div class="flex justify-between items-center px-4 py-3 bg-white rounded-2xl border border-slate-100 shadow-sm">
                <%-- [Backend] 검색 결과 카운트 --%>
                <p class="text-slate-600">총 <strong class="text-indigo-600 font-bold" id="policyCount">42</strong>건의 지원사업이 있습니다.</p>
                <div class="flex items-center gap-2 text-sm font-medium text-slate-600 cursor-pointer hover:text-indigo-600 transition">
                    마감임박순 <i data-lucide="chevron-down" class="w-4 h-4"></i>
                </div>
            </div>

            <div class="grid grid-cols-1 md:grid-cols-2 gap-6" id="policyListContainer">
                
                <a href="#" class="bg-white rounded-3xl p-6 border border-slate-100 shadow-[0_4px_20px_-4px_rgba(0,0,0,0.05)] hover:shadow-xl hover:-translate-y-1 transition-all group flex flex-col h-full">
                    <div class="flex justify-between items-start mb-4">
                        <div class="flex gap-2 flex-wrap">
                            <span class="px-2.5 py-1 bg-indigo-50 text-indigo-600 rounded-md text-xs font-bold border border-indigo-100">융자</span>
                            <span class="px-2.5 py-1 bg-slate-100 text-slate-600 rounded-md text-xs font-medium">청년전용</span>
                        </div>
                        <span class="px-3 py-1 bg-rose-50 text-rose-600 rounded-full text-xs font-bold border border-rose-100">접수중</span>
                    </div>
                    <h4 class="text-xl font-extrabold text-slate-900 mb-2 group-hover:text-indigo-600 transition line-clamp-2">2026년 청년전용창업자금</h4>
                    <p class="text-sm text-slate-500 mb-6 line-clamp-2 flex-grow">우수한 아이디어를 보유한 청년 창업자를 대상으로 시설자금 및 운전자금을 지원합니다.</p>
                    <div class="flex items-end justify-between border-t border-slate-100 pt-4">
                        <div>
                            <p class="text-xs text-slate-400 mb-1">운영 기관</p>
                            <p class="text-sm font-extrabold text-slate-900">중소벤처기업진흥공단</p>
                        </div>
                        <div class="w-10 h-10 rounded-full bg-indigo-50 flex items-center justify-center group-hover:bg-indigo-600 group-hover:text-white transition-colors">
                            <i data-lucide="arrow-right" class="w-5 h-5"></i>
                        </div>
                    </div>
                </a>

                <a href="#" class="bg-white rounded-3xl p-6 border border-slate-100 shadow-[0_4px_20px_-4px_rgba(0,0,0,0.05)] hover:shadow-xl hover:-translate-y-1 transition-all group flex flex-col h-full">
                    <div class="flex justify-between items-start mb-4">
                        <div class="flex gap-2 flex-wrap">
                            <span class="px-2.5 py-1 bg-emerald-50 text-emerald-600 rounded-md text-xs font-bold border border-emerald-100">보증</span>
                            <span class="px-2.5 py-1 bg-slate-100 text-slate-600 rounded-md text-xs font-medium">초기기업</span>
                        </div>
                        <span class="px-3 py-1 bg-slate-100 text-slate-600 rounded-full text-xs font-bold">상시모집</span>
                    </div>
                    <h4 class="text-xl font-extrabold text-slate-900 mb-2 group-hover:text-indigo-600 transition line-clamp-2">디딤돌 R&D 지원사업</h4>
                    <p class="text-sm text-slate-500 mb-6 line-clamp-2 flex-grow">기술력을 갖춘 초기 스타트업의 연구개발비를 지원하여 기술 고도화를 돕습니다.</p>
                    <div class="flex items-end justify-between border-t border-slate-100 pt-4">
                        <div>
                            <p class="text-xs text-slate-400 mb-1">운영 기관</p>
                            <p class="text-sm font-extrabold text-slate-900">기술보증기금</p>
                        </div>
                        <div class="w-10 h-10 rounded-full bg-slate-50 flex items-center justify-center group-hover:bg-indigo-600 group-hover:text-white transition-colors text-slate-400">
                            <i data-lucide="arrow-right" class="w-5 h-5"></i>
                        </div>
                    </div>
                </a>
            </div>

            <div class="grid grid-cols-1 sm:grid-cols-2 gap-4 mt-4">
                <a href="/docs" class="bg-slate-50 hover:bg-slate-100 border border-slate-200 rounded-2xl p-5 flex items-center gap-4 transition-colors group">
                    <div class="p-3 bg-white rounded-xl shadow-sm group-hover:text-indigo-600"><i data-lucide="file-text" class="w-6 h-6"></i></div>
                    <div>
                        <h4 class="font-bold text-slate-900">필수 서류 양식 모음</h4>
                        <p class="text-xs text-slate-500 mt-1">사업계획서, 재무제표 양식 다운로드</p>
                    </div>
                </a>
                <a href="/consulting" class="bg-slate-50 hover:bg-slate-100 border border-slate-200 rounded-2xl p-5 flex items-center gap-4 transition-colors group">
                    <div class="p-3 bg-white rounded-xl shadow-sm group-hover:text-purple-600"><i data-lucide="users" class="w-6 h-6"></i></div>
                    <div>
                        <h4 class="font-bold text-slate-900">정책 지원 컨설팅 연결</h4>
                        <p class="text-xs text-slate-500 mt-1">서류 작성이 어렵다면 전문가의 도움을 받으세요</p>
                    </div>
                </a>
            </div>

        </div>
    </div>
</main>

<script>
    // [AI/ML] AI 자가진단 모달 열기 및 FastAPI 연동용 함수
    function openAiDiagnosisModal() {
        alert('AI 자가진단 모달이 열립니다.\n(프론트에서 모달을 띄우고, 입력값을 FastAPI로 보내 합격 확률을 계산합니다.)');
        // 추후 로직 추가: 모달 오픈 -> 입력 폼 -> axios.post('http://ai-server/predict') -> 결과 화면 렌더링
    }

    // [Backend] Spring Boot API 통신하여 정책 리스트 필터링
    function searchPolicies() {
        const form = document.getElementById('policySearchForm');
        const formData = new FormData(form);
        const searchParams = Object.fromEntries(formData.entries());

        console.log('API로 전송될 검색 파라미터:', searchParams);
        
        /* * [백엔드 연동 로직 구현부]
         * Spring Boot의 @RestController 엔드포인트(예: /api/policies)로 GET 요청을 보냅니다.
         * MyBatis나 JPA(QueryDSL 등)를 사용하여 전달받은 파라미터(category, institution, application_available_yn, keyword)
         * 에 따라 동적 쿼리를 실행해 결과를 반환받아야 합니다.
         */
         
        // axios.get('/api/policies', { params: searchParams })
        //     .then(response => {
        //         // 1. response.data의 배열을 순회하며 HTML 문자열 생성
        //         // 2. document.getElementById('policyListContainer').innerHTML = 생성된HTML;
        //         // 3. document.getElementById('policyCount').innerText = response.data.length;
        //     })
        //     .catch(error => {
        //         console.error('검색 중 오류 발생:', error);
        //         alert('데이터를 불러오는데 실패했습니다.');
        //     });
    }
</script>

<%-- 푸터 파일 로드 --%>
<jsp:include page="/WEB-INF/views/common/footer.jsp" />