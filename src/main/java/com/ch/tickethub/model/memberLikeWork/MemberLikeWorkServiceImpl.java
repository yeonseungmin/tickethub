package com.ch.tickethub.model.memberLikeWork;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ch.tickethub.dto.MemberLikeWork;
import com.ch.tickethub.exception.MemberLikeWorkException;

@Service
public class MemberLikeWorkServiceImpl implements MemberLikeWorkService{

	@Autowired
	MemberLikeWorkDAO memberLikeWorkDAO;
	
	@Override
	public int getMemberLikeWork(int memberId) {

		return memberLikeWorkDAO.countByMemberId(memberId);
	}

	@Override
	public void regist(MemberLikeWork memberLikeWork) throws MemberLikeWorkException {
		
		memberLikeWorkDAO.insert(memberLikeWork);
	}
	
}
