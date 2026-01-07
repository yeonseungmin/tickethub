package com.ch.tickethub.dto;

import com.fasterxml.jackson.annotation.JsonProperty;

import lombok.Data;

//토큰을 이용하여, 사용자정보를 요청할 때 서버측에서 보내온 정보를 담게될 객체
@Data
public class GoogleUser {
	@JsonProperty("sub")
	private String id; //구글에서 사용자를 구분하기 위한 openid를 우리에게 보내줄때는 id라는 용어른 쓰지 않는다...
						//sub라는 키값으로 보내온다.. 하지만 개발자가 id변수명을 고집하고싶을 경우, 어노테이션을 명시하면 자동으로 매핑해줌
	private String email;
	private Boolean verified_email;
	private String name;
	private String given_name;
	private String family_name;
	private String picture; //프로필 사진 Url
	private String locale; //언어설정
}
