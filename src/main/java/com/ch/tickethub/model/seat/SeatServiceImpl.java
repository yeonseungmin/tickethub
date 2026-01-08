package com.ch.tickethub.model.seat;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.ch.tickethub.dto.Seat;
import com.ch.tickethub.dto.SeatGroup;
import com.ch.tickethub.exception.SeatException;

@Service
public class SeatServiceImpl implements SeatService {

    @Autowired
    private SeatDAO seatDAO;

    // 추가된 메서드
    @Transactional
    @Override
    public void insert(Seat seat) {
        seatDAO.insert(seat);
    }

    @Override
    public Seat select(int seat_id) {
        return seatDAO.select(seat_id);
    }

    @Transactional
    @Override
    public void updateSeatState(int seat_id, String seat_state) {
        seatDAO.updateSeatState(seat_id, seat_state);
    }

    @Transactional
    @Override
    public void delete(int seat_id) {
        seatDAO.delete(seat_id);
    }
    
    @Override
    public List<Seat> selectByGroup(int seat_group_id) {
        return seatDAO.selectByGroup(seat_group_id);
    }
    

    @Transactional
    @Override
    public void updateSeatGrade(int seat_id, int seat_grade_id) {
        seatDAO.updateSeatGrade(seat_id, seat_grade_id);
    }



}

