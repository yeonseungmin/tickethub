package com.ch.tickethub.dto;

import com.ch.tickethub.dto.Person;

import lombok.Data;

@Data
public class Person {
	private int person_id;
	private String person_name;
	private String profile_url;
}