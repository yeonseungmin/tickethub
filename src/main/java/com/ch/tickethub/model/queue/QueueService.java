package com.ch.tickethub.model.queue;

import com.ch.tickethub.dto.QueueStatus;

public interface QueueService {

	public void enterQueue(String type, String work_id, String user_id); // 대기열 진입. 순서대로 대기열타입(1차, 2차), 어떤 공연인지, 어떤 유저인지

	public QueueStatus getQueueStatus(String user_id); // 현재 내 상태 조회

	public void leaveQueue(String type, String work_id, String user_id); // 대기열 이탈

	public void processQueue(String type, String work_id, int count); // 대기열에서 입장시키기
}
