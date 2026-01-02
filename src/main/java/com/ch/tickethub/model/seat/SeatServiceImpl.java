package com.ch.tickethub.model.seat;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ch.tickethub.dto.Seat;
import com.ch.tickethub.model.seat.SeatDAO;

@Service
public class SeatServiceImpl implements SeatService {

	@Autowired
	private SeatDAO seatDAO;

	/*----------------------------------
	  좌석 등록
	----------------------------------*/
	@Override
	public int insert(Seat seat) {
		return seatDAO.insert(seat);
	}

	/*----------------------------------
	  공연장 + 구역별 좌석 조회
	----------------------------------*/
	@Override
	public List<Seat> selectSeatByPlaceAndGroup(int place_id, String group_name) {
		return seatDAO.selectSeatByPlaceAndGroup(place_id, group_name);
	}

	/*----------------------------------
	  좌석 1건 조회
	----------------------------------*/
	@Override
	public Seat select(int seat_id) {
		return seatDAO.select(seat_id);
	}

	/*----------------------------------
	  좌석 고정 상태 변경
	----------------------------------*/
	@Override
	public int updateSeatState(int seat_id, String seat_state) {
		return seatDAO.updateSeatState(seat_id, seat_state);
	}

	/*----------------------------------
	  좌석 삭제
	----------------------------------*/
	@Override
	public int deleteSeat(int seat_id) {
		return seatDAO.deleteSeat(seat_id);
	}
}