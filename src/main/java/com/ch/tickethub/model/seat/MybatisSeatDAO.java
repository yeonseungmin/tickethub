package com.ch.tickethub.model.seat;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.ch.tickethub.dto.Seat;

@Repository
public class MybatisSeatDAO implements SeatDAO{
	
	@Autowired
	SqlSessionTemplate sqlSessionTemplate;
	
	/*---------------------------------------------------------------------------------
	  좌석 등록 
	 ----------------------------------------------------------------------------------*/
	@Override
	public int insert(Seat seat) {
		return sqlSessionTemplate.insert("Seat.insert",seat);
	}

	/*---------------------------------------------------------------------------------
	  공연장 + 구역별 좌석 조회
	 ----------------------------------------------------------------------------------*/
	@Override
	public List<Seat> selectSeatByPlaceAndGroup(int placeId, String groupName) {
		
		Map<String, Object> param = new HashMap<>();
		param.put("place_id", placeId);
        param.put("group_name", groupName);
		
		return sqlSessionTemplate.selectList("Seat.selectSeatByPlaceAndGroup",param);
	}

	/*---------------------------------------------------------------------------------
	  좌석 1건 조회
	 ----------------------------------------------------------------------------------*/
	@Override
	public Seat select(int seatId) {
		return sqlSessionTemplate.selectOne("Seat.select",seatId);
	}

	/*---------------------------------------------------------------------------------
	  좌석 고정 상태 변경
	 ----------------------------------------------------------------------------------*/
	@Override
	public int updateSeatState(int seatId, String seatState) {
		
		Map<String, Object> param = new HashMap();
		param.put("seat_id",seatId);
		param.put("seat_state",seatState);
		return sqlSessionTemplate.update("Seat.updateSeatState",param);
	}

	/*---------------------------------------------------------------------------------
	  좌석 삭제
	 ----------------------------------------------------------------------------------*/
	@Override
	public int deleteSeat(int seatId) {
		return sqlSessionTemplate.delete("Seat.delete",seatId);
	}

	
	
}
