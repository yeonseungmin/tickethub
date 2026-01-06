package com.ch.tickethub.model.reservation;

import java.util.List;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import com.ch.tickethub.dto.Reservation;

@Repository
public class MybatisReservationDAO implements ReservationDAO {

    @Autowired
    private SqlSessionTemplate sqlSessionTemplate;

    @Override
    public int insert(Reservation reservation) {
        return sqlSessionTemplate.insert("Reservation.insert", reservation);
    }

    @Override
    public Reservation select(int reservation_id) {
        return sqlSessionTemplate.selectOne("Reservation.select", reservation_id);
    }

    @Override
    public List<Reservation> selectByMember(int member_id) {
        return sqlSessionTemplate.selectList("Reservation.selectByMember", member_id);
    }

    @Override
    public List<Reservation> selectByRound(int round_id) {
        return sqlSessionTemplate.selectList("Reservation.selectByRound", round_id);
    }

    @Override
    public int delete(int reservation_id) {
        return sqlSessionTemplate.delete("Reservation.delete", reservation_id);
    }
}