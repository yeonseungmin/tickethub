package com.ch.tickethub.dto;

import lombok.Data;

@Data
public class MainBanner {

	private int mainbanner_id;
	private String main_image_url;
	private int work_id;
	private int display_order;

	private Work work; // 조인용
}
