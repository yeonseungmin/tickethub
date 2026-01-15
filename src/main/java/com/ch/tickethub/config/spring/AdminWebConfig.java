package com.ch.tickethub.config.spring;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.multipart.commons.CommonsMultipartResolver;
import org.springframework.web.servlet.config.annotation.EnableWebMvc;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurerAdapter;

import com.ch.tickethub.interceptor.AdminAuthInterceptor;

@Configuration
@EnableWebMvc
@ComponentScan(basePackages = {"com.ch.tickethub.controller.admin"})
public class AdminWebConfig extends WebMvcConfigurerAdapter {

    @Bean
    public CommonsMultipartResolver multipartResolver() {
        CommonsMultipartResolver resolver = new CommonsMultipartResolver();
        // 필요하면 설정 추가
        // resolver.setMaxUploadSize(10 * 1024 * 1024);
        // resolver.setDefaultEncoding("UTF-8");
        return resolver;
    }

    @Override
    public void addInterceptors(InterceptorRegistry registry) {
        registry.addInterceptor(new AdminAuthInterceptor())
                
        		//이미 admin/** 쓰고 있어서... 
                .addPathPatterns("/**")
                // 로그인/콜백 같은 건 관리자 체크에서 제외
                .excludePathPatterns("/auth/**")
                // 정적 리소스 제외
                .excludePathPatterns("/static/**", "/photo/**", "/banner/**");
    }
}
