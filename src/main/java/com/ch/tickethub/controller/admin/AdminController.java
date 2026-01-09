package com.ch.tickethub.controller.admin;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class AdminController {
	
	@GetMapping("/main")
	public String main() {
		log.debug("어드민 메인에 요청 받음");
		return "admin/index";
	}
}
