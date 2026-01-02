package com.ch.tickethub.dto;

import lombok.Data;

@Data
public class SeatDetail {

    /* ===== seat ===== */
    private int seat_id;
    private String seat_x;
    private int seat_y;
    private String seat_name;
    private int floor;

    /* ===== seat_group (배치 기준) ===== */
    private int pos_x;
    private int pos_y;
    private int row_gap;
    private int col_gap;
    private String group_name;
    private String direction;

    /* ===== seat_grade ===== */
    private String grade_name;
    private String on_img_url;
    private String off_img_url;
    private String sold_img_url;

    /* ===== round_seat ===== */
    private String status;
}
