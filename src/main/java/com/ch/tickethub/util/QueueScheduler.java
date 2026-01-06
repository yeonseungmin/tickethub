package com.ch.tickethub.util;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import com.ch.tickethub.model.queue.QueueService;

// 특정 시간마다 QueueService 의 메서드들을 호출해서 입장시킬 클래스
@Component
public class QueueScheduler {

	@Autowired
	private QueueService queueService;

	@Scheduled(fixedDelay = 700) // 0.7초마다 실행
	public void moveUserToActive() {

		// 한 번에 n 명씩 대기방(Waiting) 에서 활동방(Active)으로 이동
		queueService.processQueue(5); // 지금의 경우 시연을 위해 5명만 이동.
	}
}
