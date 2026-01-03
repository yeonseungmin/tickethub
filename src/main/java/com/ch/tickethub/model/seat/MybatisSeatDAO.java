package com.ch.tickethub.model.seat;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.ch.tickethub.dto.Seat;
import com.ch.tickethub.exception.SeatException;

@Repository
public class MybatisSeatDAO implements SeatDAO {

    @Autowired
    private SqlSessionTemplate sqlSessionTemplate;

    @Override
    public void insert(Seat seat) {
    	try {
			sqlSessionTemplate.insert("Seat.insert", seat);
		} catch (Exception e) {
			e.printStackTrace();
			throw new SeatException("좌석 등록 실패",e);
		}
    }

    @Override
    public Seat select(int seat_id) {
        return sqlSessionTemplate.selectOne("Seat.select", seat_id);
    }

    
    @Override
    public void updateSeatState(int seat_id, String seat_state) {
        Seat seat = new Seat();
        seat.setSeat_id(seat_id);
        seat.setSeat_state(seat_state);
        try {
			sqlSessionTemplate.update("Seat.updateSeatState", seat);
		} catch (Exception e) {
			e.printStackTrace();
			throw new SeatException("좌석 업데이트 실패",e);
		}
    }

    @Override
    public void delete(int seat_id) {
    	try {
			sqlSessionTemplate.delete("Seat.delete", seat_id);
		} catch (Exception e) {
			e.printStackTrace();
			throw new SeatException("좌석삭제 실패 " ,e);
		}
    }

    @Override
    public List<Seat> selectByGroup(int seat_group_id) {
        return sqlSessionTemplate.selectList("Seat.selectByGroup", seat_group_id);
    }

}
