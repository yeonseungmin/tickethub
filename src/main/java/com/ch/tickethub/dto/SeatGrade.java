package com.ch.tickethub.dto;

import lombok.Data;

@Data
public class SeatGrade {

    private int seat_grade_id;
    private String grade_name;   // VIP, R, S, A

    private String on_img_url;
    private String off_img_url;
    private String sold_img_url;
    
    private int surcharge;
}
