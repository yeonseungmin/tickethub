package com.ch.tickethub.model.seatgroup;

import java.util.List;
import com.ch.tickethub.dto.SeatGroup;

public interface SeatGroupService {

    List<SeatGroup> getByPlace(int place_id);

    SeatGroup get(int seat_group_id);

    int insert(SeatGroup seatGroup);

    int updatePosition(int seat_group_id, int pos_x, int pos_y);

    int updateLayout(int seat_group_id, int row_gap, int col_gap, String direction);

    int delete(int seat_group_id);
    
}
