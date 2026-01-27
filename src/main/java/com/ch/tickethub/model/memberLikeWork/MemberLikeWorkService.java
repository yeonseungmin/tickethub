package com.ch.tickethub.model.memberLikeWork;

import com.ch.tickethub.dto.MemberLikeWork;

public interface MemberLikeWorkService {
	public int getMemberLikeWork(int memberId);
	public void regist(MemberLikeWork memberLikeWork);
	public void remove(MemberLikeWork memberLikeWork);
}
