package com.ch.tickethub.model.reservation;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.ch.tickethub.dto.Reservation;
import com.ch.tickethub.model.roundseat.RoundSeatService;

@Service
public class ReservationServiceImpl implements ReservationService {

    @Autowired
    private ReservationDAO reservationDAO;
    
    @Autowired
    private RoundSeatService roundSeatService;

    @Transactional
    @Override
    public int makeReservation(Reservation reservation, List<Integer> seatIds) {
        reservationDAO.insert(reservation);
        int resId = reservation.getReservation_id();
        
        // 예매 성공 시 해당 회차의 모든 좌석 상태를 'RESERVED'로 변경
        for (int seatId : seatIds) {
            roundSeatService.reserve(reservation.getRound_id(), seatId, resId);
        }
        return resId;
    }

    @Transactional
    @Override
    public void cancelReservation(int reservation_id, int round_id, List<Integer> seatIds) {
        // 1. 예매 데이터 삭제
        reservationDAO.delete(reservation_id);
        
        // 2. 연결된 모든 좌석을 다시 'AVAILABLE' 상태로 복구
        for (int seatId : seatIds) {
            roundSeatService.cancel(round_id, seatId);
        }
    }

    @Override
    public Reservation getReservation(int reservation_id) {
        return reservationDAO.select(reservation_id);
    }

    @Override
    public List<Reservation> getMemberReservations(int member_id) {
        return reservationDAO.selectByMember(member_id);
    }
}