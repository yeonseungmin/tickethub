package com.ch.tickethub.dto;

import lombok.Data;

@Data
public class Member {
	private Integer memberId;
	private String loginId;
	private String passwordHash;
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
	private String oauthProvider;
	private String oauthId;
}
