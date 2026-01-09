package com.ch.tickethub.model.person;

import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.ch.tickethub.dto.Person;

@Repository
public class MybatisPersonDAO implements PersonDAO{
	
	@Autowired
	SqlSessionTemplate sqlSessionTemplate;
	
	@Override
	public void insert(Person person) {
		
		sqlSessionTemplate.insert("Person.insert", person);
	}
	
	@Override
	public List selectAll() {
		return sqlSessionTemplate.selectList("Person.selectAll");
	}

}