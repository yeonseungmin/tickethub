package com.ch.tickethub.model.reportCategory;

import java.util.List;

import com.ch.tickethub.dto.ReportCategory;

public interface ReportCategoryDAO {
	public List<ReportCategory> selectAll();
}
