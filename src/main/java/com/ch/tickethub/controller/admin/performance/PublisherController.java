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
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.ResponseBody;

import com.ch.tickethub.dto.Publisher;
import com.ch.tickethub.exception.PublisherException;
import com.ch.tickethub.model.publisher.PublisherService;

import lombok.extern.slf4j.Slf4j;


@Controller
@Slf4j
public class PublisherController {
	
	@Autowired
	PublisherService publisherService;

	@GetMapping("/performance/publisher")
	public String person() {
		
		return "admin/performance/publisher/publisher";
	}
	
	@GetMapping("/performance/publisher/registform")
	public String getRegistForm() {
		
		return "admin/performance/publisher/regist";
	}
	
	@PostMapping("/performance/publisher/regist")
	@ResponseBody
	/* 복잡한 List는 그냥 @RequestBody JSON이 GOAT
	 *  */
	public Map<String, String> regist(@RequestBody List<Publisher> publisherList) {
		
		for(Publisher publisher : publisherList) {
			log.debug("주최/기획 " + publisher.getPublisher_name());
			log.debug("전화번호 " + publisher.getPublisher_phone());
		}

		
		try {
			publisherService.regist(publisherList);
		} catch (Exception e) {
			e.printStackTrace();
			throw e;
		}
		
		Map<String, String> body = new HashMap<>();
		body.put("message", "주최/기획 등록 성공");
		
		return body;
	}
	

	@GetMapping("/performance/publisher/listpage")
	public String getListPage() {
		
		return "admin/performance/publisher/list";
	}
	
	@GetMapping("/performance/publisher/list")
	@ResponseBody
	public List<Publisher> getList() {
	
		return publisherService.getList();
	}
	
	
	@ExceptionHandler({PublisherException.class, MissingServletRequestParameterException.class})
	@ResponseBody
	public ResponseEntity<Map<String, String>> handle(Exception e){
		log.debug("주최/기획 등록 시 예외가 발생하여, handler 메서드가 호출됨");
		
		Map<String, String> body = new HashMap<>();
		body.put("message", "주최/기획 등록 실패");
		
		return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(body);
	}
	
}
