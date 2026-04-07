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
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Pretendard:wght@300;400;500;600;700;800&display=swap');
        body { font-family: 'Pretendard', sans-serif; -webkit-font-smoothing: antialiased; }
        /* 라디오 버튼 커스텀 스타일 */
        .type-radio:checked + label {
            border-color: #3B82F6;
            background-color: #EFF6FF;
            color: #1D4ED8;
        }
    </style>
</head>
<body class="bg-[#F8FAFC] flex flex-col min-h-screen text-slate-800">

    <%-- 1. 헤더 불러오기 --%>
    <jsp:include page="/WEB-INF/views/common/header.jsp" />
    
    <main class="flex-grow max-w-4xl mx-auto w-full px-4 sm:px-6 py-12">
        
        <div class="mb-8">
            <span class="bg-blue-100 text-blue-700 text-xs font-bold px-3 py-1 rounded-full mb-3 inline-block">공급자(Host) 전용</span>
            <h1 class="text-3xl font-extrabold text-slate-900 tracking-tight">새로운 공간 등록하기</h1>
            <p class="text-slate-500 mt-2">비즈니스에 최적화된 공간을 등록하고, 더 많은 창업자들과 연결되세요.</p>
        </div>

        <%-- 사진 업로드가 포함된 폼이므로 반드시 multipart/form-data 가 필요합니다. --%>
        <form action="/api/spaces" method="POST" enctype="multipart/form-data" class="space-y-8">
            
            <%-- 섹션 1: 기본 정보 --%>
            <section class="bg-white rounded-3xl p-8 border border-slate-200 shadow-sm">
                <h2 class="text-xl font-bold text-slate-900 mb-6 flex items-center gap-2">
                    <i data-lucide="info" class="w-5 h-5 text-blue-500"></i> 기본 정보
                </h2>
                
                <div class="space-y-6">
                    <div>
                        <label class="block text-sm font-semibold text-slate-700 mb-2">공간명 <span class="text-rose-500">*</span></label>
                        <input type="text" name="name" required placeholder="예: 스타트업 라운지 강남점 4인 회의실" class="w-full px-4 py-3 bg-slate-50 border border-slate-200 rounded-xl focus:bg-white focus:outline-none focus:ring-2 focus:ring-blue-500 transition-all">
                    </div>

                    <div>
                        <label class="block text-sm font-semibold text-slate-700 mb-2">공간 유형 <span class="text-rose-500">*</span></label>
                        <p class="text-xs text-slate-400 mb-3">검색 필터에 노출될 카테고리입니다. 공간에 가장 잘 맞는 유형 하나를 선택해 주세요.</p>
                        <div class="grid grid-cols-3 sm:grid-cols-6 gap-3">
                            <%-- 검색 화면(space.jsp)과 동일한 value 값 사용 --%>
                            <c:forEach var="type" items="${['shop', 'warehouse', 'studio', 'meeting', 'consulting', 'office']}">
                                <div class="relative">
                                    <input type="radio" id="type_${type}" name="spaceType" value="${type}" class="hidden type-radio" required>
                                    <label for="type_${type}" class="cursor-pointer block text-center px-2 py-3 border border-slate-200 rounded-xl text-sm font-medium text-slate-600 hover:bg-slate-50 transition-all">
                                        ${type == 'shop' ? '상점' : type == 'warehouse' ? '창고' : type == 'studio' ? '스튜디오' : type == 'meeting' ? '회의실' : type == 'consulting' ? '상담실' : '사무실'}
                                    </label>
                                </div>
                            </c:forEach>
                        </div>
                    </div>

                    <div>
                        <label class="block text-sm font-semibold text-slate-700 mb-2">한 줄 소개 <span class="text-rose-500">*</span></label>
                        <input type="text" name="description" required placeholder="예: 화이트보드와 빔프로젝터가 구비된 쾌적한 회의실입니다." class="w-full px-4 py-3 bg-slate-50 border border-slate-200 rounded-xl focus:bg-white focus:outline-none focus:ring-2 focus:ring-blue-500 transition-all">
                    </div>
                </div>
            </section>

            <%-- 섹션 2: 위치 및 인원 --%>
            <section class="bg-white rounded-3xl p-8 border border-slate-200 shadow-sm">
                <h2 class="text-xl font-bold text-slate-900 mb-6 flex items-center gap-2">
                    <i data-lucide="map-pin" class="w-5 h-5 text-blue-500"></i> 위치 및 상세 옵션
                </h2>
                
                <div class="space-y-6">
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                        <div class="md:col-span-2">
                            <label class="block text-sm font-semibold text-slate-700 mb-2">도로명 주소 <span class="text-rose-500">*</span></label>
                            <div class="flex gap-2">
                                <input type="text" id="address" name="address" required readonly placeholder="주소 검색 버튼을 클릭하세요" class="flex-grow px-4 py-3 bg-slate-50 border border-slate-200 rounded-xl focus:outline-none">
                                <button type="button" onclick="alert('주소 검색 API(예: 카카오 우편번호) 연동 필요')" class="bg-slate-900 text-white px-6 py-3 rounded-xl font-medium hover:bg-slate-800 transition-colors">주소 찾기</button>
                            </div>
                        </div>
                        <div>
                            <label class="block text-sm font-semibold text-slate-700 mb-2">상세 주소</label>
                            <input type="text" name="detailAddress" placeholder="예: 4층 402호" class="w-full px-4 py-3 bg-slate-50 border border-slate-200 rounded-xl focus:bg-white focus:outline-none focus:ring-2 focus:ring-blue-500 transition-all">
                        </div>
                        <div>
                            <label class="block text-sm font-semibold text-slate-700 mb-2">최대 수용 인원 <span class="text-rose-500">*</span></label>
                            <div class="relative">
                                <input type="number" name="maxCapacity" min="1" required placeholder="예: 6" class="w-full px-4 py-3 bg-slate-50 border border-slate-200 rounded-xl focus:bg-white focus:outline-none focus:ring-2 focus:ring-blue-500 transition-all">
                                <span class="absolute right-4 top-1/2 -translate-y-1/2 text-slate-400 font-medium">명</span>
                            </div>
                        </div>
                    </div>

                    <div>
                        <label class="block text-sm font-semibold text-slate-700 mb-3">제공 시설 (다중 선택 가능)</label>
                        <div class="grid grid-cols-2 sm:grid-cols-4 gap-3">
                            <c:forEach var="facility" items="${['무료 Wi-Fi', '빔프로젝터', '화이트보드', '주차 가능', '냉난방기', '음료/다과', 'PC/노트북', '장애인 시설']}">
                                <label class="flex items-center gap-2 p-3 border border-slate-200 rounded-xl cursor-pointer hover:bg-slate-50 transition-colors">
                                    <input type="checkbox" name="facilities" value="${facility}" class="w-4 h-4 text-blue-600 border-slate-300 rounded focus:ring-blue-500">
                                    <span class="text-sm font-medium text-slate-600">${facility}</span>
                                </label>
                            </c:forEach>
                        </div>
                    </div>
                </div>
            </section>

            <%-- 섹션 3: 가격 및 시간 --%>
            <section class="bg-white rounded-3xl p-8 border border-slate-200 shadow-sm">
                <h2 class="text-xl font-bold text-slate-900 mb-6 flex items-center gap-2">
                    <i data-lucide="credit-card" class="w-5 h-5 text-blue-500"></i> 대여료 및 이용 시간
                </h2>
                
                <div class="space-y-6">
                    <div>
                        <label class="block text-sm font-semibold text-slate-700 mb-2">시간당 대여 가격 <span class="text-rose-500">*</span></label>
                        <div class="relative max-w-sm">
                            <input type="number" name="pricePerHour" min="0" step="1000" required placeholder="예: 15000" class="w-full px-4 py-3 bg-slate-50 border border-slate-200 rounded-xl focus:bg-white focus:outline-none focus:ring-2 focus:ring-blue-500 transition-all">
                            <span class="absolute right-4 top-1/2 -translate-y-1/2 text-slate-400 font-medium">원 / 1시간</span>
                        </div>
                        <p class="text-xs text-slate-400 mt-2">입력하신 금액을 기준으로 검색 필터(가격 슬라이더)에 노출됩니다.</p>
                    </div>

                    <div class="grid grid-cols-1 sm:grid-cols-2 gap-6 pt-4 border-t border-slate-100">
                        <div>
                            <label class="block text-sm font-semibold text-slate-700 mb-2">운영 시작 시간</label>
                            <input type="time" name="openTime" value="09:00" class="w-full px-4 py-3 bg-slate-50 border border-slate-200 rounded-xl focus:bg-white focus:outline-none focus:ring-2 focus:ring-blue-500 transition-all text-slate-600">
                        </div>
                        <div>
                            <label class="block text-sm font-semibold text-slate-700 mb-2">운영 마감 시간</label>
                            <input type="time" name="closeTime" value="22:00" class="w-full px-4 py-3 bg-slate-50 border border-slate-200 rounded-xl focus:bg-white focus:outline-none focus:ring-2 focus:ring-blue-500 transition-all text-slate-600">
                        </div>
                    </div>
                </div>
            </section>

            <%-- 섹션 4: 대표 이미지 업로드 --%>
            <section class="bg-white rounded-3xl p-8 border border-slate-200 shadow-sm">
                <h2 class="text-xl font-bold text-slate-900 mb-6 flex items-center gap-2">
                    <i data-lucide="image" class="w-5 h-5 text-blue-500"></i> 공간 대표 사진
                </h2>
                
                <div>
                    <label class="block text-sm font-semibold text-slate-700 mb-2">메인 썸네일 <span class="text-rose-500">*</span></label>
                    <p class="text-xs text-slate-400 mb-4">공간을 가장 잘 보여주는 밝고 선명한 사진을 업로드해 주세요. (최대 5MB)</p>
                    
                    <div class="flex items-center justify-center w-full">
                        <label for="dropzone-file" class="flex flex-col items-center justify-center w-full h-48 border-2 border-slate-300 border-dashed rounded-2xl cursor-pointer bg-slate-50 hover:bg-slate-100 transition-colors">
                            <div class="flex flex-col items-center justify-center pt-5 pb-6">
                                <i data-lucide="upload-cloud" class="w-10 h-10 text-slate-400 mb-3"></i>
                                <p class="mb-2 text-sm text-slate-500 font-medium">클릭하여 사진 선택 또는 드래그 앤 드롭</p>
                                <p class="text-xs text-slate-400">JPG, PNG, WEBP 포맷 지원</p>
                            </div>
                            <input id="dropzone-file" type="file" name="mainImage" accept="image/*" class="hidden" required />
                        </label>
                    </div>
                </div>
            </section>

            <%-- 폼 제출 버튼 --%>
            <div class="flex gap-4 justify-end">
                <button type="button" onclick="history.back()" class="px-8 py-4 font-bold text-slate-600 bg-white border border-slate-200 rounded-xl hover:bg-slate-50 transition-all">
                    취소
                </button>
                <button type="submit" class="px-10 py-4 font-bold text-white bg-blue-600 rounded-xl hover:bg-blue-700 shadow-lg shadow-blue-200 transition-all hover:-translate-y-0.5">
                    내 공간 등록하기
                </button>
            </div>

        </form>
    </main>

    <%-- 2. 푸터 불러오기 --%>
    <jsp:include page="/WEB-INF/views/common/footer.jsp" />

    <script>
        // 루사이드 아이콘 초기화
        lucide.createIcons();

        // 이미지 업로드 시 파일명 표시 (단순 편의 기능)
        document.getElementById('dropzone-file').addEventListener('change', function(e) {
            if(e.target.files.length > 0) {
                const fileName = e.target.files[0].name;
                const uploadText = this.previousElementSibling.querySelector('p.font-medium');
                uploadText.innerHTML = `<span class='text-blue-600 font-bold'>선택된 파일:</span> \${fileName}`;
            }
        });
    </script>
</body>
</html>