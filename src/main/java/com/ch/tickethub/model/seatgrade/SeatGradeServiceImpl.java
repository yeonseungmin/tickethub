package com.ch.tickethub.model.seatgrade;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ch.tickethub.dto.SeatGrade;

@Service
public class SeatGradeServiceImpl implements SeatGradeService {

    @Autowired
    private SeatGradeDAO seatGradeDAO;

    @Override
    public List<SeatGrade> getList() {
        return seatGradeDAO.selectAll();
    }

    @Override
    public SeatGrade getGrade(int seat_grade_id) {
        return seatGradeDAO.select(seat_grade_id);
    }

    @Override
    public int register(SeatGrade seatGrade) {
        return seatGradeDAO.insert(seatGrade);
    }

    @Override
    public int modify(SeatGrade seatGrade) {
        return seatGradeDAO.update(seatGrade);
    }

    @Override
    public int remove(int seat_grade_id) {
        return seatGradeDAO.delete(seat_grade_id);
    }
}