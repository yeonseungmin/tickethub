package com.ch.tickethub.config.spring;

import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.jndi.JndiTemplate;
import org.springframework.scheduling.annotation.EnableScheduling;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.servlet.config.annotation.EnableWebMvc;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurerAdapter;

import com.ch.tickethub.controller.tickethub.QueueInterceptor;
import com.ch.tickethub.dto.OAuthClient;

@Configuration  // 단지 xml을 대신한 설정용 클래스에 불과함
@EnableWebMvc       // 필수 설정(스프링이 지원하는 MVC 프레임워크를 사용하기 위한 어노테이션)
@EnableScheduling
@ComponentScan(basePackages = {"com.ch.tickethub"})
public class TickethubWebConfig extends WebMvcConfigurerAdapter{
    
    /*context.xml 등에 명시된 외부 자원을 JNDI 방식으로 읽어들일 수 있는 스프링의 객체*/ 
    
	/*--------------------------------------------------
	 대기열 체크용 인터셉터 등록
	--------------------------------------------------*/
    @Bean
    public QueueInterceptor queueInterceptor() {
   	 return new QueueInterceptor();
    }
    
    @Override
    public void addInterceptors(org.springframework.web.servlet.config.annotation.InterceptorRegistry registry) {
        registry.addInterceptor(queueInterceptor())
                .addPathPatterns("/**") 
                .excludePathPatterns("/queue/**") // 대기 페이지 예외
                .excludePathPatterns("/assets/**") // 이미지, CSS 같은 정적 파일 예외
                .excludePathPatterns("/auth/**");  // 로그인 관련 페이지,,, 일단 예외 > 추가 수정 필요.
    }
	
    @Bean
    public JndiTemplate jndiTemplate() {
        return new JndiTemplate();
    }

    @Bean
    public RestTemplate restTemplate() {
        return new RestTemplate();
    }

     @Bean
     public String googleClientId(JndiTemplate jndiTemplate) throws Exception{
         return (String)jndiTemplate.lookup("java:comp/env/google/client/id");
     }
     
     @Bean
     public String googleClientSecret(JndiTemplate jndiTemplate) throws Exception{
         return (String)jndiTemplate.lookup("java:comp/env/google/client/secret");
     }
     
     @Bean
     public String naverClientId(JndiTemplate jndiTemplate) throws Exception{
         return (String)jndiTemplate.lookup("java:comp/env/naver/client/id");
     }
     
     @Bean
     public String naverClientSecret(JndiTemplate jndiTemplate) throws Exception{
         return (String)jndiTemplate.lookup("java:comp/env/naver/client/secret");
     }
     
     @Bean
     public String kakaoClientId(JndiTemplate jndiTemplate) throws Exception{
         return (String)jndiTemplate.lookup("java:comp/env/kakao/client/id");
     }
     
     @Bean
     public String kakaoClientSecret(JndiTemplate jndiTemplate) throws Exception{
         return (String)jndiTemplate.lookup("java:comp/env/kakao/client/secret");
     }
     
     // 구글 로그인 시 사용되는 환경변수(요청 주소, 콜백 주소.. 등등) 객체로 담아서 관리하면 유지하기 좋다
     // 우리의 경우 여러 프로바이더를 연동할 것이므로, OAuthClient 객체를 여러개 메모리에 보관해놓자 
     @Bean
     public Map<String, OAuthClient> oauthClients(
             @Qualifier("googleClientId") String googleClientId,
             @Qualifier("googleClientSecret") String googleClientSecret,
             @Qualifier("naverClientId") String naverClientId,
             @Qualifier("naverClientSecret") String naverClientSecret,
             @Qualifier("kakaoClientId") String kakaoClientId,
             @Qualifier("kakaoClientSecret") String kakaoClientSecret
             ){
         
         //구글 네이버 카카오를 각각 OauthClient 인스턴스 담으 ㄴ후 다시 Map에 모아두자
         Map<String, OAuthClient> map = new HashMap<>();
         
         // 구글 등록
         OAuthClient google = new OAuthClient();
         google.setProvider("google");
         google.setClientId(googleClientId);
         google.setClientSecret(googleClientSecret);
         google.setAuthorizeUrl("https://accounts.google.com/o/oauth2/v2/auth"); //google api 문서에 나와있다... 
         google.setTokenUrl("https://oauth2.googleapis.com/token"); //토큰을 요청할 주소
         google.setUserInfoUrl("https://openidconnect.googleapis.com/v1/userinfo");
         google.setScope("openid email profile"); //사용자에 대한 정보의 접근 범위
         google.setRedirectUri("http://localhost:8888/auth/login/callback/google");
         
         map.put("google", google);
         
         // 네이버 등록
         OAuthClient naver = new OAuthClient();
         
         naver.setProvider("naver");
         naver.setClientId(naverClientId);
         naver.setClientSecret(naverClientSecret);
         naver.setAuthorizeUrl("https://nid.naver.com/oauth2.0/authorize"); //google api 문서에 나와있다... 
         naver.setTokenUrl("https://nid.naver.com/oauth2.0/token"); //토큰을 요청할 주소
         naver.setUserInfoUrl("https://openapi.naver.com/v1/nid/me");
         naver.setScope("name email"); //사용자에 대한 정보의 접근 범위
         naver.setRedirectUri("http://localhost:8888/auth/login/callback/naver");
         
         map.put("naver", naver);
         
         // 카카오 등록
         OAuthClient kakao = new OAuthClient();
         
         kakao.setProvider("kakao");
         kakao.setClientId(kakaoClientId);
         kakao.setClientSecret(kakaoClientSecret);
         kakao.setAuthorizeUrl("https://kauth.kakao.com/oauth/authorize"); // 인가 코드 요청
         kakao.setTokenUrl("https://kauth.kakao.com/oauth/token");         // 토큰 요청
         kakao.setUserInfoUrl("https://kapi.kakao.com/v2/user/me");        // 사용자 정보 요청
         kakao.setScope("profile_nickname"); //사용자에 대한 정보의 접근 범위
         kakao.setRedirectUri("http://localhost:8888/auth/login/callback/kakao");
         
         map.put("kakao", kakao);
         
         return map;
     }
}