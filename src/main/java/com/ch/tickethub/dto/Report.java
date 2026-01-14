package com.ch.tickethub.dto;

import lombok.Data;

@Data
public class Report {
	private int report_id;
	private String report_content;
	private String report_date;
	
	// received, rejected, processed
	private String report_state;
	
	private Review review;
	private ReportCategory reportCategory;
}