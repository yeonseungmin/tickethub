package com.ch.tickethub.model.queue;

import com.ch.tickethub.dto.QueueStatus;

public interface QueueService {

	public void enterQueue(String type, String work_id, String user_id); // 대기열 진입. 순서대로 대기열타입(1차, 2차), 어떤 공연인지, 어떤 유저인지
	public QueueStatus getQueueStatus(String type, String work_id, String user_id); // 현재 내 상태 조회
	public void processQueue(String type, String work_id); // 대기열 통과(대기자 > 활성자)
	public void leaveQueue(String type, String work_id, String user_id); // 대기열 이탈
	public void changeSessionId(String oldId, String newId);	// 세션 아이디 변경 시, redis key 도 같이 변경
}
