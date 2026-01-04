package com.ch.tickethub.model.seatgrade;

import java.util.List;
import com.ch.tickethub.dto.SeatGrade;

public interface SeatGradeService {
    // 등급 등록
    int register(SeatGrade seatGrade);
    
    // 등급 전체 조회
    List<SeatGrade> getList();
    
    // 등급 1건 조회
    SeatGrade getGrade(int seat_grade_id);
    
    // 등급 수정
    int modify(SeatGrade seatGrade);
    
    // 등급 삭제
    int remove(int seat_grade_id);
}