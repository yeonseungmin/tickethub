package com.ch.tickethub.model.roundseat;

import java.util.List;
import java.util.HashMap;
import java.util.Map;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.ch.tickethub.dto.Round;
import com.ch.tickethub.dto.RoundSeat;
import com.ch.tickethub.dto.SeatDetail;

@Repository
public class MybatisRoundSeatDAO implements RoundSeatDAO {

    @Autowired
    private SqlSessionTemplate sqlSessionTemplate;
    @Autowired
    private SqlSessionTemplate sqlSession;
    
    private static final String NAMESPACE = "RoundSeat";

    @Override
    public int countByRoundAndGroup(int round_id, int seat_group_id) {
        Map<String, Object> param = new HashMap<>();
        param.put("round_id", round_id);
        param.put("seat_group_id", seat_group_id);
        return sqlSessionTemplate.selectOne("RoundSeat.countByRoundAndGroup", param);
    }

    @Override
    public void insert(RoundSeat roundSeat) {
        sqlSessionTemplate.insert("RoundSeat.insert", roundSeat);
    }

    @Override
    public List<SeatDetail> selectSeatDetailByRound(int round_id) {
        // XML의 id="selectSeatDetailByRound"와 매핑
        return sqlSessionTemplate.selectList("RoundSeat.selectSeatDetailByRound", round_id);
    }

    @Override
    public int updateStatus(RoundSeat roundSeat) {
        // XML의 id="updateStatus"와 매핑
        return sqlSessionTemplate.update("RoundSeat.updateStatus", roundSeat);
    }

    @Override
    public void insertBulkByGroup(int seat_group_id) {
        sqlSessionTemplate.insert("RoundSeat.insertBulkByGroup", seat_group_id);
    }

    @Override
    public void updateStateBySeatId(int seat_id, String seat_state) {
        Map<String, Object> params = new HashMap<>();
        params.put("seat_id", seat_id);
        params.put("seat_state", seat_state);
        sqlSession.update(NAMESPACE + ".updateStateBySeatId", params);
    }

    @Override
    public void updateGradeBySeatId(int seat_id, int seat_grade_id) {
        Map<String, Object> params = new HashMap<>();
        params.put("seat_id", seat_id);
        params.put("seat_grade_id", seat_grade_id);
        sqlSession.update(NAMESPACE + ".updateGradeBySeatId", params);
    }
    
    @Override
    public void deleteBySeatId(int seat_id) {
        // Mapper의 namespace="RoundSeat", id="deleteBySeatId"를 호출
        sqlSessionTemplate.delete("RoundSeat.deleteBySeatId", seat_id);
    }

}