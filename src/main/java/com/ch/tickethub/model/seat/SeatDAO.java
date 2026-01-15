package com.ch.tickethub.model.seat;

import java.util.List;

import org.apache.ibatis.annotations.Param;
import org.mybatis.spring.SqlSessionTemplate;

import com.ch.tickethub.dto.Seat;

public interface SeatDAO {

    // 좌석 등록
    public void insert(Seat seat);

    // 좌석 1건 조회
    public Seat select(int seat_id);

    // 좌석 상태 변경
    public void updateSeatState(int seat_id, String seat_state);

    // 좌석 삭제
    public void delete(int seat_id);
    
    // 그룹별 좌석 리스트 조회
    public List<Seat> selectByGroup(int seat_group_id);
    
    // 좌석 등급 변경
    void updateSeatGrade(@Param("seat_id") int seat_id, @Param("seat_grade_id") int seat_grade_id);

}
