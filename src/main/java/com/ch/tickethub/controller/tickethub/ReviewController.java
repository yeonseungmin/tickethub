package com.ch.tickethub.controller.tickethub;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.ch.tickethub.dto.Review;
import com.ch.tickethub.model.review.ReviewService;

import lombok.extern.slf4j.Slf4j;

@Controller
@Slf4j
public class ReviewController {
	
	@Autowired
	ReviewService reviewService;
	
	
	@GetMapping("/detail/review")
	@ResponseBody
	public List<Review> getReview(int work_id) {
		
		return reviewService.getListByWorkId(work_id);
	}
}