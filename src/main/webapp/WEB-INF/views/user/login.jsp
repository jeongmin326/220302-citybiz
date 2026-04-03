<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%-- 헤더 파일 로드 --%>
<jsp:include page="/WEB-INF/views/common/header.jsp" />

<main class="flex-1 flex items-center justify-center bg-[#F8FAFC] py-6 px-4 mb-[-64px]">
    <div class="max-w-md w-full bg-white p-8 rounded-2xl shadow-sm border border-slate-100">
        <div class="text-center mb-8">
            <h2 class="text-3xl font-bold text-slate-900 tracking-tight">로그인</h2>
            <p class="text-slate-500 mt-2 text-sm">CityBiz의 맞춤형 자원 추천을 경험하세요.</p>
        </div>

        <c:if test="${param.error eq 'true'}">
            <div class="mb-4 rounded-lg bg-rose-50 border border-rose-100 px-4 py-3 text-sm text-rose-600">
                이메일 또는 비밀번호가 올바르지 않습니다.
            </div>
        </c:if>

        <form class="space-y-6" action="/login" method="POST">
            <div>
                <label for="email" class="block text-sm font-medium text-slate-700">이메일 (아이디)</label>
                <div class="mt-1 relative">
                    <input id="email" name="email" type="email" required 
                           class="appearance-none block w-full px-4 py-3 border border-slate-200 rounded-xl placeholder-slate-400 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent transition text-sm" 
                           placeholder="you@example.com">
                    <i data-lucide="mail" class="absolute right-4 top-3.5 text-slate-400 w-5 h-5"></i>
                </div>
            </div>

            <div>
                <label for="password" class="block text-sm font-medium text-slate-700">비밀번호</label>
                <div class="mt-1 relative">
                    <input id="password" name="password" type="password" required 
                           class="appearance-none block w-full px-4 py-3 border border-slate-200 rounded-xl placeholder-slate-400 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent transition text-sm" 
                           placeholder="••••••••">
                    <i data-lucide="lock" class="absolute right-4 top-3.5 text-slate-400 w-5 h-5"></i>
                </div>
            </div>

            <div class="flex items-center justify-between">
                <div class="flex items-center">
                    <input id="remember-id" name="rememberId" type="checkbox"
                        class="h-4 w-4 text-blue-600 focus:ring-blue-500 border-slate-300 rounded"
                        <c:if test="${not empty cookie.rememberEmail.value}">checked</c:if>>
                    <label for="remember-id" class="ml-2 block text-sm text-slate-600 cursor-pointer">아이디 저장</label>
                </div>

                <div class="text-sm space-x-2">
                    <a href="/findID" class="font-medium text-blue-600 hover:text-blue-500 transition">아이디 찾기</a>
                    <span class="text-slate-300 text-xs">|</span>
                    <a href="/findPWD" class="font-medium text-blue-600 hover:text-blue-500 transition">비밀번호 찾기</a>
                </div>
            </div>

            <div>
                <button type="submit" class="w-full flex justify-center py-3 px-4 border border-transparent rounded-xl shadow-md text-sm font-bold text-white bg-slate-900 hover:bg-slate-800 transition-all transform hover:-translate-y-0.5">
                    로그인
                </button>
            </div>
        </form>

        <div class="mt-6 text-center">
            <p class="text-sm text-slate-600">
                아직 계정이 없으신가요? 
                <a href="/signup" class="font-bold text-blue-600 hover:text-blue-500 transition ml-1 underline underline-offset-4">회원가입</a>
            </p>
        </div>
    </div>
</main>

<%-- 푸터 파일 로드 --%>
<jsp:include page="/WEB-INF/views/common/footer.jsp" />

<script>
    // URL 파라미터 처리 (성공/실패 알림)
    const params = new URLSearchParams(window.location.search);
    if (params.get('signup') === 'success') alert('회원가입이 완료되었습니다!');
    
    // Lucide 아이콘은 footer.jsp 하단 스크립트에서 자동 실행됩니다.
</script>