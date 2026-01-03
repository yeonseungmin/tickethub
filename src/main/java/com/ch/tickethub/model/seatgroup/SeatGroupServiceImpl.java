package com.ch.tickethub.model.seatgroup;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.ch.tickethub.dto.SeatGroup;

@Service
public class SeatGroupServiceImpl implements SeatGroupService {

    @Autowired
    private SeatGroupDAO seatGroupDAO;

    @Override
    public List<SeatGroup> getByPlace(int place_id) {
        return seatGroupDAO.selectByPlace(place_id);
    }

    @Override
    public SeatGroup get(int seat_group_id) {
        return seatGroupDAO.select(seat_group_id);
    }

    @Transactional
    @Override
    public int insert(SeatGroup seatGroup) {
        return seatGroupDAO.insert(seatGroup);
    }

    @Transactional
    @Override
    public int updatePosition(int seat_group_id, int pos_x, int pos_y) {
        return seatGroupDAO.updatePosition(seat_group_id, pos_x, pos_y);
    }

    @Transactional
    @Override
    public int updateLayout(int seat_group_id, int row_gap, int col_gap, String direction) {
        return seatGroupDAO.updateLayout(seat_group_id, row_gap, col_gap, direction);
    }

    @Transactional
    @Override
    public int delete(int seat_group_id) {
        return seatGroupDAO.delete(seat_group_id);
    }
}
