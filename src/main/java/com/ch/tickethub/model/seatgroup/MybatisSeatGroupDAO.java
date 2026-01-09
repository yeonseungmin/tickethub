package com.ch.tickethub.model.seatgroup;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import com.ch.tickethub.dto.SeatGroup;

@Repository
public class MybatisSeatGroupDAO implements SeatGroupDAO {

    @Autowired
    private SqlSessionTemplate sqlSession;
    
    private static final String NAMESPACE = "SeatGroup";

    @Override
    public int insert(SeatGroup seatGroup) {
        return sqlSession.insert("SeatGroup.insert", seatGroup);
    }

    @Override
    public List<SeatGroup> selectByPlace(int place_id) {
        return sqlSession.selectList("SeatGroup.selectByPlace", place_id);
    }

    @Override
    public SeatGroup select(int seat_group_id) {
        return sqlSession.selectOne("SeatGroup.select", seat_group_id);
    }

    @Override
    public int updatePosition(int seat_group_id, int pos_x, int pos_y) {
        Map<String, Object> param = new HashMap<>();
        param.put("seat_group_id", seat_group_id);
        param.put("pos_x", pos_x);
        param.put("pos_y", pos_y);

        return sqlSession.update("SeatGroup.updatePosition", param);
    }

    @Override
    public int updateLayout(int seat_group_id, int row_gap, int col_gap, String direction) {
        Map<String, Object> param = new HashMap<>();
        param.put("seat_group_id", seat_group_id);
        param.put("row_gap", row_gap);
        param.put("col_gap", col_gap);
        param.put("direction", direction);

        return sqlSession.update("SeatGroup.updateLayout", param);
    }
    
    @Override
    public int delete(int seat_group_id) {
        return sqlSession.delete("SeatGroup.delete", seat_group_id);
    }

    @Override
    public void updateGroupPosition(@Param("seat_group_id") int seat_group_id, @Param("pos_x") int pos_x, @Param("pos_y") int pos_y) {
        Map<String, Object> params = new HashMap<>();
        params.put("seat_group_id", seat_group_id);
        params.put("pos_x", pos_x);
        params.put("pos_y", pos_y);
        
        sqlSession.update(NAMESPACE + ".updateGroupPosition", params);
    }
    
    
}
