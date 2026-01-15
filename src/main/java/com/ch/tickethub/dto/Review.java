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
	// active, blocked, deleted
	private String review_state;
	// 작성자에 의해 삭제될 경우 삭제일
	private String review_deleted_at;
	private int rating;
	private String review_regdate;
	
	private Work work;
	private Member member;
	
	private List<ReReview> reReviewList;
}