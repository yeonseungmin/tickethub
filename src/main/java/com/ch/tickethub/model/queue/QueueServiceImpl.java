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

	private static final String WAITING_KEY = "tickethub.waiting";
	// 입장 대기방. 번호표뽑고 기다리는 중. 먼저 온 사람이 앞에 서야 하므로 Sorted Set 을 사용.
	private static final String ACTIVE_KEY = "tickethub.active";
	// 입장 완료 이후 활동방. 순서 상관없이 이 사람이 여기 있는 지만 중요하므로 일반 Set 을 사용.

	private static final int MAX_ACTIVE_USERS = 10; // 동시 입장 가능한 최대 인원 (지금의 경우, 테스트를 위해 10명만)

	@Override
	public void enterQueue(String type, String work_id, String user_id) { // 클라이언트가 입장하면(예매하면) 호출.
		// 1. zadd 의 Score 값에다가 timestamp 넣어서 대기열에 추가.
		redisTemplate.opsForZSet().add(WAITING_KEY, user_id, System.currentTimeMillis());
	}

	@Override
	public QueueStatus getQueueStatus(String user_id) { // 나 진입할 수 있음? >> 클라이언트 화면에서 5초마다 호출할 로직.
		// 2. 먼저 이 사람이 이미 번호표 뽑고 '활동방'에 들어간 건 지 확인
		Boolean isActive = redisTemplate.opsForSet().isMember(ACTIVE_KEY, user_id);

		if (isActive != null && isActive) { // Added null check for isActive
			return QueueStatus.builder().user_id(user_id).rank(0).allowed(true).build();
		}

		// 3. 활동방에 없다면, 대기열 순번 확인
		Long rank = redisTemplate.opsForZSet().rank(WAITING_KEY, user_id);

		if (rank == null) { // redis 는 대기열에 유저가 없다면 null 을 반환.
			return QueueStatus.builder().user_id(user_id).rank(-1).allowed(false).build();
		} // 대기열에 등록되지 않는 사용자가 조회를 할 경우, redis 에 rank를 -1로 보내고 allowed 를 false로 처리.

		return QueueStatus.builder().user_id(user_id).rank(rank + 1).allowed(false).build();
	} // 여기서 rank 에다가 +1 하는 이유는 우리는 0번째부터 시작하는 걸 알지만, 클라이언트는 0번째부터 << 라는 개념 자체가 안
		// 익숙하므로 1을 더해준다.

	@Override
	public void leaveQueue(String type, String work_id, String user_id) {
		// 4. 양쪽 방에서 다 제거
		redisTemplate.opsForZSet().remove(WAITING_KEY, user_id);
		redisTemplate.opsForSet().remove(ACTIVE_KEY, user_id);
	}

	@Override
	public void processQueue(String type, String work_id, int count) {
		// 5. 대기열 맨 앞(0번)부터 count 만큼 가져오기
		Set<Object> userToActivate = redisTemplate.opsForZSet().range(WAITING_KEY, 0, count - 1);

		if (userToActivate != null && !userToActivate.isEmpty()) {
			for (Object user : userToActivate) {
				// 대기열에서 빼고 활동방에 넣기
				redisTemplate.opsForSet().add(ACTIVE_KEY, user.toString());
				redisTemplate.opsForZSet().remove(WAITING_KEY, user.toString());
			}
		}
	}

	@PostConstruct // 객체가 생성되자마자 이 메서드를 실행하는 애노테이션
	public void initDummyUsers() {
		Long count = redisTemplate.opsForZSet().zCard(WAITING_KEY);

		// 서버가 시작될 때 대기열이 비어있다면 n 명을 미리 넣어둔다.
		if (count == null || count == 0) {
			for (int i = 0; i <= 300; i++) {
				redisTemplate.opsForZSet().add(WAITING_KEY, "user" + i, (double) i);
			}
		}
	}
}