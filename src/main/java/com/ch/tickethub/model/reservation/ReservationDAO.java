package com.ch.tickethub.model.reservation;

import java.util.List;
import com.ch.tickethub.dto.Reservation;

public interface ReservationDAO {

    // 예매 생성
	public int insert(Reservation reservation);

    // 예매 1건 조회
	public Reservation select(int reservation_id);

    // 회원별 예매 내역
	public List<Reservation> selectByMember(int member_id);

    // 회차별 예매 내역 (관리자)
	public List<Reservation> selectByRound(int round_id);

    // 예매 취소 (논리적)
	public int delete(int reservation_id);
}
