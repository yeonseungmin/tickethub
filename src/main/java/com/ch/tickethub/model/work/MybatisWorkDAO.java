package com.ch.tickethub.model.work;

import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.ch.tickethub.dto.Work;
import com.ch.tickethub.exception.WorkException;

@Repository
public class MybatisWorkDAO implements WorkDAO {
	
	@Autowired
	SqlSessionTemplate sqlSessionTemplate;
	
	@Override
	public void insert(Work work) throws WorkException {
		try {
			sqlSessionTemplate.insert("Work.insert", work);
		} catch (Exception e) {
			e.printStackTrace();
			
			throw new WorkException("작품 insert 실패", e);
		}
		
	}

	@Override
	public List selectAll() {
		return sqlSessionTemplate.selectList("Work.selectAll");
	}

}
