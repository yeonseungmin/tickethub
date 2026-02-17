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

import com.ch.tickethub.dto.Person;
import com.ch.tickethub.dto.Place;
import com.ch.tickethub.dto.SeatGroup;
import com.ch.tickethub.exception.PersonException;
import com.ch.tickethub.exception.PlaceException;
import com.ch.tickethub.exception.UploadException;
import com.ch.tickethub.model.person.PersonService;
import com.ch.tickethub.model.place.PlaceService;
import com.ch.tickethub.model.seatgroup.SeatGroupService;

import lombok.extern.slf4j.Slf4j;


@Controller
@Slf4j
public class PlaceController {
	
	@Autowired
	PlaceService placeService;
	@Autowired
	SeatGroupService seatGroupService;

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
	
	@PostMapping("/performance/place/delete")
	@ResponseBody
	public Map<String, String> remove(int place_id) {
		
		try {
			placeService.remove(place_id);
		} catch (Exception e) {
			e.printStackTrace();
			throw e;
		}
		
		Map<String, String> body = new HashMap<>();
		body.put("message", "장소 삭제 성공");
		
		return body;
	}
	
	@PostMapping("/performance/place/update")
	@ResponseBody
	public Map<String, String> setPlace(Place place) {

	    Map<String, String> body = new HashMap<>();

	    try {
	        placeService.setPlace(place); 

	        body.put("message", "정보가 성공적으로 수정되었습니다.");
	        return body;
	        
	    } catch (Exception e) {
			e.printStackTrace();
	        throw e;
	    }
	}
	
	@ExceptionHandler({PlaceException.class, MissingServletRequestParameterException.class})
	@ResponseBody
	public ResponseEntity<Map<String, String>> handle(Exception e){
		log.debug("장소 예외가 발생하여, handler 메서드가 호출됨");
		
		Map<String, String> body = new HashMap<>();
		body.put("message", "장소 실패");
		
		return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(body);
	}
	
	// 구역 목록 AJAX 요청 처리 (404 해결용)
		@GetMapping("/performance/place/group/list")
		@ResponseBody
		public List<SeatGroup> getGroupList(@RequestParam("place_id") int placeId) {
			log.debug("구역 목록 요청 수신 - 장소 ID: {}", placeId);
			// 서비스의 메서드 명칭인 getByPlace를 사용합니다.
			return seatGroupService.getByPlace(placeId);
		}
}
