package com.ch.tickethub.dto;

import lombok.Data;

@Data
public class SeatDetail {

    // seat
    private int seat_id;
    private String seat_x;
    private int seat_y;
    private String seat_name;
    private int floor;

    // seat_group
    private int seat_group_id;
    private String group_name;
    private double pos_x;
    private double pos_y;
    private double angle;
    private double row_gap;
    private double col_gap;
    private String direction;

    // seat_grade
    private String grade_name;
    private String on_img_url;
    private String off_img_url;
    private String sold_img_url;

    // round_seat
    private int round_id;
    private int round_seat_id;
    private String status;
    private Integer reservation_id;
    
    //reservation
    private int surcharge;    // 등급별 추가 금액
    private int work_price;   // 공연 기본 가격
    private int price;        // 최종 결제 금액 (기본가 + 추가가)
    private int seat_grade_id;
}

