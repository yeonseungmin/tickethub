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
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.ch.tickethub.dto.Work;
import com.ch.tickethub.exception.UploadException;
import com.ch.tickethub.exception.WorkException;
import com.ch.tickethub.model.work.WorkService;

import lombok.extern.slf4j.Slf4j;

@Controller
@Slf4j
public class WorkController {
	
	@Autowired
	WorkService workService;

	@GetMapping("/performance/work")
	public String person() {
		
		return "admin/performance/work/work";
	}
	
	@GetMapping("/performance/work/registform")
	public String getRegistForm() {
		
		return "admin/performance/work/regist";
	}
	
	@PostMapping("/performance/work/regist")
	@ResponseBody
	public Map<String, String> regist(Work work, MultipartFile work_poster_img, MultipartFile work_content_img){

//		log.debug("work_title " + work.getWork_title());
//		log.debug("director " + work.getDirector());
//		log.debug("age_limit " + work.getAge_limit());
//		log.debug("work_price " + work.getWork_price());
//		log.debug("running_time " + work.getRunning_time());
//		log.debug("work_type " + work.getWork_type());
//		log.debug("ticket_start_date " + work.getTicket_start_date());
//		log.debug("work_start_date " + work.getWork_start_date());
//		log.debug("work_end_date " + work.getWork_end_date());
//		log.debug("장르는 " + work.getGenre().getGenre_id());
//		log.debug("주최/기획은 " + work.getPublisher().getPublisher_id());
//		log.debug("포스터 이미지는 " + work_poster_img.getOriginalFilename());
//		log.debug("내용 이미지는 " + work_content_img.getOriginalFilename());
		
		try {
			workService.regist(work, work_poster_img, work_content_img);
		} catch (Exception e) {
			workService.cancelUpload(work);
			e.printStackTrace();
			throw e;
		}
		
		Map<String, String> body = new HashMap<>();
		body.put("message", "작품 등록 성공");
		
		return body;
	}
	

	@GetMapping("/performance/work/listpage")
	public String getListPage() {
		
		return "admin/performance/work/list";
	}
	
	@GetMapping("/performance/work/list")
	@ResponseBody
	public List<Work> getList(){
		
		return workService.getList(); 
	}
	
	// MissingServletRequestParameterException.class 값을 제대로 입력 받지 못했을 때의 에러. 난 이것도 처리했다.
	@ExceptionHandler({WorkException.class, UploadException.class, MissingServletRequestParameterException.class})
	@ResponseBody
	public ResponseEntity<Map<String, String>> handle(Exception e){
		log.debug("작품 등록 시 예외가 발생하여, handler 메서드가 호출됨");
		
		Map<String, String> body = new HashMap<>();
		body.put("message", "작품 등록 실패");
		
		return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(body);
	}
	
}