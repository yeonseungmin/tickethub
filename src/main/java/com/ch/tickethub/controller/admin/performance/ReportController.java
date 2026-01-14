package com.ch.tickethub.controller.admin.performance;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

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
}