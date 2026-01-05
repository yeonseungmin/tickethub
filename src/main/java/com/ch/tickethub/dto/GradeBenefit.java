package com.ch.tickethub.dto;

import lombok.Data;

@Data
public class GradeBenefit {
	private Integer benefitId;
    private Integer gradeId;

    private String title;
    private String summary;
    private String detail;
}
