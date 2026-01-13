package com.ch.tickethub.model.rereview;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.ch.tickethub.dto.ReReview;
import com.ch.tickethub.exception.ReReviewException;

@Repository
public class MybatisReReviewDAO implements ReReviewDAO{

	@Autowired
	SqlSessionTemplate sqlSessionTemplate;
	
	@Override
	public void insert(ReReview reReview) throws ReReviewException {
		try {
			sqlSessionTemplate.insert("ReReview.insert", reReview);
		} catch (Exception e) {
			e.printStackTrace();
			throw new ReReviewException("답글 등록 과정 중 오류 발생", e);
		}
	}
	
}
