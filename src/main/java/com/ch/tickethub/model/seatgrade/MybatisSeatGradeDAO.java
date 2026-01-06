package com.ch.tickethub.model.seatgrade;

import java.util.List;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import com.ch.tickethub.dto.SeatGrade;

@Repository
public class MybatisSeatGradeDAO implements SeatGradeDAO {

    @Autowired
    private SqlSessionTemplate sqlSessionTemplate;

    @Override
    public int insert(SeatGrade seatGrade) {
        return sqlSessionTemplate.insert("SeatGrade.insert", seatGrade);
    }

    @Override
    public List<SeatGrade> selectAll() {
        return sqlSessionTemplate.selectList("SeatGrade.selectAll");
    }

    @Override
    public SeatGrade select(int seat_grade_id) {
        return sqlSessionTemplate.selectOne("SeatGrade.select", seat_grade_id);
    }

    @Override
    public int update(SeatGrade seatGrade) {
        return sqlSessionTemplate.update("SeatGrade.update", seatGrade);
    }

    @Override
    public int delete(int seat_grade_id) {
        return sqlSessionTemplate.delete("SeatGrade.delete", seat_grade_id);
    }
}