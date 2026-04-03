<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<jsp:include page="/WEB-INF/views/common/header.jsp" />

<main class="flex-1 flex items-center justify-center bg-[#F8FAFC] py-10 px-4 mb-[-64px]">
    <div class="max-w-md w-full bg-white p-8 rounded-2xl shadow-sm border border-slate-100">
        <div class="text-center mb-8">
            <div class="inline-flex items-center justify-center w-12 h-12 bg-blue-50 text-blue-600 rounded-xl mb-4">
                <i data-lucide="user-search" class="w-6 h-6"></i>
            </div>
            <h2 class="text-2xl font-bold text-slate-900">아이디 찾기</h2>
            <p class="text-slate-500 mt-2 text-sm">가입 시 등록한 이름과 휴대폰 번호를 입력하세요.</p>
        </div>

        <form class="space-y-5" action="/findID" method="POST">
            <div>
                <label for="name" class="block text-sm font-medium text-slate-700 mb-1.5">이름</label>
                <input type="text" id="name" name="name" required
                       class="w-full px-4 py-3 border border-slate-200 rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-500 transition text-sm shadow-sm"
                       placeholder="성함을 입력해주세요">
            </div>
            <div>
                <label for="phone" class="block text-sm font-medium text-slate-700 mb-1.5">휴대폰 번호</label>
                <input type="tel" id="phone" name="phone" required
                       class="w-full px-4 py-3 border border-slate-200 rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-500 transition text-sm shadow-sm"
                       placeholder="010-0000-0000">
            </div>
            <button type="submit" 
                    class="w-full py-3.5 bg-slate-900 text-white rounded-xl font-bold text-sm hover:bg-slate-800 transition shadow-lg hover:-translate-y-0.5 mt-2">
                아이디 확인하기
            </button>
        </form>

        <div class="mt-8 pt-6 border-t border-slate-50 flex justify-between items-center text-xs">
            <a href="/login" class="text-slate-400 hover:text-slate-600 transition flex items-center gap-1">
                <i data-lucide="arrow-left" class="w-3.5 h-3.5"></i> 로그인으로 돌아가기
            </a>
            <a href="/findPWD" class="text-blue-600 font-semibold hover:underline">비밀번호 찾기</a>
        </div>
    </div>
</main>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />