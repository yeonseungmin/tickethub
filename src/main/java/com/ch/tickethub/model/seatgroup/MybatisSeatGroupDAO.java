package com.ch.tickethub.model.seatgroup;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import com.ch.tickethub.dto.SeatGroup;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Repository
public class MybatisSeatGroupDAO implements SeatGroupDAO {

    @Autowired
    private SqlSessionTemplate sqlSessionTemplate;
    
    private static final String NAMESPACE = "SeatGroup";

    @Override
    public int insert(SeatGroup seatGroup) {
        return sqlSessionTemplate.insert("SeatGroup.insert", seatGroup);
    }

    @Override
    public List<SeatGroup> selectByPlace(int place_id) {
        return sqlSessionTemplate.selectList("SeatGroup.selectByPlace", place_id);
    }

    @Override
    public SeatGroup select(int seat_group_id) {
        return sqlSessionTemplate.selectOne("SeatGroup.select", seat_group_id);
    }

    @Override
    public int updatePosition(int seat_group_id, int pos_x, int pos_y,double angle) {
        Map<String, Object> param = new HashMap<>();
        param.put("seat_group_id", seat_group_id);
        param.put("pos_x", pos_x);
        param.put("pos_y", pos_y);
        param.put("angle", angle);

        return sqlSessionTemplate.update("SeatGroup.updatePosition", param);
    }

    @Override
    public int updateLayout(int seat_group_id, int row_gap, int col_gap, String direction) {
        Map<String, Object> param = new HashMap<>();
        param.put("seat_group_id", seat_group_id);
        param.put("row_gap", row_gap);
        param.put("col_gap", col_gap);
        param.put("direction", direction);

        return sqlSessionTemplate.update("SeatGroup.updateLayout", param);
    }
    
    @Override
    public int delete(int seat_group_id) {
        return sqlSessionTemplate.delete("SeatGroup.delete", seat_group_id);
    }

    @Override
    public void updateGroupPos(@Param("seat_group_id") int seat_group_id, @Param("pos_x") int pos_x, @Param("pos_y") int pos_y,@Param("angle") double angle) {
        Map<String, Object> params = new HashMap<>();
        params.put("seat_group_id", seat_group_id);
        params.put("pos_x", pos_x);
        params.put("pos_y", pos_y);
        params.put("angle", angle);
        
       int result = sqlSessionTemplate.update(NAMESPACE + ".updateGroupPos", params);
        log.debug(">>> DB 업데이트 결과(영향받은 행): " + result);
    }

    @Override
    public void insertGroupByPlace(SeatGroup seatGroup) {
        // session.insert("네임스페이스.아이디", 파라미터객체)
    	sqlSessionTemplate.insert(NAMESPACE + ".insertGroupByPlace", seatGroup);
    }
    
    
}
