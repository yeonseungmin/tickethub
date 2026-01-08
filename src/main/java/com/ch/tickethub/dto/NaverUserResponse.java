package com.ch.tickethub.dto;

import lombok.Data;

/*
 * "resultcode: "00",
 * "message": "success",
 * "response": NaverUser 객체
 * 
 */
@Data
public class NaverUserResponse {
	private String resultcode;
	private String message;
	private NaverUser response;
}
