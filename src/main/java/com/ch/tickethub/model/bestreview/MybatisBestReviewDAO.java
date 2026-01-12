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
		return sqlSessionTemplate.selectList("BestReview.selectAll");
	}

	@Override
	public void insert(BestReview bestReview) {
		sqlSessionTemplate.insert("BestReview.insert", bestReview);
	}

	@Override
	public void delete(int bestreview_id) {
		sqlSessionTemplate.delete("BestReview.delete", bestreview_id);
	}
}