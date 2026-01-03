package com.ch.tickethub.dto;

import lombok.Data;

@Data
public class SeatGroup {

    private int seat_group_id;
    private int place_id;

    private String group_name;

    // 배치 기준
    private int pos_x;
    private int pos_y;

    private int row_gap;
    private int col_gap;

    // 좌석 배치 방향 (선택)
    private String direction; // LTR (왼쪽부터 오른쪽), RTL(오른쪽부터 왼쪽)
}
