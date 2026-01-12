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

@Configuration
@EnableWebMvc
@ComponentScan(basePackages = {"com.ch.tickethub.controller.tickethub"})
public class TickethubWebConfig extends WebMvcConfigurerAdapter {

    /* ------------------------------
       대기열 체크용 인터셉터 등록
    ------------------------------ */
    @Bean
    public QueueInterceptor queueInterceptor() {
        return new QueueInterceptor();
    }

    /* ------------------------------
    공통 Bean
 ------------------------------ */
 @Bean
 public JndiTemplate jndiTemplate() {
     return new JndiTemplate();
 }

 @Bean
 public RestTemplate restTemplate() {
     return new RestTemplate();
 }
    
    @Override
    public void addInterceptors(org.springframework.web.servlet.config.annotation.InterceptorRegistry registry) {
        registry.addInterceptor(queueInterceptor())
                .addPathPatterns("/**") 
                .excludePathPatterns("/queue/**") // 대기 페이지 예외
                .excludePathPatterns("/assets/**") // 이미지, CSS 같은 정적 파일 예외
                .excludePathPatterns("/auth/**")  // 로그인 관련 페이지,,, 일단 예외 > 추가 수정 필요.
        		.excludePathPatterns("/ticket/reservation/popup");	//  티켓 예매 popup 로그인 전이므로 일단 예외 > 추가 수정 필요.
    }
   

    /* ------------------------------
       OAuth Client Secrets (JNDI)
    ------------------------------ */
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

    /* ------------------------------
       (추가) Naver Map Client ID
    ------------------------------ */
    @Bean
    public String naverMapClientId(JndiTemplate jndiTemplate) throws Exception {
        return (String) jndiTemplate.lookup("java:comp/env/naver/map/client/id");
    }

    /* ------------------------------
       OAuth Clients Map
    ------------------------------ */
    @Bean
    public Map<String, OAuthClient> oauthClients(
            @Qualifier("googleClientId") String googleClientId,
            @Qualifier("googleClientSecret") String googleClientSecret,
            @Qualifier("naverClientId") String naverClientId,
            @Qualifier("naverClientSecret") String naverClientSecret,
            @Qualifier("kakaoClientId") String kakaoClientId,
            @Qualifier("kakaoClientSecret") String kakaoClientSecret
    ) {
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