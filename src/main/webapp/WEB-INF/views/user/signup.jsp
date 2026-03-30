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

        <!-- db에 맞추어서 수정 -->
        <form id="signupForm"
        class="hidden max-w-4xl mx-auto bg-white/90 backdrop-blur-md p-8 md:p-12 rounded-[2.5rem] shadow-2xl border border-slate-100"
        action="${pageContext.request.contextPath}/signup"
        method="post">

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
                <h2 class="text-xl font-bold text-slate-900 flex items-center gap-2 mb-6">
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

    let isEmailChecked = false;

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
                    <input type="text" id="companyName" name="company_name" required class="w-full px-4 py-3 bg-slate-50 border border-slate-200 rounded-xl focus:ring-2 focus:ring-blue-500 outline-none" placeholder="회사 이름을 입력해주세요">
                </div>
                <div>
                    <label class="block text-sm font-bold text-slate-700 mb-2">사업자 등록번호</label>
                    <div class="flex gap-2">
                        <input type="text" id="bizNo" name="biz_no" class="flex-grow px-4 py-3 bg-slate-50 border border-slate-200 rounded-xl focus:ring-2 focus:ring-blue-500 outline-none" placeholder="000-00-00000">
                        <button type="button" onclick="alert('정상적인 사업자입니다.')" class="px-4 py-3 bg-slate-800 text-white text-xs font-bold rounded-xl whitespace-nowrap">진위 확인</button>
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

        // 이메일 중복체크
        const contextPath = '${pageContext.request.contextPath}';
        const checkEmailBtn = document.getElementById('checkEmailBtn');
        const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

    if (checkEmailBtn) {
        checkEmailBtn.addEventListener('click', async function () {
            const emailInput = document.getElementById('email');
            const email = emailInput.value.trim();

            if (!email) {
                alert('이메일을 입력해주세요.');
                emailInput.focus();
                return;
            }

            if (!emailRegex.test(email)) {
                alert('올바른 이메일 형식이 아닙니다.');
                emailInput.focus();
                return;
            }

            try {
                const response = await fetch(contextPath + '/check-email?email=' + encodeURIComponent(email), {
                    method: 'GET',
                    headers: {
                        'Accept': 'application/json'
                    }
                });

                if (!response.ok) {
                    throw new Error('서버 응답 오류');
                }

                const data = await response.json();

               if (!data.valid) {
                alert('올바른 이메일 형식이 아닙니다.');
                isEmailChecked = false;
                emailInput.focus();

                checkEmailBtn.innerText = '중복 확인';
                checkEmailBtn.classList.remove('bg-green-600');
                checkEmailBtn.classList.add('bg-slate-800');

            } else if (data.exists) {
                alert('이미 사용 중인 이메일입니다.');
                isEmailChecked = false;
                emailInput.focus();

                checkEmailBtn.innerText = '중복 확인';
                checkEmailBtn.classList.remove('bg-green-600');
                checkEmailBtn.classList.add('bg-slate-800');

            } else {
                alert('사용 가능한 이메일입니다.');
                isEmailChecked = true;

                checkEmailBtn.innerText = '확인 완료';
                checkEmailBtn.classList.remove('bg-slate-800');
                checkEmailBtn.classList.add('bg-green-600');
            }
            } catch (error) {
                console.error(error);
                alert('중복 확인 중 오류가 발생했습니다.');
            }
        });

        document.getElementById('email').addEventListener('input', function () {
            isEmailChecked = false;
        });
    }

    signupForm.addEventListener('submit', function (e) {
        if (!isEmailChecked) {
            alert('이메일 중복 확인을 먼저 해주세요.');
            e.preventDefault();
        }
    });

    signupForm.addEventListener('submit', function (e) {
        const email = document.getElementById('email').value.trim();

        if (!emailRegex.test(email)) {
            alert('올바른 이메일 형식을 입력해주세요.');
            e.preventDefault();
            return;
        }
    });

    // mail 중복 체크를 했는데 다시 바꾸면 초기화
    document.getElementById('email').addEventListener('input', function () {
        isEmailChecked = false;

        // 버튼 원상 복구
        checkEmailBtn.innerText = '중복 확인';
        checkEmailBtn.classList.remove('bg-green-600');
        checkEmailBtn.classList.add('bg-slate-800');
    });

    document.getElementById('phone').addEventListener('input', function () {
        // 숫자만 남기기
        this.value = this.value.replace(/[^0-9]/g, '');

        // 11자리 제한
        if (this.value.length > 11) {
            this.value = this.value.slice(0, 11);
        }
    });

    // 휴대폰 번호 형식 검증 & 중복 확인
    const verifyPhoneBtn = document.getElementById('verifyPhoneBtn');

    if (verifyPhoneBtn) {
        verifyPhoneBtn.addEventListener('click', async function () {
            const phoneInput = document.getElementById('phone');
            const phone = phoneInput.value.trim();

            if (!phone) {
                alert('전화번호를 입력해주세요.');
                phoneInput.focus();
                return;
            }

            if (!/^01[0-9]{9}$/.test(phone)) {
                alert('전화번호는 01로 시작하는 11자리 숫자로 입력해주세요.');
                phoneInput.focus();
                return;
            }

            try {
                const response = await fetch(contextPath + '/check-phone?phone=' + encodeURIComponent(phone));

                if (!response.ok) {
                    throw new Error('서버 오류');
                }

                const data = await response.json();

                if (data.exists) {
                    alert('이미 사용 중인 전화번호입니다.');

                    // ❌ 중복 → 버튼 원상복구
                    verifyPhoneBtn.innerText = '본인 인증';
                    verifyPhoneBtn.classList.remove('bg-green-600');
                    verifyPhoneBtn.classList.add('bg-blue-600');

                    phoneInput.focus();

                } else {
                    alert('본인인증 기능은 아직 준비 중입니다.');

                    // ✔ 사용 가능 → 확인 완료
                    verifyPhoneBtn.innerText = '확인 완료';
                    verifyPhoneBtn.classList.remove('bg-blue-600');
                    verifyPhoneBtn.classList.add('bg-green-600');
                }

            } catch (error) {
                console.error(error);
                alert('본인 인증 중 오류가 발생했습니다.');
            }
        });
    }
    // 전화번호 중복 체크를 했는데 다시 바꾸면 초기화
    document.getElementById('phone').addEventListener('input', function () {

        verifyPhoneBtn.innerText = '본인 인증';
        verifyPhoneBtn.classList.remove('bg-green-600');
        verifyPhoneBtn.classList.add('bg-blue-600');

    });

</script>

<style>
    @keyframes fadeIn { from { opacity: 0; transform: translateY(20px); } to { opacity: 1; transform: translateY(0); } }
</style>

<%-- 푸터 로드 --%>
<jsp:include page="/WEB-INF/views/common/footer.jsp" />