<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%-- 헤더 파일 로드 --%>
<jsp:include page="/WEB-INF/views/common/header.jsp" />


<div class="flex items-center justify-center py-20 px-4 sm:px-6 lg:px-8">
    <div class="max-w-md w-full bg-white p-8 rounded-2xl shadow-sm border border-gray-100">
        <div class="text-center mb-8">
            <h2 class="text-3xl font-bold text-gray-900 tracking-tight">로그인</h2>
            <p class="text-gray-500 mt-2 text-sm">CityBiz의 맞춤형 자원 추천을 경험하세요.</p>
        </div>
        <!-- ***** -->
        <!-- 03/28 18:55 로그인 실패시 뜨는 문구 추가 -->
        <!-- ***** -->
        <c:if test="${param.error eq 'true'}">
            <div class="mb-4 rounded-lg bg-red-50 border border-red-200 px-4 py-3 text-sm text-red-600">
                이메일 또는 비밀번호가 올바르지 않습니다.
            </div>
        </c:if>
        <form class="space-y-6" action="/login" method="POST">
            <div>
                <label for="email" class="block text-sm font-medium text-gray-700">이메일 (아이디)</label>
                <div class="mt-1 relative">
                    <input id="email" name="email" type="email" required 
                           class="appearance-none block w-full px-4 py-3 border border-gray-300 rounded-xl placeholder-gray-400 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent transition" 
                           placeholder="you@example.com">
                    <i data-lucide="mail" class="absolute right-4 top-3.5 text-gray-400 w-5 h-5"></i>
                </div>
            </div>

            <div>
                <label for="password" class="block text-sm font-medium text-gray-700">비밀번호</label>
                <div class="mt-1 relative">
                    <input id="password" name="password" type="password" required 
                           class="appearance-none block w-full px-4 py-3 border border-gray-300 rounded-xl placeholder-gray-400 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent transition" 
                           placeholder="••••••••">
                    <i data-lucide="lock" class="absolute right-4 top-3.5 text-gray-400 w-5 h-5"></i>
                </div>
            </div>

            <div class="flex items-center justify-between">
                <div class="flex items-center">
                    <!-- ***** -->
                    <!-- 03/28 18:51 자동 로그인이 너무 빡세서 아이디 저장으로 수정해보았습니다요..
                     별로면 말씀주시길.. -->
                    <!-- ***** -->
                    <input id="remember-id" name="rememberId" type="checkbox"
                        class="h-4 w-4 text-blue-600 focus:ring-blue-500 border-gray-300 rounded"
                        <c:if test="${not empty cookie.rememberEmail.value}">checked</c:if>>
                    <label for="remember-id" class="ml-2 block text-sm text-gray-700">아이디 저장</label>
                </div>

                <!-- 아이디찾기추가 -->
                <div class="text-sm">
                    <a href="/findID" class="font-medium text-blue-600 hover:text-blue-500">아이디 찾기</a>
                    <a href="/findPWD" class="font-medium text-blue-600 hover:text-blue-500">비밀번호 찾기</a>
                </div>
            </div>

            <div>
                <button type="submit" class="w-full flex justify-center py-3 px-4 border border-transparent rounded-xl shadow-sm text-sm font-bold text-white bg-blue-600 hover:bg-blue-700 transition">
                    로그인
                </button>
            </div>
        </form>

        <div class="mt-6 text-center">
            <p class="text-sm text-gray-600">
                아직 계정이 없으신가요? 
                <a href="/join" class="font-medium text-blue-600 hover:text-blue-500 transition">회원가입</a>
            </p>
        </div>
    </div>
</div>

<%-- 푸터 파일 로드 --%>
<jsp:include page="/WEB-INF/views/common/footer.jsp" />