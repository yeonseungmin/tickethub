package com.ch.tickethub.dto;

import lombok.Data;

@Data
public class Member {
	private Integer memberId; //일반 로그인 아이디
	private String loginId;
	private String passwordHash; //일반 로그인 패스워드
	private String name;
	private String birthDate;
	private String phone;
	private String zipCode;
	private String address;
	private String status;
	private String role;
	private Integer gradeId;
	private String createdAt;
	private String updatedAt;
	private String lastLoginAt;
	private String oauthProvider; // 소셜 로그인 이름
	private String oauthId; // 소셜 로그인 id
}
