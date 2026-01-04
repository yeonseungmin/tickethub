package com.ch.tickethub.model.roundseat;

import java.util.List;

import com.ch.tickethub.dto.SeatDetail;

public interface RoundSeatService {

	void createRoundSeat(int round_id, int seat_id);
    void validateNotExists(int round_id, int seat_group_id);

    // 추가된 메서드들
    List<SeatDetail> getSeatDetailByRound(int round_id);
    void preempt(int round_id, int seat_id);
    void reserve(int round_id, int seat_id, int reservation_id);
    void cancel(int round_id, int seat_id);
}
