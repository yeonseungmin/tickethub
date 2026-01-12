package com.ch.tickethub.model.seatgroup;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.ch.tickethub.dto.RoundSeat;
import com.ch.tickethub.dto.Seat;
import com.ch.tickethub.dto.SeatGroup;
import com.ch.tickethub.model.round.RoundDAO;
import com.ch.tickethub.model.roundseat.RoundSeatDAO;
import com.ch.tickethub.model.seat.SeatDAO;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class SeatGroupServiceImpl implements SeatGroupService {

    @Autowired
    private SeatGroupDAO seatGroupDAO;
    @Autowired
    private SeatDAO seatDAO;
    
    @Autowired
    private RoundDAO roundDAO;
    
    @Autowired
    private RoundSeatDAO roundSeatDAO;
    
    // 이 클래스 내부에 있던 @GetMapping 메서드는 삭제되었습니다. (Controller로 이동)

    @Override
    public List<SeatGroup> getByPlace(int place_id) {
        // 인터페이스 정의에 따라 getByPlace를 구현하며 DAO의 selectByPlace를 호출합니다.
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
    public int updatePosition(int seat_group_id, int pos_x, int pos_y, double angle) {
    	log.debug("=== 서비스 진입 성공 ===");
    	log.debug("전달받은 ID: " + seat_group_id);
    	log.debug("서비스 계층 확인: " + angle);
        return seatGroupDAO.updatePosition(seat_group_id, pos_x, pos_y, angle);
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
    
    @Override
    @Transactional
    public void createBulkSeats(int seat_group_id, int row_count, int col_count) {
        // 1. 물리 좌석(seat)들만 먼저 생성 (이중 반복문)
        for (int i = 0; i < row_count; i++) {
            for (int j = 0; j < col_count; j++) {
                Seat seat = new Seat();
                seat.setSeat_group_id(seat_group_id);
                
                String colLabel = String.valueOf((char)('A' + i)); 
                seat.setSeat_x(colLabel); 
                seat.setSeat_y(j + 1); 
                seat.setSeat_name(colLabel + "-" + (j + 1));
                seat.setFloor(1);
                seat.setSeat_grade_id(1); 
                
                // 물리 좌석 생성 (DB insert)
                seatDAO.insert(seat);
            }
        }

        // 2. 핵심: 모든 회차에 대한 round_seat 데이터 일괄 생성
        // 위에서 만든 모든 좌석들을 해당 구역의 장소(place_id)에 속한 모든 회차와 연결합니다.
        roundSeatDAO.insertBulkByGroup(seat_group_id); 
    }
    
    @Override
    @Transactional // 두 작업을 하나의 트랜잭션으로 묶음
    public void updateGroupAndSeatPosition(int seatGroupId, int posX, int posY, double angle) {
    	// 1. 구역 업데이트 (이것만 실행)
        seatGroupDAO.updateGroupPos(seatGroupId, posX, posY,angle);
    }
    
    public void insertGroupByPlace(SeatGroup seatGroup) {
        seatGroupDAO.insertGroupByPlace(seatGroup);
    }
}