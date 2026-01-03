package com.ch.tickethub.model.seatgrade;

import java.util.List;
import com.ch.tickethub.dto.SeatGrade;

public interface SeatGradeDAO {

    // 등급 등록
	public int insert(SeatGrade seatGrade);

    // 등급 전체 조회
	public List<SeatGrade> selectAll();

    // 등급 1건 조회
	public SeatGrade select(int seat_grade_id);

    // 등급 수정 (이미지 교체)
	public int update(SeatGrade seatGrade);

    // 등급 삭제
	public int delete(int seat_grade_id);
}
