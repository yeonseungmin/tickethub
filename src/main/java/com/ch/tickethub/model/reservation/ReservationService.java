package com.ch.tickethub.model.reservation;

import java.util.List;

import com.ch.tickethub.dto.Reservation;

public interface ReservationService {
	
    int makeReservation(Reservation reservation, List<Integer> seatIds);
    
    void cancelReservation(int reservation_id, int round_id, List<Integer> seatIds);
    
    Reservation getReservation(int reservation_id);
    
    List<Reservation> getMemberReservations(int member_id);
    
}