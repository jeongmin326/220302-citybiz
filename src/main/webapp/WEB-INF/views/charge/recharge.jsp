<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>포인트 충전 - City Biz Hub</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script src="https://unpkg.com/lucide@latest"></script>
    <script src="https://cdn.iamport.kr/v1/iamport.js"></script>
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Pretendard:wght@400;500;600;700;800&display=swap');
        body {
            font-family: 'Pretendard', sans-serif;
            -webkit-font-smoothing: antialiased;
            background-color: #ffffff;
        }

        .charge-card {
            border: 1px solid #475569;
            background-color: #ffffff;
            transition: all 0.2s ease-in-out;
            display: flex;
            align-items: center;
            padding: 1.25rem;
            border-radius: 1rem;
            position: relative;
        }

        .charge-option:checked + .charge-card {
            border-color: #2563eb;
            background-color: #f0f7ff;
            box-shadow: 0 0 0 1px #2563eb;
        }

        .charge-card .icon-check { display: none; }
        .charge-option:checked + .charge-card .icon-uncheck { display: none; }
        .charge-option:checked + .charge-card .icon-check {
            display: block;
            color: #2563eb;
        }

        .pay-method-option:checked + .pay-method-card {
            border-color: #2563eb;
            background-color: #f0f7ff;
            color: #1e40af;
        }
    </style>
</head>
<body class="flex flex-col min-h-screen text-slate-800">

    <jsp:include page="/WEB-INF/views/common/header.jsp" />

    <main class="flex-grow max-w-xl mx-auto w-full px-6 py-12">

        <div class="mb-8">
            <h2 class="text-2xl font-bold text-slate-900">포인트 충전</h2>
            <p class="text-slate-500 text-sm mt-1">원하는 만큼 포인트를 충전하고 서비스를 이용하세요.</p>
        </div>

        <div class="bg-sky-50 rounded-2xl p-6 border border-sky-100 mb-10 flex items-center gap-4">
            <div class="w-12 h-12 bg-white rounded-full flex items-center justify-center shadow-sm">
                <i data-lucide="wallet" class="text-sky-500 w-6 h-6"></i>
            </div>
            <div>
                <p class="text-sm font-semibold text-sky-700 mb-0.5">나의 보유 포인트</p>
                <p class="text-3xl font-extrabold text-slate-900 flex items-baseline">
                    <span id="currentPointDisplay">${currentPoint != null ? currentPoint : '0'}</span> <span class="text-xl font-bold text-sky-600 ml-1">P</span>
                </p>
            </div>
        </div>

        <div class="mb-12">
            <h4 class="font-bold text-slate-900 mb-4 px-1">충전할 금액</h4>
            <div class="grid grid-cols-2 gap-3">

                <label class="cursor-pointer">
                    <input type="radio" name="chargeAmount" value="5000" class="charge-option hidden" onchange="syncAmount(5000)">
                    <div class="charge-card h-full">
                        <div class="mr-4 flex-shrink-0">
                            <i data-lucide="circle" class="icon-uncheck w-6 h-6 text-slate-300"></i>
                            <i data-lucide="check-circle-2" class="icon-check w-6 h-6"></i>
                        </div>
                        <div class="flex flex-col">
                            <span class="text-lg font-extrabold text-slate-800">5,000P</span>
                            <span class="text-xs font-medium text-slate-500">5,000원</span>
                        </div>
                    </div>
                </label>

                <label class="cursor-pointer">
                    <input type="radio" name="chargeAmount" value="10000" class="charge-option hidden" onchange="syncAmount(10000)">
                    <div class="charge-card h-full overflow-hidden">
                        <div class="absolute -top-0 -right-0 bg-sky-500 text-white text-[10px] px-2 py-0.5 rounded-bl-lg font-bold">
                            +2% 적립
                        </div>
                        <div class="mr-4 flex-shrink-0">
                            <i data-lucide="circle" class="icon-uncheck w-6 h-6 text-slate-300"></i>
                            <i data-lucide="check-circle-2" class="icon-check w-6 h-6"></i>
                        </div>
                        <div class="flex flex-col">
                            <span class="text-lg font-extrabold text-slate-800">10,000P</span>
                            <span class="text-xs font-medium text-slate-500">10,000원</span>
                        </div>
                    </div>
                </label>

                <label class="cursor-pointer">
                    <input type="radio" name="chargeAmount" value="30000" class="charge-option hidden" onchange="syncAmount(30000)">
                    <div class="charge-card h-full overflow-hidden">
                        <div class="absolute -top-0 -right-0 bg-blue-600 text-white text-[10px] px-2 py-0.5 rounded-bl-lg font-bold">
                            +3% 적립
                        </div>
                        <div class="mr-4 flex-shrink-0">
                            <i data-lucide="circle" class="icon-uncheck w-6 h-6 text-slate-300"></i>
                            <i data-lucide="check-circle-2" class="icon-check w-6 h-6"></i>
                        </div>
                        <div class="flex flex-col">
                            <span class="text-lg font-extrabold text-slate-800">30,000P</span>
                            <span class="text-xs font-medium text-slate-500">30,000원</span>
                        </div>
                    </div>
                </label>

                <label class="cursor-pointer">
                    <input type="radio" name="chargeAmount" value="50000" class="charge-option hidden" onchange="syncAmount(50000)">
                    <div class="charge-card h-full overflow-hidden">
                        <div class="absolute -top-0 -right-0 bg-purple-600 text-white text-[10px] px-2 py-0.5 rounded-bl-lg font-bold">
                            +5% 적립
                        </div>
                        <div class="mr-4 flex-shrink-0">
                            <i data-lucide="circle" class="icon-uncheck w-6 h-6 text-slate-300"></i>
                            <i data-lucide="check-circle-2" class="icon-check w-6 h-6"></i>
                        </div>
                        <div class="flex flex-col">
                            <span class="text-lg font-extrabold text-slate-800">50,000P</span>
                            <span class="text-xs font-medium text-slate-500">50,000원</span>
                        </div>
                    </div>
                </label>

            </div>
        </div>

        <div class="mb-12">
            <h4 class="font-bold text-slate-900 mb-4 px-1">결제 수단</h4>
            <div class="grid grid-cols-3 gap-3">
                <label class="cursor-pointer">
                    <input type="radio" name="payMethod" value="card" class="pay-method-option hidden">
                    <div class="pay-method-card flex flex-col items-center justify-center py-4 border border-slate-300 bg-white rounded-xl text-sm font-medium text-slate-600">
                        <i data-lucide="credit-card" class="mb-1.5 w-6 h-6"></i>
                        일반결제
                    </div>
                </label>
                <label class="cursor-pointer">
                    <input type="radio" name="payMethod" value="kakao" class="pay-method-option hidden">
                    <div class="pay-method-card flex flex-col items-center justify-center py-4 border border-slate-300 bg-white rounded-xl text-sm font-medium text-slate-600">
                        <div class="w-6 h-6 bg-[#FEE500] rounded-md mb-1.5 flex items-center justify-center text-xs font-black text-black">pay</div>
                        카카오페이
                    </div>
                </label>
                <label class="cursor-pointer">
                    <input type="radio" name="payMethod" value="toss" class="pay-method-option hidden">
                    <div class="pay-method-card flex flex-col items-center justify-center py-4 border border-slate-300 bg-white rounded-xl text-sm font-medium text-slate-600">
                        <div class="w-6 h-6 bg-[#0064FF] rounded-md mb-1.5 flex items-center justify-center text-xs text-white font-bold italic">toss</div>
                        토스페이
                    </div>
                </label>
            </div>
        </div>

        <button onclick="requestPayment()" class="w-full bg-blue-600 hover:bg-blue-700 text-white font-bold py-4 rounded-xl shadow-lg shadow-blue-100 transition-all active:scale-[0.98]">
            <span id="finalBtnText">충전 금액을 선택해 주세요</span>
        </button>

    </main>

    <jsp:include page="/WEB-INF/views/common/footer.jsp" />

    <script>
        lucide.createIcons();
        formatCurrentPoint();
        IMP.init('${impKey}');

        let currentSelectedPrice = 0;
        let currentMerchantUid = '';
        const channelKeys = {
            'card': '${cardChannelKey}',
            'kakao': '${kakaoChannelKey}',
            'toss': '${tossChannelKey}'
        };

        // 현재 포인트 포맷팅
        function formatCurrentPoint() {
            const pointElement = document.getElementById('currentPointDisplay');
            if (pointElement) {
                const point = parseInt(pointElement.textContent);
                if (!isNaN(point)) {
                    pointElement.textContent = point.toLocaleString();
                }
            }
        }

        function syncAmount(price) {
            currentSelectedPrice = price;
            document.getElementById('finalBtnText').innerText = price.toLocaleString() + '원 결제하기';
        }

        async function requestPayment() {
            if (currentSelectedPrice === 0) {
                alert('충전할 금액을 선택해주세요.');
                return;
            }

            const method = document.querySelector('input[name="payMethod"]:checked')?.value;
            if (!method) {
                alert('결제 수단을 선택해주세요.');
                return;
            }

            const payMethodMap = {
                'card': 'card',
                'kakao': 'payco',
                'toss': 'card'
            };

            currentMerchantUid = 'charge_' + Date.now();

            IMP.request_pay({
                channelKey: channelKeys[method],
                pay_method: payMethodMap[method],
                merchant_uid: currentMerchantUid,
                name: currentSelectedPrice.toLocaleString() + '원 포인트 충전',
                amount: currentSelectedPrice,
                buyer_name: document.querySelector('input[name="buyerName"]')?.value || '구매자',
                buyer_email: document.querySelector('input[name="buyerEmail"]')?.value || '',
                buyer_tel: document.querySelector('input[name="buyerTel"]')?.value || ''
            }, function(rsp) {
                if (rsp.success) {
                    verifyPayment(rsp.imp_uid, currentSelectedPrice, currentMerchantUid);
                } else {
                    alert('결제가 취소되었습니다: ' + rsp.error_msg);
                }
            });
        }

        async function verifyPayment(impUid, amount, merchantUid) {
            try {
                const response = await fetch('/charge/verify', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json'
                    },
                    body: JSON.stringify({
                        imp_uid: impUid,
                        amount: amount,
                        merchant_uid: merchantUid
                    })
                });

                const data = await response.json();

                if (data.success) {
                    alert(data.message);
                    setTimeout(() => {
                        window.location.href = '/charge/pointHistory';
                    }, 500);
                } else {
                    alert('포인트 충전 실패: ' + data.message);
                }
            } catch (error) {
                alert('오류 발생: ' + error.message);
            }
        }
    </script>
</body>
</html>