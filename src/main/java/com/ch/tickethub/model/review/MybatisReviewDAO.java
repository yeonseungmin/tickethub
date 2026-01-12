package com.ch.tickethub.model.review;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.ch.tickethub.dto.Review;

@Repository
public class MybatisReviewDAO implements ReviewDAO{

	@Autowired
	SqlSessionTemplate sqlSessionTemplate;
	
	@Override
	public void insert(Review review) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public List<Review> selectByWorkId(int work_id, String orderType) {
		Map<String, Object> map = new HashMap();
		map.put("work_id", work_id);
		map.put("orderType", orderType);
		
		return sqlSessionTemplate.selectList("Review.selectByWorkId", map);
	}

}
