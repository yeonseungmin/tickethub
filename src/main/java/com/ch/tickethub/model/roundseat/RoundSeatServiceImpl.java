package com.ch.tickethub.model.roundseat;

import java.time.LocalDateTime;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.ch.tickethub.dto.RoundSeat;
import com.ch.tickethub.dto.SeatDetail;
import com.ch.tickethub.exception.SeatException;

@Service
public class RoundSeatServiceImpl implements RoundSeatService {

    @Autowired
    private RoundSeatDAO roundSeatDAO;

    @Override
    public List<SeatDetail> getSeatDetailByRound(int round_id) {
        return roundSeatDAO.selectSeatDetailByRound(round_id);
    }

    @Transactional
    @Override
    public void createRoundSeat(int round_id, int seat_id) {
        RoundSeat rs = new RoundSeat();
        rs.setRound_id(round_id);
        rs.setSeat_id(seat_id);
        rs.setStatus("AVAILABLE"); // 초기 상태는 예약 가능

        roundSeatDAO.insert(rs);
    }

    @Override
    public void validateNotExists(int round_id, int seat_group_id) {
        int count = roundSeatDAO.countByRoundAndGroup(round_id, seat_group_id);
        if (count > 0) {
            throw new SeatException("이미 해당 회차에 좌석 데이터가 생성되어 있습니다.");
        }
    }

    @Transactional
    @Override
    public void preempt(int round_id, int seat_id) {
        RoundSeat rs = new RoundSeat();
        rs.setRound_id(round_id);
        rs.setSeat_id(seat_id);
        rs.setStatus("PREEMPTED");
        rs.setPreempted_at(LocalDateTime.now());
        
        // DAO의 updateStatus가 영향받은 행의 수(int)를 반환한다고 가정
        // WHERE 조건에 status = 'AVAILABLE'이 포함되어야 동시성 제어가 가능합니다.
        int result = roundSeatDAO.updateStatus(rs);
        
        if (result == 0) {
            throw new SeatException("이미 다른 사용자가 선택 중이거나 예약된 좌석입니다.");
        }
    }

    @Transactional
    @Override
    public void reserve(int round_id, int seat_id, int reservation_id) {
        RoundSeat rs = new RoundSeat();
        rs.setRound_id(round_id);
        rs.setSeat_id(seat_id);
        rs.setReservation_id(reservation_id);
        rs.setStatus("RESERVED");
        rs.setReserved_at(LocalDateTime.now());

        int result = roundSeatDAO.updateStatus(rs);
        if (result == 0) {
            throw new SeatException("좌석 예약 상태를 변경할 수 없습니다.");
        }
    }

    @Transactional
    @Override
    public void cancel(int round_id, int seat_id) {
        RoundSeat rs = new RoundSeat();
        rs.setRound_id(round_id);
        rs.setSeat_id(seat_id);
        rs.setStatus("AVAILABLE"); 
        rs.setCanceled_at(LocalDateTime.now());
        rs.setReservation_id(null); 

        roundSeatDAO.updateStatus(rs);
    }
}