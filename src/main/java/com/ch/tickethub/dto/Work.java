package com.ch.tickethub.dto;

import java.util.List;

import lombok.Data;

@Data
public class Work {
	private int work_id;
	private String work_title;
	private String director;
	private String work_poster_url;
	private String work_content_url;
	private int work_like_count;
	private int age_limit;
	private int work_price;
	
	private int running_time;				// minute
	private String ticket_start_date;	// yyyy-MM-dd HH:mm
	private String work_start_date;		// yyyy-MM-dd
	private String work_end_date; 		// yyyy-MM-dd
	
	private String work_type;				// round(회차) period(상시)
	
	private Genre genre;
	private Publisher publisher;
	
	private List<Round> roundList;
	
}