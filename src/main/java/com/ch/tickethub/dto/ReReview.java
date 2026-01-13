package com.ch.tickethub.dto;

import lombok.Data;

@Data
public class ReReview {
	private int re_review_id;
	private String re_review_content;
	private String re_review_regdate;
	
	private Review review;
	private Member member;
}