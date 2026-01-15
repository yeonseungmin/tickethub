package com.ch.tickethub.config.spring;

import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.jndi.JndiTemplate;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.servlet.config.annotation.EnableWebMvc;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurerAdapter;

import com.ch.tickethub.controller.tickethub.QueueInterceptor;
import com.ch.tickethub.dto.OAuthClient;
import com.ch.tickethub.interceptor.ProfileRequiredInterceptor;

@Configuration
@EnableWebMvc
@ComponentScan(basePackages = { "com.ch.tickethub.controller.tickethub" })
public class TickethubWebConfig extends WebMvcConfigurerAdapter {

	/*
	 * ------------------------------ 대기열 체크용 인터셉터 등록 ------------------------------
	 */
	@Bean
	public QueueInterceptor queueInterceptor() {
		return new QueueInterceptor();
	}

	// 프로필 완성 전까지는 로그인 못 하게 하는 인터셉터
	@Bean
	public ProfileRequiredInterceptor profileRequiredInterceptor() {
		return new ProfileRequiredInterceptor();
	}

	/*
	 * ------------------------------ 공통 Bean ------------------------------
	 */
	@Bean
	public JndiTemplate jndiTemplate() {
		return new JndiTemplate();
	}

	@Bean
	public RestTemplate restTemplate() {
		return new RestTemplate();
	}

	@Override
	public void addInterceptors(InterceptorRegistry registry) {

		// 1) 프로필 미완료면 무조건 /auth/profile로 보내기
		registry.addInterceptor(profileRequiredInterceptor()).addPathPatterns("/**").excludePathPatterns(
				// auth 쪽은 루프 방지 + 프로필 입력 허용
				"/auth/**",

				// 정적리소스
				"/assets/**", "/static/**", "/resources/**", "/css/**", "/js/**", "/images/**",

				// 대기열 페이지 자체는 막으면 안 됨
				"/queue/**",

				// (선택) 관리자 디스패처가 따로면 없어도 되지만, 안전하게 제외
				"/admin/**");

		// 2) 대기열 인터셉터
		registry.addInterceptor(queueInterceptor()).addPathPatterns("/**").excludePathPatterns("/queue/**")
				.excludePathPatterns("/assets/**").excludePathPatterns("/auth/**")
				.excludePathPatterns("/ticket/reservation/popup");
	}

	/*
	 * ------------------------------ OAuth Client Secrets (JNDI)
	 * ------------------------------
	 */
	@Bean
	public String googleClientId(JndiTemplate jndiTemplate) throws Exception {
		return (String) jndiTemplate.lookup("java:comp/env/google/client/id");
	}

	@Bean
	public String googleClientSecret(JndiTemplate jndiTemplate) throws Exception {
		return (String) jndiTemplate.lookup("java:comp/env/google/client/secret");
	}

	@Bean
	public String naverClientId(JndiTemplate jndiTemplate) throws Exception {
		return (String) jndiTemplate.lookup("java:comp/env/naver/client/id");
	}

	@Bean
	public String naverClientSecret(JndiTemplate jndiTemplate) throws Exception {
		return (String) jndiTemplate.lookup("java:comp/env/naver/client/secret");
	}

	@Bean
	public String kakaoClientId(JndiTemplate jndiTemplate) throws Exception {
		return (String) jndiTemplate.lookup("java:comp/env/kakao/client/id");
	}

	@Bean
	public String kakaoClientSecret(JndiTemplate jndiTemplate) throws Exception {
		return (String) jndiTemplate.lookup("java:comp/env/kakao/client/secret");
	}

	/*
	 * ------------------------------ (추가) Naver Map Client ID
	 * ------------------------------
	 */
	@Bean
	public String naverMapClientId(JndiTemplate jndiTemplate) throws Exception {
		return (String) jndiTemplate.lookup("java:comp/env/naver/map/client/id");
	}

	/*
	 * ------------------------------ OAuth Clients Map
	 * ------------------------------
	 */
	@Bean
	public Map<String, OAuthClient> oauthClients(@Qualifier("googleClientId") String googleClientId,
			@Qualifier("googleClientSecret") String googleClientSecret,
			@Qualifier("naverClientId") String naverClientId, @Qualifier("naverClientSecret") String naverClientSecret,
			@Qualifier("kakaoClientId") String kakaoClientId,
			@Qualifier("kakaoClientSecret") String kakaoClientSecret) {
		Map<String, OAuthClient> map = new HashMap<>();

		OAuthClient google = new OAuthClient();
		google.setProvider("google");
		google.setClientId(googleClientId);
		google.setClientSecret(googleClientSecret);
		google.setAuthorizeUrl("https://accounts.google.com/o/oauth2/v2/auth");
		google.setTokenUrl("https://oauth2.googleapis.com/token");
		google.setUserInfoUrl("https://openidconnect.googleapis.com/v1/userinfo");
		google.setScope("openid email profile");
		google.setRedirectUri("http://localhost:8888/auth/login/callback/google");
		map.put("google", google);

		OAuthClient naver = new OAuthClient();
		naver.setProvider("naver");
		naver.setClientId(naverClientId);
		naver.setClientSecret(naverClientSecret);
		naver.setAuthorizeUrl("https://nid.naver.com/oauth2.0/authorize");
		naver.setTokenUrl("https://nid.naver.com/oauth2.0/token");
		naver.setUserInfoUrl("https://openapi.naver.com/v1/nid/me");
		naver.setScope("name email");
		naver.setRedirectUri("http://localhost:8888/auth/login/callback/naver");
		map.put("naver", naver);

		OAuthClient kakao = new OAuthClient();
		kakao.setProvider("kakao");
		kakao.setClientId(kakaoClientId);
		kakao.setClientSecret(kakaoClientSecret);
		kakao.setAuthorizeUrl("https://kauth.kakao.com/oauth/authorize");
		kakao.setTokenUrl("https://kauth.kakao.com/oauth/token");
		kakao.setUserInfoUrl("https://kapi.kakao.com/v2/user/me");
		kakao.setScope("profile_nickname");
		kakao.setRedirectUri("http://localhost:8888/auth/login/callback/kakao");
		map.put("kakao", kakao);

		return map;
	}
}