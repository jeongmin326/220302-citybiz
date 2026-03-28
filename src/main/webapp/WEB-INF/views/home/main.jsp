<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<jsp:include page="../common/header.jsp" />



aaaaaaaaaaaaaaaaaaaaaaaaaa




<div class="max-w-7xl mx-auto px-4 py-12">
    <section class="text-center mb-16">
        <h2 class="text-4xl md:text-5xl font-extrabold text-gray-900 mb-6 tracking-tight">도시의 비즈니스 자원을 한 곳에서</h2>
        <p class="text-xl text-gray-600 mb-10">AI가 당신의 사업 단계에 맞는 공간, 지원금, 컨설팅을 추천합니다.</p>
        
        <div class="max-w-3xl mx-auto relative group">
            <input type="text" id="mainSearch" placeholder="어떤 자원이 필요하신가요? (예: 판교 회의실, 시드 투자)" 
                   class="w-full p-5 pl-14 rounded-2xl border border-gray-200 focus:border-blue-500 focus:ring-4 focus:ring-blue-100 outline-none shadow-sm transition text-lg">
            <i data-lucide="search" class="absolute left-5 top-5 text-gray-400 group-focus-within:text-blue-500 transition"></i>
            <button class="absolute right-3 top-3 bg-blue-600 text-white px-6 py-2 rounded-xl hover:bg-blue-700 transition font-medium">검색</button>
        </div>
    </section>

    <div class="grid grid-cols-1 lg:grid-cols-3 gap-8">
        <section class="lg:col-span-2 space-y-6">
            <div class="flex items-center gap-2 border-b pb-4">
                <i data-lucide="sparkles" class="text-blue-600 w-6 h-6"></i>
                <h3 class="text-2xl font-bold text-gray-900">AI 맞춤 추천 자원</h3>
            </div>
            <div id="ai-recommendations" class="grid grid-cols-1 md:grid-cols-2 gap-4">
                </div>
        </section>

        <section class="space-y-6">
            <div class="flex items-center gap-2 border-b pb-4">
                <i data-lucide="bar-chart-3" class="text-blue-600 w-6 h-6"></i>
                <h3 class="text-2xl font-bold text-gray-900">주요 공간 실시간 수요 예측</h3>
            </div>
            <div class="bg-white p-6 rounded-2xl border shadow-sm h-64 flex flex-col justify-end relative">
                <div id="congestion-chart" class="flex items-end justify-between h-40 gap-2">
                    </div>
            </div>
        </section>
    </div>
</div>

<script>
    document.addEventListener("DOMContentLoaded", () => {
        loadRecommendations();
        loadCongestionChart();
    });

    // AI 추천 데이터 로드 함수 일단 임시임 가짜
    function loadRecommendations() {
        const container = document.getElementById('ai-recommendations');
        const mockData = [
            { type: '지원사업', title: '청년창업사관학교 입교생 모집', desc: '최대 1억 원 사업화 자금 지원', badge: 'bg-green-100 text-green-700' },
            { type: '공간/예약', title: '강남스타트업센터 4인 회의실', desc: '오후 2시 예약 가능', badge: 'bg-blue-100 text-blue-700' },
            { type: 'AI 컨설팅', title: '기술신용보증기금 맞춤형 보증', desc: 'IT/소프트웨어 분야 특화', badge: 'bg-purple-100 text-purple-700' },
            { type: '네트워크', title: '초기 창업자 네트워킹 데이', desc: '판교 테크원, 이번주 금요일', badge: 'bg-orange-100 text-orange-700' }
        ];

        container.innerHTML = mockData.map(item => `
            <div class="bg-white p-5 rounded-xl border hover:shadow-md transition cursor-pointer group">
                <span class="text-xs font-bold px-2.5 py-1 rounded-full \${item.badge}">\${item.type}</span>
                <h4 class="font-bold mt-3 text-lg text-gray-900 group-hover:text-blue-600 transition">\${item.title}</h4>
                <p class="text-gray-500 text-sm mt-1">\${item.desc}</p>
            </div>
        `).join('');
    }

    // Spring Boot API(/api/chart/congestion) 연동 이것도...임시...
    async function loadCongestionChart() {
        try {
            const response = await axios.get('/api/chart/congestion');
            const data = response.data;
            const chart = document.getElementById('congestion-chart');
            
            chart.innerHTML = data.values.map((val, i) => {
                // 혼잡도가 80 이상이면 빨간색, 아니면 파란색
                const colorClass = val >= 80 ? 'bg-red-400' : 'bg-blue-400';
                return `
                <div class="flex flex-col items-center w-full group relative">
                    <span class="absolute -top-8 text-xs font-bold text-gray-600 opacity-0 group-hover:opacity-100 transition">\${val}%</span>
                    <div class="w-full \${colorClass} rounded-t-md transition-all duration-500 ease-in-out hover:brightness-110" style="height: \${val}%"></div>
                    <span class="text-xs text-gray-500 mt-2 font-medium">\${data.labels[i]}시</span>
                </div>
                `;
            }).join('');
        } catch(error) {
            console.error("차트 데이터 로드 실패", error);
            document.getElementById('congestion-chart').innerHTML = '<p class="text-sm text-red-500">데이터를 불러오지 못했습니다.</p>';
        }
    }
</script>

<jsp:include page="../common/footer.jsp" />