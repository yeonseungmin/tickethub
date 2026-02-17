package com.ch.tickethub.model.round;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.ch.tickethub.dto.Round;

@Repository
public class MybatisRoundDAO implements RoundDAO{
	
	@Autowired
	SqlSessionTemplate sqlSessionTemplate;
	
	@Override
	public void insert(Round round) {
		sqlSessionTemplate.insert("Round.insert", round);
	}

	@Override
	public List<Round> selectByWorkId(int work_id) {
		// RoundMapper.xml의 namespace="Round", id="selectByWorkId" 호출
		return sqlSessionTemplate.selectList("Round.selectByWorkId", work_id);
	}

	@Override
	public List<Integer> selectRoundIdsByPlace(int place_id) {
	    // RoundMapper.xml 의 id="selectRoundIdsByPlace" 호출
	    return sqlSessionTemplate.selectList("Round.selectRoundIdsByPlace", place_id);
	}
	
	@Override
	public List<Round> selectByWorkAndPlace(int work_id, int place_id) {
	    Map<String, Object> params = new HashMap<>();
	    params.put("work_id", work_id);
	    params.put("place_id", place_id);
	    
	    // RoundMapper.xml의 id="selectByWorkAndPlace" 호출
	    return sqlSessionTemplate.selectList("Round.selectByWorkAndPlace", params);
	}

	@Override
	public List<Map<String, Object>> selectSeatStats(int round_id) {
		return sqlSessionTemplate.selectList("Round.selectSeatStatsByRoundId", round_id);
	}

	@Override
	public int updateCancelStatus(Map<String, Object> params) {
		return sqlSessionTemplate.update("Round.updateCancelStatus", params);
	}

	@Override
	public int delete(int round_id) {
		
		return sqlSessionTemplate.delete("Round.delete", round_id);
	}

	@Override
	public List<Round> selectByDate(int work_id, String sourceDate) {
	    Map<String, Object> params = new HashMap<>();
	    params.put("work_id", work_id);
	    params.put("round_date", sourceDate);

		return sqlSessionTemplate.selectList("Round.selectByDate", params);
	}
	

}