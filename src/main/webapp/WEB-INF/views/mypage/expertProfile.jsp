<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>전문가 프로필 수정 - City Biz Hub</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script src="https://unpkg.com/lucide@latest"></script>
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
            <h1 class="text-3xl font-extrabold text-slate-900 tracking-tight">프로필 수정</h1>
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
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                        <div>
                            <label class="block text-sm font-semibold text-slate-700 mb-2">전문가 유형 <span class="text-rose-500">*</span></label>
                            <select name="expertType" id="expertTypeSelect" class="w-full px-4 py-3 bg-slate-50 border border-slate-200 rounded-xl text-sm focus:outline-none focus:ring-2 focus:ring-purple-500 transition-all" required>
                                <option value="">선택하세요</option>
                                <option value="세무사">세무사</option>
                                <option value="회계사">회계사</option>
                                <option value="노무사">노무사</option>
                                <option value="변호사">변호사</option>
                            </select>
                        </div>
                        <div>
                            <label class="block text-sm font-semibold text-slate-700 mb-2">성명 <span class="text-rose-500">*</span></label>
                            <input type="text" name="name" placeholder="홍길동" class="w-full px-4 py-3 bg-slate-50 border border-slate-200 rounded-xl text-sm focus:outline-none focus:ring-2 focus:ring-purple-500 transition-all" required>
                        </div>
                        <div>
                            <label class="block text-sm font-semibold text-slate-700 mb-2">사무실명 <span class="text-rose-500">*</span></label>
                            <input type="text" name="office" placeholder="예: 길동 세무사 사무소" class="w-full px-4 py-3 bg-slate-50 border border-slate-200 rounded-xl text-sm focus:outline-none focus:ring-2 focus:ring-purple-500 transition-all" required>
                        </div>
                        <div>
                            <label class="block text-sm font-semibold text-slate-700 mb-2">전화번호 <span class="text-rose-500">*</span></label>
                            <input type="tel" name="phone" placeholder="예: 02-1234-5678" class="w-full px-4 py-3 bg-slate-50 border border-slate-200 rounded-xl text-sm focus:outline-none focus:ring-2 focus:ring-purple-500 transition-all" required>
                        </div>
                    </div>
                </section>

                <%-- 2. 주소 --%>
                <section>
                    <h2 class="text-lg font-bold text-slate-900 border-b border-slate-100 pb-3 mb-5 flex items-center gap-2">
                        <i data-lucide="map-pin" class="w-5 h-5 text-purple-500"></i> 주소
                    </h2>
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                        <div>
                            <label class="block text-sm font-semibold text-slate-700 mb-2">시/도 <span class="text-rose-500">*</span></label>
                            <input type="text" name="city" placeholder="예: 서울특별시" class="w-full px-4 py-3 bg-slate-50 border border-slate-200 rounded-xl text-sm focus:outline-none focus:ring-2 focus:ring-purple-500 transition-all" required>
                        </div>
                        <div>
                            <label class="block text-sm font-semibold text-slate-700 mb-2">구/군 <span class="text-rose-500">*</span></label>
                            <input type="text" name="district" placeholder="예: 강남구" class="w-full px-4 py-3 bg-slate-50 border border-slate-200 rounded-xl text-sm focus:outline-none focus:ring-2 focus:ring-purple-500 transition-all" required>
                        </div>
                        <div class="md:col-span-2">
                            <label class="block text-sm font-semibold text-slate-700 mb-2">도로명 주소 <span class="text-rose-500">*</span></label>
                            <input type="text" name="roadAddress" placeholder="예: 테헤란로 123" class="w-full px-4 py-3 bg-slate-50 border border-slate-200 rounded-xl text-sm focus:outline-none focus:ring-2 focus:ring-purple-500 transition-all" required>
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
                                <option value="평일">평일</option>
                                <option value="야간">야간</option>
                                <option value="주말">주말</option>
                                <option value="주말야간">주말야간</option>
                            </select>
                        </div>
                        <div>
                            <label class="block text-sm font-semibold text-slate-700 mb-2">경력 (년수) <span class="text-rose-500">*</span></label>
                            <input type="number" name="experienceYears" min="0" max="50" placeholder="예: 10" class="w-full px-4 py-3 bg-slate-50 border border-slate-200 rounded-xl text-sm focus:outline-none focus:ring-2 focus:ring-purple-500 transition-all" required>
                        </div>
                        <div>
                            <label class="block text-sm font-semibold text-slate-700 mb-2">상담 가격 (만원) <span class="text-rose-500">*</span></label>
                            <input type="number" name="price" min="0" placeholder="예: 10" class="w-full px-4 py-3 bg-slate-50 border border-slate-200 rounded-xl text-sm focus:outline-none focus:ring-2 focus:ring-purple-500 transition-all" required>
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

        document.getElementById('expertProfileForm').addEventListener('submit', function (e) {
            e.preventDefault();
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

        document.getElementById('expertTypeSelect').addEventListener('change', function () {
            const fieldSelect = document.getElementById('fieldSelect');
            const type = this.value;
            fieldSelect.innerHTML = '<option value="">선택하세요</option>';
            if (type && fieldOptions[type]) {
                fieldOptions[type].forEach(function (opt) {
                    const option = document.createElement('option');
                    option.value = opt;
                    option.textContent = opt;
                    fieldSelect.appendChild(option);
                });
                fieldSelect.disabled = false;
            } else {
                fieldSelect.innerHTML = '<option value="">직종을 먼저 선택하세요</option>';
                fieldSelect.disabled = true;
            }
        });

        // 초기 비활성화
        document.getElementById('fieldSelect').disabled = true;
    </script>
</body>
</html>
