package com.ch.tickethub.model.review;

import java.util.List;

import com.ch.tickethub.dto.Review;

public interface ReviewService {
	public void regist(Review review);
	public List<Review> getListByWorkId(int work_id, String orderType);
	public Review getReview(int review_id);
	public void setHit(int review_id);
}
