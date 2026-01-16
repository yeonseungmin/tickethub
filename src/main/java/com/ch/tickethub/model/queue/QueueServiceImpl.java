package com.ch.tickethub.model.queue;

import java.util.Set;

import javax.annotation.PostConstruct;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.stereotype.Service;

import com.ch.tickethub.dto.QueueStatus;

@Service
public class QueueServiceImpl implements QueueService {

	@Autowired
	private RedisTemplate<String, Object> redisTemplate;

	// Redis 에 저장할 데이터 형식 ex) tickethub:waiting(=active):entry(=work):0
	private static final String WAITING_LIST_KEY = "tickethub:waiting:%s:%s";
	private static final String ACTIVE_LIST_KEY = "tickethub:active:%s";

	// 최대 인원
	private static final int MAX_SITE_USERS = 200; // 사이트 전체
	private static final int MAX_PERFORMANCE_USERS = 200; // 공연별 인원

	// 유효시간
	private static final long TTL_MINUTES = 20;

	private static final String GLOBAL_SITE_ID = "0"; // 사이트 전체를 의미하는 약속된 ID

	// redis 에 넣을 이름
	private String createWaitingKey(String type, String work_id) {
		// type 이 entry 면 0, work 면 work_id 를 넣기
		String id;
		if (work_id == null || "0".equals(work_id) || "".equals(work_id)) {
			id = "0";
		} else {
			id = work_id;
		}
		return String.format(WAITING_LIST_KEY, type.toLowerCase(), id);
	}

	private String createActiveKey(String type, String work_id) {
		String suffix;
		if (work_id == null || "0".equals(work_id) || "".equals(work_id)) {
			suffix = ""; // 0번(전체)은 suffix 없음
		} else {
			suffix = ":" + work_id;
		}
		return String.format(ACTIVE_LIST_KEY, type.toLowerCase() + suffix);
	}

	@Override
	public void enterQueue(String type, String work_id, String user_id) {
		// waiting key 정의.
		String waitingKey = createWaitingKey(type, work_id);

		// Redis Sorted Set 에 담기
		redisTemplate.opsForZSet().add(waitingKey, user_id, System.currentTimeMillis()); // score 자리에 timestamp 로 순서 구분.
	}

	@Override
	public QueueStatus getQueueStatus(String type, String work_id, String user_id) {
		String waitingKey = createWaitingKey(type, work_id);
		String activeKey = createActiveKey(type, work_id);

		// 먼저 active 상태인지 확인
		Double activeCheck = redisTemplate.opsForZSet().score(activeKey, user_id);

		if (activeCheck != null) {

			// active 면, 20분 연장
			long nextTime = System.currentTimeMillis() + (TTL_MINUTES * 60 * 1000);

			// 예매중이어도 연장
			if ("WORK".equals(type)) {
				String entryKey = createActiveKey("ENTRY", GLOBAL_SITE_ID);
				redisTemplate.opsForZSet().add(entryKey, user_id, (double) nextTime);
			}

			// 지금 내 active time 도 연장
			redisTemplate.opsForZSet().add(activeKey, user_id, (double) nextTime);
			return QueueStatus.builder().user_id(user_id).rank(0).allowed(true).build();
		}

		// 대기 중 순서 확인
		Long currentPosition = redisTemplate.opsForZSet().rank(waitingKey, user_id);

		if (currentPosition == null) {
			return QueueStatus.builder().user_id(user_id).rank(-1).allowed(false).build();
		}

		return QueueStatus.builder().user_id(user_id).rank(currentPosition + 1).allowed(false).build();
	}

	@Override
	public void processQueue(String type, String work_id) {
		String waitingKey = createWaitingKey(type, work_id);
		String activeKey = createActiveKey(type, work_id);

		// 토큰이 만료된 유저들 청소.
		redisTemplate.opsForZSet().removeRangeByScore(activeKey, 0, System.currentTimeMillis());

		// 현재 active 인 사람 수 확인
		Long activeCount = redisTemplate.opsForZSet().zCard(activeKey);

		// type 에 따른 최대 인원 정하기 (메인페이지, 공연별)
		int maxUsers;
		if ("WORK".equals(type)) {
			maxUsers = MAX_PERFORMANCE_USERS;
		} else {
			maxUsers = MAX_SITE_USERS;
		}

		// 빈자리 구하기
		long availableSlots;
		if (activeCount == null) {
			availableSlots = maxUsers - 0;
		} else {
			availableSlots = maxUsers - activeCount;
		}

		// 빈자리가 0보다 크면, 입장 시작
		if (availableSlots > 0) {
			Set<Object> userToEnter = redisTemplate.opsForZSet().range(waitingKey, 0, availableSlots - 1);
			// 여기서 availableSlots 에다가 -1 하는 이유는 0번부터 시작하기 때문.

			if (userToEnter != null && !userToEnter.isEmpty()) {
				for (Object user : userToEnter) {
					String userId = user.toString();

					// 대기열에서 지우기
					redisTemplate.opsForZSet().remove(waitingKey, userId);

					// active 에 넣기
					// 더미 유저는 10초 뒤 만료, 일반 유저는 20분 뒤 만료
					long ttl;
					if (userId.startsWith("dummy_user")) {
					    // 더미 유저 번호(i)를 추출해서 퇴장 시간을 5초 ~ 25초 사이로 골고루 분산
					    int dummyIndex = Integer.parseInt(userId.substring(userId.lastIndexOf("_") + 1));
					    ttl = (5 + (dummyIndex % 20)) * 1000; 
					} else {
					    ttl = TTL_MINUTES * 60 * 1000; // 실제 유저는 기존대로 20분
					}
					long nextTime = System.currentTimeMillis() + ttl;

					redisTemplate.opsForZSet().add(activeKey, userId, (double) nextTime);
				}
			}
		}
	}

	@Override
	public void leaveQueue(String type, String work_id, String user_id) {
		String waitingKey = createWaitingKey(type, work_id);
		String activeKey = createActiveKey(type, work_id);

		redisTemplate.opsForZSet().remove(waitingKey, user_id);
		redisTemplate.opsForZSet().remove(activeKey, user_id);
	}

	@PostConstruct // 서버가 켜지자마자 실행
	public void initDummyUsers() {
		Set<String> keys = redisTemplate.keys("tickethub:*");
		if (keys != null && !keys.isEmpty()) {
			redisTemplate.delete(keys);
		}
		String entryWaitKey = createWaitingKey("ENTRY", GLOBAL_SITE_ID);

		// 현재 대기열에 몇 명이 있는지 확인.
		Long count = redisTemplate.opsForZSet().zCard(entryWaitKey);

		// 만약 대기열이 비어있다면, dummy_user n명 추가.
		if (count == null || count == 0) {
			for (int i = 1; i <= 50000; i++) {
				redisTemplate.opsForZSet().add(entryWaitKey, "dummy_user_" + i, (double) i);
			}
		}
	}

	@Override
	public void changeSessionId(String oldId, String newId) {
		// redis 에 있는 대기열 탐색
		Set<String> keys = redisTemplate.keys("tickethub:*");

		if (keys != null && !keys.isEmpty()) {
			for (String key : keys) {
				// 이전 key 에 oldId 가 있는지 확인하고 score 가져오기
				Double score = redisTemplate.opsForZSet().score(key, oldId);

				if (score != null) {
					// 새 세션 id 로 score 교체.
					redisTemplate.opsForZSet().remove(key, oldId);
					redisTemplate.opsForZSet().add(key, newId, score);
				}
			}
		}
	}

	@Override
	public void processAllWorkQueues() {
		// 1. "tickethub:waiting:work:*" 패턴에 맞는 모든 키를 찾음
		Set<String> keys = redisTemplate.keys("tickethub:waiting:work:*");

		if (keys != null && !keys.isEmpty()) {
			for (String key : keys) {
				// 2. 키에서 work_id 추출 (예: tickethub:waiting:work:1 -> 1)
				// 마지막 콜론(:) 뒤에 있는 부분이 work_id
				String workId = key.substring(key.lastIndexOf(":") + 1);

				// 3. 해당 공연 대기열 처리
				processQueue("WORK", workId);
			}
		}
	}
}
