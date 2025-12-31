package com.ch.tickethub.model.publisher;

import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.ch.tickethub.dto.Publisher;
import com.ch.tickethub.exception.PublisherException;

@Repository
public class MybatisPublisherDAO implements PublisherDAO{

	@Autowired
	SqlSessionTemplate sqlSessionTemplate;
	
	@Override
	public void insert(Publisher publisher) throws PublisherException {
		try {
			sqlSessionTemplate.insert("Publisher.insert", publisher);
		} catch (Exception e) {
			e.printStackTrace();
			throw new PublisherException("주최/기획 등록 실패", e);
		}
	}

	@Override
	public List selectAll() {
		return sqlSessionTemplate.selectList("Publisher.selectAll");
	}

}
