package com.ch.tickethub.controller.tickethub;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import com.ch.tickethub.dto.QueueStatus;
import com.ch.tickethub.model.queue.QueueService;

public class QueueInterceptor extends HandlerInterceptorAdapter{

	@Autowired
	private QueueService queueService;
	
	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
		
		HttpSession session = request.getSession();
		String user_id = session.getId();
		
		// 어디로 가는 지 확인. url 에 reservation 이 있으면 공연 대기열 체크
		String uri = request.getRequestURI();
		// [추가] 상세 페이지는 일단 대기열 검사 패스
	    if (uri.contains("/detail")) {
	        return true;
	    }
		String work_id = request.getParameter("work_id");	// url 에서 공연번호 읽기
		
		// 1차 대기열 통과했는 지 확인.
		QueueStatus entryCheck = queueService.getQueueStatus("ENTRY", "0", user_id);
		
		if (!entryCheck.isAllowed()) {	// 1차 대기열 통과 안 했으면 가차없이 대기열로 이동
			response.sendRedirect(request.getContextPath() + "/queue/waiting?type=ENTRY");
			return false;		// 거부.
		}
		
		// 2차 대기열 통과했는 지 확인
		if (uri.contains("/reservation") && work_id != null) {
			QueueStatus workCheck = queueService.getQueueStatus("WORK", work_id, user_id);
			
			if (!workCheck.isAllowed()) {	// 2차 대기열 통과 안 했으면 2차 대기열로 이동
				response.sendRedirect(request.getContextPath() + "/queue/waiting?type=WORK&work_id=" + work_id);
				return false;
			}
		}
		
		return true;
	}
}
