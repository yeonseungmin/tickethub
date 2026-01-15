package com.ch.tickethub.model.graderule;

import java.util.List;

import com.ch.tickethub.dto.GradeRule;

public interface GradeRuleDAO {
	public List<GradeRule> selectRulesByGradeId();
}
