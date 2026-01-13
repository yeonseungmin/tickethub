package com.ch.tickethub.controller.admin;

import java.util.List;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import com.ch.tickethub.dto.Member;
import com.ch.tickethub.model.member.MemberService;

@Controller
@RequestMapping("/members")
public class AdminMemberController {

    @Autowired
    private MemberService memberService;

    private boolean isAdmin(HttpSession session) {
        Object obj = session.getAttribute("loginMember");
        if (obj == null) return false;
        return "ADMIN".equals(((Member)obj).getRole());
    }

    // ✅ 목록 (fragment로 리턴)
    @GetMapping
    public String list(
            @RequestParam(value = "keyword", required = false) String keyword,
            @RequestParam(value = "status", required = false) String status,
            @RequestParam(value = "gradeId", required = false) Integer gradeId,
            @RequestParam(value = "page", defaultValue = "1") int page,
            HttpSession session,
            Model model
    ) {
        if (!isAdmin(session)) return "redirect:/auth/login";

        int size = 10;

        int total = memberService.adminSelectMemberListCount(keyword, status, gradeId);
        int totalPage = (int)Math.ceil(total / (double) size);
        if (totalPage < 1) totalPage = 1;
        if (page < 1) page = 1;
        if (page > totalPage) page = totalPage;

        List<Member> members = memberService.adminSelectMemberList(keyword, status, gradeId, page, size);

        model.addAttribute("members", members);
        model.addAttribute("keyword", keyword);
        model.addAttribute("status", status);
        model.addAttribute("gradeId", gradeId);
        model.addAttribute("page", page);
        model.addAttribute("size", size);
        model.addAttribute("total", total);
        model.addAttribute("totalPage", totalPage);

        return "admin/members/list";
    }

    // ✅ 상세
    @GetMapping("/detail")
    public String detail(
            @RequestParam("memberId") Integer memberId,
            HttpSession session,
            Model model
    ) {
        if (!isAdmin(session)) return "redirect:/auth/login";

        Member member = memberService.adminSelectMemberDetail(memberId);
        model.addAttribute("member", member);

        return "admin/members/detail";
    }

    // ✅ 상태 변경 (AJAX POST 대응)
    @PostMapping("/status")
    @ResponseBody
    public String updateStatus(
            @RequestParam("memberId") Integer memberId,
            @RequestParam("status") String status,
            HttpSession session
    ) {
        if (!isAdmin(session)) return "FORBIDDEN";
        memberService.adminUpdateMemberStatus(memberId, status);
        return "OK";
    }

    // ✅ 등급 변경 (AJAX POST 대응)
    @PostMapping("/grade")
    @ResponseBody
    public String updateGrade(
            @RequestParam("memberId") Integer memberId,
            @RequestParam("gradeId") Integer gradeId,
            HttpSession session
    ) {
        if (!isAdmin(session)) return "FORBIDDEN";
        memberService.adminUpdateMemberGrade(memberId, gradeId);
        return "OK";
    }
}