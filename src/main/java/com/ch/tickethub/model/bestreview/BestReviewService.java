package com.ch.tickethub.model.bestreview;

import java.util.List;

import com.ch.tickethub.dto.BestReview;

public interface BestReviewService {

	public List<BestReview> getList();
	public void register(BestReview bestReview);
	public void remove(int bestreview_id);
}
