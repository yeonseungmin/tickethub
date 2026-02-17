package com.ch.tickethub.model.round;

import java.util.List;
import java.util.Map;

import com.ch.tickethub.dto.Round;
import com.ch.tickethub.request.RoundRegistRequest;

public interface RoundService {
	public void regist(RoundRegistRequest roundRegistRequest);
	public List<Round> findByWorkId(int workId); // 추가
	public List<Round> selectByWorkAndPlace(int workId, int placeId);
	public List<Map<String, Object>> getSeatStats(int round_id);
	public void updateCasting(Round round);
	public void setCancelStatus(int round_id, boolean is_cancelled);
	public void removeRound(int round_id);
	public void copyDaySchedule(int work_id, String sourceDate, List<String> targetDates);
}