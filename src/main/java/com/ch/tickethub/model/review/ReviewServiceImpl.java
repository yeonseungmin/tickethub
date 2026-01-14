package com.ch.tickethub.model.review;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ch.tickethub.dto.Review;
import com.ch.tickethub.exception.ReviewException;

@Service
public class ReviewServiceImpl implements ReviewService{
	
	@Autowired
	ReviewDAO reviewDAO;

	@Override
	public void regist(Review review) throws ReviewException{
		reviewDAO.insert(review);
	}

	@Override
	public List<Review> getListByWorkId(int work_id, String orderType) {
		
		return reviewDAO.selectByWorkId(work_id, orderType);
	}

	@Override
	public Review getReview(int review_id) {
		return reviewDAO.select(review_id);
	}

	@Override
	public Map<String, Object> getReviewStats(int work_id) {
		return reviewDAO.selectReviewStats(work_id);
	}
	
	@Override
	public void setHit(int review_id) throws ReviewException{
		
		reviewDAO.updateHit(review_id);
	}

	@Override
	public void setLikeCount(int review_id) throws ReviewException{
		
		reviewDAO.updateLikeCount(review_id);
	}

	@Override
	public void remove(int review_id) throws ReviewException{
		reviewDAO.softDelete(review_id);
	}


	
	
}
