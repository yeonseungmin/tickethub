package com.ch.tickethub.model.round;

import java.util.List;

import com.ch.tickethub.dto.Round;

public interface RoundDAO {
	public void insert(Round round);
	public List<Round> selectByWorkId(int work_id); // 회차 목록 조회 메서드 추가
	public List<Integer> selectRoundIdsByPlace(int place_id);
	List<Round> selectByWorkAndPlace(int work_id, int place_id);
}