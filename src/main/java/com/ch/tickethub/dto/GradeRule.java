package com.ch.tickethub.dto;

import lombok.Data;

@Data
public class GradeRule {
	 private Integer ruleId;
	 private Integer gradeId;

	 private String ruleType;
	 private Integer monthsWindow;
	 private Integer threshold;
	 private String description;
}
