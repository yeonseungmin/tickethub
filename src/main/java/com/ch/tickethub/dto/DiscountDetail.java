package com.ch.tickethub.dto;

import lombok.Data;

@Data
public class DiscountDetail {

    private int discount_detail_id;

    private int reservation_id;
    private int benefit_id;
}
