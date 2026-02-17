package com.ch.tickethub.controller.admin.performance;


import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.MissingServletRequestParameterException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.ch.tickethub.dto.Person;
import com.ch.tickethub.dto.Report;
import com.ch.tickethub.dto.ReportCategory;
import com.ch.tickethub.exception.PersonException;
import com.ch.tickethub.exception.UploadException;
import com.ch.tickethub.model.person.PersonService;

import lombok.extern.slf4j.Slf4j;


@Controller
@Slf4j
public class PersonController {
	
	@Autowired
	PersonService personService;

	@GetMapping("/performance/person")
	public String person() {
		
		return "admin/performance/person/person";
	}
	
	@GetMapping("/performance/person/registform")
	public String getRegistForm() {
		
		return "admin/performance/person/regist";
	}
	
	@PostMapping("/performance/person/regist")
	@ResponseBody
	public Map<String, String> regist(
			@RequestParam("person_name") List<String> nameList,
			@RequestParam("profile_img") List<MultipartFile> imgList) {
		
		for(MultipartFile img : imgList) {
			log.debug("프로필 이미지명은 " + img.getOriginalFilename());	
		}
		
		try {
			personService.regist(nameList, imgList);
		} catch (Exception e) {
			e.printStackTrace();
			throw e;
		}
		
		Map<String, String> body = new HashMap<>();
		body.put("message", "인물등록 성공");
		
		return body;
	}
	

	@GetMapping("/performance/person/listpage")
	public String getListPage() {
		
		return "admin/performance/person/list";
	}

	
	@GetMapping("/performance/person/list")
	@ResponseBody
	public List<Person> getList() {
		
		return personService.getList();
	}

	@PostMapping("/performance/person/delete")
	@ResponseBody
	public Map<String, String> remove(int person_id) {
		
		try {
			personService.remove(person_id);
		} catch (Exception e) {
			e.printStackTrace();
			throw e;
		}
		
		Map<String, String> body = new HashMap<>();
		body.put("message", "인물삭제 성공");
		
		return body;
	}
	
	@PostMapping("/performance/person/update")
	@ResponseBody
	public Map<String, String> setPerson(Person person, 
	        @RequestParam(value = "profile_img", required = false) MultipartFile img) {

	    Map<String, String> body = new HashMap<>();

	    try {
	        if (img != null && !img.isEmpty()) {
	            personService.setPerson(person, img); 	            
	        } else {
	        	throw new PersonException("이미지가 비어있습니다");
	        }


	        body.put("message", "정보가 성공적으로 수정되었습니다.");
	        return body;
	        
	    } catch (PersonException e) {
			throw e;
		} catch (Exception e) {
			e.printStackTrace();
	        throw e;
	    }
	}
	
	// MissingServletRequestParameterException.class 값을 제대로 입력 받지 못했을 때의 에러. 난 이것도 처리했다.
	@ExceptionHandler({PersonException.class, UploadException.class, MissingServletRequestParameterException.class})
	@ResponseBody
	public ResponseEntity<Map<String, String>> handle(Exception e){
		log.debug("인물 예외가 발생하여, handler 메서드가 호출됨");
		
		Map<String, String> body = new HashMap<>();
		body.put("message", "인물 실패");
		
		return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(body);
	}
	
}
