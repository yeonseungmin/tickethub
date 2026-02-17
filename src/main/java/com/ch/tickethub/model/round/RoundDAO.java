package com.ch.tickethub.model.round;

import java.util.List;
import java.util.Map;

import com.ch.tickethub.dto.Round;

public interface RoundDAO {
	public void insert(Round round);
	public List<Round> selectByWorkId(int work_id); // 회차 목록 조회 메서드 추가
	public List<Integer> selectRoundIdsByPlace(int place_id);
	public List<Round> selectByWorkAndPlace(int work_id, int place_id);
	public  List<Map<String, Object>> selectSeatStats(int round_id);
	public int updateCancelStatus(Map<String, Object> params);
	public int delete(int round_id);
	public List<Round> selectByDate(int work_id, String sourceDate);
}