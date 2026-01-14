package com.ch.tickethub.model.report;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ch.tickethub.dto.Report;
import com.ch.tickethub.exception.ReportException;

@Service
public class ReportServiceImpl implements ReportService {
	
	@Autowired
	ReportDAO reportDAO;

	@Override
	public void regist(Report report) throws ReportException{
		reportDAO.insert(report);
	}

}
