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
        <form action="/api/expert/profile" method="POST" enctype="multipart/form-data" class="bg-white rounded-3xl p-8 border border-slate-200 shadow-sm">
            
            <div class="space-y-8">
                <%-- 1. 기본 정보 --%>
                <section>
                    <h2 class="text-lg font-bold text-slate-900 border-b border-slate-100 pb-3 mb-5 flex items-center gap-2">
                        <i data-lucide="user" class="w-5 h-5 text-purple-500"></i> 기본 정보
                    </h2>
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                        <div>
                            <label class="block text-sm font-semibold text-slate-700 mb-2">전문가 이름 (또는 소속)</label>
                            <input type="text" name="expertName" class="w-full px-4 py-3 bg-slate-50 border border-slate-200 rounded-xl text-sm focus:outline-none focus:ring-2 focus:ring-purple-500 transition-all">
                        </div>
                        <div>
                            <label class="block text-sm font-semibold text-slate-700 mb-2">전문 분야</label>
                            <select name="category" class="w-full px-4 py-3 bg-slate-50 border border-slate-200 rounded-xl text-sm focus:outline-none focus:ring-2 focus:ring-purple-500 transition-all">
                                <option value="law">법률/특허</option>
                                <option value="tax">세무/회계</option>
                                <option value="marketing" selected>마케팅/PR</option>
                                <option value="it">IT/개발</option>
                                <option value="design">디자인/브랜딩</option>
                            </select>
                        </div>
                    </div>
                </section>

                <%-- 2. 상세 소개 --%>
                <section>
                    <h2 class="text-lg font-bold text-slate-900 border-b border-slate-100 pb-3 mb-5 flex items-center gap-2">
                        <i data-lucide="file-text" class="w-5 h-5 text-purple-500"></i> 상세 소개
                    </h2>
                    <div class="space-y-5">
                        <div>
                            <label class="block text-sm font-semibold text-slate-700 mb-2">한 줄 소개 <span class="text-rose-500">*</span></label>
                            <input type="text" name="shortIntro" placeholder="예: 매출을 3배 올려주는 퍼포먼스 마케터입니다." class="w-full px-4 py-3 bg-slate-50 border border-slate-200 rounded-xl text-sm focus:outline-none focus:ring-2 focus:ring-purple-500 transition-all" required>
                        </div>
                        <div>
                            <label class="block text-sm font-semibold text-slate-700 mb-2">상세 경력 및 제공 서비스</label>
                            <textarea name="detailIntro" rows="6" placeholder="진행했던 주요 프로젝트, 경력, 제공할 수 있는 컨설팅 내용을 자세히 적어주세요." class="w-full px-4 py-3 bg-slate-50 border border-slate-200 rounded-xl text-sm focus:outline-none focus:ring-2 focus:ring-purple-500 transition-all"></textarea>
                        </div>
                    </div>
                </section>

                <%-- 3. 포트폴리오 / 이력서 --%>
                <section>
                    <h2 class="text-lg font-bold text-slate-900 border-b border-slate-100 pb-3 mb-5 flex items-center gap-2">
                        <i data-lucide="paperclip" class="w-5 h-5 text-purple-500"></i> 포트폴리오
                    </h2>
                    <div>
                        <label class="block text-sm font-semibold text-slate-700 mb-2">포트폴리오 파일 또는 이력서 첨부</label>
                        <input type="file" name="portfolioFile" class="block w-full text-sm text-slate-500 file:mr-4 file:py-2.5 file:px-4 file:rounded-xl file:border-0 file:text-sm file:font-semibold file:bg-purple-50 file:text-purple-700 hover:file:bg-purple-100 cursor-pointer border border-slate-200 rounded-xl p-1.5">
                        <p class="text-xs text-slate-400 mt-2">PDF, PPT, DOCX 형식만 지원됩니다. (최대 10MB)</p>
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
        // 루사이드 아이콘 초기화
        lucide.createIcons();
    </script>
</body>
</html>