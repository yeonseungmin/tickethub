package com.ch.tickethub.model.bestreview;

import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.ch.tickethub.dto.BestReview;

@Repository
public class MybatisBestReviewDAO implements BestReviewDAO{

	@Autowired
	SqlSessionTemplate sqlSessionTemplate;
	
	@Override
	public List<BestReview> selectAll() {
		return null;
	}

	@Override
	public void insert(BestReview bestReview) {
		
	}

	@Override
	public void delete(int bestreview_id) {
		
	}

}
