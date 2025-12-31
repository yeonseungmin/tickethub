package com.ch.tickethub.controller.admin.performance;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.MissingServletRequestParameterException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.ch.tickethub.dto.Round;
import com.ch.tickethub.exception.RoundException;
import com.ch.tickethub.exception.UploadException;

import lombok.extern.slf4j.Slf4j;

@Controller
@Slf4j
public class RoundController {
	
	@Autowired

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
	public Map<String, String> regist(Round round, @RequestParam("round_start_time") List<String> roundStartTimeList){
		log.debug("round_date " + round.getRound_date());
		log.debug("place_id " + round.getPlace().getPlace_id());
		log.debug("work_id " + round.getWork().getWork_id());
		
		for(String roundStartTime : roundStartTimeList) {
			log.debug("round_start_time " + roundStartTime);
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
	@ExceptionHandler({RoundException.class, UploadException.class, MissingServletRequestParameterException.class})
	@ResponseBody
	public ResponseEntity<Map<String, String>> handle(Exception e){
		log.debug("회차 등록 시 예외가 발생하여, handler 메서드가 호출됨");
		
		Map<String, String> body = new HashMap<>();
		body.put("message", "회차 등록 실패");
		
		return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(body);
	}
	
}