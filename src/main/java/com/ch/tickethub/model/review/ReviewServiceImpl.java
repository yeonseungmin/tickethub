package com.ch.tickethub.model.review;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ch.tickethub.dto.Review;

@Service
public class ReviewServiceImpl implements ReviewService{
	
	@Autowired
	ReviewDAO reviewDAO;

	@Override
	public void regist(Review review) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public List<Review> getListByWorkId(int work_id) {
		
		return reviewDAO.selectByWorkId(work_id);
	}

}
