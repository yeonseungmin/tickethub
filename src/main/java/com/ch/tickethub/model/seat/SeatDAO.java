package com.ch.tickethub.model.seat;

import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;

import com.ch.tickethub.dto.Seat;

public interface SeatDAO {

    // 좌석 등록
    public int insert(Seat seat);

    // 좌석 1건 조회
    public Seat select(int seat_id);

    // 공연장별 좌석 조회
    public List<Seat> selectByPlace(int place_id);

    // 그룹별 좌석 조회
    public List<Seat> selectByGroup(int seat_group_id);

    // 좌석 활성/비활성
    public int updateSeatState(int seat_id, String seat_state);

    // 좌석 삭제
    public int delete(int seat_id);
}
