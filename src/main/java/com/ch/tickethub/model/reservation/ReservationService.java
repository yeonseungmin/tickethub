package com.ch.tickethub.model.reservation;

import java.util.List;
import java.util.Map;

import com.ch.tickethub.dto.Reservation;
import com.ch.tickethub.dto.Seat;
import com.ch.tickethub.dto.SeatDetail;
import com.ch.tickethub.dto.SeatGrade;

public interface ReservationService {
	
    int makeReservation(Reservation reservation, List<Integer> seatIds);
    
    void cancelReservation(int reservation_id, int round_id, List<Integer> seatIds);
    
    Reservation getReservation(int reservation_id);
    
    List<Reservation> getMemberReservations(int member_id);
    
    boolean preemptSeats(int roundId, List<Integer> seatIds);
    List<SeatDetail> getSelectedSeatsInfo(List<Integer> seatIds);
    
    // 회원 등급별 혜택
    Map<String, Object> getAppliedBenefit(int memberId);
    
    int insertReservation(int memberId, int roundId, int amount, int totalAmount,int seatGradeId);
    
    void confirmSeats(List<Integer> seatIds, int reservationId);
    
    void insertDiscountDetail(int reservationId, int benefitId);
    

}