package com.ch.tickethub.config.spring;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.data.redis.connection.RedisConnectionFactory;
import org.springframework.data.redis.connection.jedis.JedisConnectionFactory;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.data.redis.serializer.StringRedisSerializer;

import redis.clients.jedis.JedisPoolConfig;

@Configuration
public class RedisConfig {

	@Bean
	public RedisConnectionFactory redisConnectionFactory() {
		// 1. 동시에 여러 요청을 처리 할 커넥션 풀 설정
		JedisPoolConfig jedisPoolConfig = new JedisPoolConfig();
		jedisPoolConfig.setMaxTotal(10);		// 최대 연결 개수. 이 때 개수는 대기열이 아니라 redis의 최대 커넥션 개수임을 주의.
		jedisPoolConfig.setMaxIdle(5); 	// 최소 유휴 개수.
		
		// 2. redis 서버 정보 설정
		JedisConnectionFactory jedisConnectionFactory = new JedisConnectionFactory(jedisPoolConfig);
		jedisConnectionFactory.setHostName("localhost");
		jedisConnectionFactory.setPort(6379); 	// redis 기본 포트번호
		jedisConnectionFactory.afterPropertiesSet(); 	// Bean 생명주기 관리 메서드. 이 세팅 이후에 실행될 수 있게(꼬이지 않게) 설정.
		return jedisConnectionFactory;
	}
	
	@Bean
	public RedisTemplate<String, Object> redisTemplate() {
		// 3. redis 템플릿 설정 (데이터 읽고 쓰기)
		RedisTemplate<String, Object> redisTemplate = new RedisTemplate<String, Object>();
		redisTemplate.setConnectionFactory(redisConnectionFactory());
		
		// 4. 시리얼라이저 설정 (redis 는 ram 이라서 1,0 밖에 인식 못하므로, 데이터 깨지지 않게 문자열로 변환)
		redisTemplate.setKeySerializer(new StringRedisSerializer());
		redisTemplate.setValueSerializer(new StringRedisSerializer());
		
		return redisTemplate;
	}
}
