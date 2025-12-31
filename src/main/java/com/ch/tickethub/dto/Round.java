package com.ch.tickethub.dto;

import lombok.Data;

@Data
public class Round {
	private int round_id;
	private String round_date;
	private String round_start_time;		// 00:00일 경우 Work.work_type = period(상시) 물론 만들지는 모름
	private boolean is_cancelled;			// 회차 단위 취소
	
	private Work work;
	private Place place;
}