package com.ch.tickethub.model.gradebenefit;

import java.util.List;

import com.ch.tickethub.dto.GradeBenefit;

public interface GradeBenefitDAO {
	List<GradeBenefit> selectBenefitsByGradeId();
}
