<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>전문가 정보 수정 - City Biz Hub</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script src="https://unpkg.com/lucide@latest"></script>
    <script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Pretendard:wght@300;400;500;600;700;800&display=swap');
        body { font-family: 'Pretendard', sans-serif; -webkit-font-smoothing: antialiased; }
    </style>
</head>
<body class="bg-[#F8FAFC] flex flex-col min-h-screen text-slate-800">

    <%-- 1. 헤더 불러오기 --%>
    <jsp:include page="/WEB-INF/views/common/header.jsp" />

    <main class="flex-grow max-w-4xl mx-auto w-full px-4 sm:px-6 py-12">

        <div class="mb-8">
            <span class="bg-purple-100 text-purple-700 text-xs font-bold px-3 py-1 rounded-full mb-3 inline-block">전문가 설정</span>
            <h1 class="text-3xl font-extrabold text-slate-900 tracking-tight">전문가 정보 수정</h1>
            <p class="text-slate-500 mt-2">클라이언트에게 보여질 나의 전문 분야와 이력을 매력적으로 작성해 보세요.</p>
        </div>

        <%-- 프로필 수정 폼 --%>
        <form id="expertProfileForm" class="bg-white rounded-3xl p-8 border border-slate-200 shadow-sm">

            <div class="space-y-8">

                <%-- 1. 기본 정보 --%>
                <section>
                    <h2 class="text-lg font-bold text-slate-900 border-b border-slate-100 pb-3 mb-5 flex items-center gap-2">
                        <i data-lucide="user" class="w-5 h-5 text-purple-500"></i> 기본 정보
                    </h2>
                    <%-- 전문가 유형은 가입 시 확정되므로 변경 불가 --%>
                    <input type="hidden" name="expertType" value="${profile.expertType}">
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                        <div>
                            <label class="block text-sm font-semibold text-slate-700 mb-2">전문가 유형</label>
                            <div class="w-full px-4 py-3 bg-slate-100 border border-slate-200 rounded-xl text-sm text-slate-600 flex items-center gap-2">
                                <span class="bg-purple-100 text-purple-700 text-xs font-bold px-2 py-0.5 rounded-full">${profile.expertType}</span>
                                <span class="text-slate-400 text-xs">가입 시 선택한 유형은 변경할 수 없습니다</span>
                            </div>
                        </div>
                        <div>
                            <label class="block text-sm font-semibold text-slate-700 mb-2">성명 <span class="text-rose-500">*</span></label>
                            <input type="text" name="name" value="${profile.name}" placeholder="홍길동" readonly class="w-full px-4 py-3 bg-slate-100 border border-slate-200 rounded-xl text-sm cursor-not-allowed" required>
                        </div>
                        <div>
                            <label class="block text-sm font-semibold text-slate-700 mb-2">사무실명 <span class="text-rose-500">*</span></label>
                            <input type="text" name="office" value="${profile.office}" placeholder="예: 길동 세무사 사무소" class="w-full px-4 py-3 bg-slate-50 border border-slate-200 rounded-xl text-sm focus:outline-none focus:ring-2 focus:ring-purple-500 transition-all" required>
                        </div>
                        <div>
                            <label class="block text-sm font-semibold text-slate-700 mb-2">전화번호 <span class="text-rose-500">*</span></label>
                            <div class="flex gap-2">
                                <input type="tel" id="phoneInput" name="phone" value="${profile.phone}"
                                       placeholder="예: 01012345678" readonly
                                       class="flex-1 px-4 py-3 bg-slate-100 border border-slate-200 rounded-xl text-sm focus:outline-none focus:ring-2 focus:ring-purple-500 transition-all cursor-not-allowed"
                                       required>
                                <button type="button" id="phoneEditBtn"
                                        class="px-4 py-3 bg-slate-700 text-white text-xs font-bold rounded-xl whitespace-nowrap hover:bg-slate-800 transition-colors">
                                    번호 수정
                                </button>
                            </div>
                        </div>
                    </div>
                </section>

                <%-- 2. 주소 --%>
                <section>
                    <h2 class="text-lg font-bold text-slate-900 border-b border-slate-100 pb-3 mb-5 flex items-center gap-2">
                        <i data-lucide="map-pin" class="w-5 h-5 text-purple-500"></i> 주소
                    </h2>
                    <%-- 숨겨진 주소 필드 (네이버 지도 검색으로 자동 채워짐) --%>
                    <input type="hidden" name="city"        id="cityHidden"    value="${profile.city}">
                    <input type="hidden" name="district"    id="districtHidden" value="${profile.district}">
                    <input type="hidden" name="roadAddress" id="roadAddrHidden" value="${profile.roadAddress}">
                    <input type="hidden" name="latitude"    id="latHidden"     value="${profile.latitude}">
                    <input type="hidden" name="longitude"   id="lngHidden"     value="${profile.longitude}">
                    <div class="space-y-4">
                        <div>
                            <label class="block text-sm font-semibold text-slate-700 mb-2">주소 검색 <span class="text-rose-500">*</span></label>
                            <button type="button" onclick="searchAddress()"
                                class="flex items-center gap-2 px-5 py-3 bg-purple-600 text-white text-sm font-bold rounded-xl hover:bg-purple-700 transition-colors">
                                <i data-lucide="search" class="w-4 h-4"></i> 주소 검색
                            </button>
                        </div>
                        <div id="addrSelectedBox" class="${empty profile.city ? 'hidden' : ''} flex items-start gap-3 bg-purple-50 border border-purple-200 rounded-xl px-4 py-3">
                            <i data-lucide="map-pin" class="w-4 h-4 text-purple-500 mt-0.5 flex-shrink-0"></i>
                            <div>
                                <p class="text-xs text-purple-600 font-semibold mb-0.5">선택된 주소</p>
                                <p id="addrSelectedText" class="text-sm text-slate-800 font-medium">${profile.city} ${profile.district} ${profile.roadAddress}</p>
                                <p id="coordsText" class="text-xs text-slate-400 mt-0.5 ${empty profile.latitude ? 'hidden' : ''}">위도 ${profile.latitude}, 경도 ${profile.longitude}</p>
                            </div>
                        </div>
                        <div>
                            <label class="block text-sm font-semibold text-slate-700 mb-2">상세 주소</label>
                            <input type="text" name="detailAddress" value="${profile.detailAddress}" placeholder="예: 3층 302호"
                                class="w-full px-4 py-3 bg-slate-50 border border-slate-200 rounded-xl text-sm focus:outline-none focus:ring-2 focus:ring-purple-500 transition-all">
                        </div>
                    </div>
                </section>

                <%-- 3. 전문 분야 및 상담 조건 --%>
                <section>
                    <h2 class="text-lg font-bold text-slate-900 border-b border-slate-100 pb-3 mb-5 flex items-center gap-2">
                        <i data-lucide="briefcase" class="w-5 h-5 text-purple-500"></i> 전문 분야 및 상담 조건
                    </h2>
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                        <div>
                            <label class="block text-sm font-semibold text-slate-700 mb-2">전문 분야 <span class="text-rose-500">*</span></label>
                            <select name="field" id="fieldSelect" class="w-full px-4 py-3 bg-slate-50 border border-slate-200 rounded-xl text-sm focus:outline-none focus:ring-2 focus:ring-purple-500 transition-all" required>
                                <option value="">직종을 먼저 선택하세요</option>
                            </select>
                        </div>
                        <div>
                            <label class="block text-sm font-semibold text-slate-700 mb-2">상담 가능 시간 <span class="text-rose-500">*</span></label>
                            <select name="consultTime" class="w-full px-4 py-3 bg-slate-50 border border-slate-200 rounded-xl text-sm focus:outline-none focus:ring-2 focus:ring-purple-500 transition-all" required>
                                <option value="">선택하세요</option>
                                <option value="평일"    ${profile.consultTime == '평일'    ? 'selected' : ''}>평일</option>
                                <option value="야간"    ${profile.consultTime == '야간'    ? 'selected' : ''}>야간</option>
                                <option value="주말"    ${profile.consultTime == '주말'    ? 'selected' : ''}>주말</option>
                                <option value="주말야간" ${profile.consultTime == '주말야간' ? 'selected' : ''}>주말야간</option>
                            </select>
                        </div>
                        <div>
                            <label class="block text-sm font-semibold text-slate-700 mb-2">경력 (년수) <span class="text-rose-500">*</span></label>
                            <input type="number" name="experienceYears" min="0" max="50" value="${profile.experienceYears}" placeholder="예: 10" class="w-full px-4 py-3 bg-slate-50 border border-slate-200 rounded-xl text-sm focus:outline-none focus:ring-2 focus:ring-purple-500 transition-all" required>
                        </div>
                        <div>
                            <label class="block text-sm font-semibold text-slate-700 mb-2">상담 가격 (만원) <span class="text-rose-500">*</span></label>
                            <input type="number" name="price" min="0" value="${profile.price}" placeholder="예: 10" class="w-full px-4 py-3 bg-slate-50 border border-slate-200 rounded-xl text-sm focus:outline-none focus:ring-2 focus:ring-purple-500 transition-all" required>
                        </div>
                    </div>
                </section>

            </div>

            <div class="mt-10 flex gap-4">
                <button type="button" onclick="history.back()" class="flex-1 py-4 bg-slate-100 text-slate-700 font-bold rounded-xl hover:bg-slate-200 transition-colors">취소</button>
                <button type="submit" class="flex-[2] py-4 bg-purple-600 text-white font-bold rounded-xl hover:bg-purple-700 transition-all shadow-lg shadow-purple-200">프로필 저장하기</button>
            </div>
        </form>

    </main>

    <%-- 2. 푸터 불러오기 --%>
    <jsp:include page="/WEB-INF/views/common/footer.jsp" />

    <script>
        lucide.createIcons();

        // === 카카오 우편번호 서비스 주소 검색 ===
        var geocodingPromise = null;

        function searchAddress() {
            new daum.Postcode({
                oncomplete: function(data) {
                    var city     = data.sido;
                    var district = data.sigungu;
                    var roadAddr = data.roadAddress.replace(data.sido + ' ' + data.sigungu + ' ', '').trim();

                    document.getElementById('cityHidden').value     = city;
                    document.getElementById('districtHidden').value = district;
                    document.getElementById('roadAddrHidden').value = roadAddr;
                    document.getElementById('latHidden').value      = '';
                    document.getElementById('lngHidden').value      = '';

                    var displayAddr = [city, district, roadAddr].filter(Boolean).join(' ');
                    document.getElementById('addrSelectedText').textContent = displayAddr;
                    document.getElementById('addrSelectedBox').classList.remove('hidden');

                    var coordsEl = document.getElementById('coordsText');
                    coordsEl.textContent = '좌표 조회 중...';
                    coordsEl.classList.remove('hidden');

                    geocodingPromise = fetch('/api/geocode?query=' + encodeURIComponent(data.roadAddress))
                        .then(function(r) { return r.json(); })
                        .then(function(json) {
                            if (json.addresses && json.addresses.length > 0) {
                                var r = json.addresses[0];
                                document.getElementById('latHidden').value = r.y;
                                document.getElementById('lngHidden').value = r.x;
                                coordsEl.textContent = '위도 ' + parseFloat(r.y).toFixed(6) + ', 경도 ' + parseFloat(r.x).toFixed(6);
                            } else {
                                coordsEl.textContent = '좌표 조회 실패';
                            }
                        })
                        .catch(function() { coordsEl.textContent = '좌표 조회 실패'; });
                }
            }).open();
        }

        // === 전화번호 수정 및 인증 ===
        const originalPhone = '${profile.phone}';
        let isPhoneVerified = true; // 기존 번호는 인증된 상태로 시작
        let phoneEditMode = false;

        const phoneInput = document.getElementById('phoneInput');
        const phoneEditBtn = document.getElementById('phoneEditBtn');

        phoneEditBtn.addEventListener('click', async function () {
            if (!phoneEditMode) {
                // 수정 모드 진입
                phoneInput.readOnly = false;
                phoneInput.classList.remove('bg-slate-100', 'cursor-not-allowed');
                phoneInput.classList.add('bg-slate-50');
                phoneInput.focus();
                phoneEditBtn.textContent = '인증하기';
                phoneEditBtn.classList.remove('bg-slate-700', 'hover:bg-slate-800', 'bg-green-600');
                phoneEditBtn.classList.add('bg-purple-600', 'hover:bg-purple-700');
                phoneEditMode = true;
                isPhoneVerified = false;
                return;
            }

            // 인증 시도
            const phone = phoneInput.value.trim();
            if (!phone || !/^01[0-9]{9}$/.test(phone)) {
                alert('올바른 휴대폰 번호를 입력해주세요. (예: 01012345678)');
                return;
            }

            // 원래 번호와 동일하면 인증 없이 복귀
            if (phone === originalPhone) {
                setPhoneReadonly('번호 수정');
                isPhoneVerified = true;
                return;
            }

            try {
                const res = await fetch('/check-phone?phone=' + encodeURIComponent(phone));
                const data = await res.json();

                if (data.error) {
                    alert('전화번호 확인 중 오류가 발생했습니다.');
                    return;
                }
                if (data.exists) {
                    alert('이미 사용 중인 전화번호입니다.');
                    return;
                }

                alert('인증번호가 발송되었습니다. (테스트 번호: 1234)');
                const code = prompt('휴대폰으로 전송된 인증번호 4자리를 입력해주세요.');
                if (code === '1234') {
                    alert('본인 인증이 완료되었습니다.');
                    isPhoneVerified = true;
                    phoneEditMode = false;
                    phoneInput.readOnly = true;
                    phoneInput.classList.add('bg-slate-100', 'cursor-not-allowed');
                    phoneInput.classList.remove('bg-slate-50');
                    phoneEditBtn.textContent = '인증완료';
                    phoneEditBtn.classList.remove('bg-purple-600', 'hover:bg-purple-700');
                    phoneEditBtn.classList.add('bg-green-600');
                    phoneEditBtn.disabled = true;
                } else if (code !== null) {
                    alert('인증번호가 일치하지 않습니다. 다시 시도해주세요.');
                }
            } catch (e) {
                alert('전화번호 확인 중 서버 통신에 실패했습니다.');
            }
        });

        phoneInput.addEventListener('input', function () {
            if (!phoneEditMode) return;
            isPhoneVerified = false;
            phoneEditBtn.textContent = '인증하기';
            phoneEditBtn.classList.remove('bg-green-600');
            phoneEditBtn.classList.add('bg-purple-600', 'hover:bg-purple-700');
            phoneEditBtn.disabled = false;
        });

        function setPhoneReadonly(btnText) {
            phoneInput.readOnly = true;
            phoneInput.classList.add('bg-slate-100', 'cursor-not-allowed');
            phoneInput.classList.remove('bg-slate-50');
            phoneEditBtn.textContent = btnText;
            phoneEditBtn.classList.remove('bg-purple-600', 'hover:bg-purple-700', 'bg-green-600');
            phoneEditBtn.classList.add('bg-slate-700', 'hover:bg-slate-800');
            phoneEditBtn.disabled = false;
            phoneEditMode = false;
        }

        document.getElementById('expertProfileForm').addEventListener('submit', async function (e) {
            e.preventDefault();
            if (!document.getElementById('cityHidden').value || !document.getElementById('roadAddrHidden').value) {
                alert('주소를 검색하여 선택해 주세요.');
                return;
            }
            if (!isPhoneVerified) {
                alert('전화번호 인증을 완료해주세요.');
                return;
            }
            if (geocodingPromise) await geocodingPromise;

            const form = e.target;
            const params = new URLSearchParams(new FormData(form));

            fetch('/api/expert/profile', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: params.toString()
            })
            .then(function (res) {
                if (res.ok) {
                    alert('프로필이 저장되었습니다.');
                    window.location.href = '/mypage/expertManagement';
                } else {
                    return res.text().then(function (msg) { alert('저장 실패: ' + msg); });
                }
            })
            .catch(function () { alert('오류가 발생했습니다. 다시 시도해주세요.'); });
        });

        const fieldOptions = {
            '세무사': ['부가가치세', '종합소득세', '법인세', '절세', '컨설팅', '세무조사', '대응'],
            '회계사': ['재무회계', '결산', '세무회계', '외부감사', '회계감사', '스타트업', '회계', '투자유치', '기업가치평가', '재무분석'],
            '노무사': ['근로계약', '인사관리', '임금', '체불임금', '부당해고', '징계', '산업재해', '4대보험', '노무관리'],
            '변호사': ['계약', '기업법', '노동', '인사', '지식재산권', '민사', '분쟁', '스타트업', '투자']
        };

        function populateFieldSelect(type, selectedField) {
            const fieldSelect = document.getElementById('fieldSelect');
            fieldSelect.innerHTML = '';
            if (type && fieldOptions[type]) {
                fieldSelect.disabled = false;
                fieldSelect.insertAdjacentHTML('beforeend', '<option value="">선택하세요</option>');
                fieldOptions[type].forEach(function (opt) {
                    const option = document.createElement('option');
                    option.value = opt;
                    option.textContent = opt;
                    if (opt === selectedField) option.selected = true;
                    fieldSelect.appendChild(option);
                });
            } else {
                fieldSelect.disabled = true;
                fieldSelect.insertAdjacentHTML('beforeend',
                    '<option value="">직종을 먼저 선택하세요</option>');
            }
        }

        // 페이지 로드 시 저장된 값으로 자동 초기화 (유형은 변경 불가)
        (function () {
            const savedType  = '${profile.expertType}';
            const savedField = '${profile.field}';
            if (savedType) {
                populateFieldSelect(savedType, savedField);
            } else {
                document.getElementById('fieldSelect').disabled = true;
            }
        })();
    </script>
</body>
</html>
