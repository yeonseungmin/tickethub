package com.ch.tickethub.model.rereview;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ch.tickethub.dto.ReReview;
import com.ch.tickethub.exception.ReReviewException;

@Service
public class ReReviewServiceImpl implements ReReviewService{

	@Autowired
	ReReviewDAO reReviewDAO;
	
	@Override
	public void regist(ReReview reReview) throws ReReviewException{
		reReviewDAO.insert(reReview);
	}

	@Override
	public void remove(int re_review_id) throws ReReviewException{
		reReviewDAO.delete(re_review_id);
		
	}

}
