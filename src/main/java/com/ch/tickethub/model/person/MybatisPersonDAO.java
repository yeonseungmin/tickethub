package com.ch.tickethub.model.person;

import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.ch.tickethub.dto.Person;
import com.ch.tickethub.exception.PersonException;

@Repository
public class MybatisPersonDAO implements PersonDAO{
	
	@Autowired
	SqlSessionTemplate sqlSessionTemplate;
	
	@Override
	public void insert(Person person) throws PersonException{
		
		sqlSessionTemplate.insert("Person.insert", person);
	}
	
	@Override
	public List selectAll() {
		return sqlSessionTemplate.selectList("Person.selectAll");
	}

	@Override
	public void delete(int person_id) throws PersonException{
		
		sqlSessionTemplate.delete("Person.delete", person_id);
	}

	@Override
	public void update(Person person) {
		
		sqlSessionTemplate.update("Person.update", person);
	}

}