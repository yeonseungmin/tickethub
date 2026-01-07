package com.ch.tickethub.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder	// 이 애노테이션을 쓰면 Builder 패턴으로 객체를 생성해주는데, 지금과 같이 여러 값들을 담을 때 가독성이 매우 뛰어나다.
@NoArgsConstructor	// 나중에 JSON 형태로 변환할 때 Jackson 이 이 기본생성자를 생성한다.
@AllArgsConstructor	// Builder 쓸 때 같이 쓰는 애노테이션.
public class QueueStatus {

	private long rank;	// 현재 대기 순번. redis 에서 zrank 명령어로 가져올 값을 여기에 담으면 됨.
	private boolean allowed;	// 불리언 값에 따라서 입장 가능 여부를 보내주는 스위치 역할
	private String user_id;	// 사용자 식별 ID (Session ID)
}
