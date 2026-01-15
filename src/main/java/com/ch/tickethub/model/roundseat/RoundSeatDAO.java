package com.ch.tickethub.model.roundseat;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.ch.tickethub.dto.Round;
import com.ch.tickethub.dto.RoundSeat;
import com.ch.tickethub.dto.SeatDetail;

public interface RoundSeatDAO {

    public int countByRoundAndGroup(int round_id, int seat_group_id);

    public void insert(RoundSeat roundSeat);

    // 추가: 회차별 좌석 상세 정보 조회
    public List<SeatDetail> selectSeatDetailByRound(int round_id);

    // 추가: 좌석 상태 업데이트 (성공 시 1, 실패 시 0 반환)
    public int updateStatus(RoundSeat roundSeat);
    
    
    public void insertBulkByGroup(int seat_group_id);
    
 // 추가: 좌석 ID를 기준으로 모든 회차의 좌석 상태를 변경
    void updateStateBySeatId(@Param("seat_id") int seat_id, @Param("seat_state") String seat_state);

    // 추가: 좌석 ID를 기준으로 모든 회차의 좌석 등급을 변경
    void updateGradeBySeatId(@Param("seat_id") int seat_id, @Param("seat_grade_id") int seat_grade_id);
    
    void deleteBySeatId(int seat_id);

}