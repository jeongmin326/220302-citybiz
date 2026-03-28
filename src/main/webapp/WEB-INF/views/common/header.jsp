<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>City Biz Hub - 도시 비즈니스 통합 플랫폼</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script src="https://cdn.jsdelivr.net/npm/axios/dist/axios.min.js"></script>
    <script src="https://unpkg.com/lucide@latest"></script>
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Pretendard:wght@400;500;600;700&display=swap');
        body { font-family: 'Pretendard', sans-serif; }
    </style>
</head>
<body class="bg-gray-50 flex flex-col min-h-screen">

    <nav class="bg-white border-b sticky top-0 z-50">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
            <div class="flex justify-between h-16 items-center">
                <div class="flex items-center gap-8">
                    <a href="/" class="text-2xl font-bold text-blue-600 flex items-center gap-2 hover:opacity-80 transition">
                        <i data-lucide="building-2"></i> CityBiz
                    </a>
                </div>
                
                <div class="flex items-center gap-4">
                    <c:choose>
                        <%-- [Backend] 로그인 성공 시 세션에 loginUser 객체와 loginName이 있는지 확인 --%>
                        <c:when test="${not empty sessionScope.loginUser}">
                            <div class="flex items-center gap-3">
                                <div class="flex items-center gap-2 bg-gray-100 text-gray-700 px-3 py-1.5 rounded-full text-sm font-medium">
                                    <i data-lucide="user-circle" class="w-4 h-4 text-blue-500"></i>
                                    <span><strong class="text-blue-600">${sessionScope.loginName}</strong>님 환영합니다</span>
                                </div>
                                <a href="/logout" class="text-sm font-medium text-gray-500 hover:text-red-500 transition flex items-center gap-1">
                                    <i data-lucide="log-out" class="w-4 h-4"></i> 로그아웃
                                </a>
                            </div>
                        </c:when>
                        
                        <c:otherwise>
                            <a href="/login" class="text-sm font-medium text-gray-600 hover:text-blue-600 transition flex items-center gap-1">
                                <i data-lucide="log-in" class="w-4 h-4"></i> 로그인
                            </a>
                            <a href="/signup" class="bg-blue-600 hover:bg-blue-700 text-white px-4 py-2 rounded-lg text-sm transition shadow-sm font-medium flex items-center gap-1">
                                회원가입
                            </a>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </nav>
    
    <main class="flex-grow">
        </main>

    <script>
        lucide.createIcons();
    </script>
</body>
</html>