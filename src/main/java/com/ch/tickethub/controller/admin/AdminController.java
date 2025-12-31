package com.ch.tickethub.controller.admin;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class AdminController {
	
	@GetMapping("/main")
	public String main() {
		
		return "admin/index";
	}
}
