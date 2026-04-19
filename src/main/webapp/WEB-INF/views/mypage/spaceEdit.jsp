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
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Pretendard:wght@300;400;500;600;700;800&display=swap');
        body { font-family: 'Pretendard', sans-serif; -webkit-font-smoothing: antialiased; }
        .type-radio:checked + label {
            border-color: #3B82F6;
            background-color: #EFF6FF;
            color: #1D4ED8;
        }
    </style>
</head>
<body class="bg-[#F8FAFC] flex flex-col min-h-screen text-slate-800">

    <jsp:include page="/WEB-INF/views/common/header.jsp" />

    <main class="flex-grow max-w-4xl mx-auto w-full px-4 sm:px-6 py-12">

        <div class="mb-8">
            <span class="bg-blue-100 text-blue-700 text-xs font-bold px-3 py-1 rounded-full mb-3 inline-block">공급자(Host) 전용</span>
            <h1 class="text-3xl font-extrabold text-slate-900 tracking-tight">공간 수정하기</h1>
            <p class="text-slate-500 mt-2">기존 공간 정보를 수정합니다. 변경 후 저장하면 즉시 반영됩니다.</p>
        </div>

        <form id="editForm" enctype="multipart/form-data" class="space-y-8">

            <%-- 섹션 1: 기본 정보 --%>
            <section class="bg-white rounded-3xl p-8 border border-slate-200 shadow-sm">
                <h2 class="text-xl font-bold text-slate-900 mb-6 flex items-center gap-2">
                    <i data-lucide="info" class="w-5 h-5 text-blue-500"></i> 기본 정보
                </h2>

                <div class="space-y-6">
                    <div>
                        <label class="block text-sm font-semibold text-slate-700 mb-2">공간명 <span class="text-rose-500">*</span></label>
                        <input type="text" name="name" required value="${space.name}"
                            class="w-full px-4 py-3 bg-slate-50 border border-slate-200 rounded-xl focus:bg-white focus:outline-none focus:ring-2 focus:ring-blue-500 transition-all">
                    </div>

                    <div>
                        <label class="block text-sm font-semibold text-slate-700 mb-2">공간 유형 <span class="text-rose-500">*</span></label>
                        <p class="text-xs text-slate-400 mb-3">검색 필터에 노출될 카테고리입니다.</p>
                        <div class="grid grid-cols-3 sm:grid-cols-6 gap-3">
                            <c:forEach var="type" items="${['shop', 'warehouse', 'studio', 'meeting', 'consulting', 'office']}">
                                <div class="relative">
                                    <input type="radio" id="type_${type}" name="spaceType" value="${type}" class="hidden type-radio"
                                        required ${space.spaceType == type ? 'checked' : ''}>
                                    <label for="type_${type}" class="cursor-pointer block text-center px-2 py-3 border border-slate-200 rounded-xl text-sm font-medium text-slate-600 hover:bg-slate-50 transition-all">
                                        ${type == 'shop' ? '상점' : type == 'warehouse' ? '창고' : type == 'studio' ? '스튜디오' : type == 'meeting' ? '회의실' : type == 'consulting' ? '상담실' : '사무실'}
                                    </label>
                                </div>
                            </c:forEach>
                        </div>
                    </div>

                    <div>
                        <label class="block text-sm font-semibold text-slate-700 mb-2">한 줄 소개 <span class="text-rose-500">*</span></label>
                        <input type="text" name="description" required value="${space.description}"
                            placeholder="예: 화이트보드와 빔프로젝터가 구비된 쾌적한 회의실입니다."
                            class="w-full px-4 py-3 bg-slate-50 border border-slate-200 rounded-xl focus:bg-white focus:outline-none focus:ring-2 focus:ring-blue-500 transition-all">
                    </div>
                </div>
            </section>

            <%-- 섹션 2: 위치 및 인원 --%>
            <section class="bg-white rounded-3xl p-8 border border-slate-200 shadow-sm">
                <h2 class="text-xl font-bold text-slate-900 mb-6 flex items-center gap-2">
                    <i data-lucide="map-pin" class="w-5 h-5 text-blue-500"></i> 위치 및 상세 옵션
                </h2>

                <div class="space-y-6">
                    <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
                        <div>
                            <label class="block text-sm font-semibold text-slate-700 mb-2">광역 지역 <span class="text-rose-500">*</span></label>
                            <select id="regionSelect" name="city" required onchange="onRegionChange()"
                                    class="w-full px-4 py-3 bg-slate-50 border border-slate-200 rounded-xl focus:bg-white focus:outline-none focus:ring-2 focus:ring-blue-500 transition-all">
                                <option value="">지역 선택</option>
                                <option value="서울특별시" ${space.city == '서울특별시' ? 'selected' : ''}>서울</option>
                            </select>
                        </div>
                        <div>
                            <label class="block text-sm font-semibold text-slate-700 mb-2">구/군 <span class="text-rose-500">*</span></label>
                            <select id="districtSelect" name="district" required
                                    class="w-full px-4 py-3 bg-slate-50 border border-slate-200 rounded-xl focus:bg-white focus:outline-none focus:ring-2 focus:ring-blue-500 transition-all">
                                <option value="">먼저 지역을 선택하세요</option>
                            </select>
                        </div>
                    </div>

                    <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                        <div class="md:col-span-2">
                            <label class="block text-sm font-semibold text-slate-700 mb-2">도로명 주소 <span class="text-rose-500">*</span></label>
                            <input type="text" id="roadAddress" name="roadAddress" required value="${space.roadAddress}"
                                placeholder="예: 서울특별시 강남구 테헤란로 123"
                                class="w-full px-4 py-3 bg-slate-50 border border-slate-200 rounded-xl focus:bg-white focus:outline-none focus:ring-2 focus:ring-blue-500 transition-all">
                        </div>
                        <div>
                            <label class="block text-sm font-semibold text-slate-700 mb-2">상세 주소</label>
                            <input type="text" name="detailAddress" placeholder="예: 4층 402호"
                                class="w-full px-4 py-3 bg-slate-50 border border-slate-200 rounded-xl focus:bg-white focus:outline-none focus:ring-2 focus:ring-blue-500 transition-all">
                        </div>
                        <div>
                            <label class="block text-sm font-semibold text-slate-700 mb-2">최대 수용 인원 <span class="text-rose-500">*</span></label>
                            <div class="relative">
                                <input type="number" name="maxCapacity" min="1" required value="${space.capacity}"
                                    class="w-full px-4 py-3 bg-slate-50 border border-slate-200 rounded-xl focus:bg-white focus:outline-none focus:ring-2 focus:ring-blue-500 transition-all">
                                <span class="absolute right-4 top-1/2 -translate-y-1/2 text-slate-400 font-medium">명</span>
                            </div>
                        </div>
                    </div>
                </div>
            </section>

            <%-- 섹션 3: 가격 --%>
            <section class="bg-white rounded-3xl p-8 border border-slate-200 shadow-sm">
                <h2 class="text-xl font-bold text-slate-900 mb-6 flex items-center gap-2">
                    <i data-lucide="credit-card" class="w-5 h-5 text-blue-500"></i> 대여료 및 이용 시간
                </h2>

                <div class="space-y-6">
                    <div>
                        <label class="block text-sm font-semibold text-slate-700 mb-2">시간당 대여 가격 <span class="text-rose-500">*</span></label>
                        <div class="relative max-w-sm">
                            <input type="number" name="pricePerHour" min="0" step="1000" required value="${space.pricePerHour}"
                                class="w-full px-4 py-3 bg-slate-50 border border-slate-200 rounded-xl focus:bg-white focus:outline-none focus:ring-2 focus:ring-blue-500 transition-all">
                            <span class="absolute right-4 top-1/2 -translate-y-1/2 text-slate-400 font-medium">원 / 1시간</span>
                        </div>
                    </div>
                </div>
            </section>

            <%-- 섹션 4: 대표 이미지 --%>
            <section class="bg-white rounded-3xl p-8 border border-slate-200 shadow-sm">
                <h2 class="text-xl font-bold text-slate-900 mb-6 flex items-center gap-2">
                    <i data-lucide="image" class="w-5 h-5 text-blue-500"></i> 공간 대표 사진
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

            <%-- 제출 버튼 --%>
            <div class="flex gap-4 justify-end">
                <button type="button" onclick="history.back()" class="px-8 py-4 font-bold text-slate-600 bg-white border border-slate-200 rounded-xl hover:bg-slate-50 transition-all">
                    취소
                </button>
                <button type="submit" class="px-10 py-4 font-bold text-white bg-blue-600 rounded-xl hover:bg-blue-700 shadow-lg shadow-blue-200 transition-all hover:-translate-y-0.5">
                    변경 사항 저장
                </button>
            </div>
        </form>
    </main>

    <jsp:include page="/WEB-INF/views/common/footer.jsp" />

    <script>
        lucide.createIcons();

        const spaceId    = '${space.spaceId}';
        const savedRegion    = '${space.city}';
        const savedDistrict  = '${space.district}';

        // 서울 25개 구 목록
        const districtMap = {
            '서울특별시': ['강남구','강동구','강북구','강서구','관악구','광진구','구로구','금천구',
                     '노원구','도봉구','동대문구','동작구','마포구','서대문구','서초구',
                     '성동구','성북구','송파구','양천구','영등포구','용산구','은평구',
                     '종로구','중구','중랑구']
        };

        function onRegionChange() {
            const regionVal   = document.getElementById('regionSelect').value;
            const districtSel = document.getElementById('districtSelect');
            districtSel.innerHTML = '';
            if (regionVal && districtMap[regionVal]) {
                districtSel.disabled = false;
                districtSel.insertAdjacentHTML('beforeend', '<option value="">구/군 선택</option>');
                districtMap[regionVal].forEach(function(d) {
                    const selected = (d === savedDistrict) ? ' selected' : '';
                    districtSel.insertAdjacentHTML('beforeend',
                        '<option value="' + d + '"' + selected + '>' + d + '</option>');
                });
            } else {
                districtSel.disabled = true;
                districtSel.insertAdjacentHTML('beforeend',
                    '<option value="">먼저 지역을 선택하세요</option>');
            }
        }

        // 페이지 로드 시 기존 지역/구 자동 선택
        if (savedRegion && savedRegion !== '미설정') {
            onRegionChange();
        }

        // 이미지 선택 시 파일명 표시
        document.getElementById('dropzone-file').addEventListener('change', function(e) {
            if (e.target.files.length > 0) {
                document.getElementById('uploadLabel').innerHTML =
                    '<span class="text-blue-600 font-bold">선택된 파일:</span> ' + e.target.files[0].name;
            }
        });

        // 폼 제출 → PUT /api/spaces/{id}
        document.getElementById('editForm').addEventListener('submit', async function(e) {
            e.preventDefault();
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
