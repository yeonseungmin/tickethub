package com.ch.tickethub.dto;

import java.util.Date;
import lombok.Data;

@Data
public class Order {
    private int reservation_id;
    private String member_name;
    private String work_title;
    private int seat_count;
    private int total_paid;
    private Date regdate;
}
