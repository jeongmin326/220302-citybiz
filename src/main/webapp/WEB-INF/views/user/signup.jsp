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

        <form id="signupForm"
        class="hidden max-w-4xl mx-auto bg-white/90 backdrop-blur-md p-8 md:p-12 rounded-[2.5rem] shadow-2xl border border-slate-100"
        action="${pageContext.request.contextPath}/signup"
        method="post"
        onsubmit="return handleSignup(event)">

        <input type="hidden" id="userRole" name="role" value="">
        <input type="hidden" name="status" value="ACTIVE">

        <div class="grid grid-cols-1 lg:grid-cols-2 gap-12">

            <div class="space-y-6">
                <h2 class="text-xl font-bold text-slate-900 flex items-center gap-2 mb-6">
                    <span class="w-8 h-8 rounded-lg bg-blue-100 text-blue-600 flex items-center justify-center text-sm">1</span>
                    계정 및 담당자 정보
                </h2>

                <div>
                    <label for="email" class="block text-sm font-bold text-slate-700 mb-2">아이디 (이메일)</label>
                    <div class="flex gap-2">
                        <input type="email"
                            id="email"
                            name="email"
                            required
                            class="flex-grow px-4 py-3 bg-slate-50 border border-slate-200 rounded-xl focus:ring-2 focus:ring-blue-500 outline-none transition-all"
                            placeholder="example@email.com">
                        <button type="button" id="checkEmailBtn" class="px-4 py-3 bg-slate-800 text-white text-xs font-bold rounded-xl whitespace-nowrap">
                            중복 확인
                        </button>
                    </div>
                </div>

                <div>
                    <label for="password" class="block text-sm font-bold text-slate-700 mb-2">비밀번호</label>
                    <input type="password"
                        id="password"
                        name="password"
                        required
                        class="w-full px-4 py-3 bg-slate-50 border border-slate-200 rounded-xl focus:ring-2 focus:ring-blue-500 outline-none transition-all"
                        placeholder="8자 이상 입력">
                </div>

                <div>
                    <label for="name" class="block text-sm font-bold text-slate-700 mb-2">담당자 이름 (실명)</label>
                    <input type="text"
                        id="name"
                        name="name"
                        required
                        class="w-full px-4 py-3 bg-slate-50 border border-slate-200 rounded-xl focus:ring-2 focus:ring-blue-500 outline-none transition-all"
                        placeholder="성함을 입력해주세요">
                </div>

                <div>
                    <label for="phone" class="block text-sm font-bold text-slate-700 mb-2">휴대폰 번호</label>
                    <div class="flex gap-2">
                        <input type="tel"
                            id="phone"
                            name="phone"
                            required
                            maxlength="11"
                            pattern="^01[0-9]{9}$"
                            inputmode="numeric"
                            class="flex-grow px-4 py-3 bg-slate-50 border border-slate-200 rounded-xl focus:ring-2 focus:ring-blue-500 outline-none transition-all"
                            placeholder="01012345678">
                        <button type="button" id="verifyPhoneBtn" class="px-4 py-3 bg-blue-600 text-white text-xs font-bold rounded-xl whitespace-nowrap">
                            본인 인증
                        </button>
                    </div>
                </div>
            </div>

                <div class="space-y-6 border-t lg:border-t-0 lg:border-l border-slate-100 pt-8 lg:pt-0 lg:pl-12">
                    <h2 id="rightSectionTitle" class="text-xl font-bold text-slate-900 flex items-center gap-2 mb-6">
                        <span class="w-8 h-8 rounded-lg bg-green-100 text-green-600 flex items-center justify-center text-sm">2</span>
                        기업 및 프로젝트 정보
                    </h2>
                    <div id="dynamicFields" class="space-y-6">
                    </div>
                </div>
            </div>

        <div class="flex flex-col sm:flex-row gap-4 pt-12 mt-8 border-t border-slate-100">
            <button type="button" onclick="goBack()" class="w-full sm:w-1/3 py-4 text-slate-500 font-bold hover:bg-slate-50 rounded-2xl transition-all">
                이전으로
            </button>
            <button type="submit" class="w-full sm:w-2/3 py-4 bg-slate-900 text-white font-bold rounded-2xl shadow-lg hover:bg-slate-800 transform hover:-translate-y-1 transition-all">
                가입 완료하기
            </button>
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
    const rightSectionTitle = document.getElementById('rightSectionTitle');

    // 변수 추가: 검증 상태 확인용
    let isEmailChecked = false;
    let isPhoneVerified = false;

    // 1. 중복 확인 버튼 로직
    document.getElementById('checkEmailBtn').addEventListener('click', function() {
        const email = document.getElementById('email').value;
        const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

        if (!email) {
            alert('이메일을 입력해주세요.');
            return;
        }
        if (!emailRegex.test(email)) {
            alert('올바른 이메일 형식이 아닙니다.');
            return;
        }

        // 실제 서버 통신 대신 시뮬레이션
        alert(email + '은(는) 사용 가능한 아이디입니다.');
        isEmailChecked = true;
    });

    // 2. 본인 인증 버튼 로직
    document.getElementById('verifyPhoneBtn').addEventListener('click', function() {
        const phone = document.getElementById('phone').value;
        if (!phone || phone.length < 10) {
            alert('올바른 휴대폰 번호를 입력해주세요.');
            return;
        }

        alert('인증번호가 발송되었습니다. (테스트 번호: 1234)');
        
        const userInput = prompt('휴대폰으로 전송된 인증번호 4자리를 입력해주세요.');
        if (userInput === '1234') {
            alert('본인 인증이 완료되었습니다.');
            isPhoneVerified = true;
            this.innerText = '인증 완료';
            this.classList.replace('bg-blue-600', 'bg-green-600');
            this.disabled = true;
        } else if (userInput !== null) {
            alert('인증번호가 일치하지 않습니다. 다시 시도해주세요.');
        }
    });

    function selectRole(role) {
        document.getElementById('userRole').value = role;
        roleSelectionSection.classList.add('hidden');
        signupForm.classList.remove('hidden');
        signupForm.classList.add('animate-[fadeIn_0.5s_ease-out]');
        
        let html = '';
        if (role === 'USER') {
            subtitle.innerText = "스타트업 성장을 위한 기업 정보를 입력해주세요.";
            rightSectionTitle.innerHTML = '<span class="w-8 h-8 rounded-lg bg-green-100 text-green-600 flex items-center justify-center text-sm">2</span>기업 및 프로젝트 정보';
            html = `
                <div>
                    <label class="block text-sm font-bold text-slate-700 mb-2">기업명 (또는 팀명)</label>
                    <input type="text" id="companyName" name="company_name" required class="w-full px-4 py-3 bg-slate-50 border border-slate-200 rounded-xl focus:ring-2 focus:ring-blue-500 outline-none" placeholder="회사 이름을 입력해주세요">
                </div>
                <div>
                    <label class="block text-sm font-bold text-slate-700 mb-2">사업자 등록번호</label>
                    <div class="flex gap-2">
                        <input type="text" id="bizNo" name="biz_no" class="flex-grow px-4 py-3 bg-slate-50 border border-slate-200 rounded-xl focus:ring-2 focus:ring-blue-500 outline-none" placeholder="000-00-00000">
                        <button type="button" onclick="alert('정상적인 사업자 등록번호입니다.')" class="px-4 py-3 bg-slate-800 text-white text-xs font-bold rounded-xl whitespace-nowrap">진위 확인</button>
                    </div>
                    <p class="text-[10px] text-slate-400 mt-1">* 예비창업자는 입력하지 않아도 됩니다.</p>
                </div>
                <div>
                    <label class="block text-sm font-bold text-slate-700 mb-2">창업 단계</label>
                    <select id="stage" name="business_stage" class="w-full px-4 py-3 bg-slate-50 border border-slate-200 rounded-xl outline-none focus:ring-2 focus:ring-blue-500">
                        <option value="PRE">예비 창업자</option>
                        <option value="EARLY">초기 창업 (3년 이내)</option>
                        <option value="GROWTH">도약기 창업 (3~7년)</option>
                    </select>
                </div>
                <div>
                    <label class="block text-sm font-bold text-slate-700 mb-2">주요 관심 분야</label>
                    <select id="industry" name="industry" class="w-full px-4 py-3 bg-slate-50 border border-slate-200 rounded-xl outline-none focus:ring-2 focus:ring-blue-500">
                        <option value="IT">IT / 소프트웨어</option>
                        <option value="BIO">바이오 / 헬스케어</option>
                        <option value="EDU">교육 / 서비스</option>
                        <option value="MFG">제조 / 하드웨어</option>
                    </select>
                </div>
            `;
        } else if (role === 'PROVIDER') {
            subtitle.innerText = "공간 및 시설 공급을 위한 파트너 정보를 입력해주세요.";
            rightSectionTitle.innerHTML = '<span class="w-8 h-8 rounded-lg bg-indigo-100 text-indigo-600 flex items-center justify-center text-sm">2</span>시설 및 사업자 정보';
            html = `
                <div>
                    <label class="block text-sm font-bold text-slate-700 mb-2">운영 기관/시설명</label>
                    <input type="text" id="facilityName" required class="w-full px-4 py-3 bg-slate-50 border border-slate-200 rounded-xl focus:ring-2 focus:ring-indigo-500 outline-none" placeholder="예: 시티비즈 공유오피스 강남점">
                </div>
                <div>
                    <label class="block text-sm font-bold text-slate-700 mb-2">사업자 등록번호</label>
                    <div class="flex gap-2">
                        <input type="text" id="providerBizNo" required class="flex-grow px-4 py-3 bg-slate-50 border border-slate-200 rounded-xl focus:ring-2 focus:ring-indigo-500 outline-none" placeholder="000-00-00000">
                        <button type="button" onclick="alert('사업자 확인이 완료되었습니다.')" class="px-4 py-3 bg-slate-800 text-white text-xs font-bold rounded-xl whitespace-nowrap">진위 확인</button>
                    </div>
                </div>
                <div>
                    <label class="block text-sm font-bold text-slate-700 mb-2">사업자 등록증 첨부</label>
                    <label class="flex flex-col items-center justify-center w-full h-28 border-2 border-dashed border-slate-200 rounded-2xl bg-slate-50 hover:bg-slate-100 cursor-pointer transition-all">
                        <i data-lucide="upload-cloud" class="w-8 h-8 text-slate-400 mb-2"></i>
                        <span class="text-xs text-slate-500">클릭하여 PDF 또는 이미지 업로드</span>
                        <input type="file" class="hidden">
                    </label>
                </div>
                <div class="grid grid-cols-2 gap-4">
                    <div>
                        <label class="block text-sm font-bold text-slate-700 mb-2">정산 은행</label>
                        <select class="w-full px-4 py-3 bg-slate-50 border border-slate-200 rounded-xl outline-none focus:ring-2 focus:ring-indigo-500">
                            <option>신한은행</option>
                            <option>국민은행</option>
                            <option>우리은행</option>
                            <option>농협은행</option>
                        </select>
                    </div>
                    <div>
                        <label class="block text-sm font-bold text-slate-700 mb-2">계좌 번호</label>
                        <input type="text" class="w-full px-4 py-3 bg-slate-50 border border-slate-200 rounded-xl outline-none focus:ring-2 focus:ring-indigo-500" placeholder="'-' 제외 입력">
                    </div>
                </div>
            `;
        } else {
            subtitle.innerText = "전문가 풀 등록을 위한 정보를 입력해주세요.";
            rightSectionTitle.innerHTML = '<span class="w-8 h-8 rounded-lg bg-purple-100 text-purple-600 flex items-center justify-center text-sm">2</span>전문가 정보';
            html = `<p class='text-slate-400 pt-10 text-center'>해당 역할에 맞는 필드를 준비 중입니다.</p>`;
        }
        dynamicFields.innerHTML = html;
        if (window.lucide) { lucide.createIcons(); } // 동적 생성된 아이콘 로드
    }

    function goBack() {
        signupForm.classList.add('hidden');
        roleSelectionSection.classList.remove('hidden');
        subtitle.innerText = "CityBiz 플랫폼에서 활동하실 역할을 선택해주세요.";
    }

    // 3. 가입 완료하기 로직
    async function handleSignup(e) {
        e.preventDefault();

        // 검증 로직 추가
        if (!isEmailChecked) {
            alert('이메일 중복 확인을 진행해주세요.');
            return false;
        }
        if (!isPhoneVerified) {
            alert('휴대폰 본인 인증을 완료해주세요.');
            return false;
        }

        const confirmSignup = confirm('입력하신 정보로 회원가입을 완료하시겠습니까?');
        if (confirmSignup) {
            alert('회원가입이 성공적으로 완료되었습니다! 환영합니다.');
            // 실제 서비스에서는 폼 데이터를 서버로 전송
            // e.target.submit(); 
            location.href = "${pageContext.request.contextPath}/main.jsp";
        }
        return false;
    }
</script>

<style>
    @keyframes fadeIn { from { opacity: 0; transform: translateY(20px); } to { opacity: 1; transform: translateY(0); } }
</style>

<%-- 푸터 로드 --%>
<jsp:include page="/WEB-INF/views/common/footer.jsp" />