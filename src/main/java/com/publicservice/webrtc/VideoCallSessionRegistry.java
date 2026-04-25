package com.publicservice.webrtc;

import lombok.AllArgsConstructor;
import lombok.Getter;
import org.springframework.stereotype.Component;
import java.time.LocalDateTime;
import java.util.concurrent.ConcurrentHashMap;

@Component
public class VideoCallSessionRegistry {

    private final ConcurrentHashMap<Long, CallSession> activeCalls = new ConcurrentHashMap<>();

    @Getter
    @AllArgsConstructor
    public static class CallSession {
        private Long requestId;
        private Long callerId;
        private Long calleeId;
        private CallState state;
        private LocalDateTime startedAt;
    }

    public enum CallState {
        RINGING, IN_CALL
    }

    public boolean tryInitiateCall(Long requestId, Long callerId, Long calleeId) {
        if (activeCalls.containsKey(requestId)) {
            return false;
        }
        CallSession session = new CallSession(requestId, callerId, calleeId, CallState.RINGING, LocalDateTime.now());
        activeCalls.put(requestId, session);
        return true;
    }

    public boolean acceptCall(Long requestId) {
        CallSession session = activeCalls.get(requestId);
        if (session != null && session.state == CallState.RINGING) {
            session.state = CallState.IN_CALL;
            return true;
        }
        return false;
    }

    public boolean isCallActive(Long requestId) {
        CallSession session = activeCalls.get(requestId);
        return session != null && session.state == CallState.IN_CALL;
    }

    public void endCall(Long requestId) {
        activeCalls.remove(requestId);
    }

    public CallSession getCallSession(Long requestId) {
        return activeCalls.get(requestId);
    }
}
