package com.ch.tickethub.controller.tickethub;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.ch.tickethub.dto.QueueStatus;
import com.ch.tickethub.model.queue.QueueService;

@RestController // 새로고침 없이 비동기 방식으로. 이 애노테이션을 붙이면 메서드가 반환하는 객체(QueueStatus)를 스프링이 알아서 JSON 형식으로
				// 변환해서 클라이언트에게 보내줌.
@RequestMapping("/queue")
public class QueueController {

	@Autowired
	private QueueService queueService;

	// 1. 대기열 진입 메서드
	@PostMapping("/enter") // 대기열에 추가하는 건 서버의 상태를 변경시키므로 POST 방식으로
	public QueueStatus enterQueue(HttpSession session) {
		String user_id = session.getId(); // << 이 부분은 추후에 로그인 및 회원기능이 전부 구현 완료되면, memberId 로 교체예정. 지금은 session id 로 진행.
//		queueService.enterQueue(user_id);
		return queueService.getQueueStatus(user_id);
	}

	// 2. 현재 상태 조회 메서드
	@GetMapping("/status") // 단순히 상태 조회만 하므로 GET 방식
	public QueueStatus getQueueStatus(HttpSession session) {
		String userId = session.getId();
		return queueService.getQueueStatus(userId);
	}
}