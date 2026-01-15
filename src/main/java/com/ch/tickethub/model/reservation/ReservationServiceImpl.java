package com.ch.tickethub.model.reservation;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.ch.tickethub.dto.Reservation;
import com.ch.tickethub.dto.Seat;
import com.ch.tickethub.dto.SeatDetail;
import com.ch.tickethub.dto.SeatGrade;
import com.ch.tickethub.model.roundseat.RoundSeatService;

import lombok.extern.slf4j.Slf4j;

@Slf4j
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

    @Override
    public boolean preemptSeats(int roundId, List<Integer> seatIds) {
        // 1. 가용성 체크
    	// 위에서 수정한 쿼리를 통해 AVAILABLE 또는 PREEMPTED인 좌석 수를 가져옴
        int availableCount = reservationDAO.checkSeatsAvailability(seatIds);
        
        if (availableCount == seatIds.size()) {
            // 모든 좌석이 사용 가능하거나 내가 선점한 상태라면 업데이트 진행
            reservationDAO.updateSeatsStatus(seatIds, "PREEMPTED");
            return true;
        }
        return false;
    }

    @Override
    public List<SeatDetail> getSelectedSeatsInfo(List<Integer> seatIds) {
        // DAO 호출 결과도 SeatDetail 리스트여야 합니다.
        return reservationDAO.getSelectedSeatsInfo(seatIds);
    }
    
    //회원 등급별 혜택
    @Override
    public Map<String, Object> getAppliedBenefit(int memberId) {
        return reservationDAO.getAppliedBenefit(memberId);
    }
    
    @Override
    @Transactional // 여러 테이블을 건드리므로 트랜잭션 처리가 중요합니다.
    public int insertReservation(int memberId, int roundId, int amount, int totalAmount,int seatGradeId) {
        Map<String, Object> params = new HashMap<>();
        params.put("member_id", memberId);
        params.put("round_id", roundId);
        params.put("amount", amount);
        params.put("totalAmount", totalAmount);
        params.put("seat_grade_id", seatGradeId);
        
        reservationDAO.insertReservation(params);
        // useGeneratedKeys에 의해 params에 reservation_id가 담깁니다.
        return Integer.parseInt(params.get("reservation_id").toString());
    }

    @Override
    public void confirmSeats(List<Integer> seatIds, int reservationId) {
        Map<String, Object> params = new HashMap<>();
        params.put("seatIds", seatIds);
        params.put("reservation_id", reservationId);
        reservationDAO.confirmSeats(params);
    }

    @Override
    public void insertDiscountDetail(int reservationId, int benefitId) {
        Map<String, Object> params = new HashMap<>();
        params.put("reservation_id", reservationId);
        params.put("benefit_id", benefitId);
        reservationDAO.insertDiscountDetail(params);
    }
}