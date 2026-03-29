<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<%-- 헤더 파일 로드 --%>
<jsp:include page="/WEB-INF/views/common/header.jsp" />

<main class="flex-grow w-full px-4 sm:px-6 lg:px-8 py-20 flex flex-col justify-center relative overflow-hidden min-h-[85vh]">
    
    <div class="absolute top-[-10%] left-[-5%] w-[40rem] h-[40rem] bg-blue-400/10 rounded-full blur-3xl pointer-events-none"></div>
    <div class="absolute bottom-[-10%] right-[-5%] w-[40rem] h-[40rem] bg-purple-400/10 rounded-full blur-3xl pointer-events-none"></div>

    <section class="max-w-6xl mx-auto w-full relative z-10">
        
        <div class="text-center mb-16">
            <h1 class="text-4xl md:text-5xl font-extrabold text-slate-900 tracking-tight mb-5">회원가입</h1>
            <p class="text-lg md:text-xl text-slate-500" id="subtitle">CityBiz 플랫폼에서 활동하실 역할을 선택해주세요.</p>
        </div>

        <div id="roleSelectionSection" class="grid grid-cols-1 md:grid-cols-3 gap-8">
            
            <button onclick="selectRole('USER')" class="flex flex-col items-center text-center p-10 md:p-12 border border-slate-200/60 rounded-[2rem] hover:border-blue-500 hover:bg-white hover:-translate-y-2 transition-all duration-300 group bg-white/80 backdrop-blur-sm shadow-sm hover:shadow-xl">
                <div class="w-24 h-24 rounded-3xl bg-slate-50 shadow-inner flex items-center justify-center group-hover:bg-blue-600 group-hover:text-white text-slate-400 transition-all duration-300 mb-8">
                    <i data-lucide="building" class="w-12 h-12"></i>
                </div>
                <h3 class="text-2xl font-bold text-slate-900 group-hover:text-blue-700 transition-colors mb-2">일반 사용자</h3>
                <p class="text-base font-semibold text-blue-600 mb-4">창업기업</p>
                <p class="text-base text-slate-500 leading-relaxed break-keep">공간 예약, 지원사업 검색 및<br>컨설팅을 받고 싶은 분</p>
            </button>

            <button onclick="selectRole('PROVIDER')" class="flex flex-col items-center text-center p-10 md:p-12 border border-slate-200/60 rounded-[2rem] hover:border-indigo-500 hover:bg-white hover:-translate-y-2 transition-all duration-300 group bg-white/80 backdrop-blur-sm shadow-sm hover:shadow-xl">
                <div class="w-24 h-24 rounded-3xl bg-slate-50 shadow-inner flex items-center justify-center group-hover:bg-indigo-600 group-hover:text-white text-slate-400 transition-all duration-300 mb-8">
                    <i data-lucide="map-pin" class="w-12 h-12"></i>
                </div>
                <h3 class="text-2xl font-bold text-slate-900 group-hover:text-indigo-700 transition-colors mb-2">자원 공급자</h3>
                <p class="text-base font-semibold text-indigo-600 mb-4">공간 관리자</p>
                <p class="text-base text-slate-500 leading-relaxed break-keep">회의실, 공유오피스 등<br>공간을 등록하고 관리하실 분</p>
            </button>

            <button onclick="selectRole('EXPERT')" class="flex flex-col items-center text-center p-10 md:p-12 border border-slate-200/60 rounded-[2rem] hover:border-purple-500 hover:bg-white hover:-translate-y-2 transition-all duration-300 group bg-white/80 backdrop-blur-sm shadow-sm hover:shadow-xl">
                <div class="w-24 h-24 rounded-3xl bg-slate-50 shadow-inner flex items-center justify-center group-hover:bg-purple-600 group-hover:text-white text-slate-400 transition-all duration-300 mb-8">
                    <i data-lucide="briefcase" class="w-12 h-12"></i>
                </div>
                <h3 class="text-2xl font-bold text-slate-900 group-hover:text-purple-700 transition-colors mb-2">전문가</h3>
                <p class="text-base font-semibold text-purple-600 mb-4">컨설턴트</p>
                <p class="text-base text-slate-500 leading-relaxed break-keep">창업 기업에게 세무, 법률 등<br>전문 컨설팅을 제공하실 분</p>
            </button>

        </div>

        <form id="signupForm" class="hidden max-w-3xl mx-auto space-y-6 bg-white/90 backdrop-blur-md p-10 rounded-[2rem] shadow-lg border border-slate-100" onsubmit="handleSignup(event)">
            <input type="hidden" id="userRole" name="userRole" value="">

            <div class="space-y-6">
                <div>
                    <label for="userId" class="block text-base font-semibold text-slate-700 mb-2">아이디</label>
                    <input type="text" id="userId" required class="w-full px-5 py-4 bg-slate-50 border border-slate-200 rounded-xl focus:ring-2 focus:ring-blue-500 focus:border-blue-500 transition-all outline-none text-lg" placeholder="아이디를 입력해주세요">
                </div>
                
                <div>
                    <label for="password" class="block text-base font-semibold text-slate-700 mb-2">비밀번호</label>
                    <input type="password" id="password" required class="w-full px-5 py-4 bg-slate-50 border border-slate-200 rounded-xl focus:ring-2 focus:ring-blue-500 focus:border-blue-500 transition-all outline-none text-lg" placeholder="비밀번호를 입력해주세요">
                </div>

                <div>
                    <label for="userName" class="block text-base font-semibold text-slate-700 mb-2">이름 (또는 담당자명)</label>
                    <input type="text" id="userName" required class="w-full px-5 py-4 bg-slate-50 border border-slate-200 rounded-xl focus:ring-2 focus:ring-blue-500 focus:border-blue-500 transition-all outline-none text-lg" placeholder="이름을 입력해주세요">
                </div>
            </div>

            <div id="dynamicFields" class="space-y-6 border-t border-slate-200 pt-8 mt-8">
                </div>

            <div class="flex gap-4 pt-8">
                <button type="button" onclick="goBack()" class="w-1/3 py-5 px-4 border border-slate-200 rounded-2xl text-slate-600 text-lg font-bold bg-slate-50 hover:bg-slate-100 transition-colors">
                    이전으로
                </button>
                <button type="submit" class="w-2/3 py-5 px-4 rounded-2xl text-lg font-bold text-white bg-slate-900 hover:bg-slate-800 shadow-lg hover:shadow-xl transition-all transform hover:-translate-y-0.5">
                    가입 완료
                </button>
            </div>
        </form>

    </section>
</main>

<script>
    // Lucide 아이콘 초기화
    if (window.lucide) {
        lucide.createIcons();
    }

    const roleSelectionSection = document.getElementById('roleSelectionSection');
    const signupForm = document.getElementById('signupForm');
    const userRoleInput = document.getElementById('userRole');
    const dynamicFields = document.getElementById('dynamicFields');
    const subtitle = document.getElementById('subtitle');

    // 역할 선택 시 폼 렌더링
    function selectRole(role) {
        userRoleInput.value = role;
        roleSelectionSection.classList.add('hidden');
        signupForm.classList.remove('hidden');
        signupForm.classList.add('animate-[fadeIn_0.5s_ease-out]'); 
        
        let extraHTML = '';

        if (role === 'USER') {
            subtitle.innerHTML = "<span class='font-bold text-blue-600'>일반 사용자(창업기업)</span> 정보를 입력해주세요.";
            extraHTML = `
                <div>
                    <label for="companyName" class="block text-base font-semibold text-slate-700 mb-2">기업명 (선택)</label>
                    <input type="text" id="companyName" class="w-full px-5 py-4 bg-slate-50 border border-slate-200 rounded-xl focus:ring-2 focus:ring-blue-500 outline-none transition-all text-lg" placeholder="기업명이 있다면 입력해주세요">
                </div>
                <div>
                    <label for="startupStage" class="block text-base font-semibold text-slate-700 mb-2">창업 단계</label>
                    <select id="startupStage" class="w-full px-5 py-4 bg-slate-50 border border-slate-200 rounded-xl focus:ring-2 focus:ring-blue-500 outline-none text-slate-700 transition-all cursor-pointer text-lg">
                        <option value="PREP">예비 창업자</option>
                        <option value="EARLY">초기 창업기업 (1~3년)</option>
                        <option value="GROWTH">도약기 기업 (3년 이상)</option>
                    </select>
                </div>
            `;
        } else if (role === 'PROVIDER') {
            subtitle.innerHTML = "<span class='font-bold text-indigo-600'>자원 공급자(공간 관리자)</span> 정보를 입력해주세요.";
            extraHTML = `
                <div>
                    <label for="facilityName" class="block text-base font-semibold text-slate-700 mb-2">기관/시설명</label>
                    <input type="text" id="facilityName" required class="w-full px-5 py-4 bg-slate-50 border border-slate-200 rounded-xl focus:ring-2 focus:ring-indigo-500 outline-none transition-all text-lg" placeholder="운영하시는 공간 이름을 입력해주세요">
                </div>
                <div>
                    <label for="businessNumber" class="block text-base font-semibold text-slate-700 mb-2">사업자 등록번호</label>
                    <input type="text" id="businessNumber" required placeholder="000-00-00000" class="w-full px-5 py-4 bg-slate-50 border border-slate-200 rounded-xl focus:ring-2 focus:ring-indigo-500 outline-none transition-all text-lg">
                </div>
            `;
        } else if (role === 'EXPERT') {
            subtitle.innerHTML = "<span class='font-bold text-purple-600'>전문가(컨설턴트)</span> 정보를 입력해주세요.";
            extraHTML = `
                <div>
                    <label for="expertiseField" class="block text-base font-semibold text-slate-700 mb-2">전문 분야</label>
                    <select id="expertiseField" class="w-full px-5 py-4 bg-slate-50 border border-slate-200 rounded-xl focus:ring-2 focus:ring-purple-500 outline-none text-slate-700 transition-all cursor-pointer text-lg">
                        <option value="TAX">세무/회계</option>
                        <option value="LAW">법률/특허</option>
                        <option value="INVESTMENT">투자/IR</option>
                        <option value="MARKETING">마케팅</option>
                    </select>
                </div>
                <div>
                    <label for="portfolioLink" class="block text-base font-semibold text-slate-700 mb-2">이력/포트폴리오 링크</label>
                    <input type="url" id="portfolioLink" placeholder="https://..." class="w-full px-5 py-4 bg-slate-50 border border-slate-200 rounded-xl focus:ring-2 focus:ring-purple-500 outline-none transition-all text-lg">
                </div>
            `;
        }

        dynamicFields.innerHTML = extraHTML;
    }

    // 폼에서 뒤로가기 버튼
    function goBack() {
        signupForm.classList.add('hidden');
        roleSelectionSection.classList.remove('hidden');
        subtitle.innerText = "CityBiz 플랫폼에서 활동하실 역할을 선택해주세요.";
        signupForm.reset(); 
    }

    // 회원가입 제출 
    async function handleSignup(event) {
        event.preventDefault(); 

        const role = userRoleInput.value;
        
        // 공통 데이터 수집
        const requestData = {
            role: role,
            userId: document.getElementById('userId').value,
            password: document.getElementById('password').value,
            userName: document.getElementById('userName').value,
            extraData: {}
        };

        // 역할별 추가 데이터 수집
        if (role === 'USER') {
            requestData.extraData.companyName = document.getElementById('companyName').value;
            requestData.extraData.startupStage = document.getElementById('startupStage').value;
        } else if (role === 'PROVIDER') {
            requestData.extraData.facilityName = document.getElementById('facilityName').value;
            requestData.extraData.businessNumber = document.getElementById('businessNumber').value;
        } else if (role === 'EXPERT') {
            requestData.extraData.expertiseField = document.getElementById('expertiseField').value;
            requestData.extraData.portfolioLink = document.getElementById('portfolioLink').value;
        }

        // =========================================================================
        // [백엔드 연동 주석]
        // POST /api/auth/signup 엔드포인트로 requestData JSON 전송.
        // =========================================================================

        // [프론트엔드 테스트 로직]
        try {
            console.log("전송될 데이터:", requestData);
            alert(requestData.userName + "님, 가입이 완료되었습니다!");
            window.location.href = "/login.jsp";

        } catch (error) {
            console.error("회원가입 에러:", error);
            alert("처리 중 문제가 발생했습니다.");
        }
    }
</script>

<style>
    @keyframes fadeIn {
        from { opacity: 0; transform: translateY(15px); }
        to { opacity: 1; transform: translateY(0); }
    }
</style>

<%-- 푸터 로드 --%>
<jsp:include page="/WEB-INF/views/common/footer.jsp" />