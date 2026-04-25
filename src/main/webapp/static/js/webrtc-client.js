let stompClient = null;
let peerConnection = null;
let localStream = null;

let callState = 'IDLE';
let micEnabled = true;
let cameraEnabled = true;
let callStartedAtMs = null;  // 서버에서 받은 밀리초 타임스탐프
let callDuration = null;     // 현재 총 시간(초)
let timerInterval = null;
let alertShown = false;

const iceServers = [
    { urls: 'stun:stun.l.google.com:19302' },
    { urls: 'stun:stun1.l.google.com:19302' }
];

async function init() {
    try {
        callDuration = window.videoCallConfig.durationSeconds;
        updateTimer(callDuration);
        updateStatusDisplay();

        // 전문가는 시간 연장 버튼 숨김
        if (window.videoCallConfig.isExpert) {
            document.getElementById('extensionBanner').style.display = 'none';
        }

        localStream = await navigator.mediaDevices.getUserMedia({ audio: true, video: true });
        document.getElementById('localVideo').srcObject = localStream;
        connectStomp();
    } catch (err) {
        alert('카메라/마이크 접근 권한이 필요합니다.');
        console.error(err);
    }
}

function connectStomp() {
    const socket = new SockJS('/ws');
    stompClient = Stomp.over(socket);
    stompClient.connect({}, (frame) => {
        console.log('STOMP Connected:', frame);
        console.log('videoCallConfig:', window.videoCallConfig);
        stompClient.subscribe(`/topic/video/${window.videoCallConfig.requestId}`, onSignalMessage);
        if (window.videoCallConfig.isExpert) {
            console.log('Expert mode - callInitiated:', window.videoCallConfig.callInitiated);
            // 이미 통화 요청이 진행 중이면 수락 화면 표시
            if (window.videoCallConfig.callInitiated) {
                handleIncomingCall({});
            } else {
                console.log('Showing start call button');
                document.getElementById('initiateCallBtn').classList.remove('hidden');
            }
        } else {
            console.log('User mode - waiting for call');
            showStatusBanner('수신 대기 중...');
        }
    });
}

function initiateCall() {
    callState = 'RINGING';
    document.getElementById('initiateCallBtn').classList.add('hidden');

    stompClient.send(`/app/video/${window.videoCallConfig.requestId}/signal`, {}, JSON.stringify({
        type: 'CALL_REQUEST',
        callerId: window.videoCallConfig.myUserId,
        targetId: window.videoCallConfig.otherUserId
    }));

    showStatusBanner('상대방 연결 중...');
}

function onSignalMessage(message) {
    const signal = JSON.parse(message.body);

    if (signal.senderId === window.videoCallConfig.myUserId) return;

    console.log('Signal received:', signal.type);

    switch (signal.type) {
        case 'CALL_REQUEST':
            handleIncomingCall(signal);
            break;
        case 'CALL_ACCEPTED':
            handleCallAccepted();
            break;
        case 'CALL_REJECTED':
            handleCallRejected();
            break;
        case 'OFFER':
            handleOffer(signal);
            break;
        case 'ANSWER':
            handleAnswer(signal);
            break;
        case 'ICE_CANDIDATE':
            handleIceCandidate(signal);
            break;
        case 'HANGUP':
            handleHangup();
            break;
        case 'EXTENSION':
            callDuration = signal.durationSeconds;
            console.log('연장 알림 받음, 새 시간: ' + callDuration + '초');
            break;
    }
}

function handleIncomingCall(signal) {
    if (window.videoCallConfig.isExpert) return;
    callState = 'RINGING_IN';
    document.getElementById('acceptCallBtn').classList.remove('hidden');
    document.getElementById('rejectCallBtn').classList.remove('hidden');
    showStatusBanner('영상통화 요청 중...');
}

async function acceptCall() {
    callState = 'CONNECTING';
    stompClient.send(`/app/video/${window.videoCallConfig.requestId}/signal`, {}, JSON.stringify({
        type: 'CALL_ACCEPTED'
    }));
    showStatusBanner('통화 연결 중...');
    await startAnswer();
}

function rejectCall() {
    callState = 'IDLE';
    stompClient.send(`/app/video/${window.videoCallConfig.requestId}/signal`, {}, JSON.stringify({
        type: 'CALL_REJECTED'
    }));
    showState('통화가 거절되었습니다. 창을 닫아주세요.');
}

async function handleCallAccepted() {
    callState = 'CONNECTING';
    showStatusBanner('통화 연결 중...');
    await startOffer();
}

function handleCallRejected() {
    callState = 'IDLE';
    showState('상대방이 통화를 거절했습니다. 창을 닫아주세요.');
}

async function startOffer() {
    createPeerConnection();
    for (const track of localStream.getTracks()) {
        peerConnection.addTrack(track, localStream);
    }

    const offer = await peerConnection.createOffer();
    await peerConnection.setLocalDescription(offer);

    stompClient.send(`/app/video/${window.videoCallConfig.requestId}/signal`, {}, JSON.stringify({
        type: 'OFFER',
        sdp: peerConnection.localDescription.sdp
    }));
}

async function startAnswer() {
    createPeerConnection();
    for (const track of localStream.getTracks()) {
        peerConnection.addTrack(track, localStream);
    }
}

async function handleOffer(signal) {
    if (!peerConnection) {
        await startAnswer();
    }

    await peerConnection.setRemoteDescription(new RTCSessionDescription({
        type: 'offer',
        sdp: signal.sdp
    }));

    const answer = await peerConnection.createAnswer();
    await peerConnection.setLocalDescription(answer);

    stompClient.send(`/app/video/${window.videoCallConfig.requestId}/signal`, {}, JSON.stringify({
        type: 'ANSWER',
        sdp: peerConnection.localDescription.sdp
    }));

    await recordCallStart();
    startCallTimer();
}

async function handleAnswer(signal) {
    await peerConnection.setRemoteDescription(new RTCSessionDescription({
        type: 'answer',
        sdp: signal.sdp
    }));

    await recordCallStart();
    startCallTimer();
}

async function handleIceCandidate(signal) {
    if (peerConnection && signal.candidate) {
        try {
            await peerConnection.addIceCandidate(new RTCIceCandidate({
                candidate: signal.candidate,
                sdpMid: signal.sdpMid,
                sdpMLineIndex: signal.sdpMLineIndex
            }));
        } catch (e) {
            console.error('ICE candidate error:', e);
        }
    }
}

function handleHangup() {
    cleanupCall();
    showState('상대방이 상담을 완료했습니다. 창을 닫아주세요.');
}

function updateStatusDisplay() {
    const statusText = document.getElementById('statusText');
    const statusDot = document.getElementById('statusDot');

    if (callState === 'IN_CALL') {
        statusText.textContent = '통화 중';
        statusText.className = 'text-sm font-medium text-green-400';
        statusDot.className = 'w-3 h-3 bg-green-500 rounded-full animate-pulse';
    } else {
        statusText.textContent = '대기 중';
        statusText.className = 'text-sm font-medium text-yellow-400';
        statusDot.className = 'w-3 h-3 bg-yellow-500 rounded-full animate-pulse';
    }
}

function createPeerConnection() {
    peerConnection = new RTCPeerConnection({ iceServers });

    peerConnection.onicecandidate = (event) => {
        if (event.candidate) {
            stompClient.send(`/app/video/${window.videoCallConfig.requestId}/signal`, {}, JSON.stringify({
                type: 'ICE_CANDIDATE',
                candidate: event.candidate.candidate,
                sdpMid: event.candidate.sdpMid,
                sdpMLineIndex: event.candidate.sdpMLineIndex
            }));
        }
    };

    peerConnection.ontrack = (event) => {
        console.log('Remote track:', event.track);
        document.getElementById('remoteVideo').srcObject = event.streams[0];
    };

    peerConnection.onconnectionstatechange = () => {
        console.log('Connection state:', peerConnection.connectionState);
        if (peerConnection.connectionState === 'connected') {
            callState = 'IN_CALL';
            hideStateOverlay();
            updateStatusDisplay();
        }
    };
}

async function recordCallStart() {
    try {
        const response = await fetch(`/api/consulting/requests/${window.videoCallConfig.requestId}/start-call`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' }
        });
        const data = await response.json();
        console.log('Start-call response:', data);
        if (data.callStartedAtMs) {
            callStartedAtMs = data.callStartedAtMs;
            callDuration = data.durationSeconds;
            console.log('Timer initialized: callStartedAtMs=' + callStartedAtMs + ', callDuration=' + callDuration);
        } else {
            console.error('No callStartedAtMs in response');
        }
    } catch (err) {
        console.error('Failed to record call start:', err);
    }
}

function startCallTimer() {
    if (timerInterval) return;
    if (!callStartedAtMs) {
        console.error('Timer not started: callStartedAtMs is null');
        return;
    }
    const alertThreshold = callDuration === 45 ? 30 : 120;

    timerInterval = setInterval(() => {
        const elapsed = Math.floor((Date.now() - callStartedAtMs) / 1000);
        const remaining = Math.max(0, callDuration - elapsed);

        updateTimer(remaining);

        if (remaining <= 0) {
            clearInterval(timerInterval);
            endCall();
        }
    }, 1000);
}

function updateTimer(seconds) {
    const mins = Math.floor(seconds / 60);
    const secs = seconds % 60;
    document.getElementById('timer').textContent =
        `${String(mins).padStart(2, '0')}:${String(secs).padStart(2, '0')}`;
}

let selectedExtensionSeconds = 0;

function calculateExtensionPrice(seconds) {
    const basePrice = window.videoCallConfig.sessionPrice || 0;
    const baseDuration = 600;
    return Math.round(basePrice * seconds / baseDuration);
}

function showExtensionAlert(remaining) {
    if (window.videoCallConfig.isExpert) return;
    // remaining이 없으면 현재 남은 시간 계산
    if (remaining === undefined) {
        const elapsed = Math.floor((Date.now() - callStartedAtMs) / 1000);
        remaining = Math.max(0, callDuration - elapsed);
    }
    const timeStr = remaining > 60 ? `${Math.floor(remaining/60)}분` : `${remaining}초`;
    const alert = document.getElementById('extensionAlert');
    document.getElementById('extensionAlertMsg').textContent = `${timeStr} 남았습니다. 연장하시겠습니까?`;
    selectedExtensionSeconds = 0;
    document.getElementById('pointPayBtn').style.display = 'none';

    document.getElementById('price45').textContent = calculateExtensionPrice(45).toLocaleString() + '원';
    document.getElementById('price600').textContent = calculateExtensionPrice(600).toLocaleString() + '원';
    document.getElementById('price1200').textContent = calculateExtensionPrice(1200).toLocaleString() + '원';

    alert.classList.remove('hidden');
}

function selectExtensionTime(seconds) {
    selectedExtensionSeconds = seconds;
    document.querySelectorAll('.extension-time-btn').forEach(btn => {
        btn.classList.remove('bg-blue-600', 'text-white');
        btn.classList.add('bg-blue-100', 'text-blue-700');
    });
    document.getElementById('timeBtn' + seconds).classList.remove('bg-blue-100', 'text-blue-700');
    document.getElementById('timeBtn' + seconds).classList.add('bg-blue-600', 'text-white');
    document.getElementById('pointPayBtn').style.display = 'inline-block';
}

function proceedExtensionPayment(payType) {
    if (!selectedExtensionSeconds) {
        alert('연장 시간을 선택해주세요.');
        return;
    }
    extendWithPoint();
}

function hideExtensionAlert() {
    document.getElementById('extensionAlert').classList.add('hidden');
}

function extendWithPoint() {
    fetch(`/api/consulting/requests/${window.videoCallConfig.requestId}/extend?payType=POINT&addSeconds=${selectedExtensionSeconds}`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' }
    }).then(r => r.json()).then(data => {
        if (data.success) {
            callDuration = data.newDuration;
            alertShown = false;
            hideExtensionAlert();

            // 상대방에게 연장 알림 전송
            stompClient.send(`/app/video/${window.videoCallConfig.requestId}/signal`, {}, JSON.stringify({
                type: 'EXTENSION',
                durationSeconds: data.newDuration
            }));
        } else {
            alert('포인트 연장에 실패했습니다: ' + (data.error || data.message));
        }
    }).catch(err => {
        alert('포인트 연장 중 오류가 발생했습니다.');
        console.error(err);
    });
}

async function endCall() {
    console.log('endCall() invoked, callState:', callState);
    // 상대방에게 HANGUP 신호 전송
    if (stompClient && stompClient.connected) {
        stompClient.send(`/api/video/${window.videoCallConfig.requestId}/signal`, {}, JSON.stringify({
            type: 'HANGUP'
        }));
    }

    // 상담 종료 저장
    try {
        const response = await fetch(`/api/consulting/requests/${window.videoCallConfig.requestId}/end-call`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' }
        });
        const data = await response.json();
        console.log('end-call response:', data);

        // 마이페이지에 통화 종료 알림
        localStorage.setItem('callEnded_' + window.videoCallConfig.requestId, Date.now());

        // 부모 창(마이페이지) 새로고침
        if (window.opener) {
            window.opener.location.reload();
        }
    } catch (err) {
        console.error('Failed to end call:', err);
    }

    cleanupCall();
    showState('상담이 완료되었습니다. 창을 닫아주세요.');
}

function expertCompleteCall() {
    cleanupCall();

    fetch(`/api/consulting/requests/${window.videoCallConfig.requestId}/complete-call`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' }
    }).catch(err => console.error('Failed to complete call:', err));

    stompClient.send(`/app/video/${window.videoCallConfig.requestId}/signal`, {}, JSON.stringify({
        type: 'HANGUP'
    }));
    showState('상담이 완료되었습니다. 창을 닫아주세요.');
}

function cleanupCall() {
    if (timerInterval) {
        clearInterval(timerInterval);
        timerInterval = null;
    }
    if (peerConnection) {
        peerConnection.close();
        peerConnection = null;
    }
    callState = 'IDLE';
    updateStatusDisplay();
}

function showStatusBanner(message) {
    const banner = document.getElementById('statusBanner');
    document.getElementById('statusBannerText').textContent = message;
    banner.classList.remove('hidden');
}

function hideStatusBanner() {
    document.getElementById('statusBanner').classList.add('hidden');
}

function showState(message) {
    const overlay = document.getElementById('stateOverlay');
    document.querySelector('#stateMessage p').textContent = message;
    overlay.classList.remove('hidden');
}

function hideStateOverlay() {
    document.getElementById('stateOverlay').classList.add('hidden');
    hideStatusBanner();
}

document.getElementById('micBtn').addEventListener('click', () => {
    micEnabled = !micEnabled;
    localStream.getAudioTracks().forEach(t => t.enabled = micEnabled);
    document.getElementById('micBtn').classList.toggle('bg-gray-500', !micEnabled);
    document.getElementById('micBtn').classList.toggle('bg-blue-500', micEnabled);
});

document.getElementById('cameraBtn').addEventListener('click', () => {
    cameraEnabled = !cameraEnabled;
    localStream.getVideoTracks().forEach(t => t.enabled = cameraEnabled);
    document.getElementById('cameraBtn').classList.toggle('bg-gray-500', !cameraEnabled);
    document.getElementById('cameraBtn').classList.toggle('bg-blue-500', cameraEnabled);
});

document.getElementById('initiateCallBtn').addEventListener('click', initiateCall);

document.getElementById('acceptCallBtn').addEventListener('click', () => {
    document.getElementById('acceptCallBtn').classList.add('hidden');
    document.getElementById('rejectCallBtn').classList.add('hidden');
    acceptCall();
});

document.getElementById('rejectCallBtn').addEventListener('click', () => {
    document.getElementById('acceptCallBtn').classList.add('hidden');
    document.getElementById('rejectCallBtn').classList.add('hidden');
    rejectCall();
});

window.addEventListener('beforeunload', () => {
    console.log('beforeunload event, callState:', callState);
    if (callState === 'IN_CALL' || callState === 'CONNECTING' || callState === 'RINGING' || callState === 'RINGING_IN') {
        console.log('Calling end-call API from beforeunload');
        // 상대방에게 HANGUP 신호 전송
        if (stompClient && stompClient.connected) {
            stompClient.send(`/app/video/${window.videoCallConfig.requestId}/signal`, {}, JSON.stringify({
                type: 'HANGUP'
            }));
        }

        // 상담 종료 저장
        fetch(`/api/consulting/requests/${window.videoCallConfig.requestId}/end-call`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            keepalive: true
        }).catch(err => console.error('Failed to end call:', err));

        // 마이페이지에 통화 종료 알림
        localStorage.setItem('callEnded_' + window.videoCallConfig.requestId, Date.now());

        // 부모 창(마이페이지) 새로고침
        if (window.opener) {
            window.opener.location.reload();
        }
    }
});

// 마우스 움직임으로 컨트롤 자동 숨김/표시 (1안 디자인용)
let controlsTimeout;
const videoContainer = document.getElementById('videoContainer');
const controlsContainer = document.getElementById('controlsContainer');
const headerContainer = document.getElementById('headerContainer');

if (controlsContainer && headerContainer) {
    function showControls() {
        controlsContainer.classList.remove('hidden-controls');
        headerContainer.classList.remove('opacity-0');
        clearTimeout(controlsTimeout);
        controlsTimeout = setTimeout(() => {
            controlsContainer.classList.add('hidden-controls');
            headerContainer.classList.add('opacity-0');
        }, 3000);
    }

    videoContainer.addEventListener('mousemove', showControls);
    videoContainer.addEventListener('mouseenter', showControls);

    // 초기 표시
    showControls();
}

init();
