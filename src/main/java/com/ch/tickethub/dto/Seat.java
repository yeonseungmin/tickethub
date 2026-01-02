package com.ch.tickethub.dto;

import lombok.Data;

@Data
public class Seat {

	private int seat_id;
	private Place place;
	private String seat_name;
	private String seat_x;
	private int seat_y;
	private int floor;
	
	
}
