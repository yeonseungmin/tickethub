package com.ch.tickethub.controller.admin.performance;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;

import com.ch.tickethub.dto.Report;
import com.ch.tickethub.dto.ReportCategory;
import com.ch.tickethub.model.report.ReportService;
import com.ch.tickethub.model.reportCategory.ReportCategoryService;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class ReportController {
	
	@Autowired
	ReportService reportService;
	
	@Autowired
	ReportCategoryService reportCategoryService;
	
	
	@GetMapping("/performance/report")
    public String getReportListPage(Model model) {
        List<Report> reportList = reportService.getList();
        List<ReportCategory> reportCategoryList = reportCategoryService.getReportCategoryList();
        
        log.debug("{}", reportList);
        
        model.addAttribute("reportList", reportList);
        model.addAttribute("reportCategoryList", reportCategoryList);
        
        return "/admin/performance/report/list"; 
    }
	
	@PostMapping("/performance/report/update")
	public ResponseEntity<String> setReportState(Report report) {
	    // 확인용 로그
	    log.info("신고 ID: " + report.getReport_id());
	    log.info("리뷰 ID: " + report.getReview().getReview_id());
	    log.info("변경 상태: " + report.getReport_state());

	    try {
			reportService.setState(report);
			return ResponseEntity.ok("success");
		} catch (Exception e) {
			
			return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("fail");
		}
	   
	}
}