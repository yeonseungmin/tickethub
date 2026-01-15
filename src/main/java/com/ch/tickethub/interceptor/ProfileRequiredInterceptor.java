package com.ch.tickethub.interceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import com.ch.tickethub.dto.Member;

public class ProfileRequiredInterceptor extends HandlerInterceptorAdapter {

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
            throws Exception {

        String ctx = request.getContextPath();       // 예: "" 또는 "/tickethub"
        String uri = request.getRequestURI();        // 예: "/tickethub/auth/login"
        String path = uri.substring(ctx.length());   // 예: "/auth/login" (컨텍스트 제거)

        // 제외: auth / 정적리소스 / (선택) queue
        if (path.startsWith("/auth")
                || path.startsWith("/resources")
                || path.startsWith("/assets")
                || path.startsWith("/static")
                || path.startsWith("/css")
                || path.startsWith("/js")
                || path.startsWith("/images")
                || path.startsWith("/queue")) {
            return true;
        }

        HttpSession session = request.getSession(false);
        if (session == null) return true;

        Object joinDraft = session.getAttribute("joinDraft");
        if (joinDraft != null) {
            response.sendRedirect(request.getContextPath() + "/auth/profile");
            return false;
        }
        
        // 프로필 진행 세션이 있으면 무조건 profile로
        Object profileMemberId = session.getAttribute("profileMemberId");
        if (profileMemberId != null) {
            response.sendRedirect(ctx + "/auth/profile");
            return false;
        }

        // loginMember가 있는데 profileCompleted='N'이면 강제 profile
        Member loginMember = (Member) session.getAttribute("loginMember");
        if (loginMember != null && "N".equals(loginMember.getProfileCompleted())) {
            session.setAttribute("profileMemberId", loginMember.getMemberId());
            session.setAttribute("profileReason", "PROFILE_INCOMPLETE");
            response.sendRedirect(ctx + "/auth/profile");
            return false;
        }

        return true;
    }
}