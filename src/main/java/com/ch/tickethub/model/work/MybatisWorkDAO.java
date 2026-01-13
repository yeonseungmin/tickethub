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

	@Override
	public Work select(int work_id) {
		return sqlSessionTemplate.selectOne("Work.select", work_id);
	}

	@Override
	public List<Work> selectListByPlace(int placeId) {
		// XML의 namespace="Work"이고 id="selectListByPlace"인 쿼리를 실행
		return sqlSessionTemplate.selectList("Work.selectListByPlace", placeId);
	}

	@Override
	public List<Work> selectByGenreId(int genre_id) {
		return sqlSessionTemplate.selectList("Work.selectByGenreId", genre_id);
	}
}
