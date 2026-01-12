package com.ch.tickethub.model.review;

import java.util.List;

import com.ch.tickethub.dto.Review;

public interface ReviewDAO {
	public void insert(Review review);
	public List<Review> selectByWorkId(int work_id, String orderType);
}
