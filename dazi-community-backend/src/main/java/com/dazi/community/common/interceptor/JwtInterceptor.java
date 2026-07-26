package com.dazi.community.common.interceptor;

import com.dazi.community.common.jwt.JwtUtil;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;

import jakarta.annotation.Resource;

@Component
public class JwtInterceptor implements HandlerInterceptor {

    @Resource
    private JwtUtil jwtUtil;

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        if ("OPTIONS".equals(request.getMethod())) {
            return true;
        }

        String authHeader = request.getHeader("Authorization");
        if (authHeader == null || !authHeader.startsWith("Bearer ")) {
            // Allow GET requests without token (public browsing)
            if ("GET".equals(request.getMethod())) {
                return true;
            }
            response.setContentType("application/json;charset=utf-8");
            response.getWriter().write("{\"code\":10001,\"msg\":\"未登录/token失效\",\"data\":null}");
            return false;
        }

        String token = authHeader.substring(7);
        if (!jwtUtil.validateToken(token)) {
            response.setContentType("application/json;charset=utf-8");
            response.getWriter().write("{\"code\":10001,\"msg\":\"token失效，请重新登录\",\"data\":null}");
            return false;
        }
        Long userId = jwtUtil.getUserIdFromToken(token);
        request.setAttribute("userId", userId);
        return true;
    }
}
