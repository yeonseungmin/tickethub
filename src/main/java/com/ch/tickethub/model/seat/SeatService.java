package com.ch.tickethub.model.seat;

import java.util.List;

import com.ch.tickethub.dto.Seat;

public interface SeatService {

	// 좌석 등록
	public int insert(Seat seat);

	// 공연장 + 구역별 좌석 조회
	public List<Seat> selectSeatByPlaceAndGroup(int place_id, String group_name);

	// 좌석 1건 조회
	public Seat select(int seat_id);

	// 좌석 고정 상태 변경
	public int updateSeatState(int seat_id, String seat_state);

	// 좌석 삭제
	public int deleteSeat(int seat_id);
}
