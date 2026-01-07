package com.ch.tickethub.model.round;

import java.util.List;

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
	

}