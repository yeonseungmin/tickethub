package com.ch.tickethub.interceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import com.ch.tickethub.dto.Member;

//어드민 인터셉터
public class AdminAuthInterceptor extends HandlerInterceptorAdapter {

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
            throws Exception {

        HttpSession session = request.getSession(false);
        Member loginMember = (session == null) ? null : (Member) session.getAttribute("loginMember");

        boolean isAdmin = (loginMember != null && "ADMIN".equals(loginMember.getRole()));
        if (isAdmin) return true;

        String xrw = request.getHeader("X-Requested-With");
        boolean isAjax = "XMLHttpRequest".equalsIgnoreCase(xrw);

        if (isAjax) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED); // 401
            response.setHeader("Location", request.getContextPath() + "/auth/login");
            return false;
        }

        response.sendRedirect(request.getContextPath() + "/auth/login");
        return false;
    }
}