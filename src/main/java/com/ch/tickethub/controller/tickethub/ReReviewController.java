package com.ch.tickethub.controller.tickethub;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.ResponseBody;

import com.ch.tickethub.dto.Member;
import com.ch.tickethub.dto.ReReview;
import com.ch.tickethub.exception.ReReviewException;
import com.ch.tickethub.model.rereview.ReReviewService;

import lombok.extern.slf4j.Slf4j;

@Controller
@Slf4j
public class ReReviewController {
	
	@Autowired
	ReReviewService reReviewService;
	
	@PostMapping("/detail/re_review/regist")
	@ResponseBody
	public ResponseEntity<Map<String, String>> regist(@RequestBody ReReview reReview, HttpSession session){
		log.debug("reReview = {}", reReview);
		
		Member loginMember = (Member) session.getAttribute("loginMember");
		Map<String, String> body = new HashMap<>();
		
		if(loginMember == null) {
			body.put("message", "로그인이 필요한 서비스입니다.\n로그인 페이지로 이동하시겠습니까?");
			return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(body);
		}

		reReview.setMember(loginMember);
		
		
		reReviewService.regist(reReview);
		
		body.put("message", "답글이 등록되었습니다.");
		
		return ResponseEntity.ok(body);
	}
	
	@PostMapping("/detail/re_review/delete")
	@ResponseBody
	public ResponseEntity<Map<String, String>> remove(@RequestBody ReReview reReview, HttpSession session){
		log.debug("reReview = {}", reReview);
		
		Member loginMember = (Member) session.getAttribute("loginMember");
		Map<String, String> body = new HashMap<>();
		
		if(loginMember == null) {
			body.put("message", "로그인이 필요한 서비스입니다.\n로그인 페이지로 이동하시겠습니까?");
			return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(body);
		}
		
		reReviewService.remove(reReview.getRe_review_id());
		
		body.put("message", "답글이 삭제되었습니다.");
		
		return ResponseEntity.ok(body);
	}
	
	@ExceptionHandler({ReReviewException.class})
	@ResponseBody
	public ResponseEntity<Map<String, String>> handle(Exception e){
		log.debug("답글에서 예외가 발생하여, handler 메서드가 호출됨");
		
		Map<String, String> body = new HashMap<>();
		body.put("message", "서버 오류로 인해 실패했습니다.");
		
		return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(body);
	}
}
