package com.ch.tickethub.dto;

import lombok.Data;

@Data
public class Seat {

    private int seat_id;
    private int seat_group_id;

    private String seat_x;      // A, B, C 
    private int seat_y;         // 1,2,3
    private String seat_name;   // A10

    private int floor;
    private String seat_state;  //활성화 , 비활성화
    
}
