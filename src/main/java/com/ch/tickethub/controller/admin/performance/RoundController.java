package com.ch.tickethub.controller.admin.performance;

import java.sql.SQLIntegrityConstraintViolationException;
import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.MissingServletRequestParameterException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.ResponseBody;

import com.ch.tickethub.exception.RoundCastingException;
import com.ch.tickethub.exception.RoundException;
import com.ch.tickethub.exception.UploadException;
import com.ch.tickethub.model.round.RoundService;
import com.ch.tickethub.request.Casting;
import com.ch.tickethub.request.RoundDetail;
import com.ch.tickethub.request.RoundRegistRequest;

import lombok.extern.slf4j.Slf4j;

@Controller
@Slf4j
public class RoundController {
	
	@Autowired
	RoundService roundService;

	@GetMapping("/performance/round")
	public String person() {
		
		return "admin/performance/round/round";
	}
	
	@GetMapping("/performance/round/registform")
	public String getRegistForm() {
		
		return "admin/performance/round/regist";
	}
	
	@PostMapping("/performance/round/regist")
	@ResponseBody
	public Map<String, String> regist(@RequestBody RoundRegistRequest roundRegistRequest){
		//log.debug("수신 데이터: {}", roundRegistRequest);
		
		try {
			roundService.regist(roundRegistRequest);
		} catch (Exception e) {
			e.printStackTrace();
			throw e;
		}
		
		Map<String, String> body = new HashMap<>();
		body.put("message", "회차 등록 성공");
		
		return body;
	}
	

	@GetMapping("/performance/round/listpage")
	public String getListPage() {
		
		return "admin/performance/round/list";
	}
	
	// MissingServletRequestParameterException.class 값을 제대로 입력 받지 못했을 때의 에러. 난 이것도 처리했다.
	@ExceptionHandler({RoundException.class, UploadException.class, MissingServletRequestParameterException.class, RoundCastingException.class, SQLIntegrityConstraintViolationException.class})
	@ResponseBody
	public ResponseEntity<Map<String, String>> handle(Exception e){
		log.debug("회차 등록 시 예외가 발생하여, handler 메서드가 호출됨");
		
		Map<String, String> body = new HashMap<>();
		body.put("message", "회차 등록 실패");
		
		return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(body);
	}
	
}