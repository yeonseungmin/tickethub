package com.ch.tickethub.model.seat;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.ch.tickethub.dto.Seat;
import com.ch.tickethub.dto.SeatGroup;
import com.ch.tickethub.exception.SeatException;
import com.ch.tickethub.model.roundseat.RoundSeatDAO;

@Service
public class SeatServiceImpl implements SeatService {

    @Autowired
    private SeatDAO seatDAO;
    
    @Autowired
    private RoundSeatDAO roundSeatDAO;
    
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
    
    @Transactional // 중요: 두 삭제가 모두 성공해야 커밋됨
    @Override
    public void delete(int seatId) {
        // 1. 자식 레코드(round_seat) 먼저 삭제 (외래키 제약조건 해결)
        // 이 기능은 RoundSeatMapper.xml 에 만들 것
        roundSeatDAO.deleteBySeatId(seatId);

        // 2. 부모 레코드(seat) 삭제
        // 이 기능은 SeatMapper.xml 에 만들 것
        seatDAO.delete(seatId);
    }
    
    @Override
    public List<Seat> selectByGroup(int seat_group_id) {
    	return seatDAO.selectByGroup(seat_group_id);
    }

    @Transactional
    @Override
    public void updateSeatState(int seat_id, String seat_state) {
        // 1. 마스터 좌석 상태 변경
        seatDAO.updateSeatState(seat_id, seat_state);
        
        // 2. [추가] 모든 회차의 좌석 상태 동기화
        roundSeatDAO.updateStateBySeatId(seat_id, seat_state);
    }

    

    @Transactional
    @Override
    public void updateSeatGrade(int seat_id, int seat_grade_id) {
        // 1. 마스터 좌석 등급 변경
        seatDAO.updateSeatGrade(seat_id, seat_grade_id);
        
        // 2. [추가] 해당 좌석을 사용하는 모든 회차(round_seat)의 등급도 함께 변경
        // roundSeatDAO에 updateGradeBySeatId 같은 메서드가 필요합니다.
        roundSeatDAO.updateGradeBySeatId(seat_id, seat_grade_id); 
    }



}

