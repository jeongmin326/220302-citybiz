<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<%-- 헤더 파일 로드 --%>
<jsp:include page="/WEB-INF/views/common/header.jsp" />

<main class="w-full relative overflow-hidden px-4 sm:px-6 lg:px-8 py-12 flex flex-col justify-center min-h-[calc(100vh-14rem)]">
    
    <div class="absolute top-[-10%] left-[-5%] w-[40rem] h-[40rem] bg-blue-400/10 rounded-full blur-3xl pointer-events-none"></div>
    <div class="absolute bottom-[-10%] right-[-5%] w-[40rem] h-[40rem] bg-purple-400/10 rounded-full blur-3xl pointer-events-none"></div>

    <section class="max-w-6xl mx-auto w-full relative z-10">
        
        <div class="text-center mb-12">
            <h1 class="text-4xl md:text-5xl font-extrabold text-slate-900 tracking-tight mb-4">회원가입</h1>
            <p class="text-lg text-slate-500" id="subtitle">CityBiz 플랫폼에서 활동하실 역할을 선택해주세요.</p>
        </div>

        <div id="roleSelectionSection" class="grid grid-cols-1 md:grid-cols-3 gap-8">
            <button onclick="selectRole('USER')" class="flex flex-col items-center text-center p-10 border border-slate-200/60 rounded-[2rem] hover:border-blue-500 hover:bg-white hover:-translate-y-2 transition-all duration-300 group bg-white/80 backdrop-blur-sm shadow-sm hover:shadow-xl">
                <div class="w-20 h-20 rounded-2xl bg-slate-50 flex items-center justify-center group-hover:bg-blue-600 group-hover:text-white text-slate-400 transition-all mb-6">
                    <i data-lucide="building" class="w-10 h-10"></i>
                </div>
                <h3 class="text-2xl font-bold text-slate-900 mb-2">일반 사용자</h3>
                <p class="text-sm font-semibold text-blue-600 mb-3">창업기업 / 예비창업자</p>
                <p class="text-slate-500 text-sm break-keep">공간 예약 및 AI 맞춤형<br>지원사업 추천을 원하는 분</p>
            </button>
            
            <button onclick="selectRole('PROVIDER')" class="flex flex-col items-center text-center p-10 border border-slate-200/60 rounded-[2rem] hover:border-indigo-500 hover:bg-white hover:-translate-y-2 transition-all duration-300 group bg-white/80 backdrop-blur-sm shadow-sm hover:shadow-xl">
                <div class="w-20 h-20 rounded-2xl bg-slate-50 flex items-center justify-center group-hover:bg-indigo-600 group-hover:text-white text-slate-400 transition-all mb-6">
                    <i data-lucide="map-pin" class="w-10 h-10"></i>
                </div>
                <h3 class="text-2xl font-bold text-slate-900 mb-2">자원 공급자</h3>
                <p class="text-sm font-semibold text-indigo-600 mb-3">공간 관리자</p>
                <p class="text-slate-500 text-sm break-keep">회의실, 오피스 등 비즈니스<br>자원을 등록하고 관리하실 분</p>
            </button>

            <button onclick="selectRole('EXPERT')" class="flex flex-col items-center text-center p-10 border border-slate-200/60 rounded-[2rem] hover:border-purple-500 hover:bg-white hover:-translate-y-2 transition-all duration-300 group bg-white/80 backdrop-blur-sm shadow-sm hover:shadow-xl">
                <div class="w-20 h-20 rounded-2xl bg-slate-50 flex items-center justify-center group-hover:bg-purple-600 group-hover:text-white text-slate-400 transition-all mb-6">
                    <i data-lucide="briefcase" class="w-10 h-10"></i>
                </div>
                <h3 class="text-2xl font-bold text-slate-900 mb-2">전문가</h3>
                <p class="text-sm font-semibold text-purple-600 mb-3">컨설턴트</p>
                <p class="text-slate-500 text-sm break-keep">창업 기업에게 전문 지식과<br>컨설팅을 제공하실 분</p>
            </button>
        </div>

        <form id="signupForm" class="hidden max-w-4xl mx-auto bg-white/90 backdrop-blur-md p-8 md:p-12 rounded-[2.5rem] shadow-2xl border border-slate-100" onsubmit="handleSignup(event)">
            <input type="hidden" id="userRole" name="userRole" value="">

            <div class="grid grid-cols-1 lg:grid-cols-2 gap-12">
                
                <div class="space-y-6">
                    <h2 class="text-xl font-bold text-slate-900 flex items-center gap-2 mb-6">
                        <span class="w-8 h-8 rounded-lg bg-blue-100 text-blue-600 flex items-center justify-center text-sm">1</span>
                        계정 및 담당자 정보
                    </h2>
                    
                    <div>
                        <label class="block text-sm font-bold text-slate-700 mb-2">아이디 (이메일)</label>
                        <div class="flex gap-2">
                            <input type="email" id="userId" required class="flex-grow px-4 py-3 bg-slate-50 border border-slate-200 rounded-xl focus:ring-2 focus:ring-blue-500 outline-none transition-all" placeholder="example@email.com">
                            <button type="button" class="px-4 py-3 bg-slate-800 text-white text-xs font-bold rounded-xl whitespace-nowrap">중복 확인</button>
                        </div>
                    </div>

                    <div>
                        <label class="block text-sm font-bold text-slate-700 mb-2">비밀번호</label>
                        <input type="password" id="password" required class="w-full px-4 py-3 bg-slate-50 border border-slate-200 rounded-xl focus:ring-2 focus:ring-blue-500 outline-none transition-all" placeholder="8자 이상 입력">
                    </div>

                    <div>
                        <label class="block text-sm font-bold text-slate-700 mb-2">담당자 이름 (실명)</label>
                        <input type="text" id="userName" required class="w-full px-4 py-3 bg-slate-50 border border-slate-200 rounded-xl focus:ring-2 focus:ring-blue-500 outline-none transition-all" placeholder="성함을 입력해주세요">
                    </div>

                    <div>
                        <label class="block text-sm font-bold text-slate-700 mb-2">휴대폰 번호</label>
                        <div class="flex gap-2">
                            <input type="tel" id="userPhone" required class="flex-grow px-4 py-3 bg-slate-50 border border-slate-200 rounded-xl focus:ring-2 focus:ring-blue-500 outline-none transition-all" placeholder="010-0000-0000">
                            <button type="button" onclick="alert('인증번호가 발송되었습니다.')" class="px-4 py-3 bg-blue-600 text-white text-xs font-bold rounded-xl whitespace-nowrap">본인 인증</button>
                        </div>
                    </div>
                </div>

                <div class="space-y-6 border-t lg:border-t-0 lg:border-l border-slate-100 pt-8 lg:pt-0 lg:pl-12">
                    <h2 class="text-xl font-bold text-slate-900 flex items-center gap-2 mb-6">
                        <span class="w-8 h-8 rounded-lg bg-green-100 text-green-600 flex items-center justify-center text-sm">2</span>
                        기업 및 프로젝트 정보
                    </h2>
                    <div id="dynamicFields" class="space-y-6">
                        </div>
                </div>
            </div>

            <div class="flex flex-col sm:flex-row gap-4 pt-12 mt-8 border-t border-slate-100">
                <button type="button" onclick="goBack()" class="w-full sm:w-1/3 py-4 text-slate-500 font-bold hover:bg-slate-50 rounded-2xl transition-all">이전으로</button>
                <button type="submit" class="w-full sm:w-2/3 py-4 bg-slate-900 text-white font-bold rounded-2xl shadow-lg hover:bg-slate-800 transform hover:-translate-y-1 transition-all">가입 완료하기</button>
            </div>
        </form>
    </section>
</main>

<script>
    if (window.lucide) { lucide.createIcons(); }

    const roleSelectionSection = document.getElementById('roleSelectionSection');
    const signupForm = document.getElementById('signupForm');
    const dynamicFields = document.getElementById('dynamicFields');
    const subtitle = document.getElementById('subtitle');

    function selectRole(role) {
        document.getElementById('userRole').value = role;
        roleSelectionSection.classList.add('hidden');
        signupForm.classList.remove('hidden');
        signupForm.classList.add('animate-[fadeIn_0.5s_ease-out]');
        
        let html = '';
        if (role === 'USER') {
            subtitle.innerText = "스타트업 성장을 위한 기업 정보를 입력해주세요.";
            html = `
                <div>
                    <label class="block text-sm font-bold text-slate-700 mb-2">기업명 (또는 팀명)</label>
                    <input type="text" id="companyName" required class="w-full px-4 py-3 bg-slate-50 border border-slate-200 rounded-xl focus:ring-2 focus:ring-blue-500 outline-none" placeholder="회사 이름을 입력해주세요">
                </div>
                <div>
                    <label class="block text-sm font-bold text-slate-700 mb-2">사업자 등록번호</label>
                    <div class="flex gap-2">
                        <input type="text" id="bizNo" class="flex-grow px-4 py-3 bg-slate-50 border border-slate-200 rounded-xl focus:ring-2 focus:ring-blue-500 outline-none" placeholder="000-00-00000">
                        <button type="button" onclick="alert('정상적인 사업자입니다.')" class="px-4 py-3 bg-slate-800 text-white text-xs font-bold rounded-xl whitespace-nowrap">진위 확인</button>
                    </div>
                    <p class="text-[10px] text-slate-400 mt-1">* 예비창업자는 입력하지 않아도 됩니다.</p>
                </div>
                <div>
                    <label class="block text-sm font-bold text-slate-700 mb-2">창업 단계</label>
                    <select id="stage" class="w-full px-4 py-3 bg-slate-50 border border-slate-200 rounded-xl outline-none focus:ring-2 focus:ring-blue-500">
                        <option value="PRE">예비 창업자</option>
                        <option value="EARLY">초기 창업 (3년 이내)</option>
                        <option value="GROWTH">도약기 창업 (3~7년)</option>
                    </select>
                </div>
                <div>
                    <label class="block text-sm font-bold text-slate-700 mb-2">주요 관심 분야</label>
                    <select id="industry" class="w-full px-4 py-3 bg-slate-50 border border-slate-200 rounded-xl outline-none focus:ring-2 focus:ring-blue-500">
                        <option value="IT">IT / 소프트웨어</option>
                        <option value="BIO">바이오 / 헬스케어</option>
                        <option value="EDU">교육 / 서비스</option>
                        <option value="MFG">제조 / 하드웨어</option>
                    </select>
                </div>
            `;
        } else {
            // PROVIDER, EXPERT용 로직은 이전과 비슷하게 구성 (생략)
            html = `<p class='text-slate-400 pt-10 text-center'>해당 역할에 맞는 필드를 준비 중입니다.</p>`;
        }
        dynamicFields.innerHTML = html;
    }

    function goBack() {
        signupForm.classList.add('hidden');
        roleSelectionSection.classList.remove('hidden');
        subtitle.innerText = "CityBiz 플랫폼에서 활동하실 역할을 선택해주세요.";
    }

    async function handleSignup(e) {
        e.preventDefault();
        alert('회원가입이 완료되었습니다! 메인 페이지로 이동합니다.');
        location.href = "/main.jsp";
    }
</script>

<style>
    @keyframes fadeIn { from { opacity: 0; transform: translateY(20px); } to { opacity: 1; transform: translateY(0); } }
</style>

<%-- 푸터 로드 --%>
<jsp:include page="/WEB-INF/views/common/footer.jsp" />