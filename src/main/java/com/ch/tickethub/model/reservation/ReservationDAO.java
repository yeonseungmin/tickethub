package com.ch.tickethub.model.reservation;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;

import com.ch.tickethub.dto.Reservation;
import com.ch.tickethub.dto.Seat;
import com.ch.tickethub.dto.SeatDetail;
import com.ch.tickethub.dto.SeatGrade;

public interface ReservationDAO {

    // 예매 생성
	public int insert(Reservation reservation);

    // 예매 1건 조회
	public Reservation select(int reservation_id);

    // 회원별 예매 내역
	public List<Reservation> selectByMember(int member_id);

    // 회차별 예매 내역 (관리자)
	public List<Reservation> selectByRound(int round_id);

    // 예매 취소 (논리적)
	public int delete(int reservation_id);
	
	// 1. 좌석들의 현재 예약 가능 상태 확인
	int checkSeatsAvailability(@Param("seatIds") List<Integer> seatIds);

    // 2. 좌석 상태 업데이트 (AVAILABLE -> P)
	int updateSeatsStatus(@Param("seatIds") List<Integer> seatIds, @Param("status") String status);

    // 3. 결제 페이지용 좌석 상세 정보 조회
	public List<SeatDetail> getSelectedSeatsInfo(List<Integer> seatIds);
	
	// 4. 회원 등급별 혜택
	Map<String, Object> getAppliedBenefit(int memberId);
	
	public void insertReservation(Map<String, Object> params);
	
	public void confirmSeats(Map<String, Object> params);
	
	public void insertDiscountDetail(Map<String, Object> params);
}
