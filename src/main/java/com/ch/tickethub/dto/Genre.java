package com.ch.tickethub.dto;

import java.util.List;

import lombok.Data;

@Data
public class Genre {
	private int genre_id;
	private String genre_name;
	
	private List<Work> workList;
}
