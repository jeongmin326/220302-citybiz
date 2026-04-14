<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>CityBiz - 프리미엄 비즈니스 자원 플랫폼</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script src="https://cdn.jsdelivr.net/npm/axios/dist/axios.min.js"></script>
    <script src="https://unpkg.com/lucide@latest"></script>
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Pretendard:wght@300;400;500;600;700;800&display=swap');
        body { 
            font-family: 'Pretendard', sans-serif; 
            -webkit-font-smoothing: antialiased;
            -moz-osx-font-smoothing: grayscale;
        }
        .custom-scrollbar::-webkit-scrollbar { width: 5px; }
        .custom-scrollbar::-webkit-scrollbar-track { background: transparent; }
        .custom-scrollbar::-webkit-scrollbar-thumb { background-color: #E2E8F0; border-radius: 20px; }
        .hidden-checkbox:checked + label {
            background-color: #EFF6FF;
            border-color: #BFDBFE; color: #2563EB; font-weight: 600;
        }
    </style>
</head>
<body class="bg-[#F8FAFC] flex flex-col min-h-screen text-slate-800">

    <nav class="sticky top-0 z-50 bg-white/80 backdrop-blur-md border-b border-slate-200/60">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
            <div class="flex justify-between h-20 items-center">
                <div class="flex items-center gap-8">
                    <a href="/main" class="text-3xl font-extrabold tracking-tight flex items-center gap-2 group">
                        <div class="p-2 bg-gradient-to-br from-blue-600 to-indigo-600 rounded-xl text-white shadow-lg group-hover:scale-105 transition-transform duration-300">
                            <i data-lucide="building-2" class="w-6 h-6"></i>
                        </div>
                        <span class="bg-clip-text text-transparent bg-gradient-to-r from-slate-900 to-slate-700 hover:opacity-80 transition">CityBiz</span>
                    </a>
                </div>
                
                <nav class="hidden md:flex space-x-9" id="gnb-menu">
                    <a href="/space" class="nav-link text-base font-medium text-slate-600 hover:text-blue-600 transition-colors">공간 대여</a>
                    <a href="/policy" class="nav-link text-base font-medium text-slate-600 hover:text-blue-600 transition-colors">정책 지원</a>
                    <a href="/consulting" class="nav-link text-base font-medium text-slate-600 hover:text-blue-600 transition-colors">컨설팅 네트워크</a>
                    <a href="/about" class="nav-link text-base font-medium text-slate-600 hover:text-blue-600 transition-colors">사이트 소개</a>
                </nav>

                <div class="flex items-center gap-5">
                    <c:choose>
                        <%-- [Backend/DB] Spring Security 적용 또는 HttpSession에 로그인 사용자 정보(loginUser, loginName)가 담겨 넘어오는 시점에 활성화됩니다. --%>
                        <c:when test="${not empty sessionScope.loginUser}">
                            <div class="flex items-center gap-4">
                                <div class="flex items-center gap-2 px-4 py-2 bg-white border border-slate-200 rounded-full shadow-sm text-sm font-medium">
                                    <div class="w-6 h-6 rounded-full bg-gradient-to-tr from-blue-500 to-indigo-500 flex items-center justify-center text-white text-xs font-bold shadow-inner">
                                        ${fn:substring(sessionScope.loginName, 0, 1)}
                                    </div>
                                    <span class="text-slate-700"><strong class="text-slate-900">${sessionScope.loginName}</strong> 님</span>
                                </div>
                                <a href="/logout" class="text-sm font-medium text-slate-500 hover:text-rose-500 transition-colors flex items-center gap-1.5">
                                    <i data-lucide="log-out" class="w-4 h-4"></i> 로그아웃
                                </a>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <a href="/login" class="text-sm font-semibold text-slate-600 hover:text-blue-600 transition-colors">로그인</a>
                            <a href="/signup" class="bg-slate-900 hover:bg-slate-800 text-white px-5 py-2.5 rounded-xl text-sm font-semibold transition-all duration-200 shadow-md hover:shadow-lg hover:-translate-y-0.5">시작하기</a>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </nav>

    <script>
        document.addEventListener("DOMContentLoaded", function() {
            // 현재 브라우저 URL의 경로를 가져옴 (예: /space, /policy)
            const currentPath = window.location.pathname;
            const navLinks = document.querySelectorAll('.nav-link');
            
            // 활성화 되었을 때의 Tailwind 클래스
            const activeClasses = ['font-semibold', 'text-blue-600', 'relative', 'after:content-[""]', 'after:absolute', 'after:bottom-[-6px]', 'after:left-0', 'after:w-full', 'after:h-[2px]', 'after:bg-blue-600', 'after:rounded-full'];
            // 비활성화(기본) 되었을 때의 Tailwind 클래스
            const inactiveClasses = ['font-medium', 'text-slate-600'];

            navLinks.forEach(link => {
                const href = link.getAttribute('href');
                
                // 현재 URL이 href 경로를 포함하고 있다면 해당 메뉴 활성화
                if (currentPath.startsWith(href)) {
                    link.classList.remove(...inactiveClasses);
                    link.classList.add(...activeClasses);
                }
            });
        });
    </script>