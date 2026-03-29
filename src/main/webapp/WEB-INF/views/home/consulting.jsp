<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<%-- 헤더 파일 로드 --%>
<jsp:include page="/WEB-INF/views/common/header.jsp" />

<main class="flex-grow max-w-[1400px] mx-auto w-full px-4 sm:px-6 lg:px-8 py-12 flex flex-col gap-10 relative overflow-hidden">
    
    <div class="absolute top-[-5%] left-[-5%] w-96 h-96 bg-purple-400/15 rounded-full blur-3xl pointer-events-none"></div>

    <section class="relative z-10 bg-gradient-to-r from-purple-600 to-fuchsia-600 rounded-3xl p-10 flex flex-col md:flex-row items-center justify-between shadow-lg overflow-hidden group">
        <div class="relative z-10 w-full md:w-2/3">
            <span class="bg-white/20 text-white text-xs font-bold px-3 py-1.5 rounded backdrop-blur-sm mb-4 inline-block tracking-wide">AI 맞춤 추천</span>
            <h2 class="text-3xl md:text-4xl font-extrabold text-white mb-4 tracking-tight">무엇이 고민이신가요?</h2>
            <p class="text-purple-100 text-base font-light mb-8">AI가 고민을 분석하여 최적의 전문가를 찾고, 상담 신청서까지 자동으로 작성해 드립니다.</p>
            
            <div class="relative max-w-xl">
                <input type="text" id="heroSearchInput" placeholder="예: 초기 스타트업 절세 방법이 궁금해요." class="w-full pl-6 pr-32 py-4 rounded-2xl text-slate-900 shadow-sm focus:outline-none focus:ring-4 focus:ring-purple-300/50 transition-all text-sm font-medium">
                <button onclick="openChatWithInput()" class="absolute right-2 top-2 bottom-2 bg-slate-900 text-white px-6 rounded-xl text-sm font-bold hover:bg-slate-800 transition-colors shadow-md">
                    AI 찾기
                </button>
            </div>
        </div>
        <i data-lucide="bot" class="absolute right-10 bottom-10 w-40 h-40 text-white opacity-20 group-hover:scale-110 group-hover:rotate-12 transition-transform duration-700 pointer-events-none"></i>
    </section>

    <div class="flex flex-col md:flex-row gap-10 items-start relative z-10">
        
        <aside class="w-full md:w-[360px] flex-shrink-0 bg-white rounded-3xl border border-slate-100 p-8 sticky top-28 max-h-[calc(100vh-10rem)] overflow-y-auto custom-scrollbar shadow-[0_4px_20px_-4px_rgba(0,0,0,0.05)]">
            <div class="flex justify-between items-center mb-8 pb-4 border-b border-slate-100">
                <h3 class="font-extrabold text-xl flex items-center gap-2.5 text-slate-900"><i data-lucide="sliders-horizontal" class="w-6 h-6 text-purple-500"></i> 상세 필터</h3>
                <button type="reset" form="consultingSearchForm" class="text-sm font-medium text-slate-400 hover:text-rose-500 underline transition-colors flex items-center gap-1.5"><i data-lucide="rotate-ccw" class="w-4 h-4"></i>초기화</button>
            </div>

            <%-- [Backend] 필터 제출 시 PostgreSQL 쿼리로 매칭되는 전문가 목록 반환 --%>
            <form id="consultingSearchForm" class="space-y-8">
                
                <div>
                    <label class="block text-sm font-semibold text-slate-700 mb-3 tracking-wide">상담 분야</label>
                    <div class="flex flex-wrap gap-2.5">
                        <c:forEach var="field" items="${['세무/회계', '법률/특허', '마케팅/판로', 'IT/기술', '투자/IR']}">
                            <div class="relative">
                                <input type="checkbox" id="field_${field}" name="field" value="${field}" class="peer hidden">
                                <label for="field_${field}" class="cursor-pointer inline-block px-4 py-2 border border-slate-200 rounded-full text-sm text-slate-600 hover:bg-slate-50 peer-checked:bg-purple-50 peer-checked:text-purple-600 peer-checked:border-purple-300 peer-checked:font-bold transition-all shadow-sm">
                                    ${field}
                                </label>
                            </div>
                        </c:forEach>
                    </div>
                </div>

                <div>
                    <label class="block text-sm font-semibold text-slate-700 mb-3 tracking-wide">상담 방식</label>
                    <div class="flex flex-col gap-3">
                        <label class="flex items-center gap-3 p-3 border border-slate-100 rounded-xl cursor-pointer hover:bg-slate-50 transition-colors">
                            <input type="radio" name="method" value="face" class="accent-purple-600 w-4 h-4"> 
                            <span class="text-sm font-medium text-slate-700 flex-grow">대면 상담</span>
                            <i data-lucide="users" class="w-4 h-4 text-slate-400"></i>
                        </label>
                        <label class="flex items-center gap-3 p-3 border border-slate-100 rounded-xl cursor-pointer hover:bg-slate-50 transition-colors">
                            <input type="radio" name="method" value="video" class="accent-purple-600 w-4 h-4"> 
                            <span class="text-sm font-medium text-slate-700 flex-grow">화상 상담</span>
                            <i data-lucide="video" class="w-4 h-4 text-slate-400"></i>
                        </label>
                        <label class="flex items-center gap-3 p-3 border border-slate-100 rounded-xl cursor-pointer hover:bg-slate-50 transition-colors">
                            <input type="radio" name="method" value="call" class="accent-purple-600 w-4 h-4"> 
                            <span class="text-sm font-medium text-slate-700 flex-grow">전화 상담</span>
                            <i data-lucide="phone" class="w-4 h-4 text-slate-400"></i>
                        </label>
                    </div>
                </div>

                <div id="distanceFilter" class="bg-purple-50 p-4 rounded-xl border border-purple-100 hidden transition-all">
                    <label class="block text-sm font-semibold text-purple-900 mb-2 flex justify-between items-center">
                        <span>내 위치 기준 검색</span>
                        <span id="distanceValue" class="text-purple-600 font-bold">5km</span>
                    </label>
                    <input type="range" id="radiusRange" min="1" max="20" step="1" value="5" class="w-full h-1.5 bg-purple-200 rounded-full appearance-none cursor-pointer accent-purple-600 mb-2">
                    <p class="text-[11px] text-purple-500">* 대면 상담 선택 시 PostGIS 기반으로 주변 전문가를 추천합니다.</p>
                </div>

                <button type="button" onclick="searchConsultants()" class="w-full bg-slate-900 text-white font-bold py-4 rounded-xl hover:bg-slate-800 transition-all duration-300 shadow-md hover:shadow-lg hover:-translate-y-0.5 tracking-wide">
                    조건 적용하기
                </button>
            </form>
        </aside>

        <div class="flex-grow flex flex-col gap-10 w-full overflow-hidden">
            
            <%-- [AI/ML] 사용자의 최근 활동이나 상담 내역을 분석하여 추천 전문가 리스트 반환 --%>
            <div class="bg-white rounded-3xl p-8 border border-slate-100 shadow-[0_4px_20px_-4px_rgba(0,0,0,0.05)] relative">
                <div class="flex items-center justify-between mb-6">
                    <div>
                        <h3 class="text-xl font-extrabold text-slate-900 flex items-center gap-2"><i data-lucide="sparkles" class="w-6 h-6 text-amber-500"></i> 오늘의 AI 맞춤 전문가</h3>
                        <p class="text-sm text-slate-500 mt-1">회원님의 관심 분야(IT/소프트웨어)에 최적화된 전문가입니다.</p>
                    </div>
                </div>
                
                <div class="flex gap-4 overflow-x-auto pb-4 custom-scrollbar" id="aiRecommendedContainer">
                    <div class="min-w-[300px] bg-slate-50 border border-slate-200 rounded-2xl p-5 hover:border-purple-300 transition-colors">
                        <div class="flex justify-between items-start mb-3">
                            <span class="bg-gradient-to-r from-amber-400 to-orange-500 text-white text-xs font-bold px-2.5 py-1 rounded shadow-sm">MATCH 98%</span>
                            <div class="text-right text-xs text-slate-500"><i data-lucide="star" class="w-3 h-3 inline text-amber-400 fill-amber-400"></i> 4.9 (128)</div>
                        </div>
                        <div class="flex items-center gap-3 mb-3">
                            <div class="w-12 h-12 rounded-full bg-purple-100 text-purple-600 flex items-center justify-center font-bold text-lg">김</div>
                            <div>
                                <h4 class="font-bold text-slate-900">김철수 <span class="text-xs font-normal text-slate-500">세무사</span></h4>
                                <p class="text-xs text-slate-500">스타트업 전문 절세 전략</p>
                            </div>
                        </div>
                        <p class="text-xs text-slate-600 line-clamp-2 bg-white p-2 rounded-lg border border-slate-100">"초기 창업 기업의 정부지원금 매칭 및 세무 기장 특화 전문가입니다."</p>
                    </div>
                </div>
            </div>

            <div>
                <div class="flex justify-between items-center px-4 py-3 bg-white rounded-2xl border border-slate-100 shadow-sm mb-6">
                    <p class="text-slate-600">총 <strong class="text-purple-600 font-bold" id="resultCount">142</strong>명의 전문가가 대기 중입니다.</p>
                    <select class="text-sm border-none bg-transparent font-medium text-slate-600 focus:ring-0 cursor-pointer">
                        <option>추천순</option>
                        <option>평점 높은 순</option>
                        <option>리뷰 많은 순</option>
                    </select>
                </div>

                <div class="grid grid-cols-1 md:grid-cols-2 gap-6" id="consultantListContainer">
                    
                    <div class="bg-white rounded-3xl p-6 border border-slate-100 shadow-[0_4px_20px_-4px_rgba(0,0,0,0.05)] hover:shadow-xl hover:-translate-y-1 transition-all group flex flex-col h-full relative">
                        <div class="absolute -top-3 -right-3 bg-slate-900 text-white text-[10px] font-bold px-3 py-1.5 rounded-full shadow-lg flex items-center gap-1 opacity-0 group-hover:opacity-100 transition-opacity">
                            <i data-lucide="zap" class="w-3 h-3 text-yellow-400 fill-yellow-400"></i> 빠른 응답
                        </div>

                        <div class="flex gap-4 items-start mb-4">
                            <div class="w-16 h-16 rounded-2xl bg-slate-100 object-cover flex items-center justify-center overflow-hidden border border-slate-200">
                                <img src="https://images.unsplash.com/photo-1560250097-0b93528c311a?auto=format&fit=crop&q=80&w=200" class="w-full h-full object-cover">
                            </div>
                            <div class="flex-grow">
                                <div class="flex justify-between items-center mb-1">
                                    <span class="px-2 py-0.5 bg-indigo-50 text-indigo-600 rounded text-[10px] font-bold">법률/특허</span>
                                    <span class="text-xs font-bold text-slate-700 flex items-center gap-1">
                                        <i data-lucide="star" class="w-3 h-3 text-amber-400 fill-amber-400"></i> 4.8 <span class="text-slate-400 font-normal">(56)</span>
                                    </span>
                                </div>
                                <h4 class="text-lg font-extrabold text-slate-900">이도윤 <span class="text-sm font-medium text-slate-500">변호사</span></h4>
                            </div>
                        </div>

                        <p class="text-sm text-slate-600 mb-4 line-clamp-2">IT 플랫폼 약관 검토 및 저작권 침해 대응 전문. 복잡한 법률 문제를 알기 쉽게 설명해 드립니다.</p>
                        
                        <div class="bg-slate-50 rounded-xl p-3 mb-5 border border-slate-100">
                            <p class="text-xs font-bold text-slate-700 mb-2 flex items-center gap-1.5"><i data-lucide="clock" class="w-3.5 h-3.5 text-purple-500"></i> 오늘 예약 가능한 시간</p>
                            <div class="flex gap-2 flex-wrap">
                                <button class="px-3 py-1 bg-white border border-slate-200 rounded-md text-xs font-medium text-slate-600 hover:border-purple-500 hover:text-purple-600 transition-colors">14:00</button>
                                <button class="px-3 py-1 bg-white border border-slate-200 rounded-md text-xs font-medium text-slate-600 hover:border-purple-500 hover:text-purple-600 transition-colors">16:30</button>
                                <button class="px-3 py-1 bg-slate-100 border border-slate-200 rounded-md text-xs font-medium text-slate-400 line-through cursor-not-allowed">17:00</button>
                            </div>
                        </div>

                        <div class="flex items-center justify-between border-t border-slate-100 pt-4 mt-auto">
                            <div class="flex gap-2">
                                <span class="w-8 h-8 rounded-full bg-blue-50 flex items-center justify-center text-blue-600 tooltip" title="화상 상담"><i data-lucide="video" class="w-4 h-4"></i></span>
                                <span class="w-8 h-8 rounded-full bg-green-50 flex items-center justify-center text-green-600 tooltip" title="전화 상담"><i data-lucide="phone" class="w-4 h-4"></i></span>
                            </div>
                            <button class="bg-slate-100 text-slate-700 hover:bg-purple-600 hover:text-white px-5 py-2 rounded-xl text-sm font-bold transition-all duration-300">
                                프로필 보기
                            </button>
                        </div>
                    </div>

                </div>
            </div>
        </div>
    </div>
</main>

<div id="chat-widget-button" onclick="toggleChat()" class="fixed bottom-8 right-8 w-16 h-16 bg-gradient-to-tr from-purple-600 to-indigo-600 rounded-full shadow-[0_10px_25px_rgba(147,51,234,0.4)] flex items-center justify-center cursor-pointer hover:scale-110 transition-transform duration-300 z-[100] group">
    <i data-lucide="message-square-text" class="w-7 h-7 text-white group-hover:animate-pulse"></i>
    <span class="absolute -top-2 -right-2 w-4 h-4 bg-rose-500 rounded-full border-2 border-white animate-bounce"></span>
</div>

<div id="chat-window" class="fixed bottom-28 right-8 w-[380px] h-[600px] bg-white rounded-3xl shadow-[0_20px_50px_rgba(0,0,0,0.15)] border border-slate-100 hidden flex-col z-[100] overflow-hidden transition-all duration-300 transform translate-y-4 opacity-0">
    <div class="bg-gradient-to-r from-purple-600 to-indigo-600 p-5 text-white flex justify-between items-center shadow-md z-10">
        <div class="flex items-center gap-3">
            <div class="w-8 h-8 rounded-full bg-white/20 flex items-center justify-center backdrop-blur-sm"><i data-lucide="bot" class="w-5 h-5"></i></div>
            <div>
                <h4 class="font-bold text-sm">AI 비즈니스 어드바이저</h4>
                <p class="text-[10px] text-purple-100">자동 상담 신청서 작성 지원</p>
            </div>
        </div>
        <button onclick="toggleChat()" class="text-white hover:text-purple-200 transition-colors"><i data-lucide="x" class="w-5 h-5"></i></button>
    </div>
    
    <div id="chat-messages" class="flex-1 overflow-y-auto p-5 space-y-4 bg-slate-50 custom-scrollbar relative">
        <div class="text-center text-[10px] text-slate-400 mb-4">오늘</div>
        <div class="flex gap-2 items-end">
            <div class="w-6 h-6 rounded-full bg-purple-100 flex items-center justify-center flex-shrink-0"><i data-lucide="bot" class="w-3 h-3 text-purple-600"></i></div>
            <div class="bg-white p-3 rounded-2xl rounded-bl-none shadow-sm text-sm text-slate-700 border border-slate-100 max-w-[85%] leading-relaxed">
                안녕하세요! 찾고 계신 전문가나 고민 중인 비즈니스 문제를 편하게 말씀해 주세요. <br><br>대화를 바탕으로 알맞은 전문가를 추천하고 <strong>상담 신청서 양식까지 알아서 요약</strong>해 드릴게요! ✨
            </div>
        </div>
    </div>
    
    <div class="p-4 bg-white border-t border-slate-100">
        <div class="relative flex items-center">
            <input type="text" id="chat-input" class="w-full bg-slate-50 border border-slate-200 rounded-full pl-4 pr-12 py-3 text-sm focus:outline-none focus:ring-2 focus:ring-purple-200 focus:border-purple-400 transition-all text-slate-700" placeholder="메시지를 입력하세요..." onkeypress="handleChatEnter(event)">
            <button onclick="sendChatMessage()" class="absolute right-2 w-8 h-8 bg-purple-600 rounded-full flex items-center justify-center text-white hover:bg-purple-700 transition-colors shadow-sm">
                <i data-lucide="arrow-up" class="w-4 h-4"></i>
            </button>
        </div>
    </div>
</div>

<script>
    // Lucide 아이콘 초기화 (공통 스크립트에 있을 수 있으나 안전을 위해 호출)
    if(typeof lucide !== 'undefined') lucide.createIcons();

    // UI 인터랙션: 라디오 버튼 클릭 시 대면 상담일 경우만 거리 필터 표시
    const methodRadios = document.querySelectorAll('input[name="method"]');
    const distanceFilter = document.getElementById('distanceFilter');
    methodRadios.forEach(radio => {
        radio.addEventListener('change', (e) => {
            if(e.target.value === 'face') {
                distanceFilter.classList.remove('hidden');
            } else {
                distanceFilter.classList.add('hidden');
            }
        });
    });

    // 거리 슬라이더 값 업데이트
    const radiusRange = document.getElementById('radiusRange');
    const distanceValue = document.getElementById('distanceValue');
    radiusRange?.addEventListener('input', (e) => {
        distanceValue.textContent = e.target.value + 'km';
    });

    // 필터 검색 함수 [Backend/DB: PostgreSQL, PostGIS 통신]
    function searchConsultants() {
        alert('선택한 조건 및 PostGIS 반경 정보를 바탕으로 Spring Boot 서버에 전문가 데이터를 요청합니다.');
        // axios.get('/api/consultants', { params: {...} })
    }

    // Hero 섹션에서 입력 후 챗봇 열기
    function openChatWithInput() {
        const input = document.getElementById('heroSearchInput').value;
        if(input.trim() !== '') {
            document.getElementById('chat-input').value = input;
            toggleChat();
            setTimeout(sendChatMessage, 300);
        } else {
            toggleChat();
        }
    }

    // 챗봇 토글 함수
    function toggleChat() {
        const win = document.getElementById('chat-window');
        if(win.classList.contains('hidden')) {
            win.classList.remove('hidden');
            // 애니메이션 딜레이를 위해 setTimeout 사용
            setTimeout(() => {
                win.classList.remove('translate-y-4', 'opacity-0');
            }, 10);
        } else {
            win.classList.add('translate-y-4', 'opacity-0');
            setTimeout(() => {
                win.classList.add('hidden');
            }, 300);
        }
    }

    // 챗봇 엔터키 처리
    function handleChatEnter(e) {
        if(e.key === 'Enter') sendChatMessage();
    }

    // 챗봇 메시지 전송 및 AI 응답 처리 [AI/ML: FastAPI 연동 지점]
    async function sendChatMessage() {
        const input = document.getElementById('chat-input');
        const box = document.getElementById('chat-messages');
        const text = input.value.trim();
        if(!text) return;

        // 사용자 메시지 렌더링
        box.innerHTML += `
            <div class="flex justify-end mb-4">
                <div class="bg-purple-600 text-white p-3 rounded-2xl rounded-br-none shadow-sm text-sm max-w-[85%]">
                    \${text}
                </div>
            </div>
        `;
        input.value = '';
        box.scrollTop = box.scrollHeight;

        // AI 로딩 인디케이터
        const loadingId = 'loading-' + Date.now();
        box.innerHTML += `
            <div id="\${loadingId}" class="flex gap-2 items-end mb-4">
                <div class="w-6 h-6 rounded-full bg-purple-100 flex items-center justify-center flex-shrink-0"><i data-lucide="bot" class="w-3 h-3 text-purple-600"></i></div>
                <div class="bg-white px-4 py-3 rounded-2xl rounded-bl-none shadow-sm border border-slate-100 flex gap-1 items-center">
                    <div class="w-1.5 h-1.5 bg-purple-400 rounded-full animate-bounce"></div>
                    <div class="w-1.5 h-1.5 bg-purple-400 rounded-full animate-bounce" style="animation-delay: 0.1s"></div>
                    <div class="w-1.5 h-1.5 bg-purple-400 rounded-full animate-bounce" style="animation-delay: 0.2s"></div>
                </div>
            </div>
        `;
        box.scrollTop = box.scrollHeight;
        if(typeof lucide !== 'undefined') lucide.createIcons();

        // [AI 연동] 실제로는 여기서 axios.post('http://fastapi-server/chat') 호출
        setTimeout(() => {
            document.getElementById(loadingId).remove();
            
            // AI 응답 시나리오: 요약본 생성 및 전문가 추천
            const aiResponse = `
                <div class="flex gap-2 items-end mb-4">
                    <div class="w-6 h-6 rounded-full bg-purple-100 flex items-center justify-center flex-shrink-0"><i data-lucide="bot" class="w-3 h-3 text-purple-600"></i></div>
                    <div class="bg-white p-4 rounded-2xl rounded-bl-none shadow-sm border border-slate-100 text-sm text-slate-700 max-w-[85%]">
                        말씀하신 내용을 바탕으로 <strong>상담 가이드</strong>를 요약했습니다.<br><br>
                        <div class="bg-slate-50 p-3 rounded-lg border border-slate-200 my-2 text-xs">
                            <strong class="text-purple-600">요약 내용:</strong> 초기 스타트업 단계에서의 법인세 및 소득세 절세 방안 문의<br>
                            <strong class="text-purple-600">추천 분야:</strong> 세무/회계
                        </div>
                        이 내용을 컨설턴트에게 바로 전달해 드릴까요? 화면에 가장 적합한 전문가를 매칭해 두었습니다!
                        <button class="mt-3 w-full bg-purple-50 text-purple-600 border border-purple-200 py-2 rounded-lg font-bold text-xs hover:bg-purple-600 hover:text-white transition-colors">이 내용으로 상담 신청하기</button>
                    </div>
                </div>
            `;
            box.innerHTML += aiResponse;
            box.scrollTop = box.scrollHeight;
            if(typeof lucide !== 'undefined') lucide.createIcons();
        }, 1500);
    }
</script>

<%-- 푸터 파일 로드 --%>
<jsp:include page="/WEB-INF/views/common/footer.jsp" />