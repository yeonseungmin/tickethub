package com.ch.tickethub.config.spring;


import java.util.List;

import javax.naming.NamingException;
import javax.sql.DataSource;

import org.apache.ibatis.session.SqlSessionFactory;
import org.mybatis.spring.SqlSessionFactoryBean;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.io.ClassPathResource;
import org.springframework.http.converter.HttpMessageConverter;
import org.springframework.http.converter.json.MappingJackson2HttpMessageConverter;
import org.springframework.jdbc.datasource.DataSourceTransactionManager;
import org.springframework.jndi.JndiTemplate;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.web.multipart.commons.CommonsMultipartResolver;
import org.springframework.web.servlet.config.annotation.EnableWebMvc;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurerAdapter;
import org.springframework.web.servlet.view.InternalResourceViewResolver;



@Configuration	// 단지 xml을 대신한 설정용 클래스에 불과해!!
@EnableWebMvc		// 필수 설정(스프링이 지원하는 MVC 프레임워크를 사용하기 위한 어노테이션)

@ComponentScan(basePackages = {"com.ch.tickethub.controller.admin"})

public class AdminWebConfig extends WebMvcConfigurerAdapter{
	
	/*아파치 파일 업로드 컴포넌트를 빈으로 등록*/
	@Bean
	public CommonsMultipartResolver multipartResolver() {
		CommonsMultipartResolver resolver = new CommonsMultipartResolver();
		return resolver;
	}
	
}