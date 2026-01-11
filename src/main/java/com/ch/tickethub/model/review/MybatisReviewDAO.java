package com.ch.tickethub.model.review;

import java.util.List;

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
	public List<Review> selectByWorkId(int work_id) {
		
		return sqlSessionTemplate.selectList("Review.selectByWorkId", work_id);
	}

}
