package com.ch.tickethub.model.round;

import java.util.List;

import com.ch.tickethub.dto.Round;

public interface RoundDAO {
	public void insert(Round round);
	public List<Round> selectByWorkId(int work_id); // 회차 목록 조회 메서드 추가
	public List<com.ch.tickethub.dto.Round> selectListByWork(int workId);
}