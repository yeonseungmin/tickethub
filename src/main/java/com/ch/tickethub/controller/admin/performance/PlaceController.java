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
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.ch.tickethub.dto.Place;
import com.ch.tickethub.exception.PersonException;
import com.ch.tickethub.exception.PlaceException;
import com.ch.tickethub.exception.UploadException;
import com.ch.tickethub.model.person.PersonService;
import com.ch.tickethub.model.place.PlaceService;

import lombok.extern.slf4j.Slf4j;


@Controller
@Slf4j
public class PlaceController {
	
	@Autowired
	PlaceService placeService;

	@GetMapping("/performance/place")
	public String person() {
		
		return "admin/performance/place/place";
	}
	
	@GetMapping("/performance/place/registform")
	public String getRegistForm() {
		
		return "admin/performance/place/regist";
	}
	
	@PostMapping("/performance/place/regist")
	@ResponseBody
	/* 복잡한 List는 그냥 @RequestBody JSON이 GOAT
	 *  */
	public Map<String, String> regist(@RequestBody List<Place> placeList) {
		
		for(Place place : placeList) {
			log.debug("공연장소이름 " + place.getPlace_name());
			log.debug("주소 " + place.getAddress());
			log.debug("위도 " + place.getLatitude());
			log.debug("경도  " + place.getLongitude());
		}

		
		try {
			placeService.regist(placeList);
		} catch (Exception e) {
			e.printStackTrace();
			throw e;
		}
		
		Map<String, String> body = new HashMap<>();
		body.put("message", "장소등록 성공");
		
		return body;
	}
	

	@GetMapping("/performance/place/listpage")
	public String getListPage() {
		
		return "admin/performance/place/list";
	}
	
	@GetMapping("/performance/place/list")
	@ResponseBody
	public List<Place> getList(){
		return placeService.getList();
	}
	
	@ExceptionHandler({PlaceException.class, MissingServletRequestParameterException.class})
	@ResponseBody
	public ResponseEntity<Map<String, String>> handle(Exception e){
		log.debug("장소 등록 시 예외가 발생하여, handler 메서드가 호출됨");
		
		Map<String, String> body = new HashMap<>();
		body.put("message", "장소 등록 실패");
		
		return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(body);
	}
	
}
