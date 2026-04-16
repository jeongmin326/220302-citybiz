<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<%-- 헤더 파일 로드 --%>
<jsp:include page="/WEB-INF/views/common/header.jsp" />

<main class="flex-grow max-w-[1400px] mx-auto w-full px-4 sm:px-6 lg:px-8 py-12 flex flex-col gap-10 relative overflow-hidden">

    <div class="absolute top-[-5%] right-[-5%] w-96 h-96 bg-indigo-400/15 rounded-full blur-3xl pointer-events-none"></div>

    <section class="grid grid-cols-1 lg:grid-cols-3 gap-6 relative z-10">

        <%-- [AI/ML] 사용자 입력 폼 데이터를 받아 FastAPI에서 합격 확률 및 추천 정책 목록을 반환 --%>
        <button onclick="openAiDiagnosisModal()" class="lg:col-span-2 bg-gradient-to-r from-indigo-600 to-purple-600 rounded-3xl p-8 text-left relative overflow-hidden group shadow-md hover:shadow-xl transition-all duration-300 flex flex-col justify-center">
            <div class="relative z-10">
                <span class="bg-white/20 text-white text-xs font-bold px-3 py-1.5 rounded backdrop-blur-sm mb-4 inline-block tracking-wide">AI 자가진단</span>
                <h2 class="text-3xl font-extrabold text-white mb-3 tracking-tight">✨ 내 기업에 딱 맞는 정책지원금 찾기</h2>
                <p class="text-indigo-100 text-base font-light">업력, 매출액, 산업군만 입력하면 AI가 합격 가능성이 가장 높은 지원사업을 찾아드립니다.</p>
                <div class="mt-6 inline-flex items-center gap-2 bg-white text-indigo-600 px-5 py-2.5 rounded-xl font-bold text-sm shadow-sm group-hover:scale-105 transition-transform">
                    진단 시작하기 <i data-lucide="arrow-right" class="w-4 h-4"></i>
                </div>
            </div>
            <i data-lucide="cpu" class="absolute right-8 bottom-8 w-32 h-32 text-white opacity-20 group-hover:scale-110 transition-transform duration-500 transform rotate-12"></i>
        </button>

        <%-- [Backend] 가장 임박한 지원사업 마감일 데이터를 DB에서 가져와 렌더링 --%>
        <div class="bg-white border border-slate-100 rounded-3xl p-8 shadow-[0_4px_20px_-4px_rgba(0,0,0,0.05)] relative overflow-hidden flex flex-col">
            <div class="flex justify-between items-center mb-6">
                <h3 class="text-xl font-extrabold text-slate-900 flex items-center gap-2"><i data-lucide="calendar-clock" class="w-6 h-6 text-indigo-500"></i> 정책 마감 캘린더</h3>
                <a href="#calendar-full" class="text-sm text-slate-400 hover:text-indigo-600">전체보기</a>
            </div>
            <div class="flex flex-col gap-4 flex-grow">
                <div class="flex items-center gap-4 p-3 rounded-xl bg-rose-50 border border-rose-100">
                    <div class="text-center font-bold text-rose-600 flex flex-col leading-tight"><span class="text-xs font-medium">D-3</span><span>마감</span></div>
                    <div class="flex-grow"><p class="text-sm font-bold text-slate-800 truncate">2026 청년창업사관학교 모집</p></div>
                </div>
                <div class="flex items-center gap-4 p-3 rounded-xl hover:bg-slate-50 transition">
                    <div class="text-center font-bold text-slate-500 flex flex-col leading-tight"><span class="text-xs font-medium">D-12</span><span>진행</span></div>
                    <div class="flex-grow"><p class="text-sm font-bold text-slate-800 truncate">예비창업패키지 (일반분야)</p></div>
                </div>
            </div>
        </div>
    </section>

    <div class="flex flex-col md:flex-row gap-10 items-start relative z-10">

        <aside class="w-full md:w-[320px] flex-shrink-0 bg-white rounded-3xl border border-slate-100 p-8 sticky top-28 max-h-[calc(100vh-10rem)] overflow-y-auto shadow-[0_4px_20px_-4px_rgba(0,0,0,0.05)]">
            <div class="flex justify-between items-center mb-8 pb-4 border-b border-slate-100">
                <h3 class="font-extrabold text-xl flex items-center gap-2.5 text-slate-900"><i data-lucide="sliders-horizontal" class="w-6 h-6 text-blue-500"></i> 상세 검색</h3>
                <button type="reset" form="policySearchForm" class="text-xs font-medium text-slate-400 hover:text-rose-500 underline">초기화</button>
            </div>

            <%-- [Backend/DB] 수정됨: policy_funds 스키마에 맞춘 동적 쿼리용 필터 폼 --%>
            <form id="policySearchForm" class="space-y-6">
                <div>
                    <label class="block text-sm font-semibold text-slate-700 mb-3">자금 구분</label>
                    <select name="category" class="w-full px-4 py-3 bg-slate-50 border border-slate-200 rounded-xl text-sm focus:ring-2 focus:ring-indigo-100 focus:border-indigo-300">
                        <option value="">전체 구분</option>
                        <option value="융자">융자</option>
                        <option value="보증">보증</option>
                        <option value="보험">보험</option>
                    </select>
                </div>

                <div>
                    <label class="block text-sm font-semibold text-slate-700 mb-3">운영 기관</label>
                    <input type="text" name="institution" placeholder="예: 기술보증기금" class="w-full px-4 py-3 bg-slate-50 border border-slate-200 rounded-xl text-sm focus:ring-2 focus:ring-indigo-100 focus:border-indigo-300">
                </div>

                <div>
                    <label class="block text-sm font-semibold text-slate-700 mb-3">접수 상태</label>
                    <div class="flex flex-col gap-2">
                        <label class="flex items-center gap-2 text-sm text-slate-600"><input type="radio" name="application_available_yn" value="Y" class="accent-indigo-600" checked> 접수중 (Y)</label>
                        <label class="flex items-center gap-2 text-sm text-slate-600"><input type="radio" name="application_available_yn" value="N" class="accent-indigo-600"> 마감 (N)</label>
                        <label class="flex items-center gap-2 text-sm text-slate-600"><input type="radio" name="application_available_yn" value="" class="accent-indigo-600"> 상태 무관</label>
                    </div>
                </div>

                <div>
                    <label class="block text-sm font-semibold text-slate-700 mb-3">키워드 검색</label>
                    <input type="text" name="keyword" placeholder="해시태그, 자금명 검색" class="w-full px-4 py-3 bg-slate-50 border border-slate-200 rounded-xl text-sm focus:ring-2 focus:ring-indigo-100 focus:border-indigo-300">
                </div>

                <button type="button" onclick="searchPolicies()" class="w-full bg-slate-900 text-white font-bold py-3.5 rounded-xl hover:bg-slate-800 transition-all duration-300 mt-2 shadow-md hover:-translate-y-0.5">
                    조건 검색
                </button>
            </form>
        </aside>

        <div class="flex-grow flex flex-col gap-8 w-full">

            <div class="flex justify-between items-center px-4 py-3 bg-white rounded-2xl border border-slate-100 shadow-sm">
                <%-- [Backend] 검색 결과 카운트 --%>
                <p class="text-slate-600">총 <strong class="text-indigo-600 font-bold" id="policyCount">42</strong>건의 지원사업을 발견했습니다.</p>
                <div class="flex items-center gap-2 text-sm font-medium text-slate-600 cursor-pointer hover:text-indigo-600 transition">
                    마감임박순 <i data-lucide="chevron-down" class="w-4 h-4"></i>
                </div>
            </div>

            <div class="grid grid-cols-1 md:grid-cols-2 gap-6" id="policyListContainer">
            </div>

            <div id="loadMoreContainer" class="pt-4 hidden">
                <div class="flex justify-center">
                    <button id="loadMoreButton" type="button" class="bg-white border border-slate-200 hover:border-indigo-300 hover:text-indigo-600 text-slate-700 px-6 py-3 rounded-2xl text-sm font-bold shadow-sm transition-all">
                        더보기
                    </button>
                </div>
            </div>

            <div class="grid grid-cols-1 sm:grid-cols-2 gap-4 mt-4">
                <a href="/docs" class="bg-slate-50 hover:bg-slate-100 border border-slate-200 rounded-2xl p-5 flex items-center gap-4 transition-colors group">
                    <div class="p-3 bg-white rounded-xl shadow-sm group-hover:text-indigo-600"><i data-lucide="file-text" class="w-6 h-6"></i></div>
                    <div>
                        <h4 class="font-bold text-slate-900">필수 서류 양식 모음</h4>
                        <p class="text-xs text-slate-500 mt-1">사업계획서, 재무제표 양식 다운로드</p>
                    </div>
                </a>
                <a href="/consulting" class="bg-slate-50 hover:bg-slate-100 border border-slate-200 rounded-2xl p-5 flex items-center gap-4 transition-colors group">
                    <div class="p-3 bg-white rounded-xl shadow-sm group-hover:text-purple-600"><i data-lucide="users" class="w-6 h-6"></i></div>
                    <div>
                        <h4 class="font-bold text-slate-900">정책 지원 컨설팅 연결</h4>
                        <p class="text-xs text-slate-500 mt-1">서류 작성이 어렵다면 전문가의 도움을 받으세요</p>
                    </div>
                </a>
            </div>

        </div>
    </div>
</main>

<script>
    function openAiDiagnosisModal() {
        alert('AI 자가진단 모달이 열립니다.\n(프론트에서 모달을 띄우고, 입력값을 FastAPI로 보내 합격 확률을 계산합니다.)');
    }

    var PAGE_SIZE = 12;
    var currentPage = 0;
    var hasNextPage = false;
    var isLoading = false;
    var scrappedPolicyIds = new Set();

    function escapeHtml(val) {
        return String(val || '').replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;').replace(/"/g,'&quot;');
    }

    function truncate(str, max) {
        if (!str) return '';
        return str.length > max ? str.substring(0, max) + '...' : str;
    }

    function getCategoryStyle(cat) {
        switch (cat) {
            case '융자': return 'bg-indigo-50 text-indigo-600 border-indigo-100';
            case '보증': return 'bg-emerald-50 text-emerald-600 border-emerald-100';
            case '보험': return 'bg-amber-50 text-amber-600 border-amber-100';
            default:     return 'bg-slate-100 text-slate-600 border-slate-200';
        }
    }

    function getStatusBadge(yn) {
        if (yn === 'Y') return '<span class="px-3 py-1 bg-rose-50 text-rose-600 rounded-full text-xs font-bold border border-rose-100">접수중</span>';
        return '<span class="px-3 py-1 bg-slate-100 text-slate-500 rounded-full text-xs font-bold">마감</span>';
    }

    function getSelectedFilters() {
        var ynRadio = document.querySelector('input[name="application_available_yn"]:checked');
        return {
            category: document.querySelector('select[name="category"]').value,
            institution: document.querySelector('input[name="institution"]').value,
            applicationAvailableYn: ynRadio ? ynRadio.value : '',
            keyword: document.querySelector('input[name="keyword"]').value
        };
    }

    function searchPolicies() { loadPolicies(false); }

    function parseHashtags(str, max) {
        if (!str) return '';
        var tags = str.split('#').filter(Boolean).slice(0, max);
        return tags.map(function(t) {
            return '<span class="text-xs text-indigo-500 font-medium">#' + escapeHtml(t.trim()) + '</span>';
        }).join(' ');
    }

    function createPolicyCard(p) {
        var catStyle = getCategoryStyle(p.category);
        var hashtags = parseHashtags(p.hashtags, 3);
        var isScrapped = scrappedPolicyIds.has(Number(p.id));
        var scrapBtnClass = isScrapped
            ? 'text-rose-500 hover:text-rose-700'
            : 'text-slate-300 hover:text-rose-500';
        var scrapFill = isScrapped ? 'fill-rose-500' : '';
        return '' +
            '<div class="bg-white rounded-3xl p-6 border border-slate-100 shadow-[0_4px_20px_-4px_rgba(0,0,0,0.05)] hover:shadow-xl hover:-translate-y-1 transition-all group flex flex-col h-full" data-policy-id="' + p.id + '">' +
                '<div class="flex justify-between items-start mb-4">' +
                    '<span class="px-2.5 py-1 rounded-md text-xs font-bold border ' + catStyle + '">' + escapeHtml(p.category) + '</span>' +
                    '<div class="flex items-center gap-2">' +
                        getStatusBadge(p.applicationAvailableYn) +
                        '<button type="button" onclick="toggleScrap(event,' + p.id + ')" class="transition-colors ' + scrapBtnClass + '" title="스크랩">' +
                            '<i data-lucide="bookmark" class="w-5 h-5 ' + scrapFill + '"></i>' +
                        '</button>' +
                    '</div>' +
                '</div>' +
                '<h4 class="text-xl font-extrabold text-slate-900 mb-2 group-hover:text-indigo-600 transition line-clamp-2">' + escapeHtml(p.fundName) + '</h4>' +
                '<p class="text-sm text-slate-500 mb-4 line-clamp-2 flex-grow">' + escapeHtml(p.businessDescription) + '</p>' +
                '<div class="flex flex-wrap gap-1.5 mb-4">' + hashtags + '</div>' +
                '<div class="flex items-end justify-between border-t border-slate-100 pt-4">' +
                    '<div>' +
                        '<p class="text-xs text-slate-400 mb-1">운영 기관</p>' +
                        '<p class="text-sm font-extrabold text-slate-900">' + escapeHtml(p.institution) + '</p>' +
                    '</div>' +
                    '<div class="w-10 h-10 rounded-full bg-indigo-50 flex items-center justify-center group-hover:bg-indigo-600 group-hover:text-white transition-colors">' +
                        '<i data-lucide="arrow-right" class="w-5 h-5"></i>' +
                    '</div>' +
                '</div>' +
            '</div>';
    }

    async function toggleScrap(event, policyId) {
        event.preventDefault();
        event.stopPropagation();

        var res = await fetch('/api/policies/' + policyId + '/scrap', { method: 'POST' });
        var data = await res.json();

        if (data.error) {
            alert('로그인 후 스크랩할 수 있습니다.');
            return;
        }

        if (data.scrapped) {
            scrappedPolicyIds.add(Number(policyId));
        } else {
            scrappedPolicyIds.delete(Number(policyId));
        }

        // 해당 카드의 버튼만 업데이트
        var card = document.querySelector('[data-policy-id="' + policyId + '"]');
        if (card) {
            var btn = card.querySelector('button[title="스크랩"]');
            if (btn) {
                // lucide.createIcons() 호출 후 <i>가 <svg>로 교체되므로 두 경우 모두 처리
                var icon = btn.querySelector('svg') || btn.querySelector('i');
                if (data.scrapped) {
                    btn.classList.remove('text-slate-300', 'hover:text-rose-500');
                    btn.classList.add('text-rose-500', 'hover:text-rose-700');
                    if (icon) icon.classList.add('fill-rose-500');
                } else {
                    btn.classList.remove('text-rose-500', 'hover:text-rose-700');
                    btn.classList.add('text-slate-300', 'hover:text-rose-500');
                    if (icon) icon.classList.remove('fill-rose-500');
                }
            }
        }
    }

    async function loadPolicies(appendMode) {
        if (isLoading) return;
        var pageToLoad = appendMode ? currentPage + 1 : 0;
        var btn = document.getElementById('loadMoreButton');

        try {
            isLoading = true;
            if (btn) { btn.disabled = true; btn.textContent = '불러오는 중...'; }

            var f = getSelectedFilters();
            var q = new URLSearchParams();
            if (f.category) q.append('category', f.category);
            if (f.institution) q.append('institution', f.institution);
            if (f.applicationAvailableYn) q.append('applicationAvailableYn', f.applicationAvailableYn);
            if (f.keyword) q.append('keyword', f.keyword);
            q.append('page', String(pageToLoad));
            q.append('size', String(PAGE_SIZE));

            var res = await fetch('/api/policies?' + q.toString());
            var data = await res.json();
            var items = data.items || [];
            currentPage = Number(data.page || 0);
            hasNextPage = Boolean(data.hasNext);

            // 첫 로드 시 스크랩 목록 초기화, 더보기 시 추가
            if (!appendMode) {
                scrappedPolicyIds = new Set((data.scrappedPolicyIds || []).map(Number));
            } else {
                (data.scrappedPolicyIds || []).forEach(function(id) { scrappedPolicyIds.add(Number(id)); });
            }

            var container = document.getElementById('policyListContainer');
            if (!appendMode) container.innerHTML = '';

            if (!appendMode && items.length === 0) {
                container.innerHTML =
                    '<div class="col-span-1 md:col-span-2 bg-white rounded-3xl border border-dashed border-slate-200 shadow-sm p-10 text-center">' +
                        '<h3 class="text-lg font-bold text-slate-800 mb-2">정책 목록이 비어 있습니다</h3>' +
                        '<p class="text-sm text-slate-500">조건에 맞는 정책이 없거나 아직 등록된 정책이 없습니다.</p>' +
                    '</div>';
                document.getElementById('policyCount').textContent = '0';
                document.getElementById('loadMoreContainer').classList.add('hidden');
                return;
            }

            items.forEach(function(p) { container.insertAdjacentHTML('beforeend', createPolicyCard(p)); });
            document.getElementById('policyCount').textContent = data.totalElements || 0;

            var loadMoreEl = document.getElementById('loadMoreContainer');
            hasNextPage ? loadMoreEl.classList.remove('hidden') : loadMoreEl.classList.add('hidden');

            if (window.lucide) lucide.createIcons();
        } catch (err) {
            console.error('정책 목록 로딩 오류:', err);
        } finally {
            isLoading = false;
            if (btn) { btn.disabled = false; btn.textContent = '더보기'; }
        }
    }

    document.querySelector('button[type="reset"]').addEventListener('click', function(e) {
        e.preventDefault();
        document.querySelector('select[name="category"]').value = '';
        document.querySelector('input[name="institution"]').value = '';
        document.querySelector('input[name="application_available_yn"][value="Y"]').checked = true;
        document.querySelector('input[name="keyword"]').value = '';
        loadPolicies(false);
    });

    document.getElementById('loadMoreButton').addEventListener('click', function() { loadPolicies(true); });

    // search 페이지에서 넘어온 경우 keyword 자동 적용 + 상태필터 해제
    (function() {
        var params = new URLSearchParams(window.location.search);
        var keyword = params.get('keyword');
        if (keyword) {
            document.querySelector('input[name="keyword"]').value = keyword;
            // 기본값 "접수중(Y)" 해제 → 상태 무관으로 변경 (search 결과와 건수 일치)
            document.querySelector('input[name="application_available_yn"][value=""]').checked = true;
        }
    })();
    loadPolicies(false);
</script>

<%-- 푸터 파일 로드 --%>
<jsp:include page="/WEB-INF/views/common/footer.jsp" />
