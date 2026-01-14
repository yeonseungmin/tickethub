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
import com.ch.tickethub.dto.Report;
import com.ch.tickethub.exception.ReportException;
import com.ch.tickethub.model.report.ReportService;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class ReportController {
	
	@Autowired
	ReportService reportService;
	
	@PostMapping("/detail/report/regist")
	@ResponseBody
	public ResponseEntity<Map<String, String>> regist(@RequestBody Report report, HttpSession session){
		Member loginMember = (Member) session.getAttribute("loginMember");
		Map<String, String> body = new HashMap<>();
		
		if(loginMember == null) {
			body.put("message", "로그인이 필요한 서비스입니다.\n로그인 페이지로 이동하시겠습니까?");
			return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(body);
		}
		
		//log.debug("Report = {}", report);
		
		reportService.regist(report);
		
		body.put("message", "신고가 접수되었습니다.");
		
		return ResponseEntity.ok(body);
	}
	
	@ExceptionHandler({ReportException.class})
	@ResponseBody
	public ResponseEntity<Map<String, String>> handle(Exception e){
		log.debug("신고에서 예외가 발생하여, handler 메서드가 호출됨");
		
		Map<String, String> body = new HashMap<>();
		body.put("message", "서버 오류로 인해 신고 접수에 실패했습니다.");
		
		return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(body);
	}
}
