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

	@Override
	public void increaseLikeCount(int work_id) throws WorkException {
		
		try {
			int increaseCount = sqlSessionTemplate.update("Work.increaseLikeCount", work_id);
			
			if(increaseCount == 0) {
				throw new WorkException("작품 좋아요에 실패했습니다.");
			}
			
		} catch (WorkException e) {
			throw e;
		} catch (Exception e) {
			e.printStackTrace();
			throw new WorkException("작품 좋아요에서 오류 발생", e);
		}
		
	}

	@Override
	public void decreaseLikeCount(int work_id) throws WorkException {
	
		try {
			int decreaseCount = sqlSessionTemplate.update("Work.decreaseLikeCount", work_id);
			
			if(decreaseCount == 0) {
				throw new WorkException("작품 좋아요 취소에 실패했습니다.");
			}
			
		} catch (WorkException e) {
			throw e;
		} catch (Exception e) {
			e.printStackTrace();
			throw new WorkException("작품 좋아요 취소에서 오류 발생", e);
		}
	}

	@Override
	public void delete(int work_id) throws WorkException {
		try {
			sqlSessionTemplate.delete("Work.delete", work_id);
		} catch (Exception e) {
			e.printStackTrace();
			throw new WorkException("작품 삭제 실패", e);
		}
		
	}

	@Override
	public void update(Work work) throws WorkException {
		try {
			sqlSessionTemplate.update("Work.update", work);
		} catch (Exception e) {
			e.printStackTrace();
			throw new WorkException("작품 수정 실패", e);
		}
	}
}
