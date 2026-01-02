package com.ch.tickethub.model.seat;

import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.ch.tickethub.dto.Seat;

@Repository
public class MybatisSeatDAO implements SeatDAO {

    @Autowired
    private SqlSessionTemplate sqlSessionTemplate;

    @Override
    public int insert(Seat seat) {
        return sqlSessionTemplate.insert("Seat.insert", seat);
    }

    @Override
    public Seat select(int seat_id) {
        return sqlSessionTemplate.selectOne("Seat.select", seat_id);
    }

    @Override
    public List<Seat> selectByPlace(int place_id) {
        return sqlSessionTemplate.selectList("Seat.selectByPlace", place_id);
    }

    @Override
    public List<Seat> selectByGroup(int seat_group_id) {
        return sqlSessionTemplate.selectList("Seat.selectByGroup", seat_group_id);
    }

    @Override
    public int updateSeatState(int seat_id, String seat_state) {
        Seat seat = new Seat();
        seat.setSeat_id(seat_id);
        seat.setSeat_state(seat_state);
        return sqlSessionTemplate.update("Seat.updateSeatState", seat);
    }

    @Override
    public int delete(int seat_id) {
        return sqlSessionTemplate.delete("Seat.delete", seat_id);
    }
}
