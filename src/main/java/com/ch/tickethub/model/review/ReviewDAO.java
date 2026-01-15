package com.ch.tickethub.model.review;

import java.util.List;
import java.util.Map;

import com.ch.tickethub.dto.Review;

public interface ReviewDAO {
	public void insert(Review review);
	public List<Review> selectByWorkId(int work_id, String orderType);
	public Review select(int review_id);
	public void updateHit(int review_id);
	public void updateLikeCount(int review_id);
	public void softDelete(int review_id);
	public Map<String, Object> selectReviewStats(int work_id);
	public void updateBlock(int review_id);
	
}