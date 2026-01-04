package com.ch.tickethub.dto;

import java.time.LocalDateTime;
import lombok.Data;

@Data
public class Reservation {

    private int reservation_id;

    private int member_id;
    private int round_id;
    private int seat_grade_id;

    private int actual_paid;
    private int total_paid;

    private LocalDateTime regdate;
}
