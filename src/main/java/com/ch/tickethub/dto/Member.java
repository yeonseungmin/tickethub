package com.ch.tickethub.dto;

import java.util.Date;

import org.springframework.format.annotation.DateTimeFormat;

import lombok.Data;

@Data
public class Member {
	private Integer memberId; //일반 로그인 아이디
	private String loginId;
	private String passwordHash; //일반 로그인 패스워드
	private String name;
	private String email;
	@DateTimeFormat(pattern = "yyyy-MM-dd")
	private Date birthDate;
	private String phone;
	private String zipCode;
	private String address;
	private String status;
	private String role;
	private Integer gradeId;
	private Date createdAt;
	private Date updatedAt;
	private Date lastLoginAt;
	private String oauthProvider; // 소셜 로그인 이름
	private String oauthId; // 소셜 로그인 id
}
