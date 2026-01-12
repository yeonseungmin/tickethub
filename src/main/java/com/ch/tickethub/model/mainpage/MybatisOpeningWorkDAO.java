package com.ch.tickethub.model.mainpage;

import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.ch.tickethub.dto.OpeningWork;

@Repository
public class MybatisOpeningWorkDAO implements OpeningWorkDAO {

    @Autowired
    private SqlSessionTemplate sqlSessionTemplate;

    @Override
    public List<OpeningWork> selectAll() {
        return sqlSessionTemplate.selectList("OpeningWork.selectAll");
    }

    @Override
    public void insert(OpeningWork openingWork) {
        sqlSessionTemplate.insert("OpeningWork.insert", openingWork);
    }

    @Override
    public void delete(int openingwork_id) {
        sqlSessionTemplate.delete("OpeningWork.delete", openingwork_id);
    }
}
