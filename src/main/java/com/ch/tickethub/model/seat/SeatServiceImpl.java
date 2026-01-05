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
    public void createSeats(int rows, int cols, int seat_group_id) {
        for (int r = 0; r < rows; r++) {
            char rowName = (char) ('A' + r); 
            
            for (int c = 1; c <= cols; c++) {
                Seat seat = new Seat();
                
                // 직접 ID를 세팅하는 대신 SeatGroup 객체를 생성해서 세팅
                SeatGroup seatGroup = new SeatGroup();
                seatGroup.setSeat_group_id(seat_group_id);
                seat.setSeatGroup(seatGroup); 
                
                seat.setSeat_grade_id(1); 
                seat.setSeat_x(String.valueOf(rowName));
                seat.setSeat_y(c);
                seat.setSeat_name(rowName + String.valueOf(c));
                seat.setFloor(1);
                seat.setSeat_state("AVAILABLE");

                seatDAO.insert(seat);
            }
        }
    }

    @Transactional
    @Override
    public void updateSeatGrade(int seat_id, int seat_grade_id) {
        seatDAO.updateSeatGrade(seat_id, seat_grade_id);
    }


}

