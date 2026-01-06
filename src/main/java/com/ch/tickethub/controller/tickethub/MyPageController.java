package com.ch.tickethub.controller.tickethub;

import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.ch.tickethub.dto.Member;

@Controller
@RequestMapping("/tickethub/mypage")
public class MyPageController {
	
	@GetMapping
	public String mypageMain(HttpSession session) {
		Object obj = session.getAttribute("loginMember");
		
		if(obj == null) return "redirect:/tickethub/auth/login";
		
		Member member = (Member)obj;
		
		//차후에 규칙 만들 때(차단 등등.. 여기서 하기)
		
		return "tickethub/mypage/main";
	}
}
