package com.ch.tickethub.model.reportCategory;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ch.tickethub.dto.ReportCategory;

@Service
public class ReportCategoryServiceImpl implements ReportCategoryService{

	@Autowired
	ReportCategoryDAO reportCategoryDAO;
	
	@Override
	public List<ReportCategory> getReportCategoryList() {
		return reportCategoryDAO.selectAll();
	}

}
