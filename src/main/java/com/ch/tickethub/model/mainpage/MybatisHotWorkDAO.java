package com.ch.tickethub.model.mainpage;

import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.ch.tickethub.dto.HotWork;

@Repository
public class MybatisHotWorkDAO implements HotWorkDAO {

    @Autowired
    private SqlSessionTemplate sqlSessionTemplate;

    @Override
    public List<HotWork> selectAll() {
        return sqlSessionTemplate.selectList("HotWork.selectAll");
    }

    @Override
    public void insert(HotWork hotWork) {
        sqlSessionTemplate.insert("HotWork.insert", hotWork);
    }

    @Override
    public void delete(int hotwork_id) {
        sqlSessionTemplate.delete("HotWork.delete", hotwork_id);
    }

    @Override
    public void updateOrder(HotWork hotWork) {
        sqlSessionTemplate.update("HotWork.updateOrder", hotWork);
    }
}
