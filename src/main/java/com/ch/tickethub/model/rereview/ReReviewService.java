package com.ch.tickethub.model.rereview;

import com.ch.tickethub.dto.ReReview;

public interface ReReviewService {
	public void regist(ReReview reReview);
	public void remove(int re_review_id);
}