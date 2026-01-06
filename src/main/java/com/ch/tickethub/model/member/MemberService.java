package com.ch.tickethub.model.member;

import java.util.List;

import com.ch.tickethub.dto.Member;

public interface MemberService {
	
	public Member login(String loginId, String password);
	public List<Member> adminSearchMembers(String keyword, String status);
	public Member adminSelectMemberDetail(Integer memberId);
	public void adminUpdateMemberStatus(Integer memberId, String status);
	public void adminUpdateMemberGrade(Integer memberId, Integer gradeId);
}