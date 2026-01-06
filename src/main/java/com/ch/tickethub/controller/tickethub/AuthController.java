package com.ch.tickethub.controller.tickethub;

import java.security.PublicKey;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.ch.tickethub.dto.Member;
import com.ch.tickethub.model.member.MemberService;

@Controller
@RequestMapping("/tickethub/auth")
public class AuthController {

	@Autowired
	private MemberService memberService;

	// 로그인 화면
	@GetMapping("/login")
	public String loginForm() {
		return "tickethub/auth/login"; // /WEB-INF/views/tickethub/auth/login.jsp
	}

	// 로그인 처리
	@PostMapping("/login")
	public String login(@RequestParam("loginId") String loginId, @RequestParam("password") String password,
			HttpSession session, Model model) {
		Member member = memberService.login(loginId, password);

		if (member == null) {
			model.addAttribute("error", "아이디 또는 비밀번호를 확인해주세요");
			return "tickethub/auth/login";
		}

		session.setAttribute("loginMember", member);

		if ("ADMIN".equals(member.getRole())) {
			return "redirect:/admin/index";
		}
		
		return "redirect:/";

	}
			// 로그아웃
			@GetMapping("/logout")
			public String logout(HttpSession session) {
				session.invalidate();
				return "redirect:/tickethub/auth/login";
			}
}
