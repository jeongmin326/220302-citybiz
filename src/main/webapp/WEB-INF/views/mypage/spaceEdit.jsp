<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>공간 수정하기 - City Biz Hub</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script src="https://unpkg.com/lucide@latest"></script>
    <script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Pretendard:wght@300;400;500;600;700;800&display=swap');
        body { font-family: 'Pretendard', sans-serif; -webkit-font-smoothing: antialiased; }
        .type-radio:checked + label {
            border-color: #9333ea;
            background-color: #faf5ff;
            color: #7e22ce;
        }
    </style>
</head>
<body class="bg-[#F8FAFC] flex flex-col min-h-screen text-slate-800">

    <jsp:include page="/WEB-INF/views/common/header.jsp" />

    <main class="flex-grow max-w-4xl mx-auto w-full px-4 sm:px-6 py-12">

        <div class="mb-8">
            <span class="bg-purple-100 text-purple-700 text-xs font-bold px-3 py-1 rounded-full mb-3 inline-block">공급자(Host) 전용</span>
            <h1 class="text-3xl font-extrabold text-slate-900 tracking-tight">공간 수정하기</h1>
            <p class="text-slate-500 mt-2">공간의 첫인상을 다듬어 보세요. 정확한 정보가 더 많은 연결을 만듭니다.</p>
        </div>

        <form id="editForm" enctype="multipart/form-data" class="bg-white rounded-3xl p-8 border border-slate-200 shadow-sm">

            <div class="space-y-8">

                <%-- 섹션 1: 기본 정보 --%>
                <section>
                    <h2 class="text-lg font-bold text-slate-900 border-b border-slate-100 pb-3 mb-5 flex items-center gap-2">
                        <i data-lucide="info" class="w-5 h-5 text-purple-500"></i> 기본 정보
                    </h2>

                    <div class="space-y-6">
                        <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                            <div>
                                <label class="block text-sm font-semibold text-slate-700 mb-2">성명</label>
                                <input type="text" value="${userName}" readonly
                                       class="w-full px-4 py-3 bg-slate-100 border border-slate-200 rounded-xl text-sm cursor-not-allowed">
                            </div>
                            <div>
                                <label class="block text-sm font-semibold text-slate-700 mb-2">전화번호 <span class="text-rose-500">*</span></label>
                                <div class="flex gap-2">
                                    <input type="tel" id="phoneInput" name="phone" value="${userPhone}"
                                           placeholder="예: 01012345678" readonly
                                           class="flex-1 px-4 py-3 bg-slate-100 border border-slate-200 rounded-xl text-sm focus:outline-none focus:ring-2 focus:ring-purple-500 transition-all cursor-not-allowed">
                                    <button type="button" id="phoneEditBtn"
                                            class="px-4 py-3 bg-slate-700 text-white text-xs font-bold rounded-xl whitespace-nowrap hover:bg-slate-800 transition-colors">
                                        번호 수정
                                    </button>
                                </div>
                            </div>
                        </div>
                        <div>
                            <label class="block text-sm font-semibold text-slate-700 mb-2">공간명 <span class="text-rose-500">*</span></label>
                            <input type="text" name="name" required value="${space.name}"
                                class="w-full px-4 py-3 bg-slate-50 border border-slate-200 rounded-xl focus:outline-none focus:ring-2 focus:ring-purple-500 transition-all">
                        </div>

                        <div>
                            <label class="block text-sm font-semibold text-slate-700 mb-2">공간 유형 <span class="text-rose-500">*</span></label>
                            <p class="text-xs text-slate-400 mb-3">검색 필터에 노출될 카테고리입니다.</p>
                            <div class="grid grid-cols-3 sm:grid-cols-6 gap-3">
                                <c:forEach var="type" items="${['상점', '창고', '스튜디오', '회의실', '상담실', '사무실']}">
                                    <div class="relative">
                                        <input type="radio" id="type_${type}" name="spaceType" value="${type}" class="hidden type-radio"
                                            required ${space.spaceType == type ? 'checked' : ''}>
                                        <label for="type_${type}" class="cursor-pointer block text-center px-2 py-3 border border-slate-200 rounded-xl text-sm font-medium text-slate-600 hover:bg-slate-50 transition-all">
                                            ${type}
                                        </label>
                                    </div>
                                </c:forEach>
                            </div>
                        </div>

                        <div>
                            <label class="block text-sm font-semibold text-slate-700 mb-2">한 줄 소개 <span class="text-rose-500">*</span></label>
                            <input type="text" name="description" required value="${space.description}"
                                placeholder="예: 화이트보드와 빔프로젝터가 구비된 쾌적한 회의실입니다."
                                class="w-full px-4 py-3 bg-slate-50 border border-slate-200 rounded-xl focus:outline-none focus:ring-2 focus:ring-purple-500 transition-all">
                        </div>
                    </div>
                </section>

                <%-- 섹션 2: 위치 및 인원 --%>
                <section>
                    <h2 class="text-lg font-bold text-slate-900 border-b border-slate-100 pb-3 mb-5 flex items-center gap-2">
                        <i data-lucide="map-pin" class="w-5 h-5 text-purple-500"></i> 위치 및 상세 옵션
                    </h2>

                    <input type="hidden" name="city"        id="cityHidden"    value="${space.city}">
                    <input type="hidden" name="district"    id="districtHidden" value="${space.district}">
                    <input type="hidden" name="roadAddress" id="roadAddrHidden" value="${space.roadAddress}">
                    <input type="hidden" name="latitude"    id="latHidden"     value="${space.latitude}">
                    <input type="hidden" name="longitude"   id="lngHidden"     value="${space.longitude}">

                    <div class="space-y-6">
                        <div>
                            <label class="block text-sm font-semibold text-slate-700 mb-2">주소 검색 <span class="text-rose-500">*</span></label>
                            <button type="button" onclick="searchAddress()"
                                class="flex items-center gap-2 px-5 py-3 bg-purple-600 text-white text-sm font-bold rounded-xl hover:bg-purple-700 transition-colors">
                                <i data-lucide="search" class="w-4 h-4"></i> 주소 검색
                            </button>
                            <div id="addrSelectedBox" class="${empty space.city ? 'hidden' : ''} mt-2 flex items-start gap-3 bg-purple-50 border border-purple-200 rounded-xl px-4 py-3">
                                <i data-lucide="map-pin" class="w-4 h-4 text-purple-500 mt-0.5 flex-shrink-0"></i>
                                <div>
                                    <p class="text-xs text-purple-600 font-semibold mb-0.5">현재 주소</p>
                                    <p id="addrSelectedText" class="text-sm text-slate-800 font-medium">${space.city} ${space.district} ${space.roadAddress}</p>
                                    <p id="coordsText" class="text-xs text-slate-400 mt-0.5 ${empty space.latitude ? 'hidden' : ''}">위도 ${space.latitude}, 경도 ${space.longitude}</p>
                                </div>
                            </div>
                        </div>

                        <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                            <div>
                                <label class="block text-sm font-semibold text-slate-700 mb-2">상세 주소</label>
                                <input type="text" name="detailAddress" placeholder="예: 4층 402호" value="${space.detailAddress}"
                                    class="w-full px-4 py-3 bg-slate-50 border border-slate-200 rounded-xl focus:outline-none focus:ring-2 focus:ring-purple-500 transition-all">
                            </div>
                            <div>
                                <label class="block text-sm font-semibold text-slate-700 mb-2">최대 수용 인원 <span class="text-rose-500">*</span></label>
                                <div class="relative">
                                    <input type="number" name="maxCapacity" min="1" required value="${space.capacity}"
                                        class="w-full px-4 py-3 bg-slate-50 border border-slate-200 rounded-xl focus:outline-none focus:ring-2 focus:ring-purple-500 transition-all">
                                    <span class="absolute right-4 top-1/2 -translate-y-1/2 text-slate-400 font-medium">명</span>
                                </div>
                            </div>
                        </div>
                    </div>
                </section>

                <%-- 섹션 3: 가격 --%>
                <section>
                    <h2 class="text-lg font-bold text-slate-900 border-b border-slate-100 pb-3 mb-5 flex items-center gap-2">
                        <i data-lucide="credit-card" class="w-5 h-5 text-purple-500"></i> 대여료
                    </h2>

                    <div class="space-y-6">
                        <div>
                            <label class="block text-sm font-semibold text-slate-700 mb-2">시간당 대여 가격 <span class="text-rose-500">*</span></label>
                            <div class="relative max-w-sm">
                                <input type="number" name="pricePerHour" min="0" step="1000" required value="${space.pricePerHour}"
                                    class="w-full px-4 py-3 bg-slate-50 border border-slate-200 rounded-xl focus:outline-none focus:ring-2 focus:ring-purple-500 transition-all">
                                <span class="absolute right-4 top-1/2 -translate-y-1/2 text-slate-400 font-medium">원 / 1시간</span>
                            </div>
                        </div>
                    </div>
                </section>

                <%-- 섹션 4: 대표 이미지 --%>
                <section>
                    <h2 class="text-lg font-bold text-slate-900 border-b border-slate-100 pb-3 mb-5 flex items-center gap-2">
                        <i data-lucide="image" class="w-5 h-5 text-purple-500"></i> 공간 대표 사진
                    </h2>

                    <div id="currentImageWrap" class="mb-4">
                        <p class="text-xs text-slate-500 mb-2">현재 등록된 이미지</p>
                        <img src="/space-images/main/${space.spaceId}" alt="현재 이미지"
                             class="h-32 rounded-xl object-cover border border-slate-200"
                             onerror="document.getElementById('currentImageWrap').style.display='none'">
                    </div>

                    <div>
                        <label class="block text-sm font-semibold text-slate-700 mb-2">새 이미지로 변경 (선택)</label>
                        <p class="text-xs text-slate-400 mb-4">선택하지 않으면 기존 이미지가 유지됩니다. (최대 5MB)</p>
                        <div class="flex items-center justify-center w-full">
                            <label for="dropzone-file" class="flex flex-col items-center justify-center w-full h-36 border-2 border-slate-300 border-dashed rounded-2xl cursor-pointer bg-slate-50 hover:bg-slate-100 transition-colors">
                                <div class="flex flex-col items-center justify-center pt-5 pb-6">
                                    <i data-lucide="upload-cloud" class="w-8 h-8 text-slate-400 mb-3"></i>
                                    <p class="mb-1 text-sm text-slate-500 font-medium" id="uploadLabel">클릭하여 새 사진 선택</p>
                                    <p class="text-xs text-slate-400">JPG, PNG, WEBP 포맷 지원</p>
                                </div>
                                <input id="dropzone-file" type="file" name="mainImage" accept="image/*" class="hidden" />
                            </label>
                        </div>
                    </div>
                </section>

            </div>

            <div class="mt-10 flex gap-4">
                <button type="button" onclick="history.back()" class="flex-1 py-4 bg-slate-100 text-slate-700 font-bold rounded-xl hover:bg-slate-200 transition-colors">취소</button>
                <button type="submit" class="flex-[2] py-4 bg-purple-600 text-white font-bold rounded-xl hover:bg-purple-700 transition-all shadow-lg shadow-purple-200">변경 사항 저장</button>
            </div>
        </form>
    </main>

    <jsp:include page="/WEB-INF/views/common/footer.jsp" />

    <script>
        lucide.createIcons();

        const spaceId = '${space.spaceId}';

        // === 전화번호 수정 및 인증 ===
        const originalPhone = '${userPhone}';
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
                phoneEditBtn.classList.add('bg-purple-600', 'hover:bg-purple-700');
                phoneEditMode = true;
                isPhoneVerified = false;
                return;
            }

            const phone = phoneInput.value.trim();
            if (!phone || !/^01[0-9]{9}$/.test(phone)) {
                alert('올바른 휴대폰 번호를 입력해주세요. (예: 01012345678)');
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

                if (data.error) { alert('전화번호 확인 중 오류가 발생했습니다.'); return; }
                if (data.exists) { alert('이미 사용 중인 전화번호입니다.'); return; }

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
                    document.querySelector('#addrSelectedBox p:first-child').textContent = '선택된 주소';
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

        document.getElementById('dropzone-file').addEventListener('change', function(e) {
            if (e.target.files.length > 0) {
                document.getElementById('uploadLabel').innerHTML =
                    '<span class="text-purple-600 font-bold">선택된 파일:</span> ' + e.target.files[0].name;
            }
        });

        document.getElementById('expertForm').addEventListener('submit', async function(e) {
            const userStatus = '${sessionScope.loginUserMembership}'; 
            if (userStatus !== 'PAID') {
                e.preventDefault();
                alert('전문가 등록 권한이 없습니다. 요금제를 결제해주세요.');
                location.href = '/charge/plan';
                return;
            }
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
            const btn = this.querySelector('button[type="submit"]');
            btn.disabled = true;
            btn.textContent = '저장 중...';

            const formData = new FormData(this);
            try {
                const res  = await fetch('/api/spaces/' + spaceId, { method: 'PUT', body: formData });
                const data = await res.json();
                if (data.success) {
                    alert('공간 정보가 저장되었습니다!');
                    location.href = '/mypage/spaceManagement';
                } else {
                    alert('저장 실패: ' + (data.error || '알 수 없는 오류'));
                    btn.disabled = false;
                    btn.textContent = '변경 사항 저장';
                }
            } catch (err) {
                alert('서버 통신 오류가 발생했습니다.');
                btn.disabled = false;
                btn.textContent = '변경 사항 저장';
            }
        });
    </script>
</body>
</html>
