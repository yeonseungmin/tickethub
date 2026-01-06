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
import org.springframework.web.servlet.config.annotation.WebMvcConfigurerAdapter;

@Configuration 
@EnableWebMvc // 필수 설정(스프링이 지원하는 MVC 프레임워크를 사용하기 위한 애노테이션)
@ComponentScan(basePackages = { "com.ch.tickethub.controller.tickethub" })
// tickethub 컴포넌트가 연결되어있기 때문에 하단에 코드가 없어도 의미가 있는 클래스이다.
// 기본적으로 @Controller 애노테이션이 선언되어 있으면 컴포넌트스캔으로 Bean을 자동생성
public class TickethubWebConfig extends WebMvcConfigurerAdapter {

	/* context.xml 등에 명시된 외부 자원을 JNDI 방식으로 읽어들일 수 있는 스프링의 객체 */
	@Bean
	public JndiTemplate jndiTemplate() {
		return new JndiTemplate();
	}

	@Bean
	public RestTemplate restTemplate() {
		return new RestTemplate();
	}

}