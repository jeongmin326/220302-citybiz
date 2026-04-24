package com.publicservice.interceptor;

import com.publicservice.entity.User;
import com.publicservice.repository.UserRepository;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;

import java.time.LocalDateTime;

@Component
public class PlanCheckInterceptor implements HandlerInterceptor {

    @Autowired
    private UserRepository userRepository;

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        Long userId = (Long) request.getSession().getAttribute("loginUserId");

        if (userId == null) {
            response.sendRedirect("/login");
            return false;
        }

        String role = (String) request.getSession().getAttribute("loginRole");
        if ("USER".equals(role)) {
            return true;
        }

        User user = userRepository.findById(userId).orElse(null);
        if (user == null) {
            response.sendRedirect("/login");
            return false;
        }

        boolean hasActivePlan = !"FREE".equals(user.getPlanType())
                && user.getPlanExpiresAt() != null
                && user.getPlanExpiresAt().isAfter(LocalDateTime.now());

        if (!hasActivePlan) {
            response.sendRedirect("/charge/plan");
            return false;
        }

        return true;
    }
}
