<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>오류 발생</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script src="https://unpkg.com/lucide@latest"></script>
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Pretendard:wght@300;400;500;600;700;800&display=swap');
        body { font-family: 'Pretendard', sans-serif; }
    </style>
</head>
<body class="min-h-screen bg-[#F8FAFC] flex items-center justify-center px-4">

    <div class="max-w-md w-full bg-white rounded-2xl border border-slate-100 shadow-sm p-12 text-center">

        <div class="w-16 h-16 rounded-2xl bg-rose-50 flex items-center justify-center mx-auto mb-6">
            <i data-lucide="alert-circle" class="w-8 h-8 text-rose-500"></i>
        </div>

        <h2 class="text-xl font-bold text-slate-800 mb-2">무언가 잘못되었습니다</h2>
        <p class="text-slate-500 text-sm mb-8">${errorMessage}</p>

        <a href="/main"
           class="inline-flex items-center gap-2 bg-slate-900 hover:bg-slate-800 text-white px-6 py-3 rounded-xl font-semibold transition-all">
            <i data-lucide="house" class="w-4 h-4"></i>
            홈으로 이동
        </a>

    </div>

    <script>lucide.createIcons();</script>
</body>
</html>
