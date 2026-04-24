<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>내 공간 등록하기 - City Biz Hub</title>
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
            <c:choose>
                <c:when test="${not empty draftSpace}">
                    <h1 class="text-3xl font-extrabold text-slate-900 tracking-tight">공간 정보 완성하기</h1>
                    <p class="text-slate-500 mt-2">가입 시 등록한 시설명으로 공간 정보를 완성해 주세요.</p>
                </c:when>
                <c:otherwise>
                    <h1 class="text-3xl font-extrabold text-slate-900 tracking-tight">새로운 공간 등록하기</h1>
                    <p class="text-slate-500 mt-2">당신의 공간이 누군가의 첫 비즈니스 무대가 됩니다. 매력적으로 소개해 보세요.</p>
                </c:otherwise>
            </c:choose>
        </div>

        <c:if test="${not empty draftSpace}">
            <input type="hidden" id="editSpaceId" value="${draftSpace.spaceId}">
        </c:if>

        <form action="/api/spaces" method="POST" enctype="multipart/form-data" class="bg-white rounded-3xl p-8 border border-slate-200 shadow-sm">

            <div class="space-y-8">

                <%-- 섹션 1: 기본 정보 --%>
                <section>
                    <h2 class="text-lg font-bold text-slate-900 border-b border-slate-100 pb-3 mb-5 flex items-center gap-2">
                        <i data-lucide="info" class="w-5 h-5 text-purple-500"></i> 기본 정보
                    </h2>

                    <div class="space-y-6">
                        <div>
                            <label class="block text-sm font-semibold text-slate-700 mb-2">공간명 <span class="text-rose-500">*</span></label>
                            <c:choose>
                                <c:when test="${not empty draftSpace}">
                                    <input type="text" name="name" required value="${draftSpace.name}"
                                        class="w-full px-4 py-3 bg-slate-50 border border-slate-200 rounded-xl focus:outline-none focus:ring-2 focus:ring-purple-500 transition-all">
                                </c:when>
                                <c:when test="${not empty facilityName}">
                                    <input type="text" name="name" required value="${facilityName}"
                                        class="w-full px-4 py-3 bg-purple-50 border border-purple-200 rounded-xl focus:outline-none focus:ring-2 focus:ring-purple-500 transition-all">
                                    <p class="text-xs text-purple-500 mt-1">가입 시 등록한 시설명이 자동 입력되었습니다. 필요시 수정 가능합니다.</p>
                                </c:when>
                                <c:otherwise>
                                    <input type="text" name="name" required placeholder="예: 스타트업 라운지 강남점 4인 회의실"
                                        class="w-full px-4 py-3 bg-slate-50 border border-slate-200 rounded-xl focus:outline-none focus:ring-2 focus:ring-purple-500 transition-all">
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <div>
                            <label class="block text-sm font-semibold text-slate-700 mb-2">공간 유형 <span class="text-rose-500">*</span></label>
                            <p class="text-xs text-slate-400 mb-3">검색 필터에 노출될 카테고리입니다. 공간에 가장 잘 맞는 유형 하나를 선택해 주세요.</p>
                            <div class="grid grid-cols-3 sm:grid-cols-6 gap-3">
                                <c:forEach var="type" items="${['상점', '창고', '스튜디오', '회의실', '상담실', '사무실']}">
                                    <div class="relative">
                                        <input type="radio" id="type_${type}" name="spaceType" value="${type}" class="hidden type-radio" required>
                                        <label for="type_${type}" class="cursor-pointer block text-center px-2 py-3 border border-slate-200 rounded-xl text-sm font-medium text-slate-600 hover:bg-slate-50 transition-all">
                                            ${type}
                                        </label>
                                    </div>
                                </c:forEach>
                            </div>
                        </div>

                        <div>
                            <label class="block text-sm font-semibold text-slate-700 mb-2">한 줄 소개 <span class="text-rose-500">*</span></label>
                            <input type="text" name="description" required placeholder="예: 화이트보드와 빔프로젝터가 구비된 쾌적한 회의실입니다."
                                class="w-full px-4 py-3 bg-slate-50 border border-slate-200 rounded-xl focus:outline-none focus:ring-2 focus:ring-purple-500 transition-all">
                        </div>
                    </div>
                </section>

                <%-- 섹션 2: 위치 및 인원 --%>
                <section>
                    <h2 class="text-lg font-bold text-slate-900 border-b border-slate-100 pb-3 mb-5 flex items-center gap-2">
                        <i data-lucide="map-pin" class="w-5 h-5 text-purple-500"></i> 위치
                    </h2>

                    <input type="hidden" name="city"        id="cityHidden">
                    <input type="hidden" name="district"    id="districtHidden">
                    <input type="hidden" name="roadAddress" id="roadAddrHidden">
                    <input type="hidden" name="latitude"    id="latHidden">
                    <input type="hidden" name="longitude"   id="lngHidden">

                    <div class="space-y-6">
                        <div>
                            <label class="block text-sm font-semibold text-slate-700 mb-2">주소 검색 <span class="text-rose-500">*</span></label>
                            <button type="button" onclick="searchAddress()"
                                class="flex items-center gap-2 px-5 py-3 bg-purple-600 text-white text-sm font-bold rounded-xl hover:bg-purple-700 transition-colors">
                                <i data-lucide="search" class="w-4 h-4"></i> 주소 검색
                            </button>
                            <div id="addrSelectedBox" class="hidden mt-2 flex items-start gap-3 bg-purple-50 border border-purple-200 rounded-xl px-4 py-3">
                                <i data-lucide="map-pin" class="w-4 h-4 text-purple-500 mt-0.5 flex-shrink-0"></i>
                                <div>
                                    <p class="text-xs text-purple-600 font-semibold mb-0.5">선택된 주소</p>
                                    <p id="addrSelectedText" class="text-sm text-slate-800 font-medium"></p>
                                    <p id="coordsText" class="hidden text-xs text-slate-400 mt-0.5"></p>
                                </div>
                            </div>
                        </div>

                        <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                            <div>
                                <label class="block text-sm font-semibold text-slate-700 mb-2">상세 주소</label>
                                <input type="text" name="detailAddress" placeholder="예: 4층 402호"
                                    class="w-full px-4 py-3 bg-slate-50 border border-slate-200 rounded-xl focus:outline-none focus:ring-2 focus:ring-purple-500 transition-all">
                            </div>
                            <div>
                                <label class="block text-sm font-semibold text-slate-700 mb-2">최대 수용 인원 <span class="text-rose-500">*</span></label>
                                <div class="relative">
                                    <input type="number" name="maxCapacity" min="1" required placeholder="예: 6"
                                        class="w-full px-4 py-3 bg-slate-50 border border-slate-200 rounded-xl focus:outline-none focus:ring-2 focus:ring-purple-500 transition-all">
                                    <span class="absolute right-4 top-1/2 -translate-y-1/2 text-slate-400 font-medium">명</span>
                                </div>
                            </div>
                        </div>

                    </div>
                </section>

                <%-- 섹션 3: 대여료 --%>
                <section>
                    <h2 class="text-lg font-bold text-slate-900 border-b border-slate-100 pb-3 mb-5 flex items-center gap-2">
                        <i data-lucide="credit-card" class="w-5 h-5 text-purple-500"></i> 대여료
                    </h2>

                    <div>
                        <label class="block text-sm font-semibold text-slate-700 mb-2">시간당 대여 가격 <span class="text-rose-500">*</span></label>
                        <div class="relative max-w-sm">
                            <input type="number" name="pricePerHour" min="0" step="1000" required placeholder="예: 15000"
                                class="w-full px-4 py-3 bg-slate-50 border border-slate-200 rounded-xl focus:outline-none focus:ring-2 focus:ring-purple-500 transition-all">
                            <span class="absolute right-4 top-1/2 -translate-y-1/2 text-slate-400 font-medium">원 / 1시간</span>
                        </div>
                        <p class="text-xs text-slate-400 mt-2">입력하신 금액을 기준으로 검색 필터(가격 슬라이더)에 노출됩니다.</p>
                    </div>
                </section>

                <%-- 섹션 4: 대표 이미지 업로드 --%>
                <section>
                    <h2 class="text-lg font-bold text-slate-900 border-b border-slate-100 pb-3 mb-5 flex items-center gap-2">
                        <i data-lucide="image" class="w-5 h-5 text-purple-500"></i> 공간 대표 사진
                    </h2>

                    <div>
                        <label class="block text-sm font-semibold text-slate-700 mb-2">메인 썸네일 <span class="text-rose-500">*</span></label>
                        <p class="text-xs text-slate-400 mb-4">공간을 가장 잘 보여주는 밝고 선명한 사진을 업로드해 주세요. (최대 5MB)</p>
                        <div class="flex items-center justify-center w-full">
                            <label for="dropzone-file" class="flex flex-col items-center justify-center w-full h-48 border-2 border-slate-300 border-dashed rounded-2xl cursor-pointer bg-slate-50 hover:bg-slate-100 transition-colors">
                                <div class="flex flex-col items-center justify-center pt-5 pb-6">
                                    <i data-lucide="upload-cloud" class="w-10 h-10 text-slate-400 mb-3"></i>
                                    <p class="mb-2 text-sm text-slate-500 font-medium" id="uploadLabel">클릭하여 사진 선택 또는 드래그 앤 드롭</p>
                                    <p class="text-xs text-slate-400">JPG, PNG, WEBP 포맷 지원</p>
                                </div>
                                <input id="dropzone-file" type="file" name="mainImage" accept="image/*" class="hidden" required />
                            </label>
                        </div>
                    </div>
                </section>

            </div>

            <div class="mt-10 flex gap-4">
                <button type="button" onclick="history.back()" class="flex-1 py-4 bg-slate-100 text-slate-700 font-bold rounded-xl hover:bg-slate-200 transition-colors">취소</button>
                <button type="submit" class="flex-[2] py-4 bg-purple-600 text-white font-bold rounded-xl hover:bg-purple-700 transition-all shadow-lg shadow-purple-200">
                    <c:choose>
                        <c:when test="${not empty draftSpace}">공간 정보 완성하기</c:when>
                        <c:otherwise>내 공간 등록하기</c:otherwise>
                    </c:choose>
                </button>
            </div>

        </form>
    </main>

    <jsp:include page="/WEB-INF/views/common/footer.jsp" />

    <script>
        lucide.createIcons();

        // =========================================================================
        // [추가된 부분] 페이지 진입 시 요금제(구독) 가입 여부 확인
        // URL을 직접 치고 들어오는 무료 회원을 방어하기 위한 로직입니다.
        // =========================================================================
        (function checkMembership() {
            // 서버 세션에서 회원의 요금제 등급을 가져옴 ('FREE' 또는 'PAID')
            })();
        // =========================================================================


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

        document.getElementById('dropzone-file').addEventListener('change', function(e) {
            if (e.target.files.length > 0) {
                document.getElementById('uploadLabel').innerHTML =
                    '<span class="text-purple-600 font-bold">선택된 파일:</span> ' + e.target.files[0].name;
            }
        });

        const editSpaceIdEl = document.getElementById('editSpaceId');
        const editSpaceId   = editSpaceIdEl ? editSpaceIdEl.value : null;

        document.querySelector('form').addEventListener('submit', async function(e) {
            e.preventDefault();
            if (!document.getElementById('cityHidden').value || !document.getElementById('roadAddrHidden').value) {
                alert('주소를 검색하여 선택해 주세요.');
                return;
            }
            if (geocodingPromise) await geocodingPromise;
            const btn = this.querySelector('button[type="submit"]');
            btn.disabled = true;
            btn.textContent = editSpaceId ? '수정 중...' : '등록 중...';

            const formData = new FormData(this);
            try {
                const url    = editSpaceId ? '/api/spaces/' + editSpaceId : '/api/spaces';
                const method = editSpaceId ? 'PUT' : 'POST';
                const res    = await fetch(url, { method, body: formData });
                const data   = await res.json();
                if (data.success) {
                    alert(editSpaceId ? '공간 정보가 완성되었습니다!' : '공간이 성공적으로 등록되었습니다!');
                    location.href = '/mypage/spaceManagement';
                } else {
                    alert((editSpaceId ? '수정' : '등록') + ' 실패: ' + (data.error || '알 수 없는 오류'));
                    btn.disabled = false;
                    btn.textContent = editSpaceId ? '공간 정보 완성하기' : '내 공간 등록하기';
                }
            } catch (err) {
                alert('서버 통신 오류가 발생했습니다.');
                btn.disabled = false;
                btn.textContent = editSpaceId ? '공간 정보 완성하기' : '내 공간 등록하기';
            }
        });
    </script>
</body>
</html>