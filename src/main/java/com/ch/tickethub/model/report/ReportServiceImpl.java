package com.ch.tickethub.model.report;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.ch.tickethub.dto.Report;
import com.ch.tickethub.exception.ReportException;
import com.ch.tickethub.model.review.ReviewDAO;

@Service
public class ReportServiceImpl implements ReportService {
	
	@Autowired
	ReportDAO reportDAO;
	
	@Autowired
	ReviewDAO reviewDAO;

	@Override
	public void regist(Report report) throws ReportException{
		reportDAO.insert(report);
	}

	@Override
	public List<Report> getList() {
		return reportDAO.selectAll();
	}
	
	@Transactional
	@Override
	public void setState(Report report) {
		
		reportDAO.updateState(report);
		
	    // 수락 시 리뷰 블라인드 (review.review_id 사용)
	    if("PROCESSED".equals(report.getReport_state())) {
	    	reviewDAO.updateBlock(report.getReview().getReview_id());
	    }
	}
	
	

}
