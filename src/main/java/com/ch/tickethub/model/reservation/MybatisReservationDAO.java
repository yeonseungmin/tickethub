package com.ch.tickethub.model.reservation;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import com.ch.tickethub.dto.Reservation;
import com.ch.tickethub.dto.Seat;
import com.ch.tickethub.dto.SeatDetail;
import com.ch.tickethub.dto.SeatGrade;

@Repository
public class MybatisReservationDAO implements ReservationDAO {

    @Autowired
    private SqlSessionTemplate sqlSessionTemplate;
    
    private static final String NAMESPACE = "Reservation.";

    @Override
    public int insert(Reservation reservation) {
        return sqlSessionTemplate.insert("Reservation.insert", reservation);
    }

    @Override
    public Reservation select(int reservation_id) {
        return sqlSessionTemplate.selectOne("Reservation.select", reservation_id);
    }

    @Override
    public List<Reservation> selectByMember(int member_id) {
        return sqlSessionTemplate.selectList("Reservation.selectByMember", member_id);
    }

    @Override
    public List<Reservation> selectByRound(int round_id) {
        return sqlSessionTemplate.selectList("Reservation.selectByRound", round_id);
    }

    @Override
    public int delete(int reservation_id) {
        return sqlSessionTemplate.delete("Reservation.delete", reservation_id);
    }

    public int checkSeatsAvailability(List<Integer> seatIds) {
        Map<String, Object> params = new HashMap<>();
        params.put("seatIds", seatIds); // 이름을 "seatIds"로 지정
        return sqlSessionTemplate.selectOne(NAMESPACE + "checkSeatsAvailability", params);
    }

	@Override
	public int updateSeatsStatus(List<Integer> seatIds, String status) {
		Map<String, Object> params = new HashMap<>();
        params.put("seatIds", seatIds);
        params.put("status", status);
        return sqlSessionTemplate.update(NAMESPACE + "updateSeatsStatus", params);
    }

	// MybatisReservationDAO.java
	public List<SeatDetail> getSelectedSeatsInfo(List<Integer> seatIds) {
	    return sqlSessionTemplate.selectList("RoundSeat.getSelectedSeatsInfo", seatIds);
	}
	
	@Override
	public Map<String, Object> getAppliedBenefit(int memberId) {
	    return sqlSessionTemplate.selectOne("Reservation.getAppliedBenefit", memberId);
	}
	
	@Override
	public void insertReservation(Map<String, Object> params) {
		sqlSessionTemplate.insert("Reservation.insertReservation", params);
	}

	@Override
	public void confirmSeats(Map<String, Object> params) {
		sqlSessionTemplate.update("Reservation.confirmSeats", params);
	}

	@Override
	public void insertDiscountDetail(Map<String, Object> params) {
		sqlSessionTemplate.insert("Reservation.insertDiscountDetail", params);
	}
}
