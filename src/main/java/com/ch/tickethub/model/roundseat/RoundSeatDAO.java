package com.ch.tickethub.model.roundseat;

import java.util.List;
import com.ch.tickethub.dto.RoundSeat;
import com.ch.tickethub.dto.SeatDetail;


public interface RoundSeatDAO {

    // 회차 좌석 상태 목록 (JSP용)
	public List<SeatDetail> selectSeatDetailByRound(int round_id);

    // 좌석 상태 변경
	public int updateStatus(int round_id, int seat_id, String status);

    // 임시 점유
	public int preempt(int round_id, int seat_id);

    // 예약 확정
	public int reserve(int round_id, int seat_id, int reservation_id);

    // 취소
	public int cancel(int round_id, int seat_id);
}
