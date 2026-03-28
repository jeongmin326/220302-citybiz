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
                    <a href="/" class="text-2xl font-bold text-blue-600 flex items-center gap-2">
                        <i data-lucide="building-2"></i> CityBiz
                    </a>
                    <div class="hidden md:flex space-x-6 text-gray-600 font-medium">
                        <a href="/facility/list" class="hover:text-blue-600 transition">자원지도</a>
                        <a href="#" class="hover:text-blue-600 transition">지원사업</a>
                        <a href="#" class="hover:text-blue-600 transition">AI컨설팅</a>
                    </div>
                </div>
                <div class="flex items-center gap-4">
                    <!-- ***** -->
                    <!-- 03/28 18:42 로그인했을때, 안했을때 각 상황에서 뜨는 멘트 수정(이쁘게해주세요) -->
                    <!-- ***** -->
                    <c:choose>
                        <c:when test="${not empty sessionScope.loginUser}">
                            <span>${sessionScope.loginName}님</span>
                            <a href="/logout">로그아웃</a>
                        </c:when>
                        <c:otherwise>
                            <a href="/login" class="text-sm font-medium text-gray-700 hover:text-blue-600 transition">로그인</a>
                            <a href="/logout" class="bg-blue-600 hover:bg-blue-700 text-white px-4 py-2 rounded-lg text-sm transition shadow-sm font-medium">회원가입</a>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </nav>
    
    <main class="flex-grow">