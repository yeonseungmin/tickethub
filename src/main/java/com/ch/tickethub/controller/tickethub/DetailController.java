package com.ch.tickethub.controller.tickethub;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import com.ch.tickethub.dto.Work;
import com.ch.tickethub.model.work.WorkService;

import lombok.extern.slf4j.Slf4j;

@Controller
@Slf4j
public class DetailController {
	
	@Autowired
	WorkService workService;
	
	@GetMapping("/detail")
	public String getDetail(int work_id, Model model) {
		
		Work work = workService.getWork(work_id);
		model.addAttribute("work", work);
		
		return "/ticket/detail/index";
	}
}
