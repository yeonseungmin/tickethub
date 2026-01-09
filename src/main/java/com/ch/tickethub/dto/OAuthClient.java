package com.ch.tickethub.dto;

import lombok.Data;

@Data
public class OAuthClient {
	private String provider; //google, kakao, naver ...
	private String clientId; // 개발자 콘솔에서 앱등록 시 발급받은 클라이언트 ID
	private String clientSecret; // 개발자 콘솔에서 앱등록 시 발급받은 클라이언트 비밀번호
	private String authorizeUrl; // 클라이언트가 sns 로그인 버튼 누를 때, 요청 대상 URL
	private String tokenUrl; //리소스 오너의 정보를 조회할때 사용할 요청 주소
	private String userInfoUrl; //구글에 등록된 사용자 정보를 조회할때 사용할 URL
	private String scope;
	private String redirectUri;
}
