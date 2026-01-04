package com.ch.tickethub.controller.tickethub;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class MainController {

	@GetMapping("/")
	public String getMain() {
		return "ticket/home";
	}

	@GetMapping("/waiting")
	public String getWaitingPage() {
		return "queue/waiting";
	}
}
