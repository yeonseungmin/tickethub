package com.ch.tickethub.model.memberLikeWork;

import com.ch.tickethub.dto.MemberLikeWork;

public interface MemberLikeWorkDAO {
	public int countByMemberId(int memberId);
	public void insert(MemberLikeWork memberLikeWork);
	public void deleteByMemberId(int memberId);
}
