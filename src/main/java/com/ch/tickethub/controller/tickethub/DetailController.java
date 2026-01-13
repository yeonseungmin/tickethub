package com.ch.tickethub.controller.tickethub;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.ch.tickethub.dto.Member;
import com.ch.tickethub.dto.Review;
import com.ch.tickethub.dto.RoundCasting;
import com.ch.tickethub.dto.Work;
import com.ch.tickethub.exception.ReviewException;
import com.ch.tickethub.model.review.ReviewService;
import com.ch.tickethub.model.work.WorkService;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;

import lombok.extern.slf4j.Slf4j;

@Controller
@Slf4j
public class DetailController {
	
	@Autowired
	WorkService workService;
	
    @Autowired
    @Qualifier("naverMapClientId")
    private String naverMapClientId;

	@Autowired
	ReviewService reviewService;
	
	@GetMapping("/detail")
	public String getDetail(int work_id, Model model) {
		
		Work work = workService.getWork(work_id);
		List<RoundCasting> uniqueCastingList = workService.getUniqueCasting(work);
		

		
		model.addAttribute("work", work);
		model.addAttribute("uniqueCastingList", uniqueCastingList);
		model.addAttribute("naverMapClientId", naverMapClientId);
		
		ObjectMapper mapper = new ObjectMapper();
		
		try {
			String jsonWork = mapper.writeValueAsString(work);
			model.addAttribute("jsonWork", jsonWork);
		} catch (JsonProcessingException e) {
			e.printStackTrace();
		}
		
		return "/ticket/detail/index";
	}
	
	// orderType latest, rating, likes
	@GetMapping("/detail/review")
	@ResponseBody
	public List<Review> getReview(int work_id, String orderType) {
		//log.debug("orderType은 {}", orderType);
		
		return reviewService.getListByWorkId(work_id , orderType);
	}
	
	@PostMapping("/detail/review/regist")
	@ResponseBody
	public ResponseEntity<Map<String, String>> regist(@RequestBody Review review, HttpSession session){
		Member loginMember = (Member) session.getAttribute("loginMember");
		Map<String, String> body = new HashMap<>();
		
		if(loginMember == null) {
			body.put("message", "로그인이 필요한 서비스입니다.\n로그인 페이지로 이동하시겠습니까?");
			return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(body);
		}
		
		
		review.setMember(loginMember);
		log.debug("Review = {}", review);
		
		reviewService.regist(review);
		
		body.put("message", "리뷰가 등록되었습니다.");
		
		return ResponseEntity.ok(body);
	}
	
	// 2. [추가] 예매 팝업창 호출 메서드
    @GetMapping("/ticket/reservation/popup")
    public String openReservation(@RequestParam("work_id") int workId, @RequestParam("round_id") int roundId, Model model) {
        log.info("예매 팝업 호출 - 공연ID: {}, 회차ID: {}", workId, roundId);
        
        // JSP에서 사용할 수 있도록 모델에 담아줍니다.
        model.addAttribute("workId", workId);
        model.addAttribute("roundId", roundId);
        
        // 사용자가 말한 경로: /ticket/reservation/reservation.jsp
        return "/ticket/reservation/popup";
    }
    
	@ExceptionHandler({ReviewException.class})
	@ResponseBody
	public ResponseEntity<Map<String, String>> handle(Exception e){
		log.debug("리뷰 등록 시 예외가 발생하여, handler 메서드가 호출됨");
		
		Map<String, String> body = new HashMap<>();
		body.put("message", "서버 오류로 인해 등록에 실패했습니다.");
		
		return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(body);
	}
}
