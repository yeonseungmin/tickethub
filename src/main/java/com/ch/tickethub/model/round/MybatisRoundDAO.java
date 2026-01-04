package com.ch.tickethub.model.round;

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

}
