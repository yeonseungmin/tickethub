package com.ch.tickethub.controller.admin;

import java.util.List;

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
@RequestMapping("/admin/members")
public class AdminMemberController {
	
	@Autowired
	private MemberService memberService;
	
	//관리자 권한 체크
	private boolean isAdmin(HttpSession session) {
		Object obj = session.getAttribute("loginMember"); //로그인한 멤버
		if(obj==null) return false; //로그인한 멤버가 없으면 false반환
		Member member = (Member)obj;
		
		return "ADMIN".equals(member.getRole()); //role이 admin이면 반환
	}
	
	// 회원 통합검색/목록
	@GetMapping
	public String list(@RequestParam(value = "keyword", required = false) String keyword, @RequestParam(value = "status", required = false) String status, HttpSession session, Model model) {
		if(!isAdmin(session)) return "redirect:/auth/login";
		
		List<Member> members = memberService.adminSearchMembers(keyword, status);
		model.addAttribute("members", members);
		model.addAttribute("keyword", keyword);
		model.addAttribute("status", status);
		
		return "admin/member/list";  // /WEB-INF/views/admin/member/list.jsp
	}
	
	// 회원 상세 조희
	@GetMapping("/detail")
	public String detail(@RequestParam("memberId") Integer memberId, HttpSession session, Model model) {
		if(!isAdmin(session)) return "redirect:/auth/login";
		
		Member member = memberService.adminSelectMemberDetail(memberId);
		
		model.addAttribute("member", member);
		return "admin/member/detail";
	}
	
	//회원 상태 변경(NOMAL/BLOCKED)
	@PostMapping("/status")
	public String updateStatus(@RequestParam("memberId") Integer memberId, @RequestParam("status") String status, HttpSession session) {
		if(!isAdmin(session)) return "redirect:/auth/login";
		
		memberService.adminUpdateMemberStatus(memberId, status);
		return "redirect:/admin/members/detail?memberId="+memberId;
	}
	
	//회원 등급 변경
	@PostMapping("/grade")
	public String updateGrade(@RequestParam("memberId") Integer memberId,@RequestParam("gradeId") Integer gradeId, HttpSession session){
		if(!isAdmin(session)) return "redirect:/auth/login";
		
		memberService.adminUpdateMemberGrade(memberId, gradeId);
		return "redirect:/admin/members/detail?memberId="+memberId;
	}
}
