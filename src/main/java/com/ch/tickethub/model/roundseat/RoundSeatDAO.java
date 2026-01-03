package com.ch.tickethub.model.roundseat;

import java.util.List;
import com.ch.tickethub.dto.RoundSeat;
import com.ch.tickethub.dto.SeatDetail;

public interface RoundSeatDAO {

    public int countByRoundAndGroup(int round_id, int seat_group_id);

    public void insert(RoundSeat roundSeat);

    // 추가: 회차별 좌석 상세 정보 조회
    public List<SeatDetail> selectSeatDetailByRound(int round_id);

    // 추가: 좌석 상태 업데이트 (성공 시 1, 실패 시 0 반환)
    public int updateStatus(RoundSeat roundSeat);
}