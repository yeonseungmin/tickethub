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
		// 1. 사이트 입장 대기열 처리
		queueService.processQueue("ENTRY", "0");

		// 2. 모든 공연 예매 대기열 처리 
		queueService.processAllWorkQueues();
	}
}
