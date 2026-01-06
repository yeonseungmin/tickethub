package com.ch.tickethub.controller.admin.mainpage;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/mainpage")
public class MainPageController {

	@GetMapping("/mainbanner/banner")
	public String getMainbanner() {
		return "admin/mainpage/mainbanner/banner";
	}
}
