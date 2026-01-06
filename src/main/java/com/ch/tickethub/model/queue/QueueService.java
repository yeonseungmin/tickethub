package com.ch.tickethub.model.queue;

import com.ch.tickethub.dto.QueueStatus;

public interface QueueService {

	public void enterQueue(String userId);		// 대기열 진입
	public QueueStatus getQueueStatus(String userId);	// 현재 내 상태 조회
	public void leaveQueue(String userId); 		// 대기열 이탈
	public void processQueue(int count);		// 대기열에서 입장시키기
}
