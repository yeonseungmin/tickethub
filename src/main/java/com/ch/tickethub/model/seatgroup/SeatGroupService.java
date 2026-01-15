package com.ch.tickethub.model.seatgroup;

import java.util.List;
import com.ch.tickethub.dto.SeatGroup;

public interface SeatGroupService {

    List<SeatGroup> getByPlace(int place_id);

    SeatGroup get(int seat_group_id);

    int insert(SeatGroup seatGroup);

    int updatePosition(int seat_group_id, int pos_x, int pos_y, double angle);

    int updateLayout(int seat_group_id, int row_gap, int col_gap, String direction);

    int delete(int seat_group_id);

    //좌석 생성
    void createBulkSeats(int seatGroupId, int rowCount, int colCount);
    // Service 인터페이스
    void updateGroupsPositions(List<SeatGroup> groupList);
    //좌석 그룹생성
    void insertGroupByPlace(SeatGroup seatGroup);
}
