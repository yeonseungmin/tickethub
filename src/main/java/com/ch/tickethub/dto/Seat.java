package com.ch.tickethub.dto;

import lombok.Data;

@Data // Lombok
public class Seat {

    private int seat_id;        // PK: 좌석의 고유 식별 번호
    private int seat_group_id;  // SeatGroup 포함
    private int seat_grade_id;  // FK: SeatGrade 테이블 참조 (등급 아이디: VIP, R 등)
    private String seat_x;      // 좌석의 행 (데이터 예시: 'A', 'B', 'C')
    private int seat_y;         // 좌석의 열 (데이터 예시: 1, 2, 3)
    private String seat_name;   // 화면 표시용 전체 이름 (예시: "A10")


    private int floor;          // 층수 정보 (1층, 2층 등)
    private String seat_state;  // 좌석 상태 (AVAILABLE, PREEMPTED, RESERVED, CANCELED 등)
    
}