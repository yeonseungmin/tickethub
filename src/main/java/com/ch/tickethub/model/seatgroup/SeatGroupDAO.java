package com.ch.tickethub.model.seatgroup;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.ch.tickethub.dto.SeatGroup;

public interface SeatGroupDAO {

    // 구역 생성
	public int insert(SeatGroup seatGroup);

    // 공연장별 구역 조회
	public List<SeatGroup> selectByPlace(int place_id);

    // 구역 1건 조회
	public SeatGroup select(int seat_group_id);

    // 구역 위치 저장 (드래그 결과)
	public int updatePosition(int seat_group_id, int pos_x, int pos_y);

    // 구역 배치 옵션 변경
	public int updateLayout(
        int seat_group_id,
        int row_gap,
        int col_gap,
        String direction
    );

    // 구역 삭제
	public int delete(int seat_group_id);
	// 구역 좌표 업데이트 메서드 추가
	void updateGroupPosition(@Param("seat_group_id") int seat_group_id, @Param("pos_x") int pos_x, @Param("pos_y") int pos_y);
}
