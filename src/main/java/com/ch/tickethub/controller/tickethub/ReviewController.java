package com.ch.tickethub.controller.tickethub;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.ResponseBody;

import com.ch.tickethub.dto.Member;
import com.ch.tickethub.dto.Review;
import com.ch.tickethub.exception.ReReviewException;
import com.ch.tickethub.exception.ReviewException;
import com.ch.tickethub.model.review.ReviewService;

import lombok.extern.slf4j.Slf4j;

@Controller
@Slf4j
public class ReviewController {
	
	@Autowired
	ReviewService reviewService;
	
	// orderType latest, rating, likes
	@GetMapping("/detail/review/list")
	@ResponseBody
	public List<Review> getReviewList(int work_id, String orderType) {
		//log.debug("orderType은 {}", orderType);
		
		return reviewService.getListByWorkId(work_id , orderType);
	}
	
	@GetMapping("/detail/review")
	@ResponseBody
	public Review getReview(int review_id) {
		//log.debug("review_id는 {}", review_id);
		
		return reviewService.getReview(review_id);
	}
	
	@GetMapping("/detail/review/stats")
	@ResponseBody
	public double getReviewStats(int work_id) {
		Map<String, Object> stats = reviewService.getReviewStats(work_id);
		
		double avgRating = 0.0;
		Object val = stats.get("avgRating");
		
		return avgRating = ((java.math.BigDecimal) val).doubleValue();
	}
	
	@PostMapping("/detail/review/hit/update")
	@ResponseBody
	public Review setHit(@RequestBody Review review) {
		
		reviewService.setHit(review.getReview_id());
		
		return reviewService.getReview(review.getReview_id());
	}
	
	@PostMapping("/detail/review/like/update")
	@ResponseBody
	public Review setLikeCount(@RequestBody Review review) {
		
		reviewService.setLikeCount(review.getReview_id());
		
		return reviewService.getReview(review.getReview_id());
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
	
	@PostMapping("/detail/review/soft/delete")
	@ResponseBody
	public ResponseEntity<Map<String, String>> remove(@RequestBody Review review, HttpSession session){
		Member loginMember = (Member) session.getAttribute("loginMember");
		Map<String, String> body = new HashMap<>();
		
		if(loginMember == null) {
			body.put("message", "로그인이 필요한 서비스입니다.\n로그인 페이지로 이동하시겠습니까?");
			return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(body);
		}

		reviewService.remove(review.getReview_id());
		
		body.put("message", "리뷰가 삭제되었습니다.");
		
		return ResponseEntity.ok(body);
	}
	
	@ExceptionHandler({ReviewException.class})
	@ResponseBody
	public ResponseEntity<Map<String, String>> handle(Exception e){
		log.debug("리뷰에서 예외가 발생하여, handler 메서드가 호출됨");
		
		Map<String, String> body = new HashMap<>();
		body.put("message", "서버 오류로 인해 실패했습니다.");
		
		return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(body);
	}
}
