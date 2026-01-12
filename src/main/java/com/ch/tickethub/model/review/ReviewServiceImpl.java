package com.ch.tickethub.model.review;

import java.util.List;

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

}
