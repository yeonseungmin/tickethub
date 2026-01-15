package com.ch.tickethub.model.bestreview;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.ch.tickethub.dto.BestReview;

@Service
public class BestReviewServiceImpl implements BestReviewService{

	@Autowired
	private BestReviewDAO bestReviewDAO;
	
	@Override
	public List<BestReview> getList() {
		return bestReviewDAO.selectAll();
	}

	@Transactional
	@Override
	public void register(BestReview bestReview) {
		bestReviewDAO.insert(bestReview);
	}

	@Transactional
	@Override
	public void remove(int bestreview_id) {
		bestReviewDAO.delete(bestreview_id);
	}
}