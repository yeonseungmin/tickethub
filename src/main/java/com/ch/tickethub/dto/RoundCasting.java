package com.ch.tickethub.dto;

import lombok.Data;

@Data
public class RoundCasting {
	private int round_casting_id;
	private String role;
	
	Person person;
	Round round;
}
