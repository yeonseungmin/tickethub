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
import org.springframework.context.annotation.Import;
import org.springframework.core.io.ClassPathResource;
import org.springframework.http.converter.HttpMessageConverter;
import org.springframework.http.converter.json.MappingJackson2HttpMessageConverter;
import org.springframework.jdbc.datasource.DataSourceTransactionManager;
import org.springframework.jndi.JndiTemplate;
import org.springframework.scheduling.annotation.EnableScheduling;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.transaction.annotation.EnableTransactionManagement;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurerAdapter;
import org.springframework.web.servlet.view.InternalResourceViewResolver;

@Configuration // xml을 대신할 거야!
@ComponentScan(basePackages = { "com.ch.tickethub.model", "com.ch.tickethub.util" })
@EnableTransactionManagement
@EnableScheduling
@Import(RedisConfig.class)	// Import 애노테이션으로 위에 컴포넌트스캔 패키지 추가 및 아래에 빈등록을 '딸깍'으로 처리할 수 있다. 이거 왜 안 알려주신거지..?
public class RootConfig extends WebMvcConfigurerAdapter {

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
		converters.add(new MappingJackson2HttpMessageConverter()); // Jackson 객체를 넣기
	}

	@Bean
	public DataSource dataSource() throws NamingException {
		JndiTemplate jndi = new JndiTemplate();
		return jndi.lookup("java:comp/env/jndi/tickethub", DataSource.class);
	}

	@Bean
	public PlatformTransactionManager transactionManager(DataSource dataSource) {
		return new DataSourceTransactionManager(dataSource);
	}

	@Bean
	public SqlSessionFactory sqlSessionFactory(DataSource dataSource) throws Exception {

		SqlSessionFactoryBean sqlSessionFactoryBean = new SqlSessionFactoryBean();

		sqlSessionFactoryBean.setConfigLocation(new ClassPathResource("com/ch/tickethub/config/mybatis/config.xml"));

		sqlSessionFactoryBean.setDataSource(dataSource);

		return sqlSessionFactoryBean.getObject();
	}

	@Bean
	public SqlSessionTemplate sqlSessionTemplate(SqlSessionFactory sqlSessionFactory) throws Exception {
		return new SqlSessionTemplate(sqlSessionFactory);
	}
	

	@Bean
	public JndiTemplate jndiTemplate() {
	    return new JndiTemplate();
	}

	@Bean(name = "emailPassword")
	public String emailPassword(JndiTemplate jndiTemplate) throws NamingException {
	    return (String) jndiTemplate.lookup("java:comp/env/email/app/password");
	}
	
	
}
