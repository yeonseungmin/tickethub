package com.ch.tickethub.model.person;

import java.util.List;

import com.ch.tickethub.dto.Person;

public interface PersonDAO {
	public void insert(Person person);
	public List selectAll();
}
