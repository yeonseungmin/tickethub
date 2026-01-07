package com.ch.tickethub.controller.tickethub;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import com.ch.tickethub.dto.RoundCasting;
import com.ch.tickethub.dto.Work;
import com.ch.tickethub.model.work.WorkService;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;

import lombok.extern.slf4j.Slf4j;

@Controller
@Slf4j
public class DetailController {
	
	@Autowired
	WorkService workService;
	
	@GetMapping("/detail")
	public String getDetail(int work_id, Model model) {
		
		Work work = workService.getWork(work_id);
		List<RoundCasting> uniqueCastingList = workService.getUniqueCasting(work);
		
		model.addAttribute("work", work);
		model.addAttribute("uniqueCastingList", uniqueCastingList);
		
		ObjectMapper mapper = new ObjectMapper();
		
		try {
			String jsonWork = mapper.writeValueAsString(work);
			model.addAttribute("jsonWork", jsonWork);
		} catch (JsonProcessingException e) {
			e.printStackTrace();
		}
		
		return "/ticket/detail/index";
	}
}
