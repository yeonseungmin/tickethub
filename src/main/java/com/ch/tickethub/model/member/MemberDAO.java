package com.ch.tickethub.model.member;

import java.util.List;
import java.util.Map;

import com.ch.tickethub.dto.Member;

public interface MemberDAO {
	 	public Member selectByLoginId(String loginId);
	 	public Member selectByOauth(Map<String, Object> param);
	 	
	 	public int insert(Member member);
	    public int updateLastLoginAt(Integer memberId);

	    public List<Member> adminSearchMembers(Map<String, Object> param);
	    public Member adminSelectMemberDetail(Integer memberId);

	    public int adminUpdateMemberStatus(Map<String, Object> param);
	    public int adminUpdateMemberGrade(Map<String, Object> param);
}
