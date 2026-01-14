package com.ch.tickethub.controller.admin;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import com.ch.tickethub.model.dashboard.DashboardService;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class AdminController {

	@Autowired
	private DashboardService dashboardService;

	@GetMapping("/main")
	public String main(Model model) {
		log.debug("어드민 메인에 요청 받음");

		model.addAttribute("dashboard", dashboardService.getDashboard());

		return "admin/index";
	}
}
