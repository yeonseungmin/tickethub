package com.ch.tickethub.model.report;

import java.util.List;

import com.ch.tickethub.dto.Report;

public interface ReportService {
	public void regist(Report report);
	public List<Report> getList();
}
