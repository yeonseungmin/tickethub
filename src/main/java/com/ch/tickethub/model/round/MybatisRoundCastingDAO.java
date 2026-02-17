package com.ch.tickethub.model.round;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.ch.tickethub.dto.RoundCasting;
import com.ch.tickethub.exception.RoundCastingException;

@Repository
public class MybatisRoundCastingDAO implements RoundCastingDAO{

	@Autowired
	SqlSessionTemplate sqlSessionTemplate;
	
	@Override
	public void insert(RoundCasting roundCasting) throws RoundCastingException{
		
		try {
			sqlSessionTemplate.insert("RoundCasting.insert", roundCasting);
		} catch (Exception e) {
			e.printStackTrace();
			throw new RoundCastingException("회차별 캐스팅 저장 실패", e);
		}
	}

	@Override
	public void deleteByRoundId(int round_id) throws RoundCastingException{
		try {
			sqlSessionTemplate.delete("RoundCasting.deleteByRoundId", round_id);
		} catch (Exception e) {
			e.printStackTrace();
			throw new RoundCastingException("회차별 캐스팅 삭제 실패", e);
		}
		
	}

}
