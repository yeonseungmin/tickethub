package com.ch.tickethub.model.bestreview;

import java.util.List;

import com.ch.tickethub.dto.BestReview;

public interface BestReviewDAO {

	public List<BestReview> selectAll();
	public void insert(BestReview bestReview);
	public void delete(int bestreview_id);
}
