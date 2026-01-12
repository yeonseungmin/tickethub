package com.ch.tickethub.dto;

import lombok.Data;

@Data
public class BestReview {

	private int bestreview_id;
	private int review_id;
	
	private Work work;	// 조인용
	private Review review;	// 조인용
}
