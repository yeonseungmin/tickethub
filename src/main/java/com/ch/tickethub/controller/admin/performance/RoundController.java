package com.ch.tickethub.controller.admin.performance;

import java.sql.SQLIntegrityConstraintViolationException;
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

import com.ch.tickethub.dto.Round;
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
	
	
	@GetMapping("/performance/round/list")
	@ResponseBody
	public List<Round> getRoundList(@RequestParam("work_id") int work_id) {
		log.debug("회차 목록 요청 수신 - 공연 ID: {}", work_id);
		return roundService.findByWorkId(work_id);
	}
	
	// 관리자 좌석 관리 페이지에서 회차 목록을 불러올 때 사용
	@GetMapping("/roundseat/roundList")
	@ResponseBody
	public List<Round> getAdminRoundList(@RequestParam("work_id") int work_id, @RequestParam("place_id") int place_id) {
		log.debug("관리자 회차 필터링 요청 - 공연: {}, 장소: {}", work_id, place_id);
		// 서비스 호출 시 두 ID를 모두 전달
		return roundService.selectByWorkAndPlace(work_id, place_id); 
	}
	
	@PostMapping("/performance/round/cancel")
	@ResponseBody
	public ResponseEntity<Map<String, String>> cancelRound(
	        @RequestParam("round_id") int round_id,
	        @RequestParam("is_cancelled") boolean is_cancelled) {

	    Map<String, String> body = new HashMap<>();

	    try {
	        // 서비스 호출 (회차 ID와 변경할 상태값 전달)
	        roundService.setCancelStatus(round_id, is_cancelled);

	        String msg = is_cancelled ? "회차가 취소되었습니다." : "회차가 성공적으로 복구되었습니다.";
	        body.put("message", msg);
	        return ResponseEntity.ok(body);

	    } catch (Exception e) {
	        throw e;
	    }
	}
	
	@PostMapping("/performance/round/delete")
	@ResponseBody
	public ResponseEntity<Map<String, String>> removeRound(@RequestParam("round_id") int round_id) {

	    Map<String, String> body = new HashMap<>();

	    try {
	        // 서비스의 삭제 메서드 호출
	        roundService.removeRound(round_id);

	        body.put("message", "회차 정보와 관련 캐스팅 데이터가 삭제되었습니다.");
	        return ResponseEntity.ok(body);

	    } catch (Exception e) {
	        e.printStackTrace();
	        throw e;
	    }
	}
	
	@GetMapping("/performance/round/copypage")
	public String getCopyPage() {
		
		return "admin/performance/round/copy";
	}
	
	@PostMapping("/performance/round/copy")
	@ResponseBody
	public ResponseEntity<Map<String, String>> copyDayRounds(@RequestBody Map<String, Object> payload) {
	    Map<String, String> body = new HashMap<>();
	    try {
	        int work_id = Integer.parseInt(payload.get("work_id").toString());
	        String sourceDate = (String) payload.get("source_date");
	        List<String> targetDates = (List<String>) payload.get("target_dates");

	        // 핵심 로직은 서비스에서 처리
	        roundService.copyDaySchedule(work_id, sourceDate, targetDates);

	        body.put("message", "선택한 날짜들로 회차 정보가 복사되었습니다.");
	        return ResponseEntity.ok(body);
	    } catch (Exception e) {
	        e.printStackTrace();
	        throw e;
	    }
	}
	
	// MissingServletRequestParameterException.class 값을 제대로 입력 받지 못했을 때의 에러.
	@ExceptionHandler({RoundException.class, UploadException.class, MissingServletRequestParameterException.class, RoundCastingException.class, SQLIntegrityConstraintViolationException.class})
	@ResponseBody
	public ResponseEntity<Map<String, String>> handle(Exception e){
		log.debug("회차 예외가 발생하여, handler 메서드가 호출됨");
		
		Map<String, String> body = new HashMap<>();
		body.put("message", "회차 실패");
		
		return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(body);
	}
	
	
}