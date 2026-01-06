package com.ch.tickethub.model.grade;

import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.ch.tickethub.dto.Grade;

@Repository
public class MybatisGradeDAO implements GradeDAO{

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	
	@Override
	public List<Grade> selectGradeAll() {
		return sqlSessionTemplate.selectList("Grade.selectGradeAll");
	}

	@Override
	public Grade selectByGradeId(Integer gradeId) {
		return sqlSessionTemplate.selectOne("Grade.selectByGradeId");
	}

}
