package com.ch.tickethub.controller.tickethub;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.ch.tickethub.dto.Member;
import com.ch.tickethub.model.member.MemberService;

@Controller
@RequestMapping("/tickethub/mypage")
public class MyPageController {
	
	@Autowired
	private MemberService memberService;
	
	@GetMapping
	public String mypageMain(HttpSession session, Model model) {
		Object obj = session.getAttribute("loginMember");
		
		if(obj == null) return "redirect:/auth/login";
		
		Member loginMember = (Member)obj;
		
		Member member = memberService.selectMyPage(loginMember.getMemberId());
		
		model.addAttribute("member", member);
		
		
		return "tickethub/mypage/main";
	}
}
