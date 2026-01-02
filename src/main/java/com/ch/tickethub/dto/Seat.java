package com.ch.tickethub.dto;

import lombok.Data;

@Data
public class Seat {
	
	private int seat_id;
	private String seat_name;
	private String seat_x;
	private int seat_y;
	private int floor;
	private String seat_state;
	private Place place;
	
	//좌석 조회 용 
	private int seatGroupId;
	private String groupName;
}
