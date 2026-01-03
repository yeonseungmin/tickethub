package com.ch.tickethub.dto;

import java.time.LocalDateTime;
import lombok.Data;

@Data
public class RoundSeat {

    private int round_seat_id;

    private int round_id;
    private int seat_id;

    private Integer reservation_id;

    private String status; // AVAILABLE, PREEMPTED, RESERVED, CANCELED

    private LocalDateTime preempted_at;
    private LocalDateTime reserved_at;
    private LocalDateTime canceled_at;
}
