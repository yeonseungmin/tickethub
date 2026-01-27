package com.ch.tickethub.model.memberLikeWork;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.ch.tickethub.dto.MemberLikeWork;
import com.ch.tickethub.exception.MemberLikeWorkException;
import com.ch.tickethub.model.work.WorkDAO;

@Service
public class MemberLikeWorkServiceImpl implements MemberLikeWorkService{

	@Autowired
	MemberLikeWorkDAO memberLikeWorkDAO;
	
	@Autowired
	WorkDAO workDAO;
	
	@Override
	public int getMemberLikeWork(int memberId) {

		return memberLikeWorkDAO.countByMemberId(memberId);
	}
	
	@Transactional
	@Override
	public void regist(MemberLikeWork memberLikeWork) throws MemberLikeWorkException {
		
		memberLikeWorkDAO.insert(memberLikeWork);
		workDAO.increaseLikeCount(memberLikeWork.getWork().getWork_id());
	}
	
	@Transactional
	@Override
	public void remove(MemberLikeWork memberLikeWork) throws MemberLikeWorkException {
		
		memberLikeWorkDAO.deleteByMemberId(memberLikeWork.getMember().getMemberId());
		workDAO.decreaseLikeCount(memberLikeWork.getWork().getWork_id());
	}
	
	
}
