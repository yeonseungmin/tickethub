package com.ch.tickethub.dto;

import java.util.List;

import lombok.Data;

@Data
public class Review {
	private int review_id;
	private int hit;
	private int review_like_count;
	private String review_title;
	private String review_content;
	private String review_state;
	private int rating;
	private String review_regdate;
	
	private Work work;
	private Member member;
	
	private List<ReReview> reReviewList;
}