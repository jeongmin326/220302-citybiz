<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>내 정보 수정 - City Biz Hub</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script src="https://unpkg.com/lucide@latest"></script>
    <script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Pretendard:wght@300;400;500;600;700;800&display=swap');
        body { font-family: 'Pretendard', sans-serif; -webkit-font-smoothing: antialiased; }
    </style>
</head>
<body class="bg-[#F8FAFC] flex flex-col min-h-screen text-slate-800">

    <jsp:include page="/WEB-INF/views/common/header.jsp" />

    <main class="flex-grow max-w-4xl mx-auto w-full px-4 sm:px-6 py-12">
        <div class="mb-8">
            <span class="bg-blue-100 text-blue-700 text-xs font-bold px-3 py-1 rounded-full mb-3 inline-block">마이페이지</span>
            <h1 class="text-3xl font-extrabold text-slate-900 tracking-tight">내 정보 수정</h1>
            <p class="text-slate-500 mt-2">연락처와 사업 정보를 최신 상태로 관리해 주세요.</p>
        </div>

        <div>
            <form id="userProfileForm" class="bg-white rounded-3xl p-8 border border-slate-200 shadow-sm">
                <input type="hidden" name="city" id="cityHidden" value="${profile.city}">
                <input type="hidden" name="district" id="districtHidden" value="${profile.district}">
                <input type="hidden" name="roadAddress" id="roadAddrHidden" value="${profile.roadAddress}">

                <div class="space-y-8">
                    <section>
                        <h2 class="text-lg font-bold text-slate-900 border-b border-slate-100 pb-3 mb-5 flex items-center gap-2">
                            <i data-lucide="user" class="w-5 h-5 text-blue-500"></i> 기본 정보
                        </h2>
                        <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                            <div class="hidden">
                                <label class="block text-sm font-semibold text-slate-700 mb-2">이름</label>
                                <input type="text" value="${profile.name}" readonly class="w-full px-4 py-3 bg-slate-100 border border-slate-200 rounded-xl text-sm cursor-not-allowed">
                            </div>
                            <div class="hidden">
                                <label class="block text-sm font-semibold text-slate-700 mb-2">사업자등록번호</label>
                                <input type="text" value="${profile.bizNo}" readonly class="w-full px-4 py-3 bg-slate-100 border border-slate-200 rounded-xl text-sm cursor-not-allowed">
                            </div>
                            <div class="md:col-span-2">
                                <label class="block text-sm font-semibold text-slate-700 mb-2">휴대폰 번호 <span class="text-rose-500">*</span></label>
                                <div class="flex gap-2">
                                    <input type="tel" id="phoneInput" name="phone" value="${profile.phone}" readonly
                                           placeholder="예: 01012345678"
                                           class="flex-1 px-4 py-3 bg-slate-100 border border-slate-200 rounded-xl text-sm focus:outline-none focus:ring-2 focus:ring-blue-500 transition-all cursor-not-allowed">
                                    <button type="button" id="phoneEditBtn"
                                            class="px-4 py-3 bg-slate-700 text-white text-xs font-bold rounded-xl whitespace-nowrap hover:bg-slate-800 transition-colors">
                                        번호 수정
                                    </button>
                                </div>
                            </div>
                        </div>
                    </section>

                    <section>
                        <h2 class="text-lg font-bold text-slate-900 border-b border-slate-100 pb-3 mb-5 flex items-center gap-2">
                            <i data-lucide="map-pin" class="w-5 h-5 text-blue-500"></i> 주소
                        </h2>
                        <div class="space-y-4">
                            <div>
                                <label class="block text-sm font-semibold text-slate-700 mb-2">주소 검색 <span class="text-rose-500">*</span></label>
                                <button type="button" onclick="searchAddress()"
                                    class="flex items-center gap-2 px-5 py-3 bg-blue-600 text-white text-sm font-bold rounded-xl hover:bg-blue-700 transition-colors">
                                    <i data-lucide="search" class="w-4 h-4"></i> 주소 검색
                                </button>
                            </div>
                            <div id="addrSelectedBox" class="${empty profile.city ? 'hidden' : ''} flex items-start gap-3 bg-blue-50 border border-blue-200 rounded-xl px-4 py-3">
                                <i data-lucide="map-pin" class="w-4 h-4 text-blue-500 mt-0.5 flex-shrink-0"></i>
                                <div>
                                    <p class="text-xs text-blue-600 font-semibold mb-0.5">선택된 주소</p>
                                    <p id="addrSelectedText" class="text-sm text-slate-800 font-medium">${profile.city} ${profile.district} ${profile.roadAddress}</p>
                                </div>
                            </div>
                            <div>
                                <label class="block text-sm font-semibold text-slate-700 mb-2">상세 주소</label>
                                <input type="text" name="detailAddress" value="${profile.detailAddress}" placeholder="예: 3층 302호"
                                       class="w-full px-4 py-3 bg-slate-50 border border-slate-200 rounded-xl text-sm focus:outline-none focus:ring-2 focus:ring-blue-500 transition-all">
                            </div>
                            <div>
                                <label class="block text-sm font-semibold text-slate-700 mb-2">주요 관심 분야</label>
                                <select name="industryPreview" class="w-full px-4 py-3 bg-slate-50 border border-slate-200 rounded-xl text-sm focus:outline-none focus:ring-2 focus:ring-blue-500 transition-all">
                                    <option value="IT / 소프트웨어" ${profile.industry == 'IT / 소프트웨어' ? 'selected' : ''}>IT / 소프트웨어</option>
                                    <option value="바이오 / 헬스케어" ${profile.industry == '바이오 / 헬스케어' ? 'selected' : ''}>바이오 / 헬스케어</option>
                                    <option value="교육 / 서비스" ${profile.industry == '교육 / 서비스' ? 'selected' : ''}>교육 / 서비스</option>
                                    <option value="제조 / 하드웨어" ${profile.industry == '제조 / 하드웨어' ? 'selected' : ''}>제조 / 하드웨어</option>
                                </select>
                            </div>
                        </div>
                    </section>

                    <section>
                        <h2 class="text-lg font-bold text-slate-900 border-b border-slate-100 pb-3 mb-5 flex items-center gap-2">
                            <i data-lucide="briefcase-business" class="w-5 h-5 text-blue-500"></i> 사업 정보
                        </h2>
                        <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                            <div>
                                <label class="block text-sm font-semibold text-slate-700 mb-2">창업 단계 <span class="text-rose-500">*</span></label>
                                <select name="businessStage" class="w-full px-4 py-3 bg-slate-50 border border-slate-200 rounded-xl text-sm focus:outline-none focus:ring-2 focus:ring-blue-500 transition-all">
                                    <option value="PRE" ${profile.businessStage == 'PRE' ? 'selected' : ''}>예비 창업자</option>
                                    <option value="EARLY" ${profile.businessStage == 'EARLY' ? 'selected' : ''}>초기 창업 (3년 이내)</option>
                                    <option value="GROWTH" ${profile.businessStage == 'GROWTH' ? 'selected' : ''}>도약기 창업 (3~7년)</option>
                                </select>
                            </div>
                            <div>
                                <label class="block text-sm font-semibold text-slate-700 mb-2">관심 분야</label>
                                <input type="text" name="industry" value="${profile.industry}" placeholder="예: AI, 제조, 푸드테크"
                                       class="w-full px-4 py-3 bg-slate-50 border border-slate-200 rounded-xl text-sm focus:outline-none focus:ring-2 focus:ring-blue-500 transition-all">
                            </div>
                        </div>
                    </section>
                </div>

                <div class="mt-10 flex gap-4">
                    <a href="/mypage/status" class="flex-1 py-4 bg-slate-100 text-slate-700 font-bold rounded-xl hover:bg-slate-200 transition-colors text-center">내 활동 내역</a>
                    <button type="submit" class="flex-[2] py-4 bg-blue-600 text-white font-bold rounded-xl hover:bg-blue-700 transition-all shadow-lg shadow-blue-200">정보 저장하기</button>
                </div>
            </form>
        </div>
    </main>

    <jsp:include page="/WEB-INF/views/common/footer.jsp" />

    <script>
        lucide.createIcons();

        const industryPreview = document.querySelector('select[name="industryPreview"]');
        const industryInput = document.querySelector('input[name="industry"]');
        const savedIndustry = '${profile.industry}';

        if (industryPreview) {
            const previewWrap = industryPreview.closest('div');
            if (previewWrap) {
                previewWrap.classList.add('hidden');
            }
        }

        if (industryInput) {
            const industryWrap = industryInput.closest('div');
            if (industryWrap) {
                industryWrap.innerHTML = ''
                    + '<label class="block text-sm font-semibold text-slate-700 mb-2">주요 관심 분야</label>'
                    + '<select name="industry" id="industrySelect" class="w-full px-4 py-3 bg-slate-50 border border-slate-200 rounded-xl text-sm focus:outline-none focus:ring-2 focus:ring-blue-500 transition-all">'
                    + '<option value="IT / 소프트웨어">IT / 소프트웨어</option>'
                    + '<option value="바이오 / 헬스케어">바이오 / 헬스케어</option>'
                    + '<option value="교육 / 서비스">교육 / 서비스</option>'
                    + '<option value="제조 / 하드웨어">제조 / 하드웨어</option>'
                    + '</select>';
            }
        }

        const industrySelect = document.getElementById('industrySelect');
        if (industrySelect) {
            industrySelect.value = savedIndustry || 'IT / 소프트웨어';
        }

        function searchAddress() {
            new daum.Postcode({
                oncomplete: function(data) {
                    var city = data.sido;
                    var district = data.sigungu;
                    var roadAddr = data.roadAddress.replace(data.sido + ' ' + data.sigungu + ' ', '').trim();

                    document.getElementById('cityHidden').value = city;
                    document.getElementById('districtHidden').value = district;
                    document.getElementById('roadAddrHidden').value = roadAddr;

                    var displayAddr = [city, district, roadAddr].filter(Boolean).join(' ');
                    document.getElementById('addrSelectedText').textContent = displayAddr;
                    document.getElementById('addrSelectedBox').classList.remove('hidden');
                }
            }).open();
        }

        const originalPhone = '${profile.phone}';
        let isPhoneVerified = true;
        let phoneEditMode = false;

        const phoneInput = document.getElementById('phoneInput');
        const phoneEditBtn = document.getElementById('phoneEditBtn');

        phoneEditBtn.addEventListener('click', async function () {
            if (!phoneEditMode) {
                phoneInput.readOnly = false;
                phoneInput.classList.remove('bg-slate-100', 'cursor-not-allowed');
                phoneInput.classList.add('bg-slate-50');
                phoneInput.focus();
                phoneEditBtn.textContent = '인증하기';
                phoneEditBtn.classList.remove('bg-slate-700', 'hover:bg-slate-800', 'bg-green-600');
                phoneEditBtn.classList.add('bg-blue-600', 'hover:bg-blue-700');
                phoneEditMode = true;
                isPhoneVerified = false;
                return;
            }

            const phone = phoneInput.value.trim();
            if (!phone || !/^01[0-9]{9}$/.test(phone)) {
                alert('올바른 휴대폰 번호를 입력해 주세요. (예: 01012345678)');
                return;
            }

            if (phone === originalPhone) {
                setPhoneReadonly('번호 수정');
                isPhoneVerified = true;
                return;
            }

            try {
                const res = await fetch('/check-phone?phone=' + encodeURIComponent(phone));
                const data = await res.json();

                if (data.error) {
                    alert('휴대폰 번호 확인 중 오류가 발생했습니다.');
                    return;
                }
                if (data.exists) {
                    alert('이미 사용 중인 휴대폰 번호입니다.');
                    return;
                }

                alert('인증번호가 발송되었습니다. (테스트 번호: 1234)');
                const code = prompt('문자로 전송된 인증번호 4자리를 입력해 주세요.');
                if (code === '1234') {
                    alert('본인 인증이 완료되었습니다.');
                    isPhoneVerified = true;
                    phoneEditMode = false;
                    phoneInput.readOnly = true;
                    phoneInput.classList.add('bg-slate-100', 'cursor-not-allowed');
                    phoneInput.classList.remove('bg-slate-50');
                    phoneEditBtn.textContent = '인증완료';
                    phoneEditBtn.classList.remove('bg-blue-600', 'hover:bg-blue-700');
                    phoneEditBtn.classList.add('bg-green-600');
                    phoneEditBtn.disabled = true;
                } else if (code !== null) {
                    alert('인증번호가 일치하지 않습니다. 다시 시도해 주세요.');
                }
            } catch (e) {
                alert('휴대폰 번호 확인 중 서버 통신에 실패했습니다.');
            }
        });

        phoneInput.addEventListener('input', function () {
            if (!phoneEditMode) return;
            isPhoneVerified = false;
            phoneEditBtn.textContent = '인증하기';
            phoneEditBtn.classList.remove('bg-green-600');
            phoneEditBtn.classList.add('bg-blue-600', 'hover:bg-blue-700');
            phoneEditBtn.disabled = false;
        });

        function setPhoneReadonly(btnText) {
            phoneInput.readOnly = true;
            phoneInput.classList.add('bg-slate-100', 'cursor-not-allowed');
            phoneInput.classList.remove('bg-slate-50');
            phoneEditBtn.textContent = btnText;
            phoneEditBtn.classList.remove('bg-blue-600', 'hover:bg-blue-700', 'bg-green-600');
            phoneEditBtn.classList.add('bg-slate-700', 'hover:bg-slate-800');
            phoneEditBtn.disabled = false;
            phoneEditMode = false;
        }

        document.getElementById('userProfileForm').addEventListener('submit', async function (e) {
            e.preventDefault();

            if (!document.getElementById('cityHidden').value || !document.getElementById('roadAddrHidden').value) {
                alert('주소를 검색하여 선택해 주세요.');
                return;
            }
            if (!isPhoneVerified) {
                alert('휴대폰 번호 인증을 완료해 주세요.');
                return;
            }

            const params = new URLSearchParams(new FormData(e.target));

            try {
                const res = await fetch('/api/user/profile', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                    body: params.toString()
                });
                const data = await res.json();

                if (data.success) {
                    alert('내 정보가 저장되었습니다.');
                    window.location.href = '/mypage/status';
                } else {
                    alert(data.error || '저장에 실패했습니다.');
                }
            } catch (err) {
                alert('오류가 발생했습니다. 다시 시도해 주세요.');
            }
        });
    </script>
</body>
</html>
