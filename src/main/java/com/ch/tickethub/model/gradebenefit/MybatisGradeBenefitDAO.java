package com.ch.tickethub.model.gradebenefit;

import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.ch.tickethub.dto.GradeBenefit;

@Repository
public class MybatisGradeBenefitDAO implements GradeBenefitDAO{

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	
	@Override
	public List<GradeBenefit> selectBenefitsByGradeId() {
		return sqlSessionTemplate.selectList("GradeBenefit.selectBenefitsByGradeId");
	}
}
