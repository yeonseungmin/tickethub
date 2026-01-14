package com.ch.tickethub.model.report;

import java.util.List;

import com.ch.tickethub.dto.Report;

public interface ReportDAO {
	public void insert(Report report);
	public List<Report> selectAll();
	
}
