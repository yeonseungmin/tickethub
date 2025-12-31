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
import org.springframework.transaction.annotation.EnableTransactionManagement;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurerAdapter;
import org.springframework.web.servlet.view.InternalResourceViewResolver;


@Configuration	// xml을 대신할 거야!
@ComponentScan(basePackages = {"com.ch.tickethub.model", "com.ch.tickethub.util"})
@EnableTransactionManagement
public class RootConfig extends WebMvcConfigurerAdapter{

	@Bean
	public InternalResourceViewResolver viewResolver() {
		InternalResourceViewResolver rv = new InternalResourceViewResolver();
		// 접두어 등록
		rv.setPrefix("/WEB-INF/views/");
		// 접미어 등록
		rv.setSuffix(".jsp");
		return rv;
	}

	public void addResourceHandlers(ResourceHandlerRegistry registry) {
		
		registry.addResourceHandler("/static/**").addResourceLocations("/resources/");
		registry.addResourceHandler("/photo/**").addResourceLocations("file:/C:/tickethub/performance/");
	}
	
	@Override
	public void configureMessageConverters(List<HttpMessageConverter<?>> converters) {
		converters.add(new MappingJackson2HttpMessageConverter());	// Jackson 객체를 넣기
	}
	
	@Bean
	public DataSource dataSource() throws NamingException{
		JndiTemplate jndi = new JndiTemplate();
		return jndi.lookup("java:comp/env/jndi/tickethub", DataSource.class);
	}
	
	@Bean
	public PlatformTransactionManager transactionManager(DataSource dataSource) {
		return new DataSourceTransactionManager(dataSource);
	}
	

	@Bean
	public SqlSessionFactory sqlSessionFactory(DataSource dataSource) throws Exception{
		
		SqlSessionFactoryBean sqlSessionFactoryBean = new SqlSessionFactoryBean();

		sqlSessionFactoryBean.setConfigLocation(new ClassPathResource("com/ch/tickethub/config/mybatis/config.xml"));
		
		sqlSessionFactoryBean.setDataSource(dataSource);
		
		return sqlSessionFactoryBean.getObject();
	}
	
	@Bean
	public SqlSessionTemplate sqlSessionTemplate(SqlSessionFactory sqlSessionFactory) throws Exception{
		return new SqlSessionTemplate(sqlSessionFactory);
	}
}
