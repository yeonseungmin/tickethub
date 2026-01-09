package com.ch.tickethub.model.graderule;

import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.ch.tickethub.dto.GradeRule;

@Repository
public class MybatisGradeRuleDAO implements GradeRuleDAO{

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	
	@Override
	public List<GradeRule> selectRulesByGradeId() {
		return sqlSessionTemplate.selectList("GradeRule.selectRulesByGradeId");
	}

}
