package com.ch.tickethub.model.review;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.ch.tickethub.dto.Review;
import com.ch.tickethub.exception.ReviewException;

@Repository
public class MybatisReviewDAO implements ReviewDAO{

	@Autowired
	SqlSessionTemplate sqlSessionTemplate;
	
	@Override
	public void insert(Review review) throws ReviewException{
		try {
			sqlSessionTemplate.insert("Review.insert", review);
		} catch (Exception e) {
			e.printStackTrace();
			throw new ReviewException("리뷰 등록 과정 중 오류 발생", e);
		}
		
	}

	@Override
	public List<Review> selectByWorkId(int work_id, String orderType) {
		Map<String, Object> map = new HashMap();
		map.put("work_id", work_id);
		map.put("orderType", orderType);
		
		return sqlSessionTemplate.selectList("Review.selectByWorkId", map);
	}

	@Override
	public Review select(int review_id) {
		return sqlSessionTemplate.selectOne("Review.select", review_id);
	}

	@Override
	public void updateHit(int review_id) throws ReviewException{
	
		try {
			int updateCount = sqlSessionTemplate.update("Review.updateHit", review_id);
			
			if(updateCount == 0) {
				throw new ReviewException("업데이트 실패");
			}
		} catch (ReviewException e){
			throw e;
		} catch (Exception e) {
			e.printStackTrace();
			throw new ReviewException("나머지 모든 업데이트 에러", e);
		}
		
		
	}

}
