package com.ch.tickethub.model.grade;

import java.util.List;

import com.ch.tickethub.dto.Grade;

public interface GradeDAO {
	public List<Grade> selectGradeAll();
	public Grade selectByGradeId(Integer gradeId);
	 public Integer selectGradeIdByCode(String gradeCode);
}
