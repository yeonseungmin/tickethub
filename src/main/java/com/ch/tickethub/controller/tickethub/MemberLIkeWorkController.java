package com.ch.tickethub.controller.tickethub;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.ResponseBody;

import com.ch.tickethub.dto.Member;
import com.ch.tickethub.dto.MemberLikeWork;
import com.ch.tickethub.dto.Review;
import com.ch.tickethub.dto.Work;
import com.ch.tickethub.model.memberLikeWork.MemberLikeWorkService;

import lombok.extern.slf4j.Slf4j;

@Controller
@Slf4j
public class MemberLIkeWorkController {
	
	@Autowired
	MemberLikeWorkService memberLikeWorkService;
	
	@GetMapping("/detail/member-like-work/regist")
	@ResponseBody
	public ResponseEntity<Map<String, String>> regist(int work_id, HttpSession session) {
		Member loginMember = (Member) session.getAttribute("loginMember");
		Map<String, String> body = new HashMap<>();
		
		if(loginMember == null) {
			body.put("message", "로그인이 필요한 서비스입니다.\n로그인 페이지로 이동하시겠습니까?");
			return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(body);
		}
		
		MemberLikeWork memberLikeWork = new MemberLikeWork();
		
		Work work = new Work();
		work.setWork_id(work_id);
		
		memberLikeWork.setWork(work);
		memberLikeWork.setMember(loginMember);
		
		memberLikeWorkService.regist(memberLikeWork);
		
		body.put("message", "작품 좋아요가 등록되었습니다.");
		
		return ResponseEntity.ok(body);
	}
}
