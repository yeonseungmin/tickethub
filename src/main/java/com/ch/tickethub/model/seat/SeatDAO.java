package com.ch.tickethub.model.seat;

import java.util.List;

import com.ch.tickethub.dto.Seat;

public interface SeatDAO {

	// 좌석 등록
	public int insert(Seat seat);
	
	// 공연장 + 구역별 좌석 조회
	public List<Seat> selectSeatByPlaceAndGroup(int placeId, String groupName);
	
	//좌석 1건 조회
	public Seat select(int seatId);
	
	//좌석 고정상태 변경 (ACTIVE / INACTIVE )
	public int updateSeatState(int seatId, String seatState);
	
	// 좌석 삭제
	public int deleteSeat(int seatId);
	
}
