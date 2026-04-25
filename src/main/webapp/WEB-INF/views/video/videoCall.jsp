<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>영상통화</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script src="https://unpkg.com/lucide@latest"></script>
    <script src="https://cdn.jsdelivr.net/npm/sockjs-client@1/dist/sockjs.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/stompjs@2.3.3/lib/stomp.min.js"></script>
    <style>
        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, sans-serif;
        }
        .control-button {
            @apply w-16 h-16 rounded-full flex items-center justify-center transition-all duration-200 active:scale-90;
        }
        .floating-island {
            animation: slideUp 0.4s cubic-bezier(0.34, 1.56, 0.64, 1);
        }
        @keyframes slideUp {
            from {
                transform: translateY(100px);
                opacity: 0;
            }
            to {
                transform: translateY(0);
                opacity: 1;
            }
        }
    </style>
</head>
<body class="bg-black">
    <div class="w-full h-screen flex flex-col">
        <!-- 비디오 영역 -->
        <div class="flex-1 bg-black relative overflow-hidden" id="videoContainer">
            <!-- 상대방 비디오 -->
            <video id="remoteVideo" autoplay playsinline class="w-full h-full object-cover"></video>

            <!-- 내 비디오 (우측 상단 PIP) -->
            <div class="absolute top-6 right-6 w-44 h-32 bg-black rounded-2xl overflow-hidden border-2 border-white/20 shadow-2xl">
                <video id="localVideo" autoplay playsinline muted class="w-full h-full object-cover"></video>
            </div>

            <!-- 상단 정보 (항상 표시) -->
            <div class="absolute top-6 left-6 z-20">
                <div class="flex items-center gap-2 mb-1">
                    <h1 class="text-2xl font-bold text-white">${requestTitle}</h1>
                    <span class="text-sm text-gray-400">|</span>
                    <span class="text-sm text-gray-300">${otherUserInfo}</span>
                </div>
                <div class="flex items-center gap-2 mt-3">
                    <div id="statusDot" class="w-3 h-3 bg-yellow-500 rounded-full animate-pulse"></div>
                    <span id="statusText" class="text-sm font-medium text-yellow-400">대기 중</span>
                </div>
            </div>

            <!-- 시간 표시 (우측 상단) -->
            <div class="absolute top-6 right-60 z-20">
                <div class="bg-black/70 backdrop-blur-md px-4 py-2 rounded-full border border-white/10">
                    <span class="text-xl font-bold text-white font-mono" id="timer">00:00</span>
                </div>
            </div>

            <!-- 상태 배너 (우측 하단) -->
            <div id="statusBanner" class="absolute bottom-32 right-6 bg-slate-900 backdrop-blur rounded-2xl shadow-lg px-5 py-3 hidden z-30 text-sm font-semibold text-white flex items-center gap-2 border border-white/10">
                <div class="w-2 h-2 bg-blue-400 rounded-full animate-pulse"></div>
                <span id="statusBannerText">연결 중...</span>
            </div>

            <!-- 상태 모달 (필요할 때만) -->
            <div id="stateOverlay" class="absolute inset-0 bg-black/60 backdrop-blur-md flex items-center justify-center hidden z-40">
                <div class="bg-slate-900 rounded-3xl p-8 shadow-2xl max-w-sm mx-4 border border-white/10">
                    <div id="stateMessage" class="text-center">
                        <p class="text-white text-xl font-semibold"></p>
                    </div>
                </div>
            </div>

            <!-- 연장 버튼 (좌측 상단, 항상 표시) -->
            <div id="extensionBanner" class="absolute top-28 left-6 bg-white/95 backdrop-blur rounded-2xl shadow-lg px-5 py-3 z-30 cursor-pointer hover:bg-white transition-all text-sm font-semibold text-slate-900 flex items-center gap-2" onclick="showExtensionAlert()">
                <span class="text-lg">⏱️</span>
                <span>시간 연장</span>
            </div>

            <!-- 연장 알림 팝업 -->
            <div id="extensionAlert" class="absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 bg-white rounded-3xl shadow-2xl p-6 w-96 hidden z-50 border border-slate-200">
                <div class="flex items-center gap-2 mb-4">
                    <span class="text-2xl">⏱️</span>
                    <p class="font-bold text-slate-900 text-lg" id="extensionAlertMsg"></p>
                </div>
                <p class="text-sm text-slate-600 mb-4">연장 시간을 선택하세요</p>
                <div class="grid grid-cols-3 gap-3 mb-4">
                    <button onclick="selectExtensionTime(45)" class="px-3 py-2.5 bg-slate-100 hover:bg-blue-100 text-slate-900 rounded-lg text-xs font-bold transition-colors extension-time-btn border border-slate-200" id="timeBtn45">
                        <div class="font-semibold">45초</div>
                        <div class="text-amber-600 mt-1 text-xs" id="price45">-</div>
                    </button>
                    <button onclick="selectExtensionTime(600)" class="px-3 py-2.5 bg-slate-100 hover:bg-blue-100 text-slate-900 rounded-lg text-xs font-bold transition-colors extension-time-btn border border-slate-200" id="timeBtn600">
                        <div class="font-semibold">10분</div>
                        <div class="text-amber-600 mt-1 text-xs" id="price600">-</div>
                    </button>
                    <button onclick="selectExtensionTime(1200)" class="px-3 py-2.5 bg-slate-100 hover:bg-blue-100 text-slate-900 rounded-lg text-xs font-bold transition-colors extension-time-btn border border-slate-200" id="timeBtn1200">
                        <div class="font-semibold">20분</div>
                        <div class="text-amber-600 mt-1 text-xs" id="price1200">-</div>
                    </button>
                </div>
                <div class="flex gap-2">
                    <button onclick="proceedExtensionPayment('POINT')" class="flex-1 px-4 py-2.5 bg-blue-600 hover:bg-blue-700 text-white rounded-xl text-sm font-bold transition-colors" id="pointPayBtn" style="display:none;">포인트 연장</button>
                    <button onclick="hideExtensionAlert()" class="flex-1 px-4 py-2.5 bg-slate-200 hover:bg-slate-300 text-slate-700 rounded-xl text-sm font-bold transition-colors">취소</button>
                </div>
            </div>

            <!-- 하단 컨트롤 바 (일렬식) -->
            <div class="absolute bottom-8 left-1/2 -translate-x-1/2 z-20 flex gap-3 items-center floating-island">
                <!-- 마이크 버튼 -->
                <button id="micBtn" class="flex flex-col items-center gap-2 px-6 py-3 bg-white/10 hover:bg-white/20 text-white rounded-2xl font-medium transition-all border border-white/20 hover:border-white/40 backdrop-blur">
                    <span class="text-3xl">🎤</span>
                    <span class="text-xs">마이크</span>
                </button>

                <!-- 카메라 버튼 -->
                <button id="cameraBtn" class="flex flex-col items-center gap-2 px-6 py-3 bg-white/10 hover:bg-white/20 text-white rounded-2xl font-medium transition-all border border-white/20 hover:border-white/40 backdrop-blur">
                    <span class="text-3xl">📹</span>
                    <span class="text-xs">카메라</span>
                </button>

                <!-- 통화 시작 버튼 -->
                <button id="initiateCallBtn" class="flex flex-col items-center gap-2 px-6 py-3 bg-green-600 hover:bg-green-700 text-white rounded-2xl font-medium transition-all shadow-lg shadow-green-600/50 border border-green-500/50 backdrop-blur hidden">
                    <span class="text-3xl">☎️</span>
                    <span class="text-xs">전화 시작</span>
                </button>

                <!-- 수락 버튼 -->
                <button id="acceptCallBtn" class="flex flex-col items-center gap-2 px-6 py-3 bg-green-600 hover:bg-green-700 text-white rounded-2xl font-medium transition-all shadow-lg shadow-green-600/50 border border-green-500/50 backdrop-blur hidden">
                    <span class="text-3xl">✓</span>
                    <span class="text-xs">수락</span>
                </button>

                <!-- 거절 버튼 -->
                <button id="rejectCallBtn" class="flex flex-col items-center gap-2 px-6 py-3 bg-red-600 hover:bg-red-700 text-white rounded-2xl font-medium transition-all shadow-lg shadow-red-600/50 border border-red-500/50 backdrop-blur hidden">
                    <span class="text-3xl">✕</span>
                    <span class="text-xs">거절</span>
                </button>
            </div>
        </div>
    </div>

    <script>
        const config = {
            requestId: ${requestId},
            myUserId: ${myUserId},
            otherUserId: ${otherUserId},
            isExpert: ${isExpert},
            durationSeconds: ${durationSeconds},
            sessionPrice: ${sessionPrice},
            callInitiated: ${callInitiated}
        };
        window.videoCallConfig = config;
    </script>
    <script src="/static/js/webrtc-client.js"></script>
</body>
</html>
